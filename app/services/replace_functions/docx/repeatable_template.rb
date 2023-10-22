# frozen_string_literal: true

module ReplaceFunctions

  module Docx

    # Заполнить используя шаблон, который находится в отдельном шаблоне.
    # Обязательно наличие аттрибута template, который содержит назщвание шаблона.
    # Шаблон достаётся из БД по указанному названию, подставляется в клетку, послеп чего происходит заполнение данных.
    # Данные для заполнения берутся из report_params_dictionary. Должны быть представлены в виде массива json.
    # На каждую строчку отдельный массив, на каждую клетку структура json.
    class RepeatableTemplate < Base
      def initialize(report_params_dictionary, output_content, tag_and_arguments_hash)
        super(report_params_dictionary, output_content, tag_and_arguments_hash)
        return if tag_and_arguments_hash['arguments']['templateisparenttable'] == 'true'

        raise StandardError, 'Необходимо проставить параметр templateisparenttable в true. Иначе не работает'
        #@template_info = TemplateInfoService.find_by_name!(tag_and_arguments_hash['arguments']['template'])
      end

      def done!
        @data_array = value_for_replace
        # Ищем родительскую таблицу
        current_table_node = parent_table!(r_nodes[start_node_index])
        delete_repeatable_template_tag # Удаляем найденный таг
        original_table = current_table_node.dup

        @data_array.each_with_index do |data_hash, index| # проходим по переданным данным
          current_table_node = add_table(current_table_node, original_table) if index.positive?
          fill_table(current_table_node, data_hash)
        end
      end

      protected

      attr_reader :template_info

      # Найти ближайший родитель w:tbl
      def parent_table!(node)
        result = node.xpath('ancestor::w:tbl').first
        raise 'Не могу найти таблицу предка' unless result

        result
      end

      # скопировать эталонную таблицу после table_node
      def add_table(table_node, original_table)
        table_node.add_next_sibling(original_table.dup)
      end

      def fill_table(current_table_node, data_hash)
        report_generator = ReportGenerators::DocxGenerator.new(TemplateInfo.new(output_format: :docx), data_hash)
        report_generator.replace_tags_in_document(current_table_node)
      end

      def delete_repeatable_template_tag
        (start_node_index..end_node_index).each_with_index do |index|
          r_nodes[index].unlink
        end
      end

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

