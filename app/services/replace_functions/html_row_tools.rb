# frozen_string_literal: true

module ReplaceFunctions
  # Инструмент для разрезания Html таблицы построчно
  class HtmlRowTools

    REG_EXP_FIND_TR = /<tr[^<>]*>/
    REG_EXP_FIND_END_TR = /<\/tr>/
    REG_EXP_FIND_END_TD = /<\/td>/
    REG_EXP_SPLIT_TD = /(?<start>(<td[^<>]*>)*)(?<body>[^<>]*)(?<end><\/td>)/

    def initialize(source_str)
      @source_str = source_str
    end

    # Отдаёт следующую строку. От начала source_str ишет завершающий </tr> и отдаёт вместе с ним
    # В source_str при этом, отданный кусок отрезается
    def cut_next_row
      result = find_next_row
      @source_str = @source_str[result.length..]

      result
    end

    # Отдаёт следующую строку но не отрезает её от @source_str
    def next_row
      find_next_row
    end


    # Отдаёт следующую колонку. От начала source_str ишет завершающий </tв> и отдаёт вместе с ним
    # В source_str при этом, отданный кусок отрезается
    def cut_next_td
      m = REG_EXP_FIND_END_TD.match(@source_str)
      raise ReplaceFunctions::ReplaceFunctionError, 'Could not find finish tag of row' if m.nil?

      result = @source_str[0..m.end(0) - 1]
      @source_str = @source_str[m.end(0)..]

      result
    end

    # Разбивает строку вида <td>..</td> на три части - стартовый тег, тело, завершающий тег
    # возвращает массив из трёх элементов
    def self.split_td(source)
      m = REG_EXP_SPLIT_TD.match(source)
      if m.nil? || m[:start].nil? || m[:body].nil? || m[:end].nil?
        raise ReplaceFunctions::ReplaceFunctionError, "Could not split row #{source} as like <td>..</td>"
      end

      [m[:start], m[:body], m[:end]]
    end

    def remainder
      @source_str
    end

    private

    attr_accessor :source_str

    # Ищет конец строки </tr> и возвращает подстроку от начала, до найденного конца включительно
    def find_next_row
      m = REG_EXP_FIND_END_TR.match(@source_str)
      raise ReplaceFunctions::ReplaceFunctionError, 'Could not find finish tag of row' if m.nil?

      @source_str[0..m.end(0) - 1]
    end
  end
end
