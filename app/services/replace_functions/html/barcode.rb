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
      rescue ArgumentError => e
        raise ReplaceFunctionError, "Could not translate #{@barcode_value} to barcode image. Message: #{e.message}"
      end
    end
  end
end

