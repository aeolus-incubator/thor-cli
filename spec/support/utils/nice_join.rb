module Utils
  module NiceJoin
    def nice_join(words, common_sep = ', ', last_sep = ' and ', quotes = "\"")
      unless words.empty?
        quoted_words = words.map{|word| quotes + word + quotes}
        quoted_words[0..-2].join(common_sep) + last_sep + quoted_words.last
      end
    end
  end
end
