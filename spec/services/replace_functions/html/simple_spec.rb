# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReplaceFunctions::Html::Simple do
  let(:html_template) { '{{Title}}<br>{{Body}}</html>' }
  let(:output_content) { { output: html_template, old_string: '{{Title}}' } }
  let(:report_params) { { 'title' => 'Заголовок', 'body' => 'Тело документа' } }
  let(:simple) { described_class.new(report_params, output_content, TagParseService.parse!('Title')) }
  let(:wrong_report_params) { { 'body' => 'Тело документа' } }
  let(:simple_wrong) { described_class.new(wrong_report_params, output_content, TagParseService.parse!('Title')) }

  it { expect(simple.done!).to eq('Заголовок<br>{{Body}}</html>') }
  it { expect { simple_wrong.done! }.to raise_error(ReplaceFunctions::ReplaceFunctionError) }
end
