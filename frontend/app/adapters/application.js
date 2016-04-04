// app/adapters/application.js
import DS from 'ember-data';
import DataAdapterMixin from 'ember-simple-auth/mixins/data-adapter-mixin';

export default DS.JSONAPIAdapter.extend(DataAdapterMixin, {
  host: 'http://localhost:4000',
  // host: 'http://localhost:4000?user_email=munishapc@gmail.com&&user_token=EDqxKSvfQKswPZYf1wW7',
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // 'X-User-Email': 'munishapc@gmail.com',  // TODO: code smell
    // 'X-User-Token': 'EDqxKSvfQKswPZYf1wW7'  // TODO: code smell
  },
  authorizer: 'authorizer:application',
});

