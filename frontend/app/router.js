import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('users', function() {
    this.route('user', { path: '/:user_id' });
  });
  this.route('words', function() {
    this.route('word', { path: '/:word_id' });
  });
  this.route('dictionaries', function() {
    this.route('dictionary', { path: '/:dictionary_id' });
  });
  this.route('flags', function() {
    this.route('flag', { path: '/:flag_id' });
  });
  this.route('flag-words', { path: 'flag-words/:flag_id' }, function() {
    this.route('word', { path: '/:word_id' });
  });
  this.route('backup');
  this.route('login');
});

export default Router;
