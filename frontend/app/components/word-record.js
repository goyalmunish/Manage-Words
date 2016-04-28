import Ember from 'ember';

export default Ember.Component.extend({
  // Properties used as arguments: word

  // Other properties
  isCreatedUpdatedShowing: false,
  readonly: true,
  freshState: true,
  updateSuccess: false,

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
        this.set('freshState', true);
      }
      else {
        readonly = true;
      }
      this.set('readonly', readonly);
    },
    save() {
      console.log("Updating to server...");
      var that = this;
      this.word.save().then(function() {
        console.log("Update to server Succeed!");
        that.set('freshState', false);
        that.set('updateSuccess', true);
        that.set('readonly', true);
      }, function() {
        console.log("Update to server FAILED!");
        that.set('freshState', false);
        that.set('updateSuccess', false);
      });
    }
  }
});
