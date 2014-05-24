module MyDictionary

  def self.included(base)
    base.extend(ClassMethods);
  end

  module ClassMethods
    # module class methods will be kept here
    def cambridge(phrase)
      url = 'http://dictionary.cambridge.org/dictionary/british/'
      return "#{url}#{phrase.split.join('-')}"
    end

    def macmillan(phrase)
      url = 'http://www.macmillandictionary.com/dictionary/british/'
      return "#{url}#{phrase.split.join('-')}"
    end

    def longman(phrase)
      url = 'http://www.ldoceonline.com/search/?q='
      return "#{url}#{phrase.split.join('%20')}"
    end

    def collins(phrase)
      url = 'http://www.collinsdictionary.com/dictionary/english/'
      return "#{url}#{phrase.split.join('-')}"
    end

    def merriam_webster(phrase)
      url = 'http://www.merriam-webster.com/dictionary/'
      return "#{url}#{phrase.split.join('%20')}"
    end

    def oxford_learner(phrase)
      url = 'http://www.oxfordlearnersdictionaries.com/definition/english/'
      return "#{url}#{phrase.split.join('-')}"
    end

    def dictionary_dot_com(phrase)
      url = 'http://dictionary.reference.com/browse/'
      return "#{url}#{phrase.split.join('+')}"
    end

    def google_search(phrase)
      url = 'https://www.google.co.in/webhp?#q='
      phrase += ' meaning'
      return "#{url}#{phrase.split.join('+')}"
    end

    def oxford(phrase)
      # Not That Good
      url = 'http://www.oxforddictionaries.com/definition/english/'
      return "#{url}#{phrase.split.join('-')}"
    end
  end

  # module instance methods
end