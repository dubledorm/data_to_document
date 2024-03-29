source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.0.6'
# Use postgresql as the database for Active Record
#gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

gem 'mongoid', '~> 7.0.5'

group :test do
  # gem 'database_cleaner'
  gem 'database_cleaner-mongoid'
  gem "factory_girl_rails" , '~> 1.7.0'
  gem 'mongoid-rspec'

  # gem "factory_girl_rails" , '~> 1.7.0'
  # gem "test-unit"
  # gem "mocha", :require => false
  # gem 'capybara', '~> 2.18'
  # gem "launchy"
  # gem "autotest"
  # gem "autotest-rails-pure"
  # gem "autotest-notification"
  # gem 'webmock'
  # gem 'ruby-prof'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'rswag-specs'

  gem 'rails-controller-testing'
  gem 'dotenv-rails'
  gem 'shoulda', '~> 3.5.0'
  gem 'shoulda-matchers'
  gem 'shoulda-context'
  gem 'rack_session_access'
  gem 'timecop'
end

group :development do
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rubocop'
  gem 'rubocop-rails'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'wicked_pdf'
gem 'imgkit'
gem 'barby'
gem 'chunky_png'
gem 'rswag-api'
gem 'rswag-ui'
gem 'draper'
gem 'combine_pdf'
gem "rqrcode", "~> 2.0"
gem 'rubyzip'
gem 'nokogiri'