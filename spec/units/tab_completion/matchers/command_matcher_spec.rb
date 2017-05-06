require 'spec_helper'
require 'gitsh/tab_completion/matchers/command_matcher'

describe Gitsh::TabCompletion::Matchers::CommandMatcher do
  describe '#match?' do
    it 'always returns true' do
      matcher = described_class.new(double(:env))

      expect(matcher.match?('foo')).to be_truthy
      expect(matcher.match?('')).to be_truthy
    end
  end

  describe '#completions' do
    it 'returns the available Git commands' do
      env = double(:env, git_commands: ['add', 'commit'])
      matcher = described_class.new(env)

      expect(matcher.completions('anything')).to match_array ['add', 'commit']
    end
  end
end
