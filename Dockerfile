FROM docker:git

RUN apk add --no-cache \
  wget \
  bash \
  python \
  docker \
  jq \
  ncurses \
  && rm -rf /var/cache/apk/*

# google cloud sdk 
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.zip && unzip google-cloud-sdk.zip && rm google-cloud-sdk.zip
RUN google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/.bashrc --additional-components kubectl alpha beta

# Disable updater check for the whole installation.
RUN google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true

# Disable updater completely.
RUN sed -i -- 's/\"disable_updater\": false/\"disable_updater\": true/g' /google-cloud-sdk/lib/googlecloudsdk/core/config.json

ENV PATH /google-cloud-sdk/bin:$PATH

COPY gcloud-auth /usr/bin
WORKDIR /app

CMD ["/bin/bash"]
