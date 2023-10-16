FROM ruby:3.2.2
ARG RUBY_ENV=production

RUN gem update --system

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile* ./

RUN bundle update --bundler
RUN bundle config set frozen 'true'
RUN bundle install --local

COPY fetch $APP_HOME/
COPY app $APP_HOME/app

ENTRYPOINT ["/app/fetch"]
