# frozen_string_literal: true

require 'tempfile'
require 'barby'
require 'barby/barcode/code_25_interleaved'
require 'barby/outputter/png_outputter'

# Controller for make image for barcode
module Cdn
  # Преобразует параметр barcode в картинку. Формат кода Interleaved 2 из 5
  class BarcodeController < ApplicationController

    def barcode_to_image
      barcode = Barby::Code25Interleaved.new(params.required(:barcode))
      ::Dir::Tmpname.create(%w[barcode .png]) do |tmpname|
        File.open(tmpname, 'wb') { |file| file.write(barcode.to_png) }
        send_file(tmpname)
      end
    end
  end
end
