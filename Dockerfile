# /path/to/app/Dockerfile
FROM ruby:2.6.6-alpine
ENV BUNDLER_VERSION=2.3.21

# Установка в контейнер runtime-зависимостей приложения
RUN apk add --update --no-cache \
      binutils-gold \
      build-base \
      curl \
      file \
      g++ \
      gcc \
      git \
      less \
      libstdc++ \
      libffi-dev \
      libc-dev \
      linux-headers \
      libxml2-dev \
      libxslt-dev \
      libgcrypt-dev \
      make \
      netcat-openbsd \
      nodejs \
      openssl \
      pkgconfig \
#      python \
      tzdata \
      yarn

ENV RAILS_ENV=production \
    RACK_ENV=production \
    RAILS_SERVE_STATIC_FILES=true


RUN gem install bundler -v 2.3.21

WORKDIR /app

COPY . ./

RUN bundle install

RUN yarn install --check-files

# Установка часового пояса
ENV TZ=Europe/Moscow

# Проброс порта 3000
EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]