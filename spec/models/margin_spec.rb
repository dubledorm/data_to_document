# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HtmlToPdf::Margin, type: :model do
  let!(:attributes) do
    { 'top' => 10,
      'bottom' => 20,
      'left' => 30,
      'right' => 40 }.freeze
  end

  let!(:simple_attribute) { { 'top' => 10 }.freeze }
  let!(:empty_attributes) { {}.freeze }

  describe 'initialization' do

    context 'when all attributes exists and all right' do
      let(:subject) { described_class.new(attributes) }

      it { expect(subject.top).to eq(10) }
      it { expect(subject.bottom).to eq(20) }
      it { expect(subject.left).to eq(30) }
      it { expect(subject.right).to eq(40) }

      it { expect(subject).to be_valid }
    end

    context 'when some attributes empty' do
      let(:subject) { described_class.new(simple_attribute) }

      it { expect(subject.top).to eq(10) }
      it { expect(subject.bottom).to eq(nil) }
      it { expect(subject.left).to be_nil }
      it { expect(subject.right).to be_nil }

      it { expect(subject).to be_valid }
      it { expect(described_class.new(empty_attributes)).to be_valid }
    end

    context 'when wrong attributes' do
      it { expect(described_class.new({ top: 'wrong' })).to_not be_valid }
      it { expect(described_class.new({ bottom: 'wrong' })).to_not be_valid }
      it { expect(described_class.new({ left: 'wrong' })).to_not be_valid }
      it { expect(described_class.new({ right: 'wrong' })).to_not be_valid }
    end
  end

  describe 'as_json' do
    it { expect(described_class.new(empty_attributes).as_json).to eq({}) }
    it {
      expect(described_class.new(attributes).as_json).to eq({ 'top' => 10,
                                                              'bottom' => 20,
                                                              'left' => 30,
                                                              'right' => 40 })
    }
    it { expect(described_class.new(simple_attribute).as_json).to eq({ 'top' => 10 }) }
  end
end
