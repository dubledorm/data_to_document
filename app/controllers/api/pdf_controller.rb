# frozen_string_literal: true

# Controller for convert to pdf format
class Api::PdfController < ApplicationController

  def html_to_pdf
    pdf = WickedPdf.new.pdf_from_string(Base64.strict_decode64(params.required(:html_base64_text)))
    render json: { message: 'Ok', pdf_base64: Base64.strict_encode64(pdf) }, status: 200
  end
end
