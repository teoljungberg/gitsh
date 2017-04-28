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
end
