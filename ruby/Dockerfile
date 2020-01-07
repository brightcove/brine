FROM ruby:2.5.7-alpine3.11

ARG brine_version
ENV VERSION=$brine_version

RUN gem install bundler

COPY Gemfile /app/brine/
COPY Gemfile.lock /app/brine/
COPY brine-dsl.gemspec /app/brine/

WORKDIR /app/brine

RUN bundle install

COPY feature_setup.rb /app/brine/
COPY lib /app/brine/lib

ENV FEATURE=/features

CMD sh -c "bundle exec cucumber --require /app/brine/feature_setup.rb ${CUCUMBER_OPTS} ${FEATURE}"
