import { pipeline } from '@xenova/transformers';

// Singleton feature extraction pipeline instance
let extractorPromise = null;

async function getExtractor() {
  if (!extractorPromise) {
    // Load feature-extraction model using Xenova/all-MiniLM-L6-v2 (384 dimensions)
    extractorPromise = pipeline('feature-extraction', 'Xenova/all-MiniLM-L6-v2');
  }
  return extractorPromise;
}

/**
 * Generates a 384-dimensional normalized embedding vector for the given text.
 * @param {string} text - Input text (e.g., ticket description)
 * @returns {Promise<number[]>} Array of 384 floating point values
 */
export async function getEmbedding(text) {
  if (!text || typeof text !== 'string') {
    throw new Error('Valid text string is required to generate embedding.');
  }

  const extractor = await getExtractor();
  // Mean pooling and normalize output for cosine similarity
  const output = await extractor(text, {
    pooling: 'mean',
    normalize: true,
  });

  return Array.from(output.data);
}

/**
 * Formats a JavaScript number array into a pgvector string format '[v1, v2, ...]'
 * @param {number[]} vector
 * @returns {string}
 */
export function formatVector(vector) {
  return `[${vector.join(',')}]`;
}
