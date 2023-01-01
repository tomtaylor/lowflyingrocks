# The version of Alpine to use for the final image
# This should match the version of Alpine that the `elixir:1.8.1-alpine` image uses
ARG ALPINE_VERSION=3.16

FROM --platform=linux/amd64 elixir:1.14.1-alpine AS builder

# The environment to build with
ARG MIX_ENV=prod

ENV APP_NAME="lowflyingrocks" \
  APP_VSN="0.1.0" \
  MIX_ENV=${MIX_ENV}

# By convention, /opt is typically used for applications
WORKDIR /opt/app

# This step installs all the build tools we'll need
RUN apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache \
  git \
  build-base && \
  mix local.rebar --force && \
  mix local.hex --force

COPY . .

RUN mix do deps.get, deps.compile, compile, release

# From this line onwards, we're in a new image, which will be the image used in production
FROM --platform=linux/amd64 alpine:${ALPINE_VERSION}

# We need python, curl, openssh and procps for Heroku ps:exec to work
RUN apk update && \
  apk add --no-cache \
  bash \
  openssl-dev \
  curl \
  libgcc \
  libstdc++ \
  ncurses-libs

ENV REPLACE_OS_VARS=true \
  LANG=en_US.UTF-8 \
  APP_NAME="lowflyingrocks" \
  MIX_ENV=prod

WORKDIR /opt/app

COPY --from=builder /opt/app/_build/${MIX_ENV}/rel/${APP_NAME} .

CMD trap 'exit' INT; /opt/app/bin/${APP_NAME} start
