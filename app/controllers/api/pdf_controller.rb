# frozen_string_literal: true

module Api
  # Controller for convert to pdf format
  class PdfController < ApplicationController
    include PdfConcern

    def html_to_pdf
      pdf_params_hash = pdf_params!.decorate.as_json.deep_symbolize_keys
      pdf = build_pdf(pdf_params_hash)
      render json: { message: 'Ok', pdf_base64: Base64.strict_encode64(pdf) }, status: 200
    end
  end
end
