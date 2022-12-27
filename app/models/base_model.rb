# frozen_string_literal: true

# Базовая модель для не ActiveRecord моделей
class BaseModel
  include ActiveModel::Model
  include ActiveModel::Serializers::JSON
  include Draper::Decoratable

  def initialize(hash_attributes = {})
    self.attributes = hash_attributes
  end

  def attributes=(hash)
    return unless hash

    hash.each do |key, value|
      send("#{key}=", value)
    end
  end
end
