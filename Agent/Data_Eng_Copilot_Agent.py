



import json
import logging
import mlflow
import os
from mlflow.pyfunc import ResponsesAgent
from mlflow.types.responses import ResponsesAgentRequest, ResponsesAgentResponse
from databricks.sdk import WorkspaceClient
from databricks.vector_search.client import VectorSearchClient
from openai import OpenAI

logging.basicConfig(level=logging.INFO, format='%(levelname)s: %(message)s')
logger = logging.getLogger(__name__)

class DataEngCopilot(ResponsesAgent):

    def predict(self, request: ResponsesAgentRequest) -> ResponsesAgentResponse:

        # Load foundations config
        from pyspark.sql import SparkSession
        spark = SparkSession.builder.getOrCreate()

        foundations = {
            row['config_key']: row['config_value']
            for row in spark.sql("SELECT config_key, config_value FROM workspace.ai_project.foundations").collect()
        }

        catalog       = foundations['catalog']
        schema        = foundations['schema']
        base_url      = foundations['base_url']
        llm_model     = foundations['llm_model']
        endpoint_name = foundations['endpoint_name']

        # Load source_config
        source_config_rows = spark.sql("SELECT source_type, index_name FROM workspace.ai_project.source_config").collect()
        source_config = {
            row['source_type']: {"index": row['index_name']}
            for row in source_config_rows
        }

        # Auth — try SDK first, fall back to environment variable
        from databricks.sdk.runtime import dbutils
        
        w = WorkspaceClient()
        token = dbutils.notebook.entry_point.getDbutils().notebook().getContext().apiToken().get()
        vsc = VectorSearchClient()
        client = OpenAI(api_key=token, base_url=base_url)

        # Tool definitions
        tools = [
            {
                "type": "function",
                "function": {
                    "name": "search_documents",
                    "description": "Search the vector index for relevant context from books, technical documentation, or organizational policy. Always call this before execute_in_databricks to retrieve grounded context. When executing SQL, search 'policy' first to check applicable standards.",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "question": {
                                "type": "string",
                                "description": "The search query."
                            },
                            "source_type": {
                                "type": "string",
                                "enum": ["books", "docs", "policy"],
                                "description": "The source domain to search. Use 'books' for literary content, 'docs' for technical documentation, and 'policy' for organizational naming and table creation standards."
                            }
                        },
                        "required": ["question", "source_type"]
                    }
                }
            },
            {
                "type": "function",
                "function": {
                    "name": "execute_in_databricks",
                    "description": "Executes SQL code in Databricks after user confirmation. Only call this when the user explicitly confirms execution. Never call this without prior user confirmation in the conversation.",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "sql_code": {
                                "type": "string",
                                "description": "The SQL code to execute."
                            }
                        },
                        "required": ["sql_code"]
                    }
                }
            }
        ]

        # System prompt
        system_prompt = {
            "role": "system",
            "content": """You are an intelligent Data Engineering Assistant with access to technical documentation and literary sources.

        RULES:
        1. Always use the search_documents tool to retrieve context before answering.
        2. Choose source_type carefully:
           - Use 'docs' for technical questions about Databricks, SQL, or data engineering concepts
           - Use 'books' for questions about literary content
           - Use 'policy' for questions about naming conventions, table creation standards, or organizational governance rules
           - When executing SQL, always search 'policy' first to check for applicable standards before calling execute_in_databricks
        3. Only use retrieved context to form your answer. If nothing relevant is found, state that clearly.
        4. Always cite the Source Page and File Name from retrieved context.
        5. If a definitive answer isn't in the retrieved data, explain what IS there and clarify the uncertainty.
        6. When you need to execute SQL, first present the proposed SQL to the user and ask for confirmation. Only call execute_in_databricks after the user explicitly confirms in a follow-up message.
        7. When execute_in_databricks returns a success or cancellation message, summarize the outcome to the user. Do not ask for confirmation again — execution has already been handled."""
        }

        # Build messages from request
        messages = [system_prompt] + [
            {"role": item.role, "content": item.content}
            for item in request.input
        ]

        # Agentic tool execution loop
        output_items = []
        total_tokens = 0

        response = client.chat.completions.create(
            model=llm_model,
            messages=messages,
            tools=tools,
            tool_choice="auto"
        )

        total_tokens += response.usage.total_tokens
        response_message = response.choices[0].message
        tool_calls = response_message.tool_calls

        def clean_message(message):
            dumped = message.model_dump()
            allowed_keys = {"role", "content", "tool_calls", "tool_call_id", "name"}
            return {k: v for k, v in dumped.items() if k in allowed_keys and v is not None}

        def search_documents(query, source_type, num_results=4):
            index_name = source_config[source_type]["index"]
            index = vsc.get_index(endpoint_name, index_name)
            results = index.similarity_search(
                query_text=query,
                columns=["content", "source", "page_number", "start_index"],
                num_results=num_results
            )
            return results.get('result', {}).get('data_array', [])

        def execute_sql(sql_code):
            try:
                result = spark.sql(sql_code)
                rows = result.collect()
                if rows:
                    output = "\n".join([str(row) for row in rows])
                    return f"SQL executed successfully and committed to Databricks. Results:\n{output}"
                else:
                    return "SQL executed successfully and committed to Databricks. No further action required."
            except Exception as e:
                return f"SQL execution failed: {str(e)}"

        if tool_calls:
            messages.append(clean_message(response_message))

            while tool_calls:
                execution_happened = False

                for tool_call in tool_calls:
                    tool_name = tool_call.function.name
                    query_args = json.loads(tool_call.function.arguments)

                    if tool_name == "search_documents":
                        observations = search_documents(
                            query=query_args['question'],
                            source_type=query_args['source_type']
                        )

                        if observations:
                            context_blocks = [
                                f"Source Page {row[2]} (File: {row[1]}, Index: {row[3]}): {row[0]}"
                                for row in observations
                            ]
                            context = "\n---\n".join(context_blocks)
                        else:
                            context = "No relevant results found in the index."

                        logger.info(f"📡 Retrieved {len(observations)} excerpts from '{query_args['source_type']}' index.")

                        output_items.append(
                            self.create_function_call_item(
                                id=tool_call.id,
                                call_id=tool_call.id,
                                name="search_documents",
                                arguments=tool_call.function.arguments
                            )
                        )
                        output_items.append(
                            self.create_function_call_output_item(
                                call_id=tool_call.id,
                                output=context
                            )
                        )

                        messages.append({
                            "role": "tool",
                            "tool_call_id": tool_call.id,
                            "name": "search_documents",
                            "content": context
                        })

                    elif tool_name == "execute_in_databricks":
                        execution_result = execute_sql(query_args['sql_code'])

                        output_items.append(
                            self.create_function_call_item(
                                id=tool_call.id,
                                call_id=tool_call.id,
                                name="execute_in_databricks",
                                arguments=tool_call.function.arguments
                            )
                        )
                        output_items.append(
                            self.create_function_call_output_item(
                                call_id=tool_call.id,
                                output=execution_result
                            )
                        )

                        messages.append({
                            "role": "tool",
                            "tool_call_id": tool_call.id,
                            "name": "execute_in_databricks",
                            "content": execution_result
                        })

                        execution_happened = True

                next_response = client.chat.completions.create(
                    model=llm_model,
                    messages=messages,
                    tools=tools,
                    tool_choice="none" if execution_happened else "auto"
                )

                total_tokens += next_response.usage.total_tokens
                next_message = next_response.choices[0].message
                tool_calls = next_message.tool_calls

                if tool_calls:
                    messages.append(clean_message(next_message))
                else:
                    answer = next_message.content
                    if answer and "<function=" in answer:
                        answer = answer[:answer.index("<function=")].strip()

        else:
            answer = response_message.content

        output_items.append(
            self.create_text_output_item(
                text=answer,
                id="final_response"
            )
        )

        return ResponsesAgentResponse(
            output=output_items
        )


mlflow.models.set_model(DataEngCopilot())
