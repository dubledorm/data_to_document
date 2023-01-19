# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReplaceFunctions::Factory do
  describe 'function_class_name' do
    it { expect(described_class.function_class_name({ 'name' => 'name' })).to eq('Simple') }
    it { expect(described_class.function_class_name({})).to eq('Simple') }
    it { expect(described_class.function_class_name({ 'name' => 'name', 'arguments' => { 'asbarcode' => 'true' } })).to eq('Barcode') }
    it { expect(described_class.function_class_name({ 'name' => 'name', 'arguments' => { 'astable' => 'true' } })).to eq('Table') }
    it { expect(described_class.function_class_name({ 'name' => 'name', 'arguments' => { 'asbarcode' => 'false' } })).to eq('Simple') }
    it { expect(described_class.function_class_name({ 'name' => 'name', 'arguments' => { 'astable' => 'false' } })).to eq('Simple') }
  end

  describe 'build' do
    let(:simple_params) { { 'name' => 'name' } }
    let(:barcode_params) { { 'name' => 'name', 'arguments' => { 'asbarcode' => 'true' } } }
    let(:table_params) { { 'name' => 'name', 'arguments' => { 'astable' => 'true', 'someparam' => 'value' } } }

    it { expect(described_class.build(simple_params, 'pdf') == ReplaceFunctions::Html::Simple).to be_truthy }
    it { expect(described_class.build(barcode_params, 'pdf') == ReplaceFunctions::Html::Barcode).to be_truthy }
    it { expect(described_class.build(table_params, 'pdf') == ReplaceFunctions::Html::Table).to be_truthy }
  end
end
