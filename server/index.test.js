const request = require('supertest');
const app = require('./index');

describe('GET /', () => {
  it('should return Hello from Koronet Test!', async () => {
    const res = await request(app).get('/');
    expect(res.text).toBe('Hello from Koronet Test!');
    expect(res.statusCode).toBe(200);
  });
});
