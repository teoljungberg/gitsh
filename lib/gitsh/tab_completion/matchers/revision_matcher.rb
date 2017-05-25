module Gitsh
  module TabCompletion
    module Matchers
      class RevisionMatcher
        SEPARATORS = /(?:\.\.+|[:^~\\])/

        def initialize(env)
          @env = env
        end

        def match?(_)
          true
        end

        def completions(token)
          prefix = prefix(token)
          env.repo_heads.map { |option| prefix + option }
        end

        def eql?(other)
          self.class == other.class
        end

        def hash
          self.class.hash + 1
        end

        private

        attr_reader :env

        def prefix(token)
          token.rpartition(SEPARATORS)[0...-1].join
        end
      end
    end
  end
end
