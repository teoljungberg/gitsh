require 'spec_helper'
require 'gitsh/tab_completion/matchers/path_matcher'

describe Gitsh::TabCompletion::Matchers::PathMatcher do
  describe '#match?' do
    it 'always returns true' do
      matcher = described_class.new

      expect(matcher.match?('foo')).to be_truthy
      expect(matcher.match?('')).to be_truthy
    end
  end

  describe '#completions' do
    it 'returns paths based on the input' do
      in_a_temporary_directory do
        make_directory('foo')
        write_file('foo/first.txt')
        write_file('foo/second.txt')
        write_file('first.txt')
        write_file('second.txt')
        matcher = described_class.new

        expect(matcher.completions('')).
          to match_array ['foo/', 'first.txt', 'second.txt']
        expect(matcher.completions('f')).to match_array ['foo/', 'first.txt']
        expect(matcher.completions('foo')).to match_array ['foo/']
        expect(matcher.completions('foo/')).
          to match_array ['foo/first.txt', 'foo/second.txt']
      end
    end
  end
end
