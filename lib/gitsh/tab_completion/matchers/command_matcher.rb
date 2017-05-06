module Gitsh
  module TabCompletion
    module Matchers
      class CommandMatcher
        def initialize(env)
          @env = env
        end

        def match?(_word)
          true
        end

        def completions(_token)
          env.git_commands
        end

        private

        attr_reader :env
      end
    end
  end
end
