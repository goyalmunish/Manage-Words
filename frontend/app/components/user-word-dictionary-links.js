import Ember from 'ember';

export default Ember.Component.extend({
  // Properties used as arguments: word, user

  // Other properties

  // Computed propreties
  dictLinksForUserWord: Ember.computed('user', 'word', function() {
    let user = this.get('user');
    let word = this.get('word');
    let dictionaries = user.get('dictionaries');
    let links = [];
    if(dictionaries === undefined) {
      // alert("Would you mind first loading the Users!");
      console.log("Warning: In order to load the dictionary links, please load users first!");
    }
    else {
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
    }

    // Note: didn't have to put above block in then() block
    // dictionaries.then(function(dictionaries) {
    // });

    // console.log(links);
    return links;
  }),

});
