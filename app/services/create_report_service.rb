# frozen_string_literal: true

# Сервис для генерации отчёта на основе шаблона
# Основная задача выбрать класс для формирования отчёта на основе записи template_info
class CreateReportService

  def self.call(template_name, report_params)
    template_info = TemplateInfoService.find_by_name!(template_name)
    generator_class = "ReportGenerators::#{template_info.output_format.to_s.camelize}Generator".constantize
    generator_class.new(template_info, report_params).generate
  rescue NameError => e
    raise ArgumentError,
          "Could not find ReportGenerator class for report output_format #{template_info.output_format}, message: #{e.message}"
  end
end
