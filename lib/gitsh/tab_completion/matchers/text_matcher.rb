module Gitsh
  module TabCompletion
    module Matchers
      class TextMatcher
        def initialize(word)
          @word = word
        end

        def name
          'text'
        end

        def match?(word)
          @word == word
        end

        def completions(token)
          if word.start_with?('-') ^ token.start_with?('-')
            []
          else
            [word]
          end
        end

        private

        attr_reader :word
      end
    end
  end
end
