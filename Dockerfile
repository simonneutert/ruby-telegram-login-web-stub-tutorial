FROM ruby:3.1.1-slim

WORKDIR /app

RUN gem install bundler
COPY Gemfile* ./

RUN bundle install
RUN bundle clean --force
RUN gem cleanup rake

COPY . .

EXPOSE 5555

CMD rackup -p 5555 -o 0.0.0.0