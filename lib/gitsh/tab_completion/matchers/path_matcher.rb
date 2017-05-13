module Gitsh
  module TabCompletion
    module Matchers
      class PathMatcher
        def initialize(_env)
        end

        def name
          'path'
        end

        def match?(_)
          true
        end

        def completions(token)
          prefix = normalize_path(token)
          paths(prefix).map { |option| option.sub(prefix, token) }
        end

        private

        def normalize_path(token)
          path = File.expand_path(token)
          if token.end_with?('/') || token == ''
            path + '/'
          else
            path
          end
        end

        def paths(prefix)
          Dir["#{prefix}*"].map do |path|
            if File.directory?(path)
              path + '/'
            else
              path
            end
          end
        end
      end
    end
  end
end
