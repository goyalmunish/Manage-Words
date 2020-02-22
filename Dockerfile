FROM goyalmunish/devenv

User root

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-lc"]

RUN apt-get update \
    && apt-get install -y \
      mysql-server \
      memcached \
      r-base \
    && rm -rf /var/lib/apt/lists/* \
    && echo 'Done: Additional packages!'

ENV RUBY_VERSION 2.6.6
ENV BUNDLER_VERSION 1.17.1

RUN /root/.rbenv/bin/rbenv install ${RUBY_VERSION} \
    && /root/.rbenv/bin/rbenv local ${RUBY_VERSION} \
    && /root/.rbenv/bin/rbenv which ruby \
    && echo ruby --version \
    && echo 'Done: Installed Ruby!'

# note if the repo has changed, you would need to run
# docker build with `--no-cache` option if you clone the repo
# instead of copying it from local
COPY ./ manage-words
RUN eval "$(/root/.rbenv/bin/rbenv init -)" \
    && cd manage-words \
    && /root/.rbenv/bin/rbenv which ruby \
    && cd .. && cd manage-words \
    && echo ruby --version \
    && gem install bundler:${BUNDLER_VERSION} \
    && bundle install \
    && gem list \
    && echo 'Done: Repo cloning!'

ENV RAILS_ENV development

RUN cd manage-words \
    && eval "$(/root/.rbenv/bin/rbenv init -)" \
    && /root/.rbenv/bin/rbenv which ruby \
    && export RAILS_ENV=${RAILS_ENV} \
    && service mysql start \
    && bundle exec rake db:create \
    && bundle exec rake db:migrate \
    && bundle exec rake db:seed \
    && echo 'Done: Database preparation!'

CMD [ \
        "/bin/zsh", "-c", \
        " \
        cd ~/manage-words \
        && eval "$(/root/.rbenv/bin/rbenv init -)" \
        && service mysql start \
        && bundle exec rails s -b 0.0.0.0 -p 3000 \
        " \
    ]

# # build the image locally
# cd manage-words
# docker build -t goyalmunish/manage-words -f Dockerfile ./
# # push the image
# docker push manage-words:latest

# # run image
# docker run -it -d --name manage-words -e PS_START=de-$(uname -n) -e HOST_PLATFORM=$(uname -s) -p 3000:3000 goyalmunish/manage-words
# for testing out CMD, you might like to run the image as follows
# docker run -it -d --name manage-words -e PS_START=de-$(uname -n) -e HOST_PLATFORM=$(uname -s) -p 3000:3000 goyalmunish/manage-words /bin/bash -c "ping -i 0.2 $(gateway_ip)"
