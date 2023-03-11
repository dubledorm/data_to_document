# frozen_string_literal: true

# Содержит всю служебную информацию о шаблоне, кроме тела шаблона
# Шаблон вынесен в отдельную таблицу, чтобы размер этой записи был минимальный
class TemplateInfo
  include Mongoid::Document

  #  STATE_VALUES = %i[new stable].freeze
  OUTPUT_FORMAT_VALUES = %i[pdf xls].freeze

  field :name, type: String
  field :rus_name, type: String
  field :description, type: String
  field :output_format, type: Symbol
  field :state, type: Symbol

  embeds_one :options, class_name: 'TemplateOption'

  belongs_to :template, optional: true, dependent: :destroy

  validates :name, :rus_name, :output_format, presence: :true

  validates :output_format, inclusion: { in: OUTPUT_FORMAT_VALUES }
  validates :name, uniqueness: true


  index({ name: 1 }, { unique: true, name: "name_index" })
  index({ output_format: 1 }, { unique: false, name: 'output_format_index' })

  scope :by_name, ->(name) { where(name: name) }
end
