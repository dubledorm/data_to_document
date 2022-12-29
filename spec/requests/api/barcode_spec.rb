# frozen_string_literal: true

require 'swagger_helper'
require 'swagger_descriptions'


RSpec.describe 'api/barcode', type: :request do

  path '/api/barcode_to_image/{barcode}' do

    get('Получить изображение по бар коду') do
      tags 'Api'
      description BARCODE_TO_IMAGE_DESCRIPTION_API
      produces 'application/json'
      parameter name: :barcode, in: :path, type: :string, description: 'Штрих код для отображения'
      parameter name: :format, in: :query, type: :string, required: false,
                description: 'В каком формате отдать изображение. Доступные варианты: svg, png. По умолчанию - svg'
      response(200, 'successful') do
        schema '$ref' => '#/components/schemas/barcode_response'
        example 'application/json', :to_svg, {
          message: 'Ok',
          barcode: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" width=\"119px\" height=\"120px\" viewBox=\"0 0 119 120\" version=\"1.1\" preserveAspectRatio=\"none\" >\n<title>1234567890</title>\n<g id=\"canvas\" >\n<rect x=\"0\" y=\"0\" width=\"119px\" height=\"120px\" fill=\"#fff\" />\n<g id=\"barcode\" fill=\"#000\">\n<rect x=\"10\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"12\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"14\" y=\"10\" width=\"3px\" height=\"100px\" />\n<rect x=\"18\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"22\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"24\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"26\" y=\"10\" width=\"3px\" height=\"100px\" />\n<rect x=\"32\" y=\"10\" width=\"3px\" height=\"100px\" />\n<rect x=\"36\" y=\"10\" width=\"3px\" height=\"100px\" />\n<rect x=\"40\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"44\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"46\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"50\" y=\"10\" width=\"3px\" height=\"100px\" />\n<rect x=\"54\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"58\" y=\"10\" width=\"3px\" height=\"100px\" />\n<rect x=\"64\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"66\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"68\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"72\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"74\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"76\" y=\"10\" width=\"3px\" height=\"100px\" />\n<rect x=\"82\" y=\"10\" width=\"3px\" height=\"100px\" />\n<rect x=\"86\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"88\" y=\"10\" width=\"3px\" height=\"100px\" />\n<rect x=\"92\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"96\" y=\"10\" width=\"3px\" height=\"100px\" />\n<rect x=\"102\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"104\" y=\"10\" width=\"3px\" height=\"100px\" />\n<rect x=\"108\" y=\"10\" width=\"1px\" height=\"100px\" />\n\n</g></g>\n</svg>\n",
          format: 'svg'
        }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
      response(400, 'arguments error') do
        example 'application/json', 'wrong format value', {
          message: 'Wrong value of format: xml'
        }
        run_test!
      end
    end
  end
end
