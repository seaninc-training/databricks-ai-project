CREATE TABLE IF NOT EXISTS workspace.ai_project.source_config (
    source_type     STRING NOT NULL,
    landing_path    STRING,
    processed_path  STRING,
    chunks_table    STRING,
    index_name      STRING,
    min_size_kb     DOUBLE,
    CONSTRAINT pk_source_config PRIMARY KEY (source_type)
)
COMMENT 'Source type configuration for the AI project ingestion and processing pipeline';