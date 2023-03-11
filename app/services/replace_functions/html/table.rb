# frozen_string_literal: true

module ReplaceFunctions

  module Html

    # Заполнить таблицу. Сам тег должен располагаться в левом верхнем углу таблицы.
    # Заполнение пойдёт с клетки с тегом.
    # Данные для заполнения берутся из report_params_dictionary. Должны быть представлены в виде массива строк.
    # Заполнение будет опираться на этот массив. Т.е. если в массиве в первой строке указаны 3 значения, то алгоритм
    # будет пытаться найти и заполнить 3 клетки. Если не найдёт их в Html, то выдаст ошибку.
    # Возможно два режима заполнения таблицы, которые регламентируются атрибутом add_rows.
    # Если add_rows == true, то алгоритм будет самостоятельно добавлять новые строки, кроме 1-й.
    # Если add_rows == false, то все строки должны уже присутствовать в html и если в report_params_dictionary их
    # оказывается больше, то ошибка.
    # По умолчанию add_rows == true
    class Table < Base

      def done!
        @table_data = value_for_replace
        @html_row_tools = HtmlRowTools.new(@output_content[:output])
        sample_row = start_row + @html_row_tools.next_row.sub(output_content[:old_string], '') if add_rows?
        result = ''
        @table_data.each do |columns_array| # проходим по переданным строкам
          if result.empty? # Проверяем, что это первая строка
            row = @html_row_tools.cut_next_row
            result += fill_start_row(row, columns_array)
          else
            row = add_rows? ? sample_row : @html_row_tools.cut_next_row
            result += fill_row(row, columns_array)
          end
        end

        result + @html_row_tools.remainder
      end

      protected

      def prepare_column(column_data)
        column_data
      end

      private

      attr_accessor :table_data, :html_row_tools

      def add_rows?
        @add_rows ||= if tag_and_arguments_hash['arguments'].key?('addrows')
                        tag_and_arguments_hash['arguments']['addrows'] == 'true'
                      else
                        true
                      end
      end

      # Найти предшестующий тег <tr>. Нужно, чтлобы в дальнейшем сформировать строку для копирования.
      # Ищем в строке prev_string в обратную сторону.
      def start_row
        start_row_pos = @output_content[:prev_string]&.rindex(HtmlRowTools::REG_EXP_FIND_TR)
        raise ReplaceFunctionError, 'Could not find start tag of row' if start_row_pos.nil?

        @output_content[:prev_string][start_row_pos..]
      end

      # Заполнить первую строку. Отличие её в том, что начинается она без начального тега <tr><td>
      # Поэтому в первой клетке сразу вставляем заменяемое значение
      def fill_start_row(row, columns)
        result = ''
        source = HtmlRowTools.new(row)
        columns.each do |column|
          td = source.cut_next_td
          start_tag, _body, end_tag = HtmlRowTools.split_td(td)
          if result.empty?
            result = "#{prepare_column(column)}#{end_tag}"
          else
            result += start_tag + prepare_column(column) + end_tag
          end
        end

        result + source.remainder
      end

      def fill_row(row, columns)
        result = ''
        html_row = HtmlRow.new(row)
        source = HtmlRowTools.new(html_row.body)
        columns.each do |column|
          td = source.cut_next_td
          start_tag, _body, end_tag = HtmlRowTools.split_td(td)
          result += start_tag + prepare_column(column) + end_tag
        end

        html_row.start_tag + result + html_row.end_tag
      end
    end
  end
end

