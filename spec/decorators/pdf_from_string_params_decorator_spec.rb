# frozen_string_literal: true

require 'rails_helper'

class PdfFromStringParamsTestDecorator < HtmlToPdf::PdfFromStringParamsDecorator

  def add_script_to_html(source_html)
    super(source_html)
  end
end

RSpec.describe HtmlToPdf::PdfFromStringParamsDecorator, type: :model do
  let!(:attributes) do
    {
      'html_text' => 'html_text',
      'header_html' => '<!DOCTYPE html><html><head></head><body>This is header</body></html>',
      'footer_html' => '<!DOCTYPE html><html><head></head><body>This is footer</body></html>',
      'orientation' => 'Portrait',
      'page_height' => 100,
      'page_width' => 110,
      'page_size' => 'A4',
      'margin' => { 'top' => 10,
                    'bottom' => 20,
                    'left' => 30,
                    'right' => 40 }
    }.freeze
  end

  let!(:simple_attribute) do
    { 'html_text' => 'html_text',
      'header_html' => 'header_html',
      'footer_html' => 'footer_html' }.freeze
  end

  let(:empty_attributes) { {}.freeze }

  describe 'add_script_to_html' do
    let(:subject) { HtmlToPdf::PdfFromStringParams.new(attributes) }
    let(:decorator) { PdfFromStringParamsTestDecorator.decorate(subject) }

    it { expect(decorator.add_script_to_html('<head>')).to eq('<head>' + HtmlToPdf::PdfFromStringParamsDecorator::SCRIPT) }
    it {
      expect(decorator.add_script_to_html('<!DOCTYPE html><html>Some body</html>')).to eq('<!DOCTYPE html>'\
      "<html><head>#{HtmlToPdf::PdfFromStringParamsDecorator::SCRIPT}</head>"\
      "<body#{HtmlToPdf::PdfFromStringParamsDecorator::CALL_THE_SCRIPT}>Some body</body></html>")
    }
    it {
      expect(decorator.add_script_to_html('<!DOCTYPE html><html><head>This is head</head>Some body</html>')).to eq('<!DOCTYPE html>'\
      "<html><head>#{HtmlToPdf::PdfFromStringParamsDecorator::SCRIPT}This is head</head>"\
      "<body#{HtmlToPdf::PdfFromStringParamsDecorator::CALL_THE_SCRIPT}>Some body</body></html>")
    }
    it {
      expect(decorator.add_script_to_html('<!DOCTYPE html><html><head>This is head</head><body>Some body</body></html>')).to eq('<!DOCTYPE html>'\
      "<html><head>#{HtmlToPdf::PdfFromStringParamsDecorator::SCRIPT}This is head</head>"\
      "<body#{HtmlToPdf::PdfFromStringParamsDecorator::CALL_THE_SCRIPT}>Some body</body></html>")
    }
  end


  describe 'use' do

    context 'when all attributes exists and all right' do
      let(:subject) { HtmlToPdf::PdfFromStringParams.new(attributes) }

      it { expect(subject.decorate.html_text).to eq('html_text') }
      it { expect(subject.decorate.as_json['html_text']).to eq('html_text') }
      it {
        expect(subject.decorate.as_json['header']).to eq({ 'content' => '<!DOCTYPE html><html><head>'\
        "#{HtmlToPdf::PdfFromStringParamsDecorator::SCRIPT}</head><body"\
        "#{HtmlToPdf::PdfFromStringParamsDecorator::CALL_THE_SCRIPT}>This is header</body></html>" })
      }
      it {
        expect(subject.decorate.as_json['footer']).to eq({ 'content' => '<!DOCTYPE html><html><head>'\
        "#{HtmlToPdf::PdfFromStringParamsDecorator::SCRIPT}</head><body"\
        "#{HtmlToPdf::PdfFromStringParamsDecorator::CALL_THE_SCRIPT}>This is footer</body></html>" })
      }
    end
  end
end
