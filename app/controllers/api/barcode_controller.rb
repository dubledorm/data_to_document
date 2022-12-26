# frozen_string_literal: true
require 'barby'
require 'barby/barcode/code_25_interleaved'
require 'barby/outputter/svg_outputter'
require 'barby/outputter/png_outputter'

# Controller for make image for barcode
module Api
  # Преобразует параметр barcode в картинку. Формат кода Interleaved 2 из 5
  class BarcodeController < ApplicationController

    def barcode_to_image
      format = params[:format] || 'svg'
      barcode = Barby::Code25Interleaved.new(params.required(:barcode))
      case format
      when 'svg'
        barcode_image = barcode.to_svg
      when 'png'
        barcode_image = barcode.to_image
      else
        render json: { message: "Wrong value of format: #{format}" }, status: 400
        return
      end

      render json: { message: 'Ok',
                     barcode: barcode_image,
                     format: format }, status: 200
    end
  end
end
