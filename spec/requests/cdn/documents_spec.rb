require 'swagger_helper'
require 'swagger_descriptions'

RSpec.describe 'cdn/documents', type: :request do

  path '/cdn/documents/{template_name}' do
    parameter name: 'template_name', in: :path, type: :string, description: 'Имя шаблона. Так как он указан в БД в поле name'

    post('Построить отчёт') do
      tags 'Cdn'
      description CDN_REPORT_DESCRIPTION
      consumes 'application/json'

      parameter name: :template_params, in: :body, schema: { '$ref' => '#/components/schemas/replace_dictionary' }
      examples_body_report

      response(200, 'successful. Возвращается сформированный файл отчёта') do
        let!(:template_info) { FactoryGirl.create :template_info_with_template, name: 'Offer', output_format: :pdf }
        let(:template_name) { 'Offer' }
        let(:template_params) { { template_params: { some_param: '' } } }

        run_test!
      end

      response(404, 'Не найден шаблон') do
        schema '$ref' => '#/components/schemas/error_response'
        example 'application/json', 'template not found', {
          message: 'Not found template with name: The_template_name_dose_not_exist'
        }
        let!(:template_info) { FactoryGirl.create :template_info_with_template, name: 'Offer', output_format: :pdf }
        let(:template_name) { 'The_template_name_dose_not_exist' }
        let(:template_params) { { template_params: { some_param: '' } } }

        run_test!
      end


      response(400, 'Неправильные аргументы') do
        schema '$ref' => '#/components/schemas/error_response'
        example 'application/json', 'template params required', {
          message: 'Wrong value of format: xml'
        }
        let!(:template_info) { FactoryGirl.create :template_info_with_template, name: 'Offer', output_format: :pdf }
        let(:template_name) { 'Offer' }
        let(:template_params) { {} }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eq('param is missing or the value is empty: template_params')
        end
      end
    end
  end
end
