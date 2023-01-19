# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateReportService do
  describe 'by name' do
    let!(:template) do
      FactoryGirl.create :template, updated_at: Time.now,
                         content: BSON::Binary.new('<html>Body</html>')
    end

    let!(:template_info) do
      FactoryGirl.create :template_info, name: 'name', rus_name: 'rus name',
                         description: 'description', output_format: 'pdf', template: template,
                         state: :stable
    end

    it { expect { described_class.call('name', {}) }.to_not raise_exception }

    context 'when wrong output format' do

      before :each do
        allow_any_instance_of(TemplateInfo).to receive(:output_format).and_return('wrong_format')
      end

      it { expect { described_class.call('name', {}) }.to raise_error(ArgumentError) }
    end
  end
end
