# frozen_string_literal: true

module ReplaceFunctions

  module Html

    # Заполнить таблицу используя шаблон, который находится в отдельном шаблоне.
    # Сам тег должен располагаться в левом верхнем углу таблицы.
    # Заполнение пойдёт с клетки с тегом.
    # Обязательно наличие аттрибута template, который содержит назщвание шаблона.
    # Шаблон достаётся из БД по указанному названию, подставляется в клетку, послеп чего происходит заполнение данных.
    # Данные для заполнения берутся из report_params_dictionary. Должны быть представлены в виде массива json.
    # На каждую строчку отдельный массив, на каждую клетку структура json.
    # Возможно два режима заполнения таблицы, которые регламентируются атрибутом add_rows.
    # Если add_rows == true, то алгоритм будет самостоятельно добавлять новые строки, кроме 1-й.
    # Если add_rows == false, то все строки должны уже присутствовать в html и если в report_params_dictionary их
    # оказывается больше, то ошибка.
    # По умолчанию add_rows == true
    class TableWithTemplate < Table
      def initialize(report_params_dictionary, output_content, tag_and_arguments_hash)
        super(report_params_dictionary, output_content, tag_and_arguments_hash)
        @table_template_info = TemplateInfoService.find_by_name!(tag_and_arguments_hash['arguments']['template'])
      end

      protected

      attr_reader :table_template_info

      def prepare_column(column_data)
        report_generator = ReportGenerators::PdfGenerator.new(@table_template_info, column_data)
        template_source = report_generator.template_source
        report_generator.replace_tags_in_template(template_source)
      end
    end
  end
end

