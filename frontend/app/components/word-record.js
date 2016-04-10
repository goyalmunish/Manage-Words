import Ember from 'ember';

export default Ember.Component.extend({
  // Properties used as arguments: word
  isCreatedUpdatedShowing: false,
  actions: {
    showCreatedUpdated() {
      // Note that the action doesn't return anything
      this.set('isCreatedUpdatedShowing', true);
    },
    hideCreatedUpdated() {
      // Note that the action doesn't return anything
      this.set('isCreatedUpdatedShowing', false);
    }
  }
});
