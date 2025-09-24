const request = require('supertest');
const app = require('./app');

describe('GET /', () => {
  it('responds with Hi Koronet Team.', async () => {
    const res = await request(app).get('/');
    expect(res.text).toBe('Hi Koronet Team.');
    expect(res.statusCode).toBe(200);
  });
});