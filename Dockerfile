ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION

RUN gem update --system && \
    gem install bundler

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile* /app
RUN bundle install


ENTRYPOINT ["/bin/bash"]