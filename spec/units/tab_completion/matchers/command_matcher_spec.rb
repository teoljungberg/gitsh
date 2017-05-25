require 'spec_helper'
require 'gitsh/tab_completion/matchers/command_matcher'

describe Gitsh::TabCompletion::Matchers::CommandMatcher do
  describe '#match?' do
    it 'always returns true' do
      matcher = described_class.new(double(:env), double(:internal_command))

      expect(matcher.match?('foo')).to be_truthy
      expect(matcher.match?('')).to be_truthy
    end
  end

  describe '#completions' do
    it 'returns the available commands (Git, internal, and aliases)' do
      env = double(
        :env,
        git_commands: ['add', 'commit'],
        git_aliases: ['graph', 'force'],
      )
      internal_command = double(
        :internal_command,
        commands: [':echo', ':help'],
      )
      matcher = described_class.new(env, internal_command)

      expect(matcher.completions('anything')).to match_array [
        'add', 'commit',
        'graph', 'force',
        ':echo', ':help',
      ]
    end
  end

  describe '#eql?' do
    it 'returns true when given another instance of the same class' do
      env = double(:env)
      internal_command = double(:internal_command)
      matcher1 = described_class.new(env, internal_command)
      matcher2 = described_class.new(env, internal_command)

      expect(matcher1.eql?(matcher2)).to be true
    end

    it 'returns false when given an instance of any other class' do
      matcher = described_class.new(double(:env), double(:internal_command))
      other = double(:not_a_matcher)

      expect(matcher.eql?(double)).not_to be true
    end
  end

  describe '#hash' do
    it 'returns the same value for all instances of the class' do
      env = double(:env)
      internal_command = double(:internal_command)
      matcher1 = described_class.new(env, internal_command)
      matcher2 = described_class.new(env, internal_command)

      expect(matcher1.hash).to eq(matcher2.hash)
    end
  end
end
