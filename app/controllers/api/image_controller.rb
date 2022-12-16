# frozen_string_literal: true

# Controller for convert to pdf format
class Api::ImageController < ApplicationController

  def html_to_image
    kit = IMGKit.new('<h1>Hello There!</h1>', :quality => 50)
    render json: { message: 'Ok', jpg_base64: Base64.strict_encode64(kit.to_img(:jpg)) }, status: 200
  end
end
