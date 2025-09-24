const request = require('supertest');
const app = require('../index');

describe('GET /', () => {
  it('responds with Hi Koronet Team.', async () => {
    const res = await request(app).get('/');
    expect(res.statusCode).toBe(200);
    expect(res.text).toBe('Hi Koronet Team.\n');
  });
});
