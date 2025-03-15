FROM ruby:3.2.7-bookworm

WORKDIR /blog

COPY Gemfile Gemfile.lock .

RUN bundle install

EXPOSE 4000

CMD ["bundle", "exec", "jekyll", "serve", "--watch", "--incremental", "--force_polling", "--host", "0.0.0.0"]
