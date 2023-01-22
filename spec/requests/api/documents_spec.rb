require 'swagger_helper'

RSpec.describe 'api/documents', type: :request do

  path '/api/documents/{template_name}' do
    # You'll want to customize the parameter types...
    parameter name: 'template_name', in: :path, type: :string, description: 'template_name'

    post('Построить отчёт') do
      tags 'Api'
      description CDN_REPORT_DESCRIPTION
      consumes 'application/json'

      parameter name: :template_params, in: :body, schema: { '$ref' => '#/components/schemas/replace_dictionary' }
      examples_body_report

      response(200, 'successful') do
        schema '$ref' => '#/components/schemas/success_document_response'
        example 'application/json', 'Простой пример', {
          message: 'Ok',
          pdf_base64: "Сформированнный файл в base64"
        }

        let(:template_name) { '123' }

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

  path '/api/documents/{template_name}/tags' do
    # You'll want to customize the parameter types...
    parameter name: 'template_name', in: :path, type: :string, description: 'template_name'

    get('tags document') do
      tags 'Api'
      description 'В шаблоне, имя которого передано в параметре найти и вернуть все функции подстановки с параметрами'
      response(200, 'successful') do
        let(:template_name) { '123' }
        schema '$ref' => '#/components/schemas/success_tags_response'
        example 'application/json', 'Пример для шаблона Offer', {
          "message": "Ok",
          "tag_list": [
            {
              "name": "contractdate",
              "arguments": {}
            },
            {
              "name": "numbercontract",
              "arguments": {}
            },
            {
              "name": "phpickpointname",
              "arguments": {}
            },
            {
              "name": "full_company_name",
              "arguments": {}
            },
            {
              "name": "jrpostcode",
              "arguments": {}
            },
            {
              "name": "jrcityname",
              "arguments": {}
            },
            {
              "name": "jraddress",
              "arguments": {}
            },
            {
              "name": "phpostcode",
              "arguments": {}
            },
            {
              "name": "phcityname",
              "arguments": {}
            },
            {
              "name": "phaddress",
              "arguments": {}
            },
            {
              "name": "phone_number",
              "arguments": {}
            },
            {
              "name": "calcaccount",
              "arguments": {}
            },
            {
              "name": "bankname",
              "arguments": {}
            },
            {
              "name": "coraccount",
              "arguments": {}
            },
            {
              "name": "bik",
              "arguments": {}
            },
            {
              "name": "inn",
              "arguments": {}
            },
            {
              "name": "ogrn",
              "arguments": {}
            },
            {
              "name": "phpickpointname",
              "arguments": {}
            },
            {
              "name": "phpickpointjuridicaladdress",
              "arguments": {}
            },
            {
              "name": "phpickpointphisicaladdress",
              "arguments": {}
            },
            {
              "name": "phpickpointphone",
              "arguments": {}
            },
            {
              "name": "phpickpointpaymentaccount",
              "arguments": {}
            },
            {
              "name": "phpickpointbankname",
              "arguments": {}
            },
            {
              "name": "phpickpointcorrespondentaccount",
              "arguments": {}
            },
            {
              "name": "phpickpointbic",
              "arguments": {}
            },
            {
              "name": "phpickpointinnkpp",
              "arguments": {}
            },
            {
              "name": "phpickpointogrn",
              "arguments": {}
            },
            {
              "name": "phpickpointshortname",
              "arguments": {}
            },
            {
              "name": "phpickpointdecreenumber",
              "arguments": {}
            },
            {
              "name": "phpickpointdecreedate",
              "arguments": {}
            },
            {
              "name": "phpickpointshortname",
              "arguments": {}
            },
            {
              "name": "phpickpointdecreenumber",
              "arguments": {}
            },
            {
              "name": "phpickpointdecreedate",
              "arguments": {}
            }
          ]
        }

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
