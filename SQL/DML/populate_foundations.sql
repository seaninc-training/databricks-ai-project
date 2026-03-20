INSERT INTO workspace.ai_project.foundations
    (config_key, config_value, category, description)
VALUES
    ('catalog',         'workspace',                                                        'catalog',        'Unity Catalog catalog name'),
    ('schema',          'ai_project',                                                       'catalog',        'Unity Catalog schema name'),
    ('volume',          'raw_data',                                                         'catalog',        'Unity Catalog volume name'),
    ('base_url',        'https://7474648118426063.ai-gateway.cloud.databricks.com/mlflow/v1', 'model',        'Databricks AI Gateway base URL'),
    ('embedding_model', 'databricks-bge-large-en',                                          'model',          'Embedding model endpoint name'),
    ('llm_model',       'databricks-meta-llama-3-1-405b-instruct',                          'model',          'LLM model endpoint name'),
    ('endpoint_name',   'search_endpoint',                                                  'vector_search',  'Vector Search endpoint name');