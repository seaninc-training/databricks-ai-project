-- Table: workspace.ai_project.doc_sources
-- Description: Directory of documentation URLs used as source material for the docs ingestion pipeline
-- Created: 2026
-- Author: Sean Incardona

CREATE TABLE IF NOT EXISTS workspace.ai_project.doc_sources (
    doc_id              BIGINT GENERATED ALWAYS AS IDENTITY,
    url                 STRING NOT NULL,
    topic               STRING,
    title               STRING,
    active              BOOLEAN,
    date_added          TIMESTAMP,
    last_fetched        TIMESTAMP,
    fetch_method        STRING,
    source_type         STRING,
    CONSTRAINT doc_sources_pk PRIMARY KEY (doc_id)
)
USING DELTA
COMMENT 'Directory of documentation URLs used as source material for the docs ingestion pipeline';