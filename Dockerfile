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
ENV RBENV_PATH /root/.rbenv/bin/rbenv

RUN ${RBENV_PATH} install ${RUBY_VERSION} \
    && ${RBENV_PATH} local ${RUBY_VERSION} \
    && ${RBENV_PATH} global ${RUBY_VERSION} \
    && ${RBENV_PATH} versions \
    && ruby_path=$(${RBENV_PATH} which ruby) \
    && $ruby_path --version \
    && echo 'Done: Installed Ruby!'

ENV RAILS_ENV development

# note if the repo has changed, you would need to run
# docker build with `--no-cache` option if you clone the repo
# instead of copying it from local
COPY ./ manage-words
RUN eval "$(${RBENV_PATH} init -)" \
    && cd manage-words \
    && gem install bundler:${BUNDLER_VERSION} \
    && export RAILS_ENV=${RAILS_ENV} \
    && bundle install \
    && gem list \
    && echo 'Done: Copying the repo and bundle install!'

RUN eval "$(${RBENV_PATH} init -)" \
    && cd manage-words \
    && export RAILS_ENV=${RAILS_ENV} \
    && service mysql start \
    && bundle exec rake db:create \
    && bundle exec rake db:migrate \
    && bundle exec rake db:seed \
    && echo 'Done: Setting up database!'

CMD [ \
        "/bin/zsh", "-c", \
        " \
        eval \"$(/root/.rbenv/bin/rbenv init -)\" \
        && cd manage-words \
        && service mysql start \
        && service memcached start \
        && bundle exec rails s -b 0.0.0.0 -p 3000 \
        " \
    ]
