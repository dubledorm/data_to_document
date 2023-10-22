# frozen_string_literal: true

module Cdn
  # Controller for create report
  class DocumentsController < ApplicationController
    def build_report
      report_content, report_format = CreateReportService.call(params.required(:template_name), params.required(:template_params))
      ::Dir::Tmpname.create(['result', ".#{report_format}"]) do |tmpname|
        File.open(tmpname, 'wb') { |file| file.write(report_content) }
        send_file(tmpname)
      end
    end
  end
end
