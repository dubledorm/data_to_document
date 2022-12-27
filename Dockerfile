#FROM surnet/alpine-wkhtmltopdf:3.9-0.12.5-full as wkhtmltopdf
FROM surnet/alpine-wkhtmltopdf:3.10-0.12.6-full as wkhtmltopdf

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
      tzdata \
      yarn

RUN apk update; \
    apk add --no-cache libx11; \
    apk add --no-cache libxrender; \
    apk add --no-cache libxext; \
    apk add --no-cache libssl1.1; \
    apk add --no-cache ca-certificates; \
    apk add --no-cache fontconfig; \
    apk add --no-cache freetype; \
    apk add --no-cache ttf-dejavu; \
    apk add --no-cache ttf-droid; \
    apk add --no-cache ttf-freefont; \
    apk add --no-cache ttf-liberation; \
    apk add --no-cache ttf-ubuntu-font-family; \
    apk add --no-cache build-base; \
    apk add --no-cache aws-cli;

ENV RAILS_ENV=production \
    RACK_ENV=production \
    RAILS_SERVE_STATIC_FILES=true


RUN gem install bundler -v 2.3.21

COPY --from=wkhtmltopdf /bin/wkhtmltopdf /bin/wkhtmltopdf
COPY --from=wkhtmltopdf /bin/wkhtmltoimage /bin/wkhtmltoimage
COPY --from=wkhtmltopdf /bin/libwkhtmltox* /bin/

WORKDIR /app

COPY . ./

RUN bundle config set without 'development test'; \
    bundle install

RUN yarn install --production=true;
#RUN yarn install --check-files

# Установка часового пояса
ENV TZ=Europe/Moscow

# Проброс порта 3000
EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]