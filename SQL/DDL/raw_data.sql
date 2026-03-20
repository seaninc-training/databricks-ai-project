-- Volume: workspace.ai_project.raw_data
-- Description: External volume storing raw and processed source files for books and docs pipelines
-- Created: 2026
-- Author: Sean Incardona

CREATE VOLUME IF NOT EXISTS workspace.ai_project.raw_data
COMMENT 'External volume storing raw and processed source files for books and docs pipelines';

-- Expected volume structure:
-- raw_data/books/raw/
-- raw_data/books/processed/
-- raw_data/docs/raw/
-- raw_data/docs/processed/