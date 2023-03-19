# frozen_string_literal: true

# Сюда собираем вспомогательные процедуры для контроллеров, работающих с pdf
module PdfConcern
  extend ActiveSupport::Concern

  def pdf_params!
    begin
      pdf_params = HtmlToPdf::PdfFromStringParams.new(params.required(:options))
    rescue StandardError => e
      raise ArgumentError, e.message
    end
    raise ArgumentError, pdf_params.errors.full_messages unless pdf_params.valid?

    pdf_params
  end

  def build_pdf(params_hash)
    WickedPdf.new.pdf_from_string(params_hash[:html_text], params_hash.except(:html_text).merge(encoding: 'utf-8'))
  end

  def many_pdf_params!
    options_array = params.required(:options_array)
    begin
      options_array.map { |options| HtmlToPdf::PdfFromStringParams.new(options) }
    rescue StandardError => e
      raise ArgumentError, e.message
    end
  end
end
