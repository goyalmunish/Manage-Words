import DS from 'ember-data';

export default DS.Model.extend({
  name:           DS.attr('string'),
  value:          DS.attr('string'),
  desc:           DS.attr('string'),
  createdAt:      DS.attr('date'),
  updatedAt:      DS.attr('date'),
  // words:          DS.hasMany('word')
});
