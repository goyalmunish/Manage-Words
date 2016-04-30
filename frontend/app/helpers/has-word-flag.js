import Ember from 'ember';

export function hasWordFlag(params/*, hash*/) {
  var word_flags = params[0];
  var id = params[1];
  return word_flags.mapBy('id').contains(id);
}

export default Ember.Helper.helper(hasWordFlag);
