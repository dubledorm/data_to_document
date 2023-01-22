# frozen_string_literal: true

module ReportGenerators

  # Генератор для pdf
  class PdfGenerator < Base
    REG_EXP_FIND_TAGS = /#\[[^\]]+\]/.freeze

    def replace_tags_in_template(_template)
      remaining_str = _template
      result = ''

      loop do
        m = REG_EXP_FIND_TAGS.match(remaining_str)
        break if m.nil?

        result += remaining_str[0..m.begin(0) - 1] if m.begin(0).positive? # Копируем до начала тега
        remaining_str = replace_from_begin(result, remaining_str[m.begin(0)..], m[0])
      end
      result + remaining_str
    end

    def generate_report(_prepared_template)
      WickedPdf.new.pdf_from_string(_prepared_template, encoding: 'utf-8')
    end

    # Найти все тэги в документе и вернуть их в виде массива tag_and_arguments_hash
    def tag_list
      result = []
      template_source.scan(REG_EXP_FIND_TAGS) do |tag_string|
        tag_and_arguments_hash = TagParseService.parse!(clear_tag_string(tag_string))
        result << tag_and_arguments_hash
      end

      result
    end

    private

    # На основании tag_string найти функцию подстановки
    # Изменить и вернуть source_string
    def replace_from_begin(prev_string, source_string, tag_string)
      tag_and_arguments_hash = TagParseService.parse!(clear_tag_string(tag_string))
      html_content = { old_string: tag_string,
                       output: source_string,
                       prev_string: prev_string }
      replace_function = build_function_instance(tag_and_arguments_hash, html_content)
      replace_function.done!
    end

    def clear_tag_string(tag_string)
      tag_string[2..-2]
    end
  end
end

