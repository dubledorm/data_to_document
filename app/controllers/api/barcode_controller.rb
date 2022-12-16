# frozen_string_literal: true
require 'barby'
require 'barby/barcode/code_25_interleaved'
require 'barby/outputter/svg_outputter'

# Controller for convert to pdf format
class Api::BarcodeController < ApplicationController

  def barcode_to_image
    barcode = Barby::Code25Interleaved.new('03671234567893')
    
    render json: { message: 'Ok', barcode_svg: barcode.to_svg }, status: 200
  end
end
