-- Table: workspace.ai_project.doc_chunks
-- Description: Processed text chunks from technical documentation for vector search and RAG pipelines
-- Created: 2026
-- Author: Sean Incardona

CREATE TABLE IF NOT EXISTS workspace.ai_project.doc_chunks (
    chunk_id        STRING NOT NULL,
    content         STRING,
    source          STRING,
    --source_type     STRING,
    type            STRING,
    page_number     INT,
    start_index     INT,
    CONSTRAINT docs_chunks_pk PRIMARY KEY (chunk_id)
)
USING DELTA
TBLPROPERTIES ('delta.enableChangeDataFeed' = 'true')
COMMENT 'Processed text chunks from technical documentation for vector search and RAG pipelines';

