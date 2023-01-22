# frozen_string_literal: true

module Cdn
  # Controller for create report
  class DocumentsController < ApplicationController
    def build_report
      report_content = CreateReportService.call(params.required(:template_name), params.required(:template_params))
      ::Dir::Tmpname.create(%w[html .pdf]) do |tmpname|
        File.open(tmpname, 'wb') { |file| file.write(report_content) }
        send_file(tmpname)
      end
    end
  end
end
