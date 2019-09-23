FROM alpine:latest

ARG VERSION
LABEL version="$VERSION" \
  repository="https://github.com/donmahallem/github-pages" \
  homepage="https://donmahallem.github.io/github-pages" \
  maintainer="DonMahallem" \
  "com.github.actions.name"="GitHub Pages Helper" \
  "com.github.actions.description"="Github Action for releasing to github pages" \
  "com.github.actions.color"="purple" \
  "com.github.actions.icon"="upload-cloud"

RUN apk --update --no-cache add \
    curl \
    git \
  && rm -rf /var/cache/apk/* /tmp/*

COPY LICENSE README.md /
ADD entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]