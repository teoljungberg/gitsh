require 'spec_helper'
require 'gitsh/tab_completion/context'

describe Gitsh::TabCompletion::Context do
  describe '#prior_words' do
    it 'produces the words in the input before the word being completed' do
      context = described_class.new('stash drop my-')
      expect(context.prior_words).to eq %w(stash drop)
    end

    it 'includes variables' do
      context = described_class.new(':echo "name=$user.name" "email=')
      expect(context.prior_words).to eq [':echo', 'name=${user.name}']
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

  describe '#completing_variable?' do
    it 'returns true when the command ends with a variable' do
      expect(described_class.new(':echo $my_va')).to be_completing_variable
      expect(described_class.new(':echo "$my_va')).to be_completing_variable
      expect(described_class.new(':echo ${my_va')).to be_completing_variable
      expect(described_class.new(':echo $')).to be_completing_variable
      expect(described_class.new(':echo ${')).to be_completing_variable
    end

    it 'returns false when the command does not end with a variable' do
      expect(described_class.new(':echo hello')).not_to be_completing_variable
      expect(described_class.new(':echo $my_var ')).not_to be_completing_variable
      expect(described_class.new(':echo \'$varish')).not_to be_completing_variable
      expect(described_class.new(':echo \'$')).not_to be_completing_variable
    end
  end
end
