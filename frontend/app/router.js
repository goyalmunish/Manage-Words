import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('user');
  this.route('words');
  this.route('dictionaries');
  this.route('flags', function() {
    this.route('flag', { path: '/:flag_id' });
  });
  this.route('backup');
  this.route('login');
});

export default Router;
