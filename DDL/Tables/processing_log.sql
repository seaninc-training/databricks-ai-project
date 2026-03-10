-- Table: workspace.ai_project.processing_log
-- Description: Audit log tracking file processing status across all ingestion pipelines
-- Created: 2026
-- Author: Sean Incardona

CREATE TABLE IF NOT EXISTS workspace.ai_project.processing_log (
    log_id          STRING NOT NULL,
    file_name       STRING,
    source_type     STRING,
    processed_timestamp TIMESTAMP,
    target_table    STRING,
    chunk_count     INT,
    status          STRING,
    error_message   STRING,
    CONSTRAINT processing_log_pk PRIMARY KEY (log_id)
)
USING DELTA
COMMENT 'Audit log tracking file processing status across all ingestion pipelines';