require 'spec_helper'
require 'gitsh/tab_completion/matchers/remote_matcher'

describe Gitsh::TabCompletion::Matchers::RemoteMatcher do
  describe '#match?' do
    it 'always returns true' do
      matcher = described_class.new(double(:env))

      expect(matcher.match?('foo')).to be_truthy
      expect(matcher.match?('')).to be_truthy
    end
  end

  describe '#completions' do
    it 'returns the available Git remotes' do
      env = double(:env, repo_remotes: ['origin', 'github'])
      matcher = described_class.new(env)

      expect(matcher.completions('anything')).
        to match_array ['origin', 'github']
    end
  end
end
