FROM ruby:3.3.13-slim
WORKDIR /rails
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential git libpq-dev libyaml-dev libffi-dev pkg-config && rm -rf /var/lib/apt/lists/*
ENV RAILS_ENV=production BUNDLE_WITHOUT=development:test
COPY Gemfile Gemfile.lock ./
RUN bundle install && bundle clean --force
COPY . .
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile
EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
