require 'spec_helper'
require 'gitsh/tab_completion/context'

describe Gitsh::TabCompletion::Context do
  describe '#prior_words' do
    it 'produces the words in the input before the word being completed' do
      context = described_class.new('stash drop my-')
      expect(context.prior_words).to eq %w(stash drop)
    end

    it 'only considers the current command' do
      context = described_class.new('stash apply my-stash && stash drop my-')
      expect(context.prior_words).to eq %w(stash drop)
    end

    it 'handles multiple lines' do
      context = described_class.new("(add .\ncommit -")
      expect(context.prior_words).to eq %w(commit)
    end

    it 'only considers the current subshell' do
      context = described_class.new(':echo (config ')
      expect(context.prior_words).to eq %w(config)
    end

    context 'with input the Lexer cannot handle' do
      it 'does not explode' do
        expect { described_class.new(':echo $').prior_words }.
          not_to raise_exception
        expect { described_class.new(':echo ${').prior_words }.
          not_to raise_exception
        expect { described_class.new(':echo ${x').prior_words }.
          not_to raise_exception
      end
    end
  end
end
