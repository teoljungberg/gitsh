module Gitsh
  module TabCompletion
    module Matchers
      class CommandMatcher
        def initialize(env, internal_command)
          @env = env
          @internal_command = internal_command
        end

        def match?(_)
          true
        end

        def completions(_)
          env.git_commands + env.git_aliases + internal_command.commands
        end

        def eql?(other)
          self.class == other.class
        end

        def hash
          self.class.hash + 1
        end

        private

        attr_reader :env, :internal_command
      end
    end
  end
end
