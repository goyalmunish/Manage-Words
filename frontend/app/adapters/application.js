import DS from 'ember-data';

export default DS.JSONAPIAdapter.extend({
  host: 'http://localhost:4000',
  // host: 'http://localhost:4000?user_email=munishapc@gmail.com&&user_token=EDqxKSvfQKswPZYf1wW7',
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-User-Email': 'munishapc@gmail.com',  // TODO: code smell
    'X-User-Token': 'EDqxKSvfQKswPZYf1wW7'  // TODO: code smell
  }
});
