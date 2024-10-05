NOTE:- It's a sample documentation of setup docker with rails 7, you can also add your required library and gems.


1. Create new rails app
2. Setup gem-file and database.yml
3.0  ---->  First insure that you have installed docker and docker-compose in your system.
3.1 Create new Dockerfile in root directory of project.
3.2 Create docker-compose.yml in root directory of project



Code example:- Dockerfile

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

Code example:- docker-compose.yml
  
  version: '3.3'
  services:
    web:
      build: .
      command: rails server -b 0.0.0.0 -p 3000
      volumes:
        - .:/app
      ports:
        - "3000:3000"
      depends_on:
        - db

    db:
      image: mysql:5.7
      environment:
        MYSQL_ROOT_PASSWORD: root
        MYSQL_DATABASE: rails_7_with_docker_development
      ports:
        - "3306:3306"

Now its almost done............

* Restart docker:-
  - sudo systemctl restart docker

* To build and start application service use
  - docker-compose up

* To stop and removes all containers defined in the Compose file.
  - docker-compose down

* Run docker migration
  - docker-compose run web rake db:create db:migrate

* Access rails console
  - docker-compose run web rails console

* To check db connection use this in rails console
  - ActiveRecord::Base.connection

* To inspect log
  - docker-compose logs web
  - docker-compose logs db



# Bonus:-
  To check mysql is running in your host machine
  - sudo netstat -tuln | grep 3306

  If already running , to stop that service
  - sudo systemctl stop mysql
            or 
  - sudo service mysql stop

  To check running docker container
  - docker ps

  To stop specific container
  - docker stop <container_id>