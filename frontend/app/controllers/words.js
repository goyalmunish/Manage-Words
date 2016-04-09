import Ember from 'ember';

export default Ember.Controller.extend({
  queryParams: ['word_search', 'full_search'],
  word_search: null,
  full_search: null,
});
