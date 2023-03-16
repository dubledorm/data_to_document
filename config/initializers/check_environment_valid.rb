# Be sure to restart your server when you modify this file.

# Проверяем, что все переменные окружения переданы и верно настроено подключение к ресурсам.
Rails.application.config.after_initialize do
  next unless Rails.env.production?
  next if ENV['PRECOMPILE'].present?

  # Проверяем соединение с БД
  begin
    Template.first
  rescue => e
    abort "Could not connect to database. #{e.message}.\nPlease check parameters DB_MONGO_HOST, DB_MONGO_DATABASE_NAME" \
          ' and accessible the database'
  end
end
