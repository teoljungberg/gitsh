module Gitsh
  module TabCompletion
    module Matchers
      class BaseMatcher
        def match?(_)
          true
        end

        def completions(_)
          []
        end

        def eql?(other)
          self.class == other.class
        end

        def hash
          self.class.hash + 1
        end
      end
    end
  end
end
