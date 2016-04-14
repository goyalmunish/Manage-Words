import Ember from 'ember';

export default Ember.Component.extend({
  // Properties used as arguments: words, word_search, full_search

  // Other properties
  suggestions: null,
  sort_by_possibilities: ['id', 'word', 'trick'],
  sort_by: null,

  // Computed propreties
  filteredWords: Ember.computed('word_search', 'full_search', 'sort_by', function() {
    var filtered_words = this.get('words');
    var word_search = this.get('word_search');
    var full_search = this.get('full_search');
    var sort_by = this.get('sort_by');

    // word search
    if(word_search) {
      console.log("Word search for: " + word_search);
      var re_word_search = new RegExp(word_search);

      // filtered_words = words.filterBy('word', word_search);
      filtered_words = filtered_words.filter(function(item) {
        var result = re_word_search.test(item.get('word'));  // Note: Here we used item.get('word') and not item.word. The later one would work only in templates.
        return result;
      });
    } else {
      console.log("Word search for: <blank_value>");
    }

    // full search
    if(full_search) {
      console.log("Full search for: " + full_search);
      var re_full_search = new RegExp(full_search);

      filtered_words = filtered_words.filter(function(item) {
        var result = re_full_search.test(item.get('word')) || re_full_search.test(item.get('trick')) || re_full_search.test(item.get('additionalInfo'));
        return result;
      });
    } else {
      console.log("Full search for: <blank_value>");
    }

    // sorting
    if(sort_by && this.get('sort_by_possibilities').contains(sort_by)){
      console.log("SortBy: " + sort_by);
      filtered_words = filtered_words.sortBy(sort_by);
    } else {
      console.log("Tried to sort_by " + sort_by);
    }

    return filtered_words;
  }),

  numberOfFilteredWords: Ember.computed('filteredWords', function() {
    // Note that calling just `length` works in view but not here
    return this.get('filteredWords').get('length');
  }),

  // Actions
  actions: {
    setSortBy(sort_by) {
      this.set('sort_by', sort_by);
    },
    // this functionality is implemented using actions for learning purpose, though
    // it could be easily done using computed property based on filteredWords
    calculateSuggestions() {
      if (this.get('word_search') || this.get('full_search')) {
        var suggestions = this.get('filteredWords').map(function(item) {
          return item.get('word');
        });
        this.set('suggestions', suggestions.slice(0,9));
      } else {
        this.set('suggestions').clear();
      }
    }
  }
});
