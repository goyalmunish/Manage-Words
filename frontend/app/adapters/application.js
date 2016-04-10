// app/adapters/application.js
import DS from 'ember-data';
import ENV from '../config/environment';
import DataAdapterMixin from 'ember-simple-auth/mixins/data-adapter-mixin';

export default DS.JSONAPIAdapter.extend(DataAdapterMixin, {
  // host: 'http://localhost:4000"
  // host: 'http://localhost:4000?user_email=munishapc@gmail.com&&user_token=EDqxKSvfQKswPZYf1wW7',
  host: ENV.APP.API_HOST,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-User-Email': ENV.APP.API_ID,    // TODO: code smell
    'X-User-Token': ENV.APP.API_TOKEN,  // TODO: code smell
  },
  authorizer: 'authorizer:application',
});

