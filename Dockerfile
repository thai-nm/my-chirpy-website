FROM ruby:3.4.2-bookworm

WORKDIR /blog

COPY Gemfile .

RUN bundle install

EXPOSE 4000

CMD ["bundle", "exec", "jekyll", "serve", "--watch", "--incremental", "--force_polling", "--host", "0.0.0.0"]
