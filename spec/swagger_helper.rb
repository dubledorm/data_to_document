# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Сервис - barcode в картинку',
        description: 'Содержит функции для преобразования числового значения barcode в изображения. при этом, \
существует два варианта функций:
1. Находится в пространстве имён Api и возвращает результат в одном из полей ответа
2. Находится в пространстве имён Cdn и возвращает результат как скачиваемый файл. В этом варианте изображения бар \
кодов можно непосредственно включать в html документ в виде тега <img>, где в качестве src указывается ссылка на \
entry_point в этом сервисе',
        version: 'v1'
      },
      paths: {},
      components: {
        schemas: {
          error_response: {
            type: 'object',
            properties: {
              message: { type: 'string' }
            }
          },
          options: {
            type: 'object',
            properties: {
              options: { '$ref' => '#/components/schemas/pdf_from_string_params' }
            }
          },
          pdf_from_string_params: {
            type: 'object',
            properties: {
              html_text: { type: 'string',
                           required: true,
                           description: 'Основной HTML код который будет преобразован в pdf документ' },
              header_html: { type: 'string', allowEmptyValue: true, description: 'HTML для заголовков страниц' },
              footer_html: { type: 'string', allowEmptyValue: true, description: 'HTML для подвалов(footer) страниц' },
              orientation: { type: 'string',
                             allowEmptyValue: true,
                             description: 'Ориентация страницы',
                             default: 'Portrate',
                             enum: %w[Potrate Landscape] },
              page_height: { type: 'integer', allowEmptyValue: true, description: 'Высота страницы в мм' },
              page_width: { type: 'integer', allowEmptyValue: true, description: 'Ширина страницы в мм' },
              page_size: { type: 'string', allowEmptyValue: true, default: 'A4', description: 'Размер страницы из стандартных',
                           enum: %w[A4 Letter] },
              margin: { '$ref' => '#/components/schemas/margins', allowEmptyValue: true, description: 'Отступ от краёв листа' }
            },
          },
          margins: {
            type: 'object',
            properties: {
              top: { type: 'integer', allowEmptyValue: true },
              bottom: { type: 'integer', allowEmptyValue: true },
              right: { type: 'integer', allowEmptyValue: true },
              left: { type: 'integer', allowEmptyValue: true }
            }
          }
        }
      }
          # servers: [
      #   {
      #     url: 'http://{defaultHost}',
      #     variables: {
      #       defaultHost: {
      #         default: 'localhost:3000/'
      #       }
      #     }
      #   }
      # ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end
