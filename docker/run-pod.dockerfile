FROM runpod/pytorch:2.1.0-py3.10-cuda11.8.0-devel-ubuntu22.04

RUN apt-get update && apt-get install -y \
    curl screen nvtop vim nload python3.11 && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

RUN curl -sSL https://install.python-poetry.org | POETRY_HOME="/root/.poetry" python3 -

RUN curl -O https://dl.min.io/client/mc/release/linux-amd64/mc && \
    chmod +x mc && \
    mv mc /usr/local/bin

RUN /root/.poetry/bin/poetry config virtualenvs.in-project true 

ENV RP_ENV_ACTIONS=/rp-env/actions

RUN mkdir -p /rp-env
COPY ./remote/actions /rp-env/actions
    
# Adding poetry into .bashrc
RUN bash -c "set -x; source ${RP_ENV_ACTIONS}/actions.sh && sh_ensure_rc 'export PATH=\"/root/.poetry/bin:\$PATH\"'"

# Setting RP_ENV_ACTIONS
RUN bash -c "set -x; source ${RP_ENV_ACTIONS}/actions.sh && sh_ensure_rc 'export RP_ENV_ACTIONS=\"/rp-env/actions\"'"

# Sourcing functions for future usage
RUN bash -c "set -x; source ${RP_ENV_ACTIONS}/actions.sh && sh_ensure_rc 'source ${RP_ENV_ACTIONS}/actions.sh'"

ENTRYPOINT /rp-env/init.sh