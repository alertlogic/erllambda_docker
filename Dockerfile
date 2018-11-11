FROM amazonlinux:2017.03.1.20170812

RUN set -e \
   && yum -y install \
      autoconf \
      gcc \
      gcc-c++ \
      git \
      glibc-devel \
      make \
      ncurses-devel \
      tar \
      zip

ARG SSL_VERSION="1.1.1"

RUN set -xe \
        && OPENSSL_DOWNLOAD_URL="http://www.openssl.org/source/openssl-${SSL_VERSION}.tar.gz" \
	&& OPENSSL_DOWNLOAD_SHA256="2836875a0f89c03d0fdf483941512613a50cfb421d6fd94b9f41d7279d586a3d" \
        && mkdir -p /tmp/openssl \
        && cd /tmp \
        && curl -fSL -o openssl.tar.gz "$OPENSSL_DOWNLOAD_URL" \
        && echo "$OPENSSL_DOWNLOAD_SHA256 openssl.tar.gz" | sha256sum -c - \
        && tar -zxf openssl.tar.gz -C /tmp/openssl --strip-components=1 \
        && ( cd /tmp/openssl \
                && ./Configure \
                    --prefix=/usr/local/ssl \
                    --openssldir=/usr/local/ssl \
                   linux-x86_64 \
                   shared \
                && make -j$(nproc) \
                && make install ) \
        && rm -Rf /tmp/openssl*

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
                 --disable-dynamic-ssl-lib \
                 --with-ssl=/usr/local/ssl \
             && make -j$(nproc) \
             && make install ) \
        && find /usr/local -name examples | xargs rm -rf

CMD ["erl"]


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
