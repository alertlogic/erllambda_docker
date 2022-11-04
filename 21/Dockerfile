FROM public.ecr.aws/lambda/provided:al2
# AWS Linux2 provided runtime

# install build dependencies, not provided by lambda-base:build image
RUN set -e \
    && yum -y install \
        tar gzip ncurses-devel \
        binutils autoconf automake make \
        gcc10 gcc10-c++ \
        openssl \
        openssl-devel \
    && yum clean all \
    && rm -rf /var/cache/yum

ENV CC gcc10-gcc
ENV CXX gcc10-g++

ARG OTP_VERSION="21.3.8.21"

RUN set -e \
        && OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/OTP-${OTP_VERSION}.tar.gz" \
        && curl -fSL -o otp-src.tar.gz "$OTP_DOWNLOAD_URL" \
        && export ERL_TOP="/usr/src/otp_src_${OTP_VERSION%%@*}" \
        && mkdir -vp $ERL_TOP \
        && tar -xzf otp-src.tar.gz -C $ERL_TOP --strip-components=1 \
        && rm otp-src.tar.gz \
        && ( cd $ERL_TOP \
             && ./otp_build autoconf \
             && ./configure \
             && make -j$(nproc) \
             && make install ) \
        && rm -rf $ERL_TOP \
        && find /usr/local -name examples | xargs rm -rf

CMD ["erl"]

ARG REBAR3_VERSION="3.13.3"

RUN set -xe \
        && REBAR3_DOWNLOAD_URL="https://github.com/erlang/rebar3/archive/${REBAR3_VERSION}.tar.gz" \
        && mkdir -p /usr/src/rebar3-src \
        && curl -fSL -o rebar3-src.tar.gz "$REBAR3_DOWNLOAD_URL" \
        && tar -xzf rebar3-src.tar.gz -C /usr/src/rebar3-src --strip-components=1 \
        && rm rebar3-src.tar.gz \
        && cd /usr/src/rebar3-src \
        && HOME=$PWD ./bootstrap \
        && install -v ./rebar3 /usr/local/bin/ \
        && rm -rf /usr/src/rebar3-src
