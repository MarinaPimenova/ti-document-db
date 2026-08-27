CREATE TABLE IF NOT EXISTS vector_store
(
    id         varchar(255) PRIMARY KEY,
    content    text,
    metadata   json,
    embedding  vector(1024),

    -- Generated columns extracted from metadata JSON
    content_id bigint GENERATED ALWAYS AS ((metadata ->> 'id')::bigint) STORED
    --filename   varchar(255) GENERATED ALWAYS AS ((metadata ->> 'filename')::varchar(255)) STORED
);

-- HNSW Index for vector similarity search (using Cosine Distance)
CREATE INDEX IF NOT EXISTS vector_store_embedding_hnsw_idx
    ON vector_store USING hnsw (embedding vector_cosine_ops);

-- B-Tree Indexes for efficient filtering on the generated columns
CREATE INDEX IF NOT EXISTS idx_content_id
    ON vector_store (content_id);

/*CREATE INDEX IF NOT EXISTS idx_question_id
    ON vector_store (filename);*/