# frozen_string_literal: true

module ReplaceFunctions

  module Html

    # Просто заменить tag на значение из словаря
    class Simple < Base

      def done!
        new_value = value_for_replace
        replace_in_begin_string(output_content[:output], output_content[:old_string], new_value)
      end
    end
  end
end

