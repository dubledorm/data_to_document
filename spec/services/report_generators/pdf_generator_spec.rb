# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReportGenerators::PdfGenerator do
  describe 'replace_tags_in_template' do
    context 'when only simple functions use' do
      let!(:template) do
        FactoryGirl.create :template, updated_at: Time.now,
                           content: BSON::Binary.new('<html>#[Title]<br>#[Body]</html>')
      end

      let!(:template_info) do
        FactoryGirl.create :template_info, name: 'name', rus_name: 'rus name',
                           description: 'description', output_format: 'pdf', template: template,
                           state: :stable
      end

      let(:report_params_dictionary) { { 'title' => 'Заголовок', 'body' => 'Тело документа' } }
      let(:pdf_generator) { described_class.new(template_info, report_params_dictionary) }

      it 'should replace source string' do
        expect(pdf_generator.replace_tags_in_template('<html>#[Title]<br>#[Body]</html>')).to eq('<html>Заголовок<br>Тело документа</html>')
      end
    end

    context 'when only table functions use' do
      let!(:template) do
        FactoryGirl.create :template, updated_at: Time.now,
                           content: BSON::Binary.new(File.open(
                             Rails.root.join('spec/fixtures/table_one_row_example.html'),
                             'r', &:read
                           ))
      end

      let!(:template_info) do
        FactoryGirl.create :template_info, name: 'name', rus_name: 'rus name',
                           description: 'description', output_format: 'pdf', template: template,
                           state: :stable
      end

      let(:report_params_dictionary) { { 'result' => [%w[1 2 3], %w[4 5 6], %w[7 8 9]] } }
      let(:pdf_generator) { described_class.new(template_info, report_params_dictionary) }
      let(:result) { File.open(Rails.root.join('spec/fixtures/table_one_row_result.html'), 'r', &:read) }

      it 'should replace source string' do
        expect(pdf_generator.replace_tags_in_template(template.content.data).gsub(/\s/, '')).to eq(result.gsub(/\s/, ''))
      end
    end

    context 'when mix functions use' do
      let!(:template) do
        FactoryGirl.create :template, updated_at: Time.now,
                           content: BSON::Binary.new(File.open(
                             Rails.root.join('spec/fixtures/table_some_rows_example.html'),
                             'r', &:read
                           ))
      end

      let!(:template_info) do
        FactoryGirl.create :template_info, name: 'name', rus_name: 'rus name',
                           description: 'description', output_format: 'pdf', template: template,
                           state: :stable
      end

      let(:report_params_dictionary) do
        { 'result' => [%w[_1 _2 _3], %w[_4 _5 _6], ['_7', '_8', '#[DeepFunction]']],
          'Title' => 'The Title',
          'Column1tag' => '_Column1',
          'column3tag' => '_Column3Tag',
          'DeepFunction' => 'Function in 9 cell'}
      end
      let(:pdf_generator) { described_class.new(template_info, report_params_dictionary) }
      let(:result) { File.open(Rails.root.join('spec/fixtures/table_some_rows_result.html'), 'r', &:read) }
      let(:result_pdf) { File.open(Rails.root.join('spec/fixtures/table_some_rows_result.pdf'), 'r', &:read) }

      it 'should replace source string' do
        expect(pdf_generator.replace_tags_in_template(template.content.data).gsub(/\s/, '')).to eq(result.gsub(/\s/, ''))
      end

      it { expect { pdf_generator.generate }.to_not raise_error }
      # it 'should generate pdf' do
      #   expect(pdf_generator.generate).to eq(result_pdf)
      # end
    end
  end
end

#{"LoginLk": "info@l", "PasswordLk": "linife2016",           "NumberContract": "9990342022",            "ContractDate": "16.05.2022",           "Full_Company_name": "Общество с ограниченной ответственностью \"СИНЕРГИЯ\"",            "FIOWriteContract": "Киселева Виктория Олеговна",            "FIOWritePost": "Директор",            "BasicWriteContract": "Устава",            "RetCargoPostCode": "156016", "RetCargoCity": "Кострома",  "RetCargoAddress": "Давыдовский 3-й микрорайон, 32", "jrPostCode": "156005",            "jrCityName": "Кострома", "jrAddress": "пл. Октябрьская, Дом 3", "Phone_Number": "79203833451", "INN": "4401147784\/440101001",            "CalcAccount": "40702810547100032115",            "BankName": "ПАО АКБ \"АВАНГАРД\"",            "CorAccount": "30101810000000000201",            "BIK": "044525201", "OGRN": "1134401014813", "phpickpointname": "ПикПоинт", "phpostcode": "123456", "phcityname": "Москва", "phaddress": "Наш адрес", "phpickpointjuridicaladdress": "Наш юр адрес", "phpickpointphisicaladdress": "Наш физ адрес", "phpickpointphone": "1234556678", "phpickpointpaymentaccount": "Сюда платить", "phpickpointbankname": "Наш банк", "phpickpointcorrespondentaccount": "кор счёт", "phpickpointbic": "БИК", "phpickpointinnkpp": "ИНН", "phpickpointogrn": "ОГРН", "phpickpointshortname": "Пик", "phpickpointdecreenumber": "phpickpointdecreenumber", "phpickpointdecreedate": "phpickpointdecreedate" }