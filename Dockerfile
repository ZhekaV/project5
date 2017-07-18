FROM ruby:2.4

MAINTAINER Ievgen Vigura <zhekavigura@gmail.com>

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs mc locales cmake postgresql-client --no-install-recommends

# Use en_US.UTF-8 as our locale
# RUN locale-gen en_US.UTF-8
# ENV LANG en_US.UTF-8
# ENV LANGUAGE en_US:en
# ENV LC_ALL en_US.UTF-8

ENV APP_HOME /project5

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile ./
COPY Gemfile.lock ./
RUN bundle install --jobs 20 --retry 5

COPY . ./

# Provide dummy data to Rails so it can pre-compile assets.
RUN bundle exec rake RAILS_ENV=production DATABASE_URL=postgresql://user:pass@127.0.0.1/dbname SECRET_TOKEN=pickasecuretoken assets:precompile

# Expose a volume so that nginx will be able to read in assets in production.
VOLUME ["$APP_HOME/public"]

# Configure an entry point, so we don't need to specify
# "bundle exec" for each of our commands.
ENTRYPOINT ["bundle", "exec"]

# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
CMD ["rails", "s", "-b", "0.0.0.0"]




# psql -h postgres -p 5432 -U postgres project5_development
# docker-compose run project5 bundle update

# docker exec -it project5_project5_1 bash

# docker stop $(docker ps -a -q)
# docker rm $(docker ps -a -q)
