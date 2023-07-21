FROM ruby:2.6.3-alpine

RUN apk add --update --no-cache \
  build-base \
  nodejs \
  sqlite-dev \
  yarn \
  tzdata

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler:2.2.3
RUN bundle install

COPY . .

RUN bundle exec rails assets:precompile

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]