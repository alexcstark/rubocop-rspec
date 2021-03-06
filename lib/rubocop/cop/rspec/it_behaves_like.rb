# frozen_string_literal: true

module RuboCop
  module Cop
    module RSpec
      # Checks that only one `it_behaves_like` style is used.
      #
      # @example when configuration is `EnforcedStyle: it_behaves_like`
      #   # bad
      #   it_should_behave_like 'a foo'
      #
      #   # good
      #   it_behaves_like 'a foo'
      #
      # @example when configuration is `EnforcedStyle: it_should_behave_like`
      #   # bad
      #   it_behaves_like 'a foo'
      #
      #   # good
      #   it_should_behave_like 'a foo'
      class ItBehavesLike < Cop
        include ConfigurableEnforcedStyle

        MSG = 'Prefer `%s` over `%s` when including examples in '\
              'a nested context.'.freeze

        def_node_matcher :example_inclusion_offense, '(send _ % ...)'

        def on_send(node)
          example_inclusion_offense(node, alternative_style) do
            add_offense(node, :expression)
          end
        end

        def autocorrect(node)
          ->(corrector) { corrector.replace(node.loc.selector, style.to_s) }
        end

        private

        def message(_node)
          format(MSG, style, alternative_style)
        end
      end
    end
  end
end
