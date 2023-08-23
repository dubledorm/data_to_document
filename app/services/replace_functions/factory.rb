# frozen_string_literal: true

module ReplaceFunctions

  # Фабрика для создания класса функции замены на основе разобранной строки и template_info
  class Factory

    OUTPUT_FORMAT_TO_MODULE_NAME = { 'pdf' => 'html',
                                     'xls' => 'xls' }.freeze
    TAG_OPTION_TO_FUNCTION_NAME = { 'asbarcode' => 'Barcode',
                                    'astable' => 'Table',
                                    'asqrcode' => 'QrCode',
                                    'astablewithtemplate' => 'TableWithTemplate',
                                    'asrepeatabletemplate' => 'RepeatableTemplate' }.freeze
    DEFAULT_FUNCTION_NAME = 'Simple'

    def self.build(tag_and_arguments_hash, output_format)
      "ReplaceFunctions::#{module_name(output_format.to_s)}::#{function_class_name(tag_and_arguments_hash)}".constantize
    end

    def self.module_name(output_format)
      OUTPUT_FORMAT_TO_MODULE_NAME[output_format].to_s.camelize
    end

    def self.function_class_name(tag_and_arguments_hash)
      # Проходим по ключам массива TAG_OPTION_TO_FUNCTION_NAME и ищем их в tag_and_arguments_hash
      # Если нашли, то получаем имя функции. Если не нашли, то значит это simple
      TAG_OPTION_TO_FUNCTION_NAME.each_key do |key_name|
        next unless tag_and_arguments_hash['arguments']&.key?(key_name)

        return TAG_OPTION_TO_FUNCTION_NAME[key_name] if tag_and_arguments_hash['arguments'][key_name] == 'true'

        return DEFAULT_FUNCTION_NAME
      end
      DEFAULT_FUNCTION_NAME
    end
  end
end

