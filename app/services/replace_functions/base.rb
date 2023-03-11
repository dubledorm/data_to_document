# frozen_string_literal: true

module ReplaceFunctions

  class ReplaceFunctionError < StandardError
  end

  # Базовый класс для создания функций замены.
  # Функции замены имеют свою реализацию под каждый формат выходного документа
  class Base

    # Регулярное выражение для нахождения тега функции подстановки.
    REG_EXP_FIND_TAGS = /\{\{[^\{\}]+\}\}/.freeze

    # :report_params_dictionary - список параметров для подстановки,
    # :output_content - контент, предоставляющий данные/функции для вывода результата замены
    # :tag_and_arguments_hash - разобранный тэг
    attr_accessor :report_params_dictionary, :output_content, :tag_and_arguments_hash

    def initialize(report_params_dictionary, output_content, tag_and_arguments_hash)
      @report_params_dictionary = report_params_dictionary
      @output_content = output_content
      @tag_and_arguments_hash = stringify_and_down_keys(tag_and_arguments_hash)
    end

    # Эта функция выполняет подстановку
    def done!
      raise NotImplementedError
    end

    protected

    # Найти замену для имени тега в списке параметров для замены
    def value_for_replace
      key = @tag_and_arguments_hash['name'].downcase
      unless @report_params_dictionary.key?(key)
        raise ReplaceFunctionError, "Could not found replace value for tag #{@tag_and_arguments_hash['name']}"
      end

      @report_params_dictionary[key]
    end

    # Заменить в output_str old_string, которая находится на 0-й позиции
    # на new_value
    def replace_in_begin_string(output_str, old_string, new_value)
      new_value.to_s + output_str[old_string.length..]
    end

    def stringify_and_down_keys(hash)
      Hash[*hash.stringify_keys.map do |key, value|
        value.is_a?(Hash) ? [key.downcase, stringify_and_down_keys(value)] : [key.downcase, value]
      end.flatten]
    end
  end
end

