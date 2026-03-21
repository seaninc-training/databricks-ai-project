CREATE TABLE IF NOT EXISTS workspace.ai_project.foundations (
    config_id       BIGINT GENERATED ALWAYS AS IDENTITY,
    config_key      STRING NOT NULL,
    config_value    STRING,
    category        STRING,
    description     STRING,
    CONSTRAINT pk_foundations PRIMARY KEY (config_id)
)
COMMENT 'Global configuration values for the AI project pipeline';