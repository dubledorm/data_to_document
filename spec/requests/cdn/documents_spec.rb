require 'swagger_helper'

RSpec.describe 'cdn/documents', type: :request do

  path '/cdn/documents/{template_name}' do
    # You'll want to customize the parameter types...
    parameter name: 'template_name', in: :path, type: :string, description: 'Имя шаблона. Так как он указан в БД в поле name'

    post('Построить отчёт') do
      tags 'Cdn'
      description CDN_REPORT_DESCRIPTION
      consumes 'application/json'

      parameter name: :template_params, in: :body, schema: { '$ref' => '#/components/schemas/replace_dictionary' }
      examples_body_report

      response(200, 'successful. Возвращается сформированный файл отчёта') do
        let(:template_name) { 'Offer' }

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
        schema '$ref' => '#/components/schemas/erroe_response'
        example 'application/json', 'wrong format value', {
          message: 'Wrong value of format: xml'
        }
        run_test!
      end
    end
  end
end
