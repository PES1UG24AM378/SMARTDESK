import pg from 'pg';

const { Pool } = pg;

// Singleton pool instance across hot reloads in Next.js development
let pool;

if (!global._pgPool) {
  global._pgPool = new Pool({
    connectionString: process.env.DATABASE_URL,
    ssl: process.env.DATABASE_URL && process.env.DATABASE_URL.includes('localhost') 
      ? false 
      : { rejectUnauthorized: false }, // SSL support for Supabase/Neon
  });
}
pool = global._pgPool;

/**
 * Execute a raw SQL query with parameters using the connection pool.
 * @param {string} text - SQL query string
 * @param {Array} params - Query parameters
 * @returns {Promise<pg.QueryResult>}
 */
export async function query(text, params) {
  const start = Date.now();
  const res = await pool.query(text, params);
  const duration = Date.now() - start;
  // console.debug('Executed query', { text, duration, rows: res.rowCount });
  return res;
}

/**
 * Get a client from the pool (useful for manual transactions).
 * Remember to release the client when finished!
 * @returns {Promise<pg.PoolClient>}
 */
export async function getClient() {
  const client = await pool.connect();
  return client;
}

export default pool;
