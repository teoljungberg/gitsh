module Gitsh
  module TabCompletion
    module Matchers
      class PathMatcher
        def match?(_)
          true
        end

        def completions(token)
          prefix = normalize_path(token)
          paths(prefix).map { |option| option.sub(prefix, token) }
        end

        def eql?(other)
          self.class == other.class
        end

        def hash
          self.class.hash + 1
        end

        private

        def normalize_path(token)
          if token.end_with?('/')
            File.expand_path(token) + '/'
          else
            File.expand_path(token)
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
