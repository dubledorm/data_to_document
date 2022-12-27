# frozen_string_literal: true

module Cdn
  # Controller for convert to pdf format
  class PdfController < ApplicationController
    include PdfConcern

    def html_to_pdf
      pdf_params_hash = pdf_params!.decorate.as_json.deep_symbolize_keys
      pdf = build_pdf(pdf_params_hash)

      ::Dir::Tmpname.create(%w[html .pdf]) do |tmpname|
        File.open(tmpname, 'wb') { |file| file.write(pdf) }
        send_file(tmpname)
      end
    end
  end
end
