# frozen_string_literal: true

module ReplaceFunctions

  module Docx

    # Просто заменить tag на значение из словаря
    class Simple < Base

      def done!
        r_nodes[start_node_index].xpath('w:t').first.content = value_for_replace
        (start_node_index + 1..end_node_index).each_with_index do |index|
          r_nodes[index].unlink
        end
      end

      private

      def r_nodes
        output_content[:r_nodes]
      end

      def start_node_index
        output_content[:start_node_index]
      end

      def end_node_index
        output_content[:end_node_index]
      end
    end
  end
end

