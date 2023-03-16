# frozen_string_literal: true

require 'swagger_helper'
require 'swagger_descriptions'

RSpec.describe 'cdn/pdf', type: :request do

  path '/cdn/html_to_pdf' do

    post('Получить pdf из html') do
      tags 'Cdn'
      description HTML_TO_PDF_DESCRIPTION
      consumes 'application/json'
      parameter name: :options, in: :body, schema: { '$ref' => '#/components/schemas/options' }
      examples_body_html_to_pdf

      response(200, 'Stream. Returns the pdf file. ') do
        let!(:options) do
          { "options": {
            "html_text": '<!DOCTYPE html><html><head></head><body>Hellow world!</body></html>',
            "header_html": '<!DOCTYPE html><html><head></head><body>This is header</body></html>',
            "footer_html": '<!DOCTYPE html><html><head></head><body>This is footer</body></html>',
            "orientation": 'Landscape',
            "page_size": 'Letter',
            "margin": { "top": 50 }
          } }
        end

        run_test! do |response|
          #TODO файлы отличаются датой создания, которая записана в них как CreationDate (D:20230316132022-04'00')
          # Надо удалить дату и сравнить файлы
          #expect(response.body).to eq(File.open('spec/fixtures/simple_example.pdf', 'rb').read)
        end
      end

      response(200, 'Stream. Returns the pdf file. ') do
        let!(:options) do
          { "options": {
            "html_text": '<!DOCTYPE html><html><head></head><body>Hellow world!</body></html>',
            "header_html": '<!DOCTYPE html><html><head></head><body>Date <span class="date"></span> Time <span class="time"></span> Sitepage <span class="sitepage"></span></body></html>',
            "footer_html": '<!DOCTYPE html><html><head></head><body>Page <span class="page"></span> of <span class="topage"></span> Webpage <span class="webpage"></span></body></html>'
          } }
        end

        run_test!
      end


      response '400', 'bad arguments' do
        example 'application/json', :simple_response, {
          message: "[\"Html text can't be blank\"]"
        }, 'Не заполнен параметр', 'Параметр html_text должен быть заполнен'
        schema '$ref' => '#/components/schemas/error_response'
        let!(:options) do
          { "options": {
            "html_text": '',
            "header_html": '<!DOCTYPE html><html><head></head><body>This is header</body></html>',
            "footer_html": '<!DOCTYPE html><html><head></head><body>This is footer</body></html>',
            "orientation": 'Landscape',
            "page_size": 'Letter',
            "margin": { "top": 50 }
          } }
        end

        run_test!
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
