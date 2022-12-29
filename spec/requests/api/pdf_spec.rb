# frozen_string_literal: true

require 'swagger_helper'
require 'swagger_descriptions'

RSpec.describe 'api/pdf', type: :request do

  path '/api/html_to_pdf' do

    post('Получить pdf из html') do
      tags 'Api'
      description HTML_TO_PDF_DESCRIPTION
      consumes 'application/json'
      parameter name: :options, in: :body, schema: { '$ref' => '#/components/schemas/options' }
      request_body_example value: {
        "options": {
          "html_text": "<!DOCTYPE html><html><head></head><body>Hellow world!</body></html>",
          "header_html":"<!DOCTYPE html><html><head></head><body>This is header</body></html>",
          "footer_html":"<!DOCTYPE html><html><head></head><body>This is footer</body></html>",
          "orientation": "Landscape",
          "page_size": "Letter",
          "margin": { "top": 50 }
        }
      }, name: 'request_example_1', summary: 'Простой пример'
      request_body_example value: {
        "options": {
          "html_text": "<!DOCTYPE html><html><head></head><body>Hellow world!</body></html>",
          "header_html": "<!DOCTYPE html><html><head></head><body>Date <span class=\"date\"></span> Time <span class=\"time\"></span> Sitepage <span class=\"sitepage\"></span></body></html>",
          "footer_html": "<!DOCTYPE html><html><head></head><body>Page <span class=\"page\"></span> of <span class=\"topage\"></span> Webpage <span class=\"webpage\"></span></body></html>"
        }
      }, name: 'request_example_2', summary: 'Переменные в header и footer'

      # parameter name: :html_text, in: :query, schema: {
      #   type: :object,
      #   properties: {
      #     content: { type: :string }
      #   },
      #   required: ['content']
      # }, description: 'Html код для преобразования'

      response '200', 'successful' do
        schema '$ref' => '#/components/schemas/error_response'
        run_test!
      end

      response '400', 'bad arguments' do
        example 'application/json', :simple_response, {
          message: "[\"Html text can't be blank\"]"
        }, 'Не заполнен параметр', 'Параметр html_text должен быть заполнен'
        schema '$ref' => '#/components/schemas/error_response'
        run_test!
      end

      # response(200, 'successful') do
      #
      #   after do |example|
      #     example.metadata[:response][:content] = {
      #       'application/json' => {
      #         example: JSON.parse(response.body, symbolize_names: true)
      #       }
      #     }
      #   end
      #   run_test!
      # end
    end
  end
end
