FROM ruby:2.5.1

ENV APP_HOME /project5
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

ENV BUNDLE_PATH /project5-gems
ENV GEM_PATH /project5-gems
ENV GEM_HOME /project5-gems

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs mc locales cmake postgresql-client vim redis-tools --no-install-recommends
RUN gem install bundler --no-document

COPY Gemfile ./
COPY Gemfile.lock ./
RUN bundle check || bundle install --jobs 20 --retry 5

COPY . ./

RUN mkdir tmp/pids

COPY docker-entrypoint.sh /usr/local/bin

ENTRYPOINT ["docker-entrypoint.sh"]
