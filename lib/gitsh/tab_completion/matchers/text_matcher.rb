module Gitsh
  module TabCompletion
    module Matchers
      class TextMatcher
        def initialize(word)
          @word = word
        end

        def match?(match_word)
          word == match_word
        end

        def completions(token)
          [word]
        end

        def eql?(other)
          other.is_a?(self.class) && other.word == word
        end

        def hash
          self.class.hash + word.hash
        end

        protected

        attr_reader :word
      end
    end
  end
end
