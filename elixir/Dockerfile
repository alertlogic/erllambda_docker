FROM alertlogic/erllambda:21.3

ARG ELIXIR_VERSION=1.7.4
ENV LANG=en_US.UTF-8 \
        LANGUAGE=en_US.UTF-8 \
        LC_ALL=en_US.UTF-8

ENV MIX_REBAR3=/usr/local/bin/rebar3
ENV MIX_REBAR=/usr/local/bin/rebar

RUN set -xe \
        && ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/v${ELIXIR_VERSION}.tar.gz" \
        && curl -fsSL $ELIXIR_DOWNLOAD_URL -o elixir-src.tar.gz \
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
