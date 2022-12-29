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
      examples_body_html_to_pdf

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
    end
  end
end
