# frozen_string_literal: true

module ReplaceFunctions
  # Инструмент для разрезания Html таблицы построчно
  class HtmlRow

    attr_reader :start_tag, :body, :end_tag

    def initialize(source_str)
      end_row_pos = source_str.rindex(HtmlRowTools::REG_EXP_FIND_END_TR)
      raise ReplaceFunctionError, 'Could not find finish tag of row' if end_row_pos.nil?

      m = HtmlRowTools::REG_EXP_FIND_TR.match(source_str)
      raise ReplaceFunctions::ReplaceFunctionError, 'Could not find start tag of row' if m.nil?

      @start_tag = m[0]
      @end_tag = source_str[end_row_pos..]
      @body = source_str[m.end(0)..end_row_pos - 1]
    end
  end
end
