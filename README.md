AWS Lambda Erlang docker
========================

This is used as docker base image for developing [AWS Lambda](https://aws.amazon.com/lambda) functions running on BEAM.

The goal is to provide images which can be used to build zip packages suitable
for deployment as AWS Lambda functions with a provided BEAM runtime.

Please see [erllambda](https://github.com/alertlogic/erllambda) for further details on how to
run and deploy Erlang AWS Lambda functions.

## Usage example

### Obtain an image

#### Pull from official docker hub registry

**NOTE:** Images are not yet publicly available. Should be published at the end of November.

Simply pull image from docker hub with a required Erlang version:

``` console
$ docker pull alertlogic/erllambda:20.3 ./erllambda_docker/20
```

#### Build image from sources

To build image locally clone repository:

```console
$ git clone git@github.com/alertlogic/erllambda_docker
```

Specify path to a `Dockerfile` with a required version to build an image:

``` console
$ docker build -t alertlogic/erllambda:20.3 ./erllambda_docker/20
```

### Running

#### Erlang shell

```console
$ docker run -it --rm alertlogic/erllambda:20.3
Erlang/OTP 20 [erts-9.3.3.5] [source] [64-bit] [smp:3:3] [ds:3:3:10] [async-threads:10] [hipe] [kernel-poll:false]

Eshell V9.3.3.5  (abort with ^G)
1>
```

#### Build a package ([rebar3_erllambda](https://github.com/alertlogic/rebar3_erllambda) example)

``` console
$ docker run -it --rm -v `pwd`:/buildroot -w /buildroot alertlogic/erllambda:20.3 \
      rebar3 as prod erllambda zip
```

## Design

1. Erlang images are based on `lambci/lambda-base:build` [image](https://github.com/lambci/docker-lambda),
   which replicates the live AWS Lambda environment almost identically.
2. Erlang OTP is built from [source code](https://github.com/erlang/otp).
3. Elixir images are based on `alertlogic/erllambda:<version>` images.
4. [rebar](https://github.com/rebar/rebar) and [rebar3](https://github.com/erlang/rebar3) tools are built from source and bundled in Erlang images.
5. [mix](https://hexdocs.pm/mix/Mix.html) tool is installed from [hex](http://hex.pm) and bundled in Elixir images.
