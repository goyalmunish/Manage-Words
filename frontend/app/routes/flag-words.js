import Ember from 'ember';

export default Ember.Route.extend({
  model(params) {
    return this.store.findRecord('flag', params.flag_id);
  },
  // renderTemplate() {
  //   this.render('flag-words');
  // }
});
