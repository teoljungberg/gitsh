module Gitsh
  module TabCompletion
    module Matchers
      class RemoteMatcher
        def initialize(env)
          @env = env
        end

        def name
          'remote'
        end

        def match?(_)
          true
        end

        def completions(_)
          env.repo_remotes
        end

        private

        attr_reader :env
      end
    end
  end
end
