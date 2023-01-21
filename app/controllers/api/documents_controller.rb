# frozen_string_literal: true

module Api
  # Controller for create report
  class DocumentsController < ApplicationController
    def build_report
      report_content = CreateReportService.call(params.required(:template_name), params.required(:template_params))
      render json: { message: 'Ok', pdf_base64: Base64.strict_encode64(report_content) }, status: 200
    end
  end
end
