# frozen_string_literal: true

require 'rails_helper'

ATTRIBUTES = {
  'html_text' => 'html_text',
  'header_html' => 'header_html',
  'footer_html' => 'footer_html',
  'orientation' => 'Portrait',
  'page_height' => 100,
  'page_width' => 110,
  'page_size' => 'A4',
  'margin' => { 'top' => 10,
                'bottom' => 20,
                'left' => 30,
                'right' => 40 }
}.freeze

SIMPLE_ATTRIBUTE = { 'html_text' => 'html_text',
                     'header_html' => 'header_html',
                     'footer_html' => 'footer_html' }.freeze
EMPTY_ATTRIBUTES = {}.freeze

RSpec.describe HtmlToPdf::PdfFromStringParams, type: :model do

  describe 'initialization' do

    context 'when all attributes exists and all right' do
      let(:subject) { described_class.new(ATTRIBUTES) }

      it { expect(subject.html_text).to eq('html_text') }
      it { expect(subject.header_html).to eq('header_html') }
      it { expect(subject.footer_html).to eq('footer_html') }
      it { expect(subject.orientation).to eq('Portrait') }
      it { expect(subject.page_height).to eq(100) }
      it { expect(subject.page_width).to eq(110) }
      it { expect(subject.page_size).to eq('A4') }

      it { expect(subject.margin.top).to eq(10) }
      it { expect(subject.margin.bottom).to eq(20) }
      it { expect(subject.margin.left).to eq(30) }
      it { expect(subject.margin.right).to eq(40) }

      it { expect(subject).to be_valid }
    end

    context 'when some attributes empty' do
      let(:subject) { described_class.new(SIMPLE_ATTRIBUTE) }

      it { expect(subject.html_text).to eq('html_text') }
      it { expect(subject.header_html).to eq('header_html') }
      it { expect(subject.footer_html).to eq('footer_html') }
      it { expect(subject.orientation).to eq(nil) }
      it { expect(subject.page_height).to eq(nil) }
      it { expect(subject.page_width).to eq(nil) }
      it { expect(subject.page_size).to eq(nil) }

      it { expect(subject.margin).to eq(nil) }

      it { expect(subject).to be_valid }
      it { expect(described_class.new({ 'html_text' => 'html_text' })).to be_valid }
    end

    context 'when wrong attributes' do
      it { expect(described_class.new(EMPTY_ATTRIBUTES)).to_not be_valid }
      it { expect(described_class.new({ 'html_text' => 'html_text' })).to be_valid }
      it {
        expect(described_class.new({ 'html_text' => 'html_text',
                                     'page_height' => 'wrong' })).to_not be_valid
      }
      it {
        expect(described_class.new({ 'html_text' => 'html_text',
                                     'page_width' => 'wrong' })).to_not be_valid
      }
      it {
        expect(described_class.new({ 'html_text' => 'html_text',
                                     'orientation' => 'wrong' })).to_not be_valid
      }
      it {
        expect(described_class.new({ 'html_text' => 'html_text',
                                     'page_size' => 'wrong' })).to_not be_valid
      }
    end
  end

  describe 'as_json' do
    it { expect(described_class.new(EMPTY_ATTRIBUTES).as_json).to eq({}) }
    it { expect(described_class.new(ATTRIBUTES).as_json).to eq(ATTRIBUTES) }
    it { expect(described_class.new(SIMPLE_ATTRIBUTE).as_json).to eq(SIMPLE_ATTRIBUTE) }
  end
end
