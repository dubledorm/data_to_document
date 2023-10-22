# frozen_string_literal: true

module Api
  # Controller for create report
  class DocumentsController < ApplicationController
    def build_report
      report_content = CreateReportService.call(params.required(:template_name), params.required(:template_params))
      render json: { message: 'Ok', pdf_base64: Base64.strict_encode64(report_content) }, status: 200
    end

    def tags
      template_info = TemplateInfoService.find_by_name!(params.required(:template_name))
      generator_class = "ReportGenerators::#{template_info.output_format.to_s.camelize}Generator".constantize
      #      generator = ReportGenerators::PdfGenerator.new(template_info, {})
      generator = generator_class.new(template_info, {})
      render json: { message: 'Ok', tag_list: generator.tag_list }, status: 200
    end
  end
end
