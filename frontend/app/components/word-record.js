import Ember from 'ember';

export default Ember.Component.extend({
  // Properties used as arguments: word

  // Other properties
  isCreatedUpdatedShowing: false,
  readonly: true,

  // Actions
  actions: {
    showCreatedUpdated() {
      // Note that the action doesn't return anything
      this.set('isCreatedUpdatedShowing', true);
    },
    hideCreatedUpdated() {
      // Note that the action doesn't return anything
      this.set('isCreatedUpdatedShowing', false);
    },
    toggleReadonly() {
      var readonly = this.get('readonly');
      if(readonly) {
        readonly = false;
      }
      else {
        readonly = true;
      }
      this.set('readonly', readonly);
    },
    save() {
      console.log("Saving to server...");
      alert("Yet to be implemented");
    }
  }
});
