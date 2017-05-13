require 'spec_helper'
require 'gitsh/tab_completion/dsl/plus_operation_factory'

describe Gitsh::TabCompletion::DSL::PlusOperationFactory do
  describe '#build' do
    it 'calls the child factory and adds a free transition' do
      start_state = double(:start_state)
      context = double(:context)
      end_state = double(:end_state, add_free_transition: nil)
      child = double(:factory, build: end_state)
      factory = described_class.new(child)

      result = factory.build(start_state, context: context)

      expect(result).to eq end_state
      expect(child).to have_received(:build).with(start_state, context: context)
      expect(end_state).to have_received(:add_free_transition).with(start_state)
    end
  end
end
