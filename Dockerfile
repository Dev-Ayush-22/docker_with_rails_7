# Use the official Ruby image as a base
FROM ruby:3.2.2 AS base

# Install necessary packages
RUN apt-get update -y && \
    apt-get install -y \
    default-libmysqlclient-dev \
    build-essential \
    libssl-dev

# Set the working directory
WORKDIR /rails_7_with_docker/app

# Install Bundler
RUN gem install bundler

# Copy the Gemfile and Gemfile.lock to the container
COPY Gemfile Gemfile.lock ./

# Install the gems
RUN bundle install

# Copy the rest of the application code
COPY . .

# Set the default port
ARG DEFAULT_PORT=3000

# Expose the port
EXPOSE ${DEFAULT_PORT}

# Start the application
CMD ["bundle", "exec", "puma", "config.ru"]
