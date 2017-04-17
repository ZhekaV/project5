FROM ruby:2.4

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs cmake mc

RUN mkdir /project5
WORKDIR /project5
ADD Gemfile /project5/Gemfile
ADD Gemfile.lock /project5/Gemfile.lock
RUN bundle install
ADD . /project5
