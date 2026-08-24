-- Search using pgvector. pgVectorLiteral must be like: "[0.001, -0.12, ...]".
WITH ranked AS (
    SELECT id::varchar,
           substring(content from 1 for 200) || ' ...' AS content,
           metadata ->> 'source'                       AS source,
           1 - (embedding <=> CAST(? AS vector))       AS similarity,
           ROW_NUMBER() OVER (PARTITION BY metadata ->> 'source' ORDER BY 1 - (embedding <=> CAST(? AS vector)) DESC) AS rn
    FROM vector_store
)
SELECT id, content, source, similarity
FROM ranked
WHERE rn = 1
;

--

WITH ranked_chunks AS (
    SELECT
        id,
        content,
        metadata,
        1 - (embedding <=> :embedding::vector) as similarity,
        metadata->>'id' as content_id,
        ROW_NUMBER() OVER (
            PARTITION BY metadata->>'id'
            ORDER BY embedding <=> :embedding::vector
            ) as chunk_rank
    FROM vector_store
    WHERE 1 - (embedding <=> :embedding::vector) >= :threshold
      and (length(content) > 50)
),
     content_scores AS (
         SELECT
             content_id,
             MAX(similarity) as best_similarity
         FROM ranked_chunks
         WHERE chunk_rank <= :chunksPerContent
         GROUP BY content_id
         ORDER BY best_similarity DESC
     )
SELECT
    rc.id,
    rc.metadata->>'id' as content_id,
    rc.metadata->>'type' as type,
    rc.metadata->>'source' as source,
    rc.content,
    rc.similarity,
    --rc.metadata->>'studyName' as study_name,
    --rc.metadata->>'revOpsId' as rev_ops_id,
    --0.0 as text_score,
    rc.similarity as vector_score
FROM ranked_chunks rc
         INNER JOIN content_scores cs ON rc.content_id = cs.content_id
WHERE rc.chunk_rank <= :chunksPerContent
ORDER BY cs.best_similarity DESC, rc.chunk_rank
LIMIT 5
;