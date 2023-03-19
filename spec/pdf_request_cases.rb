# frozen_string_literal: true

require 'swagger_helper'
require 'swagger_descriptions'

module PdfRequest
  FIXTURES_PATH = 'spec/fixtures/'

  POSITIVE_CASES = [{
    title: 'Simple pdf. Check Header, Footer, Orientation, PageSize',
    options: { "options": {
      "html_text": '<!DOCTYPE html><html><head></head><body>Hellow world!</body></html>',
      "header_html": '<!DOCTYPE html><html><head></head><body>This is header</body></html>',
      "footer_html": '<!DOCTYPE html><html><head></head><body>This is footer</body></html>',
      "orientation": 'Landscape',
      "page_size": 'Letter',
      "margin": { "top": 50 }
    } },
    expected_result_file_name: 'simple_example.pdf'
  },
                    {
                      title: 'Simple pdf. Portrait, A4.',
                      options: {  "options": {
                        "html_text": '<!DOCTYPE html><html><head></head><body>Hellow world!</body></html>',
                        "header_html": '<!DOCTYPE html><html><head></head><body>This is header</body></html>',
                        "footer_html": '<!DOCTYPE html><html><head></head><body>This is footer</body></html>',
                        "orientation": 'Portrait',
                        "page_size": 'A4',
                        "margin": { "top": 50 }
                      } },
                      expected_result_file_name: 'simple_example_portrait_a4.pdf'
                    },
                    {
                      title: 'Simple pdf. Check margins.',
                      options: {  "options": {
                        "html_text": '<!DOCTYPE html><html><head></head><body>Hellow world!</body></html>',
                        "header_html": '<!DOCTYPE html><html><head></head><body>This is header</body></html>',
                        "footer_html": '<!DOCTYPE html><html><head></head><body>This is footer</body></html>',
                        "orientation": 'Portrait',
                        "page_size": 'A4',
                        "margin": { "top": 10, "bottom": 50, "left": 30, "right": 30 }
                      } },
                      expected_result_file_name: 'simple_example_portrait_a4_margins.pdf'
                    },
                    {
                      title: 'Simple pdf. Check variables in header and footer.',
                      options: {  "options": {
                        "html_text": '<!DOCTYPE html><html><head></head><body>Hellow world!</body></html>',
                        "header_html": '<!DOCTYPE html><html><head></head><body>Date <span class="page"></span> of <span class="topage"></span></body></html>',
                        "footer_html": '<!DOCTYPE html><html><head></head><body>Page <span class="page"></span> of <span class="topage"></span></body></html>'
                      } },
                      expected_result_file_name: 'example_variable_header_and_footer.pdf'
                    }].freeze

  NEGATIVE_CASES = [{
    title: 'bad arguments',
    response_status: 400,
    options: { "options": {
      "html_text": '',
      "header_html": '<!DOCTYPE html><html><head></head><body>This is header</body></html>',
      "footer_html": '<!DOCTYPE html><html><head></head><body>This is footer</body></html>',
      "orientation": 'Landscape',
      "page_size": 'Letter',
      "margin": { "top": 50 }
    } },
    expected_message: '["Html text can\'t be blank"]',
    example_name: 'Не заполнен параметр',
    example_description: 'Параметр html_text должен быть заполнен'
  },
                    {
                      title: 'bad arguments',
                      response_status: 400,
                      options: { "options": {
                        "html_text": '<!DOCTYPE html><html><head></head><body>Hallow world!</body></html>',
                        "orientation": 'wrong_value'
                      } },
                      expected_message: '["Orientation is not included in the list"]',
                      example_name: 'Orientation неверное значение',
                      example_description: 'В поле Orientation передано неверное значение'
                    }].freeze
end
