# frozen_string_literal: true

require 'swagger_helper'
require 'swagger_descriptions'
require 'compare_pdf_helper'
require 'pdf_request_cases'

RSpec.describe 'api/pdf', type: :request do

  path '/api/html_to_pdf' do

    post('Получить pdf из html') do
      tags 'Api'
      description HTML_TO_PDF_DESCRIPTION
      consumes 'application/json'
      parameter name: :options, in: :body, schema: { '$ref' => '#/components/schemas/options' }
      examples_body_html_to_pdf

      PdfRequest::POSITIVE_CASES.each do |test_case|
        response(200, test_case[:title]) do
          example 'application/json', :successful_response, {
            message: 'Ok', pdf_base64: 'result as Base64 string'
          }, 'Успешное выполнение', 'Сформированнный файл в поле pdf_base64'
          let!(:options) { test_case[:options] }

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(pdf_equal?(Base64.strict_decode64(data['pdf_base64']),
                              File.open(File.join(PdfRequest::FIXTURES_PATH,
                                                  test_case[:expected_result_file_name]), 'rb').read)).to be_truthy
          end
        end
      end

      PdfRequest::NEGATIVE_CASES.each do |test_case|
        response(test_case[:response_status], test_case[:title]) do
          example 'application/json', test_case[:title], {
            message: test_case[:expected_message]
          }, test_case[:example_name], test_case[:example_description]
          schema '$ref' => '#/components/schemas/error_response'
          let!(:options) { test_case[:options] }

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data['message']).to eq(test_case[:expected_message])
          end
        end
      end
    end
  end
end
