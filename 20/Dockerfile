FROM lambci/lambda-base:build

# install build dependencies, not provided by lambda-base:build image
RUN set -e \
   && yum -y install \
      ncurses-devel

ARG OTP_VERSION="20.3.8.11"

RUN set -e \
        && OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/OTP-${OTP_VERSION}.tar.gz" \
        && OTP_DOWNLOAD_SHA256="76fdb88a693e406efb5a484f87cfad50c5cabab932151e4f2e5ff59d2405ee40" \
        && curl -fSL -o otp-src.tar.gz "$OTP_DOWNLOAD_URL" \
        && echo "$OTP_DOWNLOAD_SHA256  otp-src.tar.gz" | sha256sum -c - \
        && export ERL_TOP="/usr/src/otp_src_${OTP_VERSION%%@*}" \
        && mkdir -vp $ERL_TOP \
        && tar -xzf otp-src.tar.gz -C $ERL_TOP --strip-components=1 \
        && rm otp-src.tar.gz \
        && ( cd $ERL_TOP \
             && ./otp_build autoconf \
             && ./configure \
             && make -j$(nproc) \
             && make install ) \
        && find /usr/local -name examples | xargs rm -rf

CMD ["erl"]

ENV REBAR_VERSION="2.6.4"

RUN set -xe \
        && REBAR_DOWNLOAD_URL="https://github.com/rebar/rebar/archive/${REBAR_VERSION}.tar.gz" \
        && REBAR_DOWNLOAD_SHA256="577246bafa2eb2b2c3f1d0c157408650446884555bf87901508ce71d5cc0bd07" \
        && mkdir -p /usr/src/rebar-src \
        && curl -fSL -o rebar-src.tar.gz "$REBAR_DOWNLOAD_URL" \
        && echo "$REBAR_DOWNLOAD_SHA256 rebar-src.tar.gz" | sha256sum -c - \
        && tar -xzf rebar-src.tar.gz -C /usr/src/rebar-src --strip-components=1 \
        && rm rebar-src.tar.gz \
        && cd /usr/src/rebar-src \
        && ./bootstrap \
        && install -v ./rebar /usr/local/bin/ \
        && rm -rf /usr/src/rebar-src

ARG REBAR3_VERSION="3.6.2"

RUN set -xe \
        && REBAR3_DOWNLOAD_URL="https://github.com/erlang/rebar3/archive/${REBAR3_VERSION}.tar.gz" \
        && REBAR3_DOWNLOAD_SHA256="7f358170025b54301bce9a10ec7ad07d4e88a80eaa7b977b73b32b45ea0b626e" \
        && mkdir -p /usr/src/rebar3-src \
        && curl -fSL -o rebar3-src.tar.gz "$REBAR3_DOWNLOAD_URL" \
        && echo "$REBAR3_DOWNLOAD_SHA256 rebar3-src.tar.gz" | sha256sum -c - \
        && tar -xzf rebar3-src.tar.gz -C /usr/src/rebar3-src --strip-components=1 \
        && rm rebar3-src.tar.gz \
        && cd /usr/src/rebar3-src \
        && HOME=$PWD ./bootstrap \
        && install -v ./rebar3 /usr/local/bin/ \
        && rm -rf /usr/src/rebar3-src
