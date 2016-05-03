import Ember from 'ember';

export default Ember.Component.extend({
  // Properties used as arguments: word, user

  // Other properties

  // Computed propreties
  dictLinksForUserWord: Ember.computed('user', 'word', function() {
    var user = this.get('user');
    var word = this.get('word');
    var dictionaries = user.get('dictionaries');
    var links = [];
    dictionaries.forEach(function(dict) {
      // generating the link url
      let dict_name = dict.get('name');
      let dict_url = dict.get('url');
      let dict_separator = dict.get('separator');
      let dict_suffix = dict.get('suffix');
      let joined_words = word.split(" ").join(dict_separator);
      let link_url = '';
      link_url += dict_url;
      link_url += joined_words;
      if(dict_suffix) { link_url += dict_suffix; }
      // generating the link
      let a_link = `<div class="dictionary_link"><a href=${link_url} target ='_blank'>${dict_name}</a></div>`;
      let a_link_html_safe = Ember.String.htmlSafe(a_link);
      // adding to links array
      links.addObject(a_link_html_safe);
    });

    // didn't have to put above block in then() block
    // dictionaries.then(function(dictionaries) {
    // });

    // console.log(links);
    return links;
  }),

});
