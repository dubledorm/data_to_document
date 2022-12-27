# frozen_string_literal: true

module HtmlToPdf

  # Margin для PdfFromStringParams
  class Margin < BaseModel

    attr_accessor :top, :bottom, :right, :left

    validates :top, :bottom, :right, :left, numericality: { only_integer: true }, allow_nil: true

    def attributes
      result = {}
      %i[top bottom right left].each do |key|
        result[key] = send(key) unless send(key).blank?
      end

      result
    end
  end
end
