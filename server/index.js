const express = require('express');
const { Pool } = require('pg');
const Redis = require('ioredis');
const client = require('prom-client');

const app = require('./app');

const app = express();
const collectDefaultMetrics = client.collectDefaultMetrics;
collectDefaultMetrics();
const requestCounter = new client.Counter({ name: 'http_requests_total', help: 'Total HTTP requests', labelNames: ['method','path','status'] });

// Postgres pool (reads connection info from env vars)
const pool = new Pool({
  connectionString: process.env.DATABASE_URL || 'postgresql://postgres:postgres@postgres:5432/postgres'
});

// Redis client
const redis = new Redis({
  host: process.env.REDIS_HOST || 'redis',
  port: process.env.REDIS_PORT ? Number(process.env.REDIS_PORT) : 6379
});

app.get('/', async (req, res) => {
  // increment counter
  res.setHeader('Content-Type', 'text/plain');
  try {
    requestCounter.inc({ method: req.method, path: '/', status: 200 }, 1);
    // simple DB ping (non-blocking)
    pool.query('SELECT 1').catch(() => {});
    // Redis ping
    redis.ping().catch(() => {});
  } catch (e) {}
  res.send('Hi Koronet Team.\n');
});

app.get('/health', async (req, res) => {
  try {
    // Check Postgres and Redis quickly
    await pool.query('SELECT 1');
    await redis.ping();
    requestCounter.inc({ method: req.method, path: '/health', status: 200 }, 1);
    res.json({ status: 'ok' });
  } catch (e) {
    requestCounter.inc({ method: req.method, path: '/health', status: 500 }, 1);
    res.status(500).json({ status: 'error', error: e.message });
  }
});

app.get('/metrics', async (req, res) => {
  res.set('Content-Type', client.register.contentType);
  res.end(await client.register.metrics());
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server listening on ${PORT}`);
});

module.exports = app; // for tests
