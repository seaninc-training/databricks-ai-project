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


-- Scrape sources (2 new)
-- INSERT INTO workspace.ai_project.doc_sources
--     (url, topic, title, active, date_added, last_fetched, fetch_method)
-- VALUES
--     ('https://docs.databricks.com/aws/en/notebooks/best-practices.html', 
--      'Databricks', 'Databricks Notebook Best Practices', true, current_timestamp(), null, 'scrape'),
    
--     ('https://www.databricks.com/blog/2022/06/25/software-engineering-best-practices-with-databricks-notebooks.html', 
--      'Databricks', 'Software Engineering Best Practices with Databricks Notebooks (Blog)', true, current_timestamp(), null, 'scrape');

-- API sources (GitHub)
-- INSERT INTO workspace.ai_project.doc_sources
--     (url, topic, title, active, date_added, last_fetched, fetch_method)
-- VALUES
--     ('https://api.github.com/repos/delta-io/delta/contents/examples/python/quickstart.py', 
--      'Delta Lake', 'Delta Lake Python Quickstart', true, current_timestamp(), null, 'api'),
    
--     ('https://api.github.com/repos/delta-io/delta/contents/examples/cheatsheet/delta_lake_cheat_sheet.pdf', 
--      'Delta Lake', 'Delta Lake Cheat Sheet', true, current_timestamp(), null, 'api'),
    
--     ('https://api.github.com/repos/databricks/notebook-best-practices/contents/notebooks/covid_eda_modular.py', 
--      'Databricks', 'Databricks Modular Notebook Example', true, current_timestamp(), null, 'api'),
    
--     ('https://api.github.com/repos/databricks/notebook-best-practices/contents/covid_analysis/transforms.py', 
--      'Databricks', 'Databricks Notebook Transforms Module', true, current_timestamp(), null, 'api'),
    
--     ('https://api.github.com/repos/apache/spark/contents/docs/sql-programming-guide.md', 
--      'Spark SQL', 'Apache Spark SQL Programming Guide', true, current_timestamp(), null, 'api');
