# frozen_string_literal: true

# Сервис для поиска TemplateInfo
# Обработка ошибок при нарушении целостности (если template_info, но нет template.content.data)
# На будущее - кэширование шаблонов здесь будет реализовано
class TemplateInfoService

  def self.find_by_name!(template_name)
    template_info = TemplateInfo.by_name(template_name).first
    raise ActionController::RoutingError, "Not found template with name: #{template_name}" if template_info.blank?

    if template_info.template.blank?
      raise ActionController::RoutingError, "Template with name: #{template_name} should have
 associated record in collection template"
    end

    if template_info.template.content&.data.blank?
      raise ActionController::RoutingError, "Template with name: #{template_name} should have
 filled record in associated collection template"
    end

    template_info
  end
end
