# frozen_string_literal: true

require 'rails_helper'

ATTRIBUTES = {
  header_html: '<!DOCTYPE html><html><head></head><body>This is header</body></html>',
  footer_html: '<!DOCTYPE html><html><head></head><body>This is footer</body></html>',
  orientation: :Portrait,
  page_height: 100,
  page_width: 110,
  page_size: :A4,
  margins: { top: 10,
             bottom: 20,
             left: 30,
             right: 40 }
}.freeze

SIMPLE_ATTRIBUTE = { header_html: 'header_html',
                     footer_html: 'footer_html' }.freeze
EMPTY_ATTRIBUTES = {}.freeze

class TemplateOptionTestDecorator < TemplateOptionDecorator

  def add_script_to_html(source_html)
    super(source_html)
  end
end

RSpec.describe TemplateOptionDecorator, type: :model do
  let(:template_info) { FactoryGirl.create :template_info, options: ATTRIBUTES }

  describe 'add_script_to_html' do

    let(:decorator) { TemplateOptionTestDecorator.decorate(template_info.options) }

    it { expect(decorator.add_script_to_html('<head>')).to eq('<head>' + TemplateOptionDecorator::SCRIPT) }
    it {
      expect(decorator.add_script_to_html('<!DOCTYPE html><html>Some body</html>')).to eq('<!DOCTYPE html>'\
      "<html><head>#{TemplateOptionDecorator::SCRIPT}</head>"\
      "<body#{TemplateOptionDecorator::CALL_THE_SCRIPT}>Some body</body></html>")
    }
    it {
      expect(decorator.add_script_to_html('<!DOCTYPE html><html><head>This is head</head>Some body</html>')).to eq('<!DOCTYPE html>'\
      "<html><head>#{TemplateOptionDecorator::SCRIPT}This is head</head>"\
      "<body#{TemplateOptionDecorator::CALL_THE_SCRIPT}>Some body</body></html>")
    }
    it {
      expect(decorator.add_script_to_html('<!DOCTYPE html><html><head>This is head</head><body>Some body</body></html>')).to eq('<!DOCTYPE html>'\
      "<html><head>#{TemplateOptionDecorator::SCRIPT}This is head</head>"\
      "<body#{TemplateOptionDecorator::CALL_THE_SCRIPT}>Some body</body></html>")
    }
  end


  describe 'use' do

    context 'when all attributes exists and all right' do
      it {
        expect(template_info.options.decorate.as_json['header']).to eq({ 'content' => '<!DOCTYPE html><html><head>'\
        "#{TemplateOptionDecorator::SCRIPT}</head><body"\
        "#{TemplateOptionDecorator::CALL_THE_SCRIPT}>This is header</body></html>" })
      }
      it {
        expect(template_info.options.decorate.as_json['footer']).to eq({ 'content' => '<!DOCTYPE html><html><head>'\
        "#{TemplateOptionDecorator::SCRIPT}</head><body"\
        "#{TemplateOptionDecorator::CALL_THE_SCRIPT}>This is footer</body></html>" })
      }
    end
  end
end
