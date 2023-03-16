require 'swagger_helper'
require 'swagger_descriptions'

RSpec.describe 'cdn/barcode', type: :request do

  path '/cdn/barcodes/{barcode}' do
    parameter name: 'barcode', in: :path, type: :string, description: 'barcode'

    get('Получить Png файл с картинкой штрих кода') do
      tags 'Cdn'
      description BARCODE_TO_IMAGE_DESCRIPTION_CDN
      produces 'application/json'
      parameter name: :barcode, in: :path, type: :string, description: 'Штрих код для отображения'

      response(200, 'Stream png file') do
        let(:barcode) { '1234567890' }
        run_test! do |response|
          expect(response.body).to eq(File.open('spec/fixtures/barcode_1234567890.png', 'rb').read)
        end
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
