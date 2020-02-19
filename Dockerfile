FROM goyalmunish/devenv

User root

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-lc"]

RUN apt-get update \
    && apt-get install -y \
      r-base \
    && rm -rf /var/lib/apt/lists/* \
    && echo 'Done: Additional packages!'

RUN git clone https://github.com/goyalmunish/manage-words \
    && eval "$(/root/.rbenv/bin/rbenv init -)" \
    && cd manage-words \
    && /root/.rbenv/bin/rbenv install 2.5.1 \
    && /root/.rbenv/bin/rbenv local 2.5.1 \
    && /root/.rbenv/bin/rbenv which ruby \
    && cd .. && cd manage-words \
    && echo ruby --version \
    && gem install bundler:1.17.1 \
    && bundle install \
    && gem list \


COPY ./conf/mgoyal_shell_helpers.sh ${DIR_DATA_TEMP}/mgoyal_shell_helpers.sh
CMD [ \
        "/bin/bash", "-c", \
        " \
        mkdir -p ${DIR_DATA} ${DIR_HOME}/${DIR_HOME_CODE_NAME} \
        && ln -s -f ${DIR_DATA_MAIN_PROJ} ${DIR_HOME}/${DIR_HOME_CODE_NAME}/${DIR_HOME_MAIN_PROJ_NAME} \
        && cd ${DIR_HOME}/${DIR_HOME_CODE_NAME}/${DIR_HOME_MAIN_PROJ_NAME} \
        && . conf/mgoyal_commands.sh \
        && . conf/mgoyal_shell_helpers.sh \
        && KEYCHAIN_ENABLED=False && . conf/mgoyal_bashrc_zshrc_common \
        && insert_if_missing \"$source_bashrc_common\" ~/.bashrc \"append\" \
        && insert_if_missing \"$source_zshrc_common\" ~/.zshrc \"append\" \
        && echo \"export DOCKER_HOST=tcp://$(netstat -rn | grep UG | awk '{ print $2 }'):2375\" >> ${DIR_HOME}/.bashrc_zshrc_current \
        && . ${DIR_DATA_TEMP}/mgoyal_shell_helpers.sh \
        && cd ~/manage-words \
        && bundle exec rails s -b 0.0.0.0 -p 3000 \
        " \
    ]

# # build the image locally
# cd manage-words
# docker build -t goyalmunish/manage-words -f Dockerfile ./
# # push the image
# docker push manage-words:latest
# 
# # function to run the image
# mwimagerun () {
#   additional_options="$@"
#   # run docker command
#   mkdir -p ~/.ssh
#   mkdir -p ~/.kube
#   mkdir -p ~/.config/gcloud
#   mkdir -p ~/.aws
#   mkdir -p ~/MG/cst
#   mkdir -p ~/Code
#   cmd="docker run -it -d --privileged \
#     --name manage-words \
#     -e PS_START=de-$(uname -n) \
#     -e HOST_PLATFORM=$(uname -s) \
#     -v ~/.ssh:/root/.ssh \
#     -v ~/.kube:/root/.kube \
#     -v ~/.config/gcloud:/root/.config/gcloud \
#     -v ~/.aws:/root/.aws \
#     -v ~/MG/cst:/data/main_proj \
#     -v ~/Code:/root/Code \
#     ${additional_options} \
#     goyalmunish/manage-words"
#   if [[ ! -z $DEVENV_RUN_CMD ]]; then
#       cmd="${cmd} ${DEVENV_RUN_CMD}"
#   fi
#   # echo the command
#   echo $cmd
#   # run the command
#   eval $cmd
#   # make sure a network exist with same name as ${DEVENV_NET}
#   docker network create ${DEVENV_NET} || true
#   # attach container to the network
#   denetcon manage-words
#   # reset non-default variables
#   unset DEVENV_RUN_CMD
#   DEVENV_CONTAINER="${DEVENV_NET}"
# }
# 
# # example run
# cd ~/MG/cst
# mwimagerun -v $SSH_AUTH_SOCK:/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent
# mwimagerun -p 3000:3000
