require 'gitsh/tab_completion/matchers/base_matcher'

module Gitsh
  module TabCompletion
    module Matchers
      class RemoteMatcher
        def initialize(env)
          @env = env
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
