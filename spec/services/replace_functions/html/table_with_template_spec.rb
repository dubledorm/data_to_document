# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReplaceFunctions::Html::TableWithTemplate do

  describe 'done' do
    let!(:template) do
      FactoryGirl.create :template, updated_at: Time.now,
                         content: BSON::Binary.new('<div>#[value1]+#[value2]</div>')
    end
    let!(:template_info) do
      FactoryGirl.create :template_info, name: 'SimpleTemplate', rus_name: 'rus name',
                         description: 'description', output_format: 'pdf', template: template,
                         state: :stable
    end

    let(:output_content) do
      { output: '{{result(asTableWithTemplate: true, Template: SimpleTemplate)}}</td><td></td><td></td></tr></tbody>',
        old_string: '{{result(asTableWithTemplate: true, Template: SimpleTemplate)}}',
        prev_string: '<tbody><tr class="tr_class1"><td>' }
    end
    let(:report_params) { { 'result' => [[{ 'value1' => 11, 'value2' => 12 }, { 'value1' => 13, 'value2' => 14 }, { 'value1' => 15, 'value2' => 16 }],
                                         [{ 'value1' => 21, 'value2' => 22 }, { 'value1' => 23, 'value2' => 24 }, { 'value1' => 25, 'value2' => 26 }],
                                         [{ 'value1' => 31, 'value2' => 32 }, { 'value1' => 33, 'value2' => 34 }, { 'value1' => 35, 'value2' => 36 }]] } }

    let(:template_example) { described_class.new(report_params, output_content, TagParseService.parse!('result(asTableWithTemplate: true, Template: SimpleTemplate)')) }
    let(:result) { '<div>11+12</div></td><td><div>13+14</div></td><td><div>15+16</div></td></tr>' \
      '<tr class="tr_class1"><td><div>21+22</div></td><td><div>23+24</div></td><td><div>25+26</div></td></tr>' \
      '<tr class="tr_class1"><td><div>31+32</div></td><td><div>33+34</div></td><td><div>35+36</div></td></tr></tbody>' }

    it { expect(Template.all.count).to eq(1) }
    it { expect(TemplateInfo.all.count).to eq(1) }
    it { expect(template_example.done!).to eq(result) }
  end
end
