import Ember from 'ember';

export default Ember.Controller.extend({
  queryParams: ['word_search', 'full_search'],
  word_search: null,
  full_search: null,

  filteredWords: Ember.computed('word_search', 'model', function() {
    var filtered_words = this.get('model');
    var word_search = this.get('word_search');
    var full_search = this.get('full_search');

    if(word_search) {
      console.log("Word search for: " + word_search);
      var re_word_search = new RegExp(word_search);

      // filtered_words = words.filterBy('word', word_search);
      filtered_words = filtered_words.filter(function(item, index, self) {
        var result = re_word_search.test(item.get('word'));  // Note: Here we used item.get('word') and not item.word. The later one would work only in templates.
        return result;
      });
    }

    if(full_search) {
      console.log("Full search for: " + full_search);
      var re_full_search = new RegExp(full_search);

      filtered_words = filtered_words.filter(function(item, index, self) {
        var result = re_full_search.test(item.get('word')) || re_full_search.test(item.get('trick')) || re_full_search.test(item.get('additionalInfo'));
        return result;
      });
    }

    return filtered_words;
  })
});
