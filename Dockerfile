FROM ruby:2.4

#RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn vim
RUN apt-get update && apt-get install -y \
  curl \
  build-essential \
  libpq-dev &&\
  curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y nodejs yarn

RUN mkdir /sage300
WORKDIR /sage300
ADD Gemfile /sage300/Gemfile
ADD Gemfile.lock /sage300/Gemfile.lock
RUN bundle install
ADD . /sage300
