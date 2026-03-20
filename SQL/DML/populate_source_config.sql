INSERT INTO workspace.ai_project.source_config
    (source_type, landing_path, processed_path, chunks_table, index_name, min_size_kb)
VALUES
    ('books',  '/Volumes/workspace/ai_project/raw_data/books/raw',   '/Volumes/workspace/ai_project/raw_data/books/processed',   'workspace.ai_project.book_chunks',   'workspace.ai_project.book_vector_index',   10.0),
    ('docs',   '/Volumes/workspace/ai_project/raw_data/docs/raw',    '/Volumes/workspace/ai_project/raw_data/docs/processed',    'workspace.ai_project.doc_chunks',    'workspace.ai_project.doc_vector_index',    1.0),
    ('policy', '/Volumes/workspace/ai_project/raw_data/policy/raw',  '/Volumes/workspace/ai_project/raw_data/policy/processed',  'workspace.ai_project.policy_chunks', 'workspace.ai_project.policy_vector_index', 1.0);