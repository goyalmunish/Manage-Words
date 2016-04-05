import DS from 'ember-data';

export default DS.Model.extend({
  // attributes
  word:           DS.attr('string'),
  trick:          DS.attr('string'),
  additionalInfo: DS.attr('string'),
  createdAt:      DS.attr('date'),
  updatedAt:      DS.attr('date'),
  // associations
  // user:           DS.belongsTo('user'),
  // flags:          DS.hasMany('flag')
});
