# frozen_string_literal: true

# Controller for convert to pdf format
class Api::PdfController < ApplicationController

  def html_to_pdf
    pdf = WickedPdf.new.pdf_from_string('<h1>Hello There!</h1>')
    render json: { message: 'Ok', pdf_base64: Base64.strict_encode64(pdf) }, status: 200
  end
end
