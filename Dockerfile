FROM node:24-slim

# ca-certificates for device-code auth
# bubblewrap is a prerequisite from codex: https://developers.openai.com/codex/concepts/sandboxing#prerequisites
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates bubblewrap \
 && rm -rf /var/lib/apt/lists/*

RUN npm install -g @openai/codex


# user setup
RUN userdel --remove node
RUN useradd --create-home --shell /bin/bash codex \
    && mkdir /home/codex/src
USER codex
WORKDIR /home/codex/src

ENTRYPOINT [ "/bin/bash" ]


# Docker has specific installation instructions for each operating system.
# Please refer to the official documentation at https://docker.com/get-started/
# Pull the Node.js Docker image:
#docker pull node:24-slim
# Create a Node.js container and start a Shell session:
#docker run -it --rm --entrypoint sh node:24-slim
# Verify the Node.js version:
#node -v # Should print "v24.15.0".
# Verify npm version:
#npm -v # Should print "11.12.1".
