# frozen_string_literal: true

module ReplaceFunctions

  module Html

    # Заполнить используя шаблон, который находится в отдельном шаблоне.
    # Обязательно наличие аттрибута template, который содержит назщвание шаблона.
    # Шаблон достаётся из БД по указанному названию, подставляется в клетку, послеп чего происходит заполнение данных.
    # Данные для заполнения берутся из report_params_dictionary. Должны быть представлены в виде массива json.
    # На каждую строчку отдельный массив, на каждую клетку структура json.
    class RepeatableTemplate < Base
      def initialize(report_params_dictionary, output_content, tag_and_arguments_hash)
        super(report_params_dictionary, output_content, tag_and_arguments_hash)
        @template_info = TemplateInfoService.find_by_name!(tag_and_arguments_hash['arguments']['template'])
      end

      def done!
        @data_array = value_for_replace
        result = String.new
        @data_array.each do |data_hash| # проходим по переданным данным
          result << render_template(data_hash)
        end

        replace_in_begin_string(output_content[:output], output_content[:old_string], result)
      end

      protected

      attr_reader :template_info

      def render_template(data_hash)
        report_generator = ReportGenerators::PdfGenerator.new(@template_info, data_hash)
        template_source = report_generator.template_source
        report_generator.replace_tags_in_template(template_source)
      end
    end
  end
end

