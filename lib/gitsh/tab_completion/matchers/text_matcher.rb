module Gitsh
  module TabCompletion
    module Matchers
      class TextMatcher
        def initialize(word)
          @word = word
        end

        def match?(word)
          @word == word
        end

        def completions(token)
          [word]
        end

        private

        attr_reader :word
      end
    end
  end
end
