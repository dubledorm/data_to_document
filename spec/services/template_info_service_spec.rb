# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TemplateInfoService do
  describe 'by name' do
    let!(:template) do
      FactoryGirl.create :template, updated_at: Time.now,
                                    content: BSON::Binary.new('<html>Body</html>')
    end

    let!(:empty_template) do
      FactoryGirl.create :template, updated_at: Time.now,
                         content: BSON::Binary.new('')
    end

    let!(:template_info) do
      FactoryGirl.create :template_info, name: 'name', rus_name: 'rus name',
                                         description: 'description', output_format: 'xls', template: template,
                                         state: :stable
    end

    let!(:template_info_new) do
      FactoryGirl.create :template_info, name: 'new_name', rus_name: 'rus name',
                         description: 'description', output_format: 'xls', template: template,
                         state: :new
    end

    let!(:template_info_without_template) do
      FactoryGirl.create :template_info, name: 'without_template', rus_name: 'rus name',
                         description: 'description', output_format: 'xls',
                         state: :stable
    end

    let!(:template_info_with_empty_template) do
      FactoryGirl.create :template_info, name: 'with_empty_template', rus_name: 'rus name',
                         description: 'description', output_format: 'xls', template: empty_template,
                         state: :stable
    end

    it { expect(described_class.find_by_name!('name').template.content.data).to eq('<html>Body</html>') }
    it { expect { described_class.find_by_name!('wrong_name') }.to raise_error(ActionController::RoutingError) }
    it { expect { described_class.find_by_name!('new_name') }.to raise_error(ActionController::RoutingError) }
    it { expect { described_class.find_by_name!('without_template') }.to raise_error(ActionController::RoutingError) }
    it { expect { described_class.find_by_name!('with_empty_template') }.to raise_error(ActionController::RoutingError) }
  end
end
