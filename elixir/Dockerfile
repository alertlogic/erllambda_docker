FROM alertlogic/erllambda:20.3

ARG ELIXIR_VERSION=1.7.4
ENV LANG=en_US.UTF-8 \
        LANGUAGE=en_US.UTF-8 \
        LC_ALL=en_US.UTF-8

ENV MIX_REBAR3=/usr/local/bin/rebar3
ENV MIX_REBAR=/usr/local/bin/rebar

RUN set -xe \
        && ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/v${ELIXIR_VERSION}.tar.gz" \
        && ELIXIR_DOWNLOAD_SHA1=c7c87983e03a1dcf20078141a22355e88dadb26b53d3f3f98b9a9268687f9e20 \
        && curl -fsSL $ELIXIR_DOWNLOAD_URL -o elixir-src.tar.gz \
        && echo "$ELIXIR_DOWNLOAD_SHA1 elixir-src.tar.gz" | sha256sum -c - \
        && mkdir -p /usr/src/elixir-src \
        && tar -xzf elixir-src.tar.gz -C /usr/src/elixir-src --strip-components=1 \
        && rm elixir-src.tar.gz \
        && cd /usr/src/elixir-src \
        && make -j$(nproc) \
        && make install \
        && rm -rf /usr/src/elixir-src \
        && cd $HOME \
        && mix local.hex --force \
        && mix hex.info

CMD ["iex"]
