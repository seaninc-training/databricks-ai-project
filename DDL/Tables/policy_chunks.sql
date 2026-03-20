CREATE TABLE IF NOT EXISTS workspace.ai_project.policy_chunks (
    chunk_id        STRING NOT NULL,
    content         STRING,
    source          STRING,
    type            STRING,
    page_number     INT,
    start_index     INT,
    created_at      TIMESTAMP DEFAULT current_timestamp(),
    CONSTRAINT pk_policy_chunks PRIMARY KEY (chunk_id)
)
TBLPROPERTIES (
    'delta.enableChangeDataFeed' = 'true', 
    'delta.feature.allowColumnDefaults' = 'supported'
    )
COMMENT 'Chunked text from organizational policy documents';