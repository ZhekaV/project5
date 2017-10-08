FROM ruby:2.4.2

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs mc locales cmake postgresql-client vim --no-install-recommends
RUN gem install bundler --no-document

ENV APP_HOME /project5
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

ENV BUNDLE_PATH /box
COPY Gemfile ./
COPY Gemfile.lock ./
RUN bundle check || bundle install --jobs 20 --retry 5

COPY . ./

ENTRYPOINT ["bundle", "exec"]

# CMD ["./start.sh"]
