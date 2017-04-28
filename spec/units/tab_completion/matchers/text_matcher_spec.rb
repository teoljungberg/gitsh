require 'spec_helper'
require 'gitsh/tab_completion/matchers/text_matcher'

describe Gitsh::TabCompletion::Matchers::TextMatcher do
  describe '#match?' do
    it 'returns true when given the same word' do
      expect(described_class.new('commit').match?('commit')).to be_truthy
    end

    it 'returns false when given anything else' do
      expect(described_class.new('commit').match?('log')).to be_falsy
    end
  end

  describe '#completions' do
    it 'returns the word, regardless of the input' do
      matcher = described_class.new('commit')

      expect(matcher.completions('foo')).to eq ['commit']
      expect(matcher.completions('')).to eq ['commit']
      expect(matcher.completions('commit')).to eq ['commit']
    end
  end
end
