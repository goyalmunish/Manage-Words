import Ember from 'ember';

export function wordFlagCheckboxName(params/*, hash*/) {
  var id = params[0];
  return `flag${id}`;
}

export default Ember.Helper.helper(wordFlagCheckboxName);
