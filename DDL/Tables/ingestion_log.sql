-- Table: workspace.ai_project.ingestion_log
-- Description: Audit log tracking URL fetching status for the docs ingestion pipeline
-- Created: 2026
-- Author: Sean Incardona

CREATE TABLE IF NOT EXISTS workspace.ai_project.ingestion_log (
    log_id              BIGINT GENERATED ALWAYS AS IDENTITY,
    doc_id              BIGINT NOT NULL,
    url                 STRING,
    fetch_timestamp     TIMESTAMP,
    status              STRING,
    file_name           STRING,
    file_size_kb        DOUBLE,
    error_message       STRING,
    CONSTRAINT ingestion_log_pk PRIMARY KEY (log_id)
)
USING DELTA
COMMENT 'Audit log tracking URL fetch status for the docs ingestion pipeline';