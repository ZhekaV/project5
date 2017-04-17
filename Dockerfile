FROM ruby:2.4

MAINTAINER Ievgen Vigura <zhekavigura@gmail.com>

RUN apt-get update && apt-get install -y build-essential nodejs libpq-dev cmake mc vim wget --fix-missing
RUN apt-get install -y postgresql-client --no-install-recommends
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV APP_HOME /project5

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile $APP_HOME/Gemfile
COPY Gemfile.lock $APP_HOME/Gemfile.lock

ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
    BUNDLE_JOBS=2 \
    BUNDLE_PATH=/bundle

RUN bundle install

COPY . .

# Provide dummy data to Rails so it can pre-compile assets.
RUN bundle exec rake RAILS_ENV=production DATABASE_URL=postgresql://user:pass@127.0.0.1/dbname SECRET_TOKEN=pickasecuretoken assets:precompile

# Expose a volume so that nginx will be able to read in assets in production.
VOLUME ["$APP_HOME/public"]

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
