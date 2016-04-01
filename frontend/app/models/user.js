import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  firstName:      DS.attr('string'),
  lastName:       DS.attr('string'),
  email:          DS.attr('string'),
  createdAt:      DS.attr('date'),
  updatedAt:      DS.attr('date'),
  words:          DS.hasMany('word'),
  dictionaries:   DS.hasMany('dictionary'),

  fullName: Ember.computed('firstName', 'lastName', function() {
    return `${this.get('firstName')} ${this.get('lastName')}`;
  })
});
