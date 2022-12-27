# frozen_string_literal: true

require 'rails_helper'

ATTRIBUTES = { 'top' => 10,
               'bottom' => 20,
               'left' => 30,
               'right' => 40 }.freeze

SIMPLE_ATTRIBUTE = { 'top' => 10 }.freeze
EMPTY_ATTRIBUTES = {}.freeze

RSpec.describe HtmlToPdf::Margin, type: :model do

  describe 'initialization' do

    context 'when all attributes exists and all right' do
      let(:subject) { described_class.new(ATTRIBUTES) }

      it { expect(subject.top).to eq(10) }
      it { expect(subject.bottom).to eq(20) }
      it { expect(subject.left).to eq(30) }
      it { expect(subject.right).to eq(40) }

      it { expect(subject).to be_valid }
    end

    context 'when some attributes empty' do
      let(:subject) { described_class.new(SIMPLE_ATTRIBUTE) }

      it { expect(subject.top).to eq(10) }
      it { expect(subject.bottom).to eq(nil) }
      it { expect(subject.left).to be_nil }
      it { expect(subject.right).to be_nil }

      it { expect(subject).to be_valid }
      it { expect(described_class.new(EMPTY_ATTRIBUTES)).to be_valid }
    end

    context 'when wrong attributes' do
      it { expect(described_class.new({ top: 'wrong' })).to_not be_valid }
      it { expect(described_class.new({ bottom: 'wrong' })).to_not be_valid }
      it { expect(described_class.new({ left: 'wrong' })).to_not be_valid }
      it { expect(described_class.new({ right: 'wrong' })).to_not be_valid }
    end
  end

  describe 'as_json' do
    it { expect(described_class.new(EMPTY_ATTRIBUTES).as_json).to eq({}) }
    it {
      expect(described_class.new(ATTRIBUTES).as_json).to eq({ 'top' => 10,
                                                              'bottom' => 20,
                                                              'left' => 30,
                                                              'right' => 40 })
    }
    it { expect(described_class.new(SIMPLE_ATTRIBUTE).as_json).to eq({ 'top' => 10 }) }
  end
end
