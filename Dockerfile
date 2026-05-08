FROM node:24-slim

# ca-certificates for device-code auth
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates \
 && rm -rf /var/lib/apt/lists/*

RUN npm install -g @openai/codex

# additional software aka dev tools
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        git ripgrep \
    && rm -rf /var/lib/apt/lists/*

# user setup
RUN userdel --remove node
RUN useradd --create-home --shell /bin/bash codex \
    && mkdir /home/codex/src
USER codex
WORKDIR /home/codex/src

CMD [ "codex", "--sandbox", "danger-full-access" ]
