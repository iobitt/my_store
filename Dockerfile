FROM ruby:3.0.0

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client libpq-dev npm cron && npm install --global yarn && yarn

## Add crontab file in the cron directory
#ADD crontab /etc/cron.d/hello-cron
## Give execution rights on the cron job
#RUN chmod 0744 /etc/cron.d/hello-cron
## Create the log file to be able to run tail
#RUN touch /var/log/cron.log
## Run the command on container startup
#CMD cron && tail -f /var/log/cron.log

RUN wget https://github.com/ess/cronenberg/releases/download/v1.0.0/cronenberg-v1.0.0-linux-amd64 -O /usr/bin/cronenberg && chmod +x /usr/bin/cronenberg

WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3001

CMD cronenberg cron-jobs.yml

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
