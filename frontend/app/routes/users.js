import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    return this.store.query('user', { filter: {email: 'munishapc@gmail.com'} });    // TODO: code smell, hard coding
    // return this.store.findAll('user');
  }
});
