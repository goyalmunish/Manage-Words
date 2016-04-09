import Ember from 'ember';

export default Ember.Route.extend({
  queryParams: {
    word_search: {
      refreshModel: true
    },
    full_search: {
      refreshModel: true
    }
  },
  model() {
    return this.store.findAll('word');
  }
});
