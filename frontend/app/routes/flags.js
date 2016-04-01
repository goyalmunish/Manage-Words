import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    // return [{name: 'flag1', title: 'FLAG 1'},  {name: 'flag2', title: 'FLAG 2'}];
    // return $.getJSON('/flags');
    return this.store.findAll('flag');
  }
});
