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
    CONSTRAINT doc_sources_pk PRIMARY KEY (doc_id)
)
USING DELTA
COMMENT 'Directory of documentation URLs used as source material for the docs ingestion pipeline';


/** INITIAL LOAD **/
-- INSERT INTO workspace.ai_project.doc_sources 
--     (url, topic, title, active, date_added, last_fetched)
-- VALUES
--     -- Delta Lake
--     ('https://docs.databricks.com/aws/en/tables/', 
--      'Delta Lake', 'Delta Lake Tables Overview', 
--      true, current_timestamp(), null),

--     ('https://docs.databricks.com/aws/en/delta/tutorial', 
--      'Delta Lake', 'Create and Manage Delta Tables', 
--      true, current_timestamp(), null),

--     ('https://docs.databricks.com/aws/en/tables/managed', 
--      'Delta Lake', 'Managed Tables', 
--      true, current_timestamp(), null),

--     -- Unity Catalog
--     ('https://docs.databricks.com/aws/en/data-governance/unity-catalog/', 
--      'Unity Catalog', 'Unity Catalog Overview', 
--      true, current_timestamp(), null),

--     ('https://docs.databricks.com/aws/en/data-governance/unity-catalog/best-practices', 
--      'Unity Catalog', 'Unity Catalog Best Practices', 
--      true, current_timestamp(), null),

--      ('https://docs.databricks.com/aws/en/tables/delta-table', 
--      'Unity Catalog', 'Unity Catalog Table Types', 
--      true, current_timestamp(), null),

--     -- Spark SQL
--     ('https://docs.databricks.com/aws/en/sql/language-manual/', 
--      'Spark SQL', 'Spark SQL Language Manual', 
--      true, current_timestamp(), null);
