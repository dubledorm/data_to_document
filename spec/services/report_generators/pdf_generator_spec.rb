# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReportGenerators::PdfGenerator do
  context 'when only simple functions use' do
    let!(:template) do
      FactoryGirl.create :template, updated_at: Time.now,
                                    content: BSON::Binary.new('<html>{{Title}}<br>{{Body}}</html>')
    end

    let!(:template_info) do
      FactoryGirl.create :template_info, name: 'name', rus_name: 'rus name',
                                         description: 'description', output_format: 'pdf', template: template,
                                         state: :stable
    end

    let(:report_params_dictionary) { { 'title' => 'Заголовок', 'body' => 'Тело документа' } }
    let(:pdf_generator) { described_class.new(template_info, report_params_dictionary) }

    it 'should replace source string' do
      expect(pdf_generator.replace_tags_in_template('<html>{{Title}}<br>{{Body}}</html>')).to eq('<html>Заголовок<br>Тело документа</html>')
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
      { 'result' => [%w[_1 _2 _3], %w[_4 _5 _6], %w[_7 _8 {{DeepFunction}}]],
        'Title' => 'The Title',
        'Column1tag' => '_Column1',
        'column3tag' => '_Column3Tag',
        'DeepFunction' => 'Function in 9 cell'}
    end
    let(:pdf_generator) { described_class.new(template_info, report_params_dictionary) }
    let(:result) { File.open(Rails.root.join('spec/fixtures/table_some_rows_result.html'), 'r', &:read) }

    it 'should replace source string' do
      expect(pdf_generator.replace_tags_in_template(template.content.data).gsub(/\s/, '')).to eq(result.gsub(/\s/, ''))
    end
  end
end
