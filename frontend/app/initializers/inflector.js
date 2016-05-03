import Ember from 'ember';
export function initialize(/* application */) {
  // application.inject('route', 'foo', 'service:foo');
  var inflector = Ember.Inflector.inflector;
  inflector.irregular('dictionary', 'dictionaries');
}

export default {
  name: 'inflector',
  initialize
};
