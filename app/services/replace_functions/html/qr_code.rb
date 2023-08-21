# frozen_string_literal: true

require 'rqrcode'

module ReplaceFunctions

  module Html

    # Вставить картинку qrcode
    class QrCode < Base

      def done!
        unless tag_and_arguments_hash.dig('arguments', 'width') && tag_and_arguments_hash.dig('arguments', 'height')
          raise ReplaceFunctionError, 'You should send parameters :width and :height in qrcode tag'
        end

        @qrcode_value = value_for_replace
        replace_in_begin_string(output_content[:output], output_content[:old_string], qrcode_image)
      end

      private

      attr_accessor :qrcode_value

      def qrcode_image
        svg = RQRCode::QRCode.new(@qrcode_value).as_svg(
          color: '000',
          shape_rendering: 'crispEdges',
          module_size: 11,
          standalone: true,
          use_path: false
        )
        Svg::NormalizeService.call(svg, tag_and_arguments_hash.dig('arguments', 'width'),
                                   tag_and_arguments_hash.dig('arguments', 'height'))
      rescue ArgumentError => e
        raise ReplaceFunctionError, "Could not translate #{@qrcode_value} to qrcode image. Message: #{e.message}"
      end
    end
  end
end

