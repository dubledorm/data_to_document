# frozen_string_literal: true

require 'swagger_helper'
require 'swagger_descriptions'
require 'compare_pdf_helper'
require 'pdf_request_cases'

RSpec.describe 'cdn/pdf', type: :request do

  path '/cdn/html_to_pdf' do

    post('Получить pdf из html') do
      tags 'Cdn'
      description HTML_TO_PDF_DESCRIPTION
      consumes 'application/json'
      parameter name: :options, in: :body, schema: { '$ref' => '#/components/schemas/options' }
      examples_body_html_to_pdf

      PdfRequest::POSITIVE_CASES.each do |test_case|
        response(200, test_case[:title]) do
          let!(:options) { test_case[:options] }

          run_test! do |response|
            expect(pdf_equal?(response.body,
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

  path '/cdn/many_html_to_pdf' do

    post('Склеить в один файл несколько html документов') do
      tags 'Cdn'
      description MANY_HTML_TO_PDF_DESCRIPTION
      consumes 'application/json'
      parameter name: :options_array, in: :body, schema: { '$ref' => '#/components/schemas/options_array' }
      request_body_example value: {
        "options_array": [
          {
            "html_text": '<!DOCTYPE html><html><head></head><body>This is first document</body></html>',
            "header_html": '<!DOCTYPE html><html><head></head><body>This is header of first focument</body></html>',
            "footer_html": '<!DOCTYPE html><html><head></head><body>This is footer of first focument</body></html>'
          },
          {
            "html_text": '<!DOCTYPE html><html><head></head><body>This is second document</body></html>',
            "header_html": '<!DOCTYPE html><html><head></head><body>This is header of second document</body></html>',
            "footer_html": '<!DOCTYPE html><html><head></head><body>This is footer of second document</body></html>'
          }
        ]
      }, name: 'request_example_1', summary: 'Простой пример'
      request_body_example value: {
        "options_array": [
          {
            "html_text": '<!DOCTYPE html><html><head></head><body>This is first document</body></html>',
            "header_html": '<!DOCTYPE html><html><head></head><body>This is header of first focument</body></html>',
            "footer_html": '<!DOCTYPE html><html><head></head><body>This is footer of first focument</body></html>',
            "orientation": 'Landscape'
          },
          {
            "html_text": '<!DOCTYPE html><html><head></head><body>This is second document</body></html>',
            "header_html": '<!DOCTYPE html><html><head></head><body>This is header of second document</body></html>',
            "footer_html": '<!DOCTYPE html><html><head></head><body>This is footer of second document</body></html>',
            "page_width": 100,
            "page_height": 50
          },
          {
            "html_text": '<!DOCTYPE html><html><head></head><body>This is third document</body></html>',
            "header_html": '<!DOCTYPE html><html><head></head><body>This is header of third document</body></html>',
            "footer_html": '<!DOCTYPE html><html><head></head><body>This is footer of third document</body></html>',
            "page_size": 'Letter'
          }
        ]
      }, name: 'request_example_2', summary: 'Разные размеры документов'

      response(200, 'successful') do
        let(:options_array) do
          {
            "options_array": [
              {
                "html_text": '<!DOCTYPE html><html><head></head><body>This is first document</body></html>',
                "header_html": '<!DOCTYPE html><html><head></head><body>This is header of first focument</body></html>',
                "footer_html": '<!DOCTYPE html><html><head></head><body>This is footer of first focument</body></html>'
              },
              {
                "html_text": '<!DOCTYPE html><html><head></head><body>This is second document</body></html>',
                "header_html": '<!DOCTYPE html><html><head></head><body>This is header of second document</body></html>',
                "footer_html": '<!DOCTYPE html><html><head></head><body>This is footer of second document</body></html>'
              }
            ]
          }
        end
        run_test!
      end
    end
  end
end
