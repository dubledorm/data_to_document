# frozen_string_literal: true

require 'strscan'

module ReportGenerators

  # Базовый генератор. Определяет основные фугкции. Даёт доступ к функциям подстановки.
  # template_info - запись о шаблоне из БД
  # report_params_dictionary - hash параметров для функций замены
  class Base

    def initialize(template_info, report_params_dictionary)
      @template_info = template_info
      @report_params_dictionary = stringify_and_down_keys(report_params_dictionary)
    end

    def generate
      template = template_source
      prepared_template = replace_tags_in_template(template)
      generate_report(prepared_template)
    rescue ReplaceFunctions::ReplaceFunctionError => e
      raise ActionController::BadRequest, e.message
    end

    protected

    attr_accessor :template_info, :report_params_dictionary

    # Заменить все функции в шаблоне
    def replace_tags_in_template(_template)
      raise NotImplementedError
    end

    # Из шаблона, где уже произведена замена сформировать отчёт в нужном формате
    def generate_report(_prepared_template)
      raise NotImplementedError
    end

    # Создать экземпляр функции подстановки.
    # Создаётся на основании tag_and_arguments_hash - разобранных параметров функции подстановки из шаблона
    # Создаётся с учётом выходного формата.
    # output_content - специфичный для каждого выходного формата неабор данных, необходмый, чтобы функция
    # вывела собственный результат
    def build_function_instance(tag_and_arguments_hash, output_content)
      ReplaceFunctions::Factory.build(tag_and_arguments_hash, @template_info.output_format)
                               .new(@report_params_dictionary, output_content, tag_and_arguments_hash)
    end

    def template_source
      @template_info.template.content.data.force_encoding('UTF-8')
    end

    def stringify_and_down_keys(hash)
      hash.stringify_keys.transform_keys(&:downcase)
    end
  end
end

