module Gitsh
  module TabCompletion
    module Matchers
      class RemoteMatcher
        def initialize(env)
          @env = env
        end

        def match?(_)
          true
        end

        def completions(_)
          env.repo_remotes
        end

        def eql?(other)
          self.class == other.class
        end

        def hash
          self.class.hash + 1
        end

        private

        attr_reader :env
      end
    end
  end
end
