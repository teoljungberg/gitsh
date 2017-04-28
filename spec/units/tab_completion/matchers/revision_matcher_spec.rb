require 'spec_helper'
require 'gitsh/tab_completion/matchers/revision_matcher'

describe Gitsh::TabCompletion::Matchers::RevisionMatcher do
  describe '#match?' do
    it 'always returns true' do
      matcher = described_class.new(double(:env))

      expect(matcher.match?('foo')).to be_truthy
      expect(matcher.match?('')).to be_truthy
    end
  end

  describe '#completions' do
    context 'given blank input' do
      it 'returns the names of all heads' do
        env = double(:env, repo_heads: ['master', 'my-feature'])
        matcher = described_class.new(env)

        expect(matcher.completions('')).to match_array ['master', 'my-feature']
      end
    end

    context 'given input containing a prefix' do
      it 'returns the name of all heads with the prefix added' do
        env = double(:env, repo_heads: ['master', 'my-feature'])
        matcher = described_class.new(env)

        expect(matcher.completions('master..')).
          to match_array ['master..master', 'master..my-feature']
        expect(matcher.completions('HEAD:')).
          to match_array ['HEAD:master', 'HEAD:my-feature']
        expect(matcher.completions('HEAD:foo')).
          to match_array ['HEAD:master', 'HEAD:my-feature']
      end
    end
  end
end
