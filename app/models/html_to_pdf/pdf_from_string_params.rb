# frozen_string_literal: true

module HtmlToPdf

  # Параметры для функции pdf_from_string
  class PdfFromStringParams < BaseModel

    ORIENTATION_VALUES = %w[Portrait Landscape].freeze
    PAGE_SIZE_VALUES = %w[A4 Letter].freeze

    attr_accessor :html_text, :header_html, :footer_html, :orientation, :page_height, :page_width, :page_size, :margin

    validates :html_text, presence: true
    validates :page_height, :page_width, numericality: { only_integer: true }, allow_nil: true
    validates :orientation, inclusion: { in: ORIENTATION_VALUES }, allow_nil: true
    validates :page_size, inclusion: { in: PAGE_SIZE_VALUES }, allow_nil: true

    def attributes=(hash)
      return unless hash

      hash.each do |key, value|
        if key == 'margin'
          send("#{key}=", HtmlToPdf::Margin.new(value))
          next
        end

        send("#{key}=", value)
      end
    end

    def attributes
      result = {}
      %i[html_text header_html footer_html orientation page_height page_width page_size].each do |key|
        result[key] = send(key) unless send(key).blank?
      end

      result['margin'] = margin.as_json unless margin.blank?
      result
    end
  end
end
