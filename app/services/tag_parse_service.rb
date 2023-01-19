# frozen_string_literal: true

# Сервис для разбора строки вида tag_name(arg1: val1, arg2: val2)
# возвращает hash вида:
# { name: tag_name,
#   arguments: { arg1: val1,
#                arg2: val2 } }
class TagParseService

  class ParseError < ArgumentError
  end

  REG_EXP_TAG_ARGS = /^\s*(?<tag_name>[a-zA-Z]\w*)(\((?<arguments>[\w\.,:\s]*)\))*\s*$/.freeze

  def self.parse!(source_string)
    m = source_string.match(REG_EXP_TAG_ARGS)
    if m.nil? || m[:tag_name].nil?
      raise ParseError, "Error parse string #{source_string}, tag_name: #{m ? m[:tag_name] : ''}," \
        " arguments: #{m ? m[:arguments] : ''}"
    end

    { 'name' => m[:tag_name]&.downcase,
      'arguments' => parse_arguments!(m[:arguments]) }
  end

  REG_EXP_ARG_VALUE = /\s*(?<arg_name>[a-zA-Z]\w*):\s*(?<value>[\w\.]+)\s*/.freeze
  REG_EXP_CHECK_ARGUMENTS =/^(,*\s*(?<arg_name>[a-zA-Z]\w*):\s*(?<value>[\w\.]+)\s*)*$/

  def self.parse_arguments!(arguments_string)
    return {} if arguments_string.blank?

    unless arguments_string =~ REG_EXP_CHECK_ARGUMENTS
      raise ParseError, "Error parse argument string #{arguments_string}"
    end

    parse_string(arguments_string)
  end

  def self.parse_string(checked_arguments_string)
    result = {}
    checked_arguments_string.scan(REG_EXP_ARG_VALUE) do |argument_pair|
      result[argument_pair[0].downcase] = argument_pair[1]
    end
    result
  end
end
