-- Table: workspace.ai_project.book_chunks
-- Description: Processed text chunks from book source files for vector search and RAG pipelines
-- Created: 2026
-- Author: Sean Incardona

CREATE TABLE IF NOT EXISTS workspace.ai_project.book_chunks (
    chunk_id        STRING NOT NULL,
    content         STRING,
    source          STRING,
    --source_type     STRING,
    type            STRING,
    page_number     INT,
    start_index     INT,
    CONSTRAINT books_chunks_pk PRIMARY KEY (chunk_id)
)
USING DELTA
TBLPROPERTIES ('delta.enableChangeDataFeed' = 'true')
COMMENT 'Processed text chunks from book source files for vector search and RAG pipelines';
