# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReplaceFunctions::Html::Table do

  describe 'addRow true' do
    let(:output_content) do
      { output: '{{result(asTable: true, addRows: true)}}</td><td></td><td></td></tr></tbody>',
        old_string: '{{result(asTable: true, addRows: true)}}',
        prev_string: '<tbody><tr class="tr_class1"><td>' }
    end
    let(:report_params) { { 'result' => [%w[1 2 3], %w[4 5 6], %w[7 8 9]] } }
    let(:template) { described_class.new(report_params, output_content, TagParseService.parse!('result(asTable: true, addRows: true)')) }

    it { expect(template.done!).to eq('1</td><td>2</td><td>3</td></tr><tr class="tr_class1"><td>4</td><td>5</td><td>6</td></tr><tr class="tr_class1"><td>7</td><td>8</td><td>9</td></tr></tbody>') }
  end

  describe 'addRow false' do
    let(:output_content) do
      { output: '{{result(asTable: true, addRows: false)}}</td><td></td><td></td></tr><tr class="tr_class1"><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td></tr></tbody>',
        old_string: '{{result(asTable: true, addRows: false)}}',
        prev_string: '<tbody><tr class="tr_class1"><td>' }
    end
    let(:report_params) { { 'result' => [%w[1 2 3], %w[4 5 6], %w[7 8 9]] } }
    let(:template) { described_class.new(report_params, output_content, TagParseService.parse!('result(asTable: true, addRows: false)')) }

    it { expect(template.done!).to eq('1</td><td>2</td><td>3</td></tr><tr class="tr_class1"><td>4</td><td>5</td><td>6</td></tr><tr><td>7</td><td>8</td><td>9</td></tr></tbody>') }
  end

  describe 'addRow not defined' do
    let(:output_content) do
      { output: '{{result(asTable: true)}}</td><td></td><td></td></tr></tbody>',
        old_string: '{{result(asTable: true)}}',
        prev_string: '<tbody><tr class="tr_class1"><td>' }
    end
    let(:report_params) { { 'result' => [%w[1 2 3], %w[4 5 6], %w[7 8 9]] } }
    let(:template) { described_class.new(report_params, output_content, TagParseService.parse!('result(asTable: true)')) }

    it { expect(template.done!).to eq('1</td><td>2</td><td>3</td></tr><tr class="tr_class1"><td>4</td><td>5</td><td>6</td></tr><tr class="tr_class1"><td>7</td><td>8</td><td>9</td></tr></tbody>') }
  end
end
