FROM ruby:3.2.7-bookworm

# Set up the working directory
WORKDIR /blog

COPY Gemfile Gemfile.lock .
RUN ls -la

# Install Jekyll and Bundler
RUN bundle install

# Expose the Jekyll server port
EXPOSE 4000

# Default command to serve the site
CMD ["bundle", "exec", "jekyll", "serve", "--watch", "--incremental", "--force_polling", "--host", "0.0.0.0"]
