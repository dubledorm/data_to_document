require 'swagger_helper'

RSpec.describe 'cdn/barcode', type: :request do

  path '/cdn/barcodes/{barcode}' do
    # You'll want to customize the parameter types...
    parameter name: 'barcode', in: :path, type: :string, description: 'barcode'

    get('Получить Png файл с картинкой штрих кода') do
      tags 'Cdn'
      description BARCODE_TO_IMAGE_DESCRIPTION_CDN
      produces 'application/json'
      parameter name: :barcode, in: :path, type: :string, description: 'Штрих код для отображения'
      response(200, 'successful') do
        # let(:barcode) { '123' }
        #
        # after do |example|
        #   example.metadata[:response][:content] = {
        #     'application/json' => {
        #       example: JSON.parse(response.body, symbolize_names: true)
        #     }
        #   }
        # end
        run_test!
      end
    end
  end
end
