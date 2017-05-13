require 'spec_helper'
require 'gitsh/tab_completion/automaton'

describe Gitsh::TabCompletion::Automaton do
  describe '#match' do
    context 'for a deterministic automaton' do
      it 'returns a set containing the end state' do
        # 0 --a--> 1

        state_0 = described_class::State.new(0)
        state_1 = described_class::State.new(1)
        state_0.add_text_transition('a', state_1)
        automaton = described_class.new(state_0)

        expect(automaton.match([])).to eq [state_0].to_set
        expect(automaton.match(['a'])).to eq [state_1].to_set
        expect(automaton.match(['b'])).to eq Set.new
      end
    end

    context 'for a non-deterministic automaton' do
      it 'returns a set containing the end states' do
        #  /--a--\    /--b--\
        # 0       -> 1       -> 2
        #  \-----/    \-----/

        state_0 = described_class::State.new(0)
        state_1 = described_class::State.new(1)
        state_2 = described_class::State.new(2)
        state_0.add_text_transition('a', state_1)
        state_0.add_free_transition(state_1)
        state_1.add_text_transition('b', state_2)
        state_1.add_free_transition(state_2)
        automaton = described_class.new(state_0)

        expect(automaton.match([])).to eq [state_0, state_1, state_2].to_set
        expect(automaton.match(['a'])).to eq [state_1, state_2].to_set
        expect(automaton.match(['a', 'b'])).to eq [state_2].to_set
        expect(automaton.match(['b'])).to eq [state_2].to_set
      end
    end
  end

  describe '#completions' do
    context 'for a deterministic automaton' do
      it 'returns possible completions' do
        #  /--aa--> 1
        # 0
        #  \--ab--> 2

        state_0 = described_class::State.new(0)
        state_1 = described_class::State.new(1)
        state_2 = described_class::State.new(2)
        state_0.add_text_transition('aa', state_1)
        state_0.add_text_transition('ab', state_2)
        automaton = described_class.new(state_0)

        expect(automaton.completions([], '')).to eq ['aa', 'ab']
        expect(automaton.completions([], 'a')).to eq ['aa', 'ab']
        expect(automaton.completions([], 'ab')).to eq ['ab']
        expect(automaton.completions([], 'a')).to eq ['aa', 'ab']
        expect(automaton.completions(['aa'], '')).to eq []
        expect(automaton.completions(['foo'], '')).to eq []
      end
    end

    context 'for a non-deterministic automaton' do
      it 'returns possible completions' do
        #    /--aa--\
        #   0        -> 1 --bb--> 2
        #    \------/

        state_0 = described_class::State.new(0)
        state_1 = described_class::State.new(1)
        state_2 = described_class::State.new(2)
        state_0.add_text_transition('aa', state_1)
        state_0.add_free_transition(state_1)
        state_1.add_text_transition('bb', state_2)
        automaton = described_class.new(state_0)

        expect(automaton.completions([], '')).to eq ['aa', 'bb']
        expect(automaton.completions([], 'a')).to eq ['aa']
        expect(automaton.completions(['aa'], '')).to eq ['bb']
        expect(automaton.completions(['foo'], '')).to eq []
      end
    end
  end
end
