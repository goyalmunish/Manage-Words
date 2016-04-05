import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  // attributes
  firstName:            DS.attr('string'),
  lastName:             DS.attr('string'),
  email:                DS.attr('string'),
  type:                 DS.attr('string'),
  provider:             DS.attr('string'),
  uid:                  DS.attr('string'),
  additionalInfo:       DS.attr('string'),
  authenticationToken:  DS.attr('string'),
  createdAt:            DS.attr('date'),
  updatedAt:            DS.attr('date'),
  // computed properties
  fullName: Ember.computed('firstName', 'lastName', function() {
    return `${this.get('firstName')} ${this.get('lastName')}`;
  }),
  // relations
  // words:                DS.hasMany('word'),
  // dictionaries:         DS.hasMany('dictionary'),
});
