

Launch command

export RP_ENV_DIR="/workspace/rp-env" && export RP_ENV_REPO="git@github.com:Soterix/rp-env.git" \
  && echo $RUNPOD_SECRET_SSHKEY_GH_RP_ENV | base64 --decode > ${HOME}/.ssh/gh_rp_env && chmod 600 ${HOME}/.ssh/gh_rp_env \
  && rm -rf $RP_ENV_DIR && mkdir -p $RP_ENV_DIR && cd $RP_ENV_DIR \
  && GIT_SSH_COMMAND="ssh -i ${HOME}/.ssh/gh_rp_env -o IdentitiesOnly=yes" git clone ${RP_ENV_REPO}