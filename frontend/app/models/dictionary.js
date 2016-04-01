import DS from 'ember-data';

export default DS.Model.extend({
  name:           DS.attr('string'),
  url:            DS.attr('string'),
  separator:      DS.attr('string'),
  suffix:         DS.attr('string'),
  additionalInfo: DS.attr('string'),
  createdAt:      DS.attr('date'),
  updatedAt:      DS.attr('date'),
  users:          DS.hasMany('user')
});
