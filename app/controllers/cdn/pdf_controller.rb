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

    def many_html_to_pdf
      options_array = many_pdf_params!
      result_pdf = CombinePDF.new
      options_array.each do |options|
        pdf = build_pdf(options.decorate.as_json.deep_symbolize_keys)
        ::Dir::Tmpname.create(%w[html .pdf]) do |tmpname|
          File.open(tmpname, 'wb') { |file| file.write(pdf) }
          result_pdf << CombinePDF.load(tmpname)
        end
      end

      ::Dir::Tmpname.create(%w[result .pdf]) do |tmpname|
        result_pdf.save(tmpname)
        send_file(tmpname)
      end
    end
  end
end
