-- Metadata contract:
-- document_id
-- section_id

CREATE TABLE IF NOT EXISTS vector_store
(
    id        uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    content   text,
    metadata  jsonb,
    embedding vector(1024),
    -- Generated columns extracted from metadata JSON
    document_id bigint GENERATED ALWAYS AS ((metadata ->> 'document_id')::bigint) STORED,
    section_id bigint GENERATED ALWAYS AS ((metadata ->> 'section_id')::bigint) STORED
);

-- HNSW Index for vector similarity search (using Cosine Distance)
CREATE INDEX IF NOT EXISTS vector_store_embedding_hnsw_idx
    ON vector_store USING hnsw (embedding vector_cosine_ops);


-- B-Tree Indexes for efficient filtering on the generated columns
CREATE INDEX IF NOT EXISTS idx_document_id
    ON vector_store (document_id);

CREATE INDEX IF NOT EXISTS idx_section_id
    ON vector_store (section_id);
