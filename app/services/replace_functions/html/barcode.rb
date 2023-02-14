# frozen_string_literal: true

require 'barby'
require 'barby/barcode/code_25_interleaved'
require 'barby/outputter/svg_outputter'

module ReplaceFunctions

  module Html

    # Вставить картинку barcode
    class Barcode < Base

      def done!
        @barcode_value = value_for_replace
        replace_in_begin_string(output_content[:output], output_content[:old_string], barcode_image)
      end

      private

      attr_accessor :barcode_value

      def barcode_image
        Barby::Code25Interleaved.new(@barcode_value).to_svg
        # Ниже строчка для заполнения текстового блока с цифрами штрих кода.
        #<text fill="#000000" font-family="Serif" font-size="12" id="svg_36" lengthAdjust="spacing" letter-spacing="0" stroke="#000000" stroke-width="0" text-anchor="middle" transform="rotate(-0.464334, 63.5179, 103.47) matrix(1.54783, 0, 0, 0.866981, -33.2854, 12.3834)" x="62.54" xml:space="preserve" y="109.11">1234567890</text>
      rescue ArgumentError => e
        raise ReplaceFunctionError, "Could not translate #{@barcode_value} to barcode image. Message: #{e.message}"
      end
    end
  end
end

