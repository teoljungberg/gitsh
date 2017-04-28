require 'gitsh/tab_completion/automaton_factory'
require 'gitsh/tab_completion/command_completer'
require 'gitsh/tab_completion/context'
require 'gitsh/tab_completion/escaper'

module Gitsh
  module TabCompletion
    class Facade
      def initialize(line_editor, env)
        @line_editor = line_editor
        @env = env
      end

      def call(input)
        context = Context.new(line_editor.line_buffer)
        command_completions(context, input)
      end

      private

      attr_reader :line_editor, :env

      def command_completions(context, input)
        CommandCompleter.new(
          line_editor,
          context.prior_words,
          input,
          automaton,
          escaper,
        ).call
      end

      def automaton
        @automaton ||= AutomatonFactory.build(env)
      end

      def escaper
        @escaper ||= Escaper.new(line_editor)
      end
    end
  end
end
