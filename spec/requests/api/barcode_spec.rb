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
        let(:barcode) { '1234567890' }
        schema '$ref' => '#/components/schemas/barcode_response'
        example 'application/json', 'получить изображение в svg', {
          message: 'Ok',
          barcode: '<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" width=\"137px\" height=\"120px\" viewBox=\"0 0 137 120\" version=\"1.1\" preserveAspectRatio=\"none\" >\n<title>202799131044</title>\n<g id=\"canvas\" >\n<rect x=\"0\" y=\"0\" width=\"137px\" height=\"120px\" fill=\"#fff\" />\n<g id=\"barcode\" fill=\"#000\">\n<rect x=\"10\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"12\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"14\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"16\" y=\"10\" width=\"3px\" height=\"100px\" />\n<rect x=\"20\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"24\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"28\" y=\"10\" width=\"3px\" height=\"100px\" />\n<rect x=\"32\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"34\" y=\"10\" width=\"3px\" height=\"100px\" />\n<rect x=\"38\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"40\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"44\" y=\"10\" width=\"3px\" height=\"100px\" />\n<rect x=\"50\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"52\" y=\"10\" width=\"3px\" height=\"100px\" />\n<rect x=\"58\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"60\" y=\"10\" width=\"3px\" height=\"100px\" />\n<rect x=\"66\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"68\" y=\"10\" width=\"3px\" height=\"100px\" />\n<rect x=\"74\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"78\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"80\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"82\" y=\"10\" width=\"3px\" height=\"100px\" />\n<rect x=\"86\" y=\"10\" width=\"3px\" height=\"100px\" />\n<rect x=\"90\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"92\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"96\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"100\" y=\"10\" width=\"3px\" height=\"100px\" />\n<rect x=\"104\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"106\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"108\" y=\"10\" width=\"3px\" height=\"100px\" />\n<rect x=\"114\" y=\"10\" width=\"1px\" height=\"100px\" />\n<rect x=\"116\" y=\"10\" width=\"3px\" height=\"100px\" />\n<rect x=\"122\" y=\"10\" width=\"3px\" height=\"100px\" />\n<rect x=\"126\" y=\"10\" width=\"1px\" height=\"100px\" />\n\n</g></g>\n</svg>\n',
          format: 'svg'
        }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
          expect(example.metadata[:response][:content]['application/json'][:example][:format]).to eq('svg')
          expect(example.metadata[:response][:content]['application/json'][:example][:message]).to eq('Ok')
          expect(example.metadata[:response][:content]['application/json'][:example][:barcode]).to eq(File.read('spec/fixtures/barcode_svg_1234567890.xml'))
        end
        run_test!
      end

      response(200, 'successful') do
        let(:barcode) { '1234567890' }
        let(:format) { 'png' }
        schema '$ref' => '#/components/schemas/barcode_response'
        example 'application/json', 'получить изображение в png', JSON.parse(File.read('spec/fixtures/barcode_png_1234567890.json'))

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
          expect(example.metadata[:response][:content]['application/json'][:example].deep_stringify_keys).to eq(JSON.parse(File.read('spec/fixtures/barcode_png_1234567890.json')))
        end
        run_test!
      end



      response(400, 'arguments error') do
        let(:barcode) { '1234567890' }
        let(:format) { 'some wrong format' }
        example 'application/json', 'wrong format value', {
          message: 'Wrong value of format: xml'
        }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
          expect(example.metadata[:response][:content]['application/json'][:example][:message]).to eq('Wrong value of format: some wrong format')
        end
        run_test!
      end

      response(400, 'arguments error. Invalid barcode value') do
        let(:barcode) { '1' }
        example 'application/json', 'Invalid barcode value', {
          message: 'data not valid'
        }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eq('data not valid')
        end
      end
    end
  end
end
