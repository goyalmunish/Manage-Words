import Ember from 'ember';

export default Ember.Route.extend({
  model(params) {
    return this.store.findRecord('word', params.word_id);
  }
});
