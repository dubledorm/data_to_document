FactoryGirl.define do
  factory :template_info, class: TemplateInfo do
    sequence(:name) { |n| "name#{n}" }
    sequence(:rus_name) { |n| "русское имя #{n}" }
    description 'Описание'
    state :new
    output_format :xls
  end

  factory :template_info_with_template, parent: :template_info do
    template
  end
end
