# frozen_string_literal: true

# Базовый класс для контроллеров
class ApplicationController < ActionController::API

  rescue_from ActionController::BadRequest, with: :bad_request unless Rails.env.development?
  rescue_from ArgumentError, with: :bad_request unless Rails.env.development?
  rescue_from ActionController::RoutingError, with: :not_found unless Rails.env.development?

  def bad_request(error)
    render json: { message: error.message }, status: 400
  end

  def not_found(error)
    render json: { message: error.message }, status: 404
  end
end
