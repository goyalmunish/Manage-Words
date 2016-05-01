import Ember from 'ember';

export default Ember.Component.extend({
  // Properties used as arguments: word, store

  // Other properties
  isCreatedUpdatedShowing: false,
  readonly: true,
  freshState: true,
  updateSuccess: false,
  allFlags: Ember.computed(function() {
    var all_flags = this.get('store').findAll('flag');
    // Note that if we put below console.log call here, it would just print 0
    all_flags.then(function() {
      console.log(`No. of Flags: ${all_flags.get('length')}`);
    });
    // returning promise, as all promises get resolved (or failed) before rendering of template
    // return all_flags.sortBy('name');    // TODO: this statement is not working
    return all_flags;
  }),

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
      var word = this.get('word');
      var that = this;
      console.log(`Updating word with id ${word.id} to server...`);
      word.save().then(function() {
        console.log("Update to server Succeed!");
        that.set('freshState', false);
        that.set('updateSuccess', true);
        that.set('readonly', true);
      }, function() {
        console.log("Update to server FAILED!");
        that.set('freshState', false);
        that.set('updateSuccess', false);
      });
    },
    addRemoveFlag(id) {
      // console.log("addRemoveFlag started executing..");
        var that = this;
        var word = that.get('word');   // Note that it is not a promise
        var wordFlags = word.get('flags');
      // Method 1:
      if (false) {
        console.log("Note: This if-block should not execute, take it as a reference in using Ember.RSVP.hash and findRecord with PushObject");
        let flag = that.get('store').findRecord('flag', id);
        let hsh = Ember.RSVP.hash({
          word: word,
          flag: flag,
          wordFlags: wordFlags
        });
        // If you want to use findRecord(), then you need to use then() method to execute
        // the stuff that is to be executed after promise is resolved.
        // But note that peekRecord() method return synchronously
        hsh.then(
          function(hash) {
            if (hash.wordFlags.contains(hash.flag)) {
              console.log(`Delete flag with id ${id} to word with id ${word.id}...`);
              hash.wordFlags.removeObject(hash.flag);
              // Note that removeObject() just modifies the object in UI and doesn't sync it to server
            } else {
              console.log(`Add flag with id ${id} to word with id ${word.id}...`);
              hash.wordFlags.pushObject(hash.flag);
              // Note that pushObject() just modifies the object in UI and doesn't sync it to server
            }
          },
          function(error) {
            console.log(`Warning: Promise reject with error: ${error}`);
          }
        );
      }
      // Method 2:
      // Note: Here we used peekRecord instead of findRecord
      let flag = that.get('store').peekRecord('flag', id);
      if (wordFlags.contains(flag)) {
        console.log(`Delete flag with id ${id} to word with id ${word.id}...`);
        wordFlags.removeObject(flag);
        // Note that removeObject() just modifies the object in UI and doesn't sync it to server
      } else {
        console.log(`Add flag with id ${id} to word with id ${word.id}...`);
        wordFlags.pushObject(flag);
        // Note that pushObject() just modifies the object in UI and doesn't sync it to server
      }
    },
  }
});
