FROM debian:bullseye-slim

RUN apt-get update -qq \
  && apt-get install -qq -y \
  autoconf \
  bison \
  build-essential \
  ca-certificates \
  curl \
  gnupg2 \
  libdb-dev \
  libffi-dev \
  libgdbm-dev \
  libgdbm6 \
  libgmp-dev \
  libncurses5-dev \
  libreadline6-dev \
  libssl-dev \
  libyaml-dev \
  patch \
  procps \
  rustc \
  shared-mime-info \
  uuid-dev \
  wget \
  zlib1g-dev \
  --no-install-recommends \
  && curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
  && echo "deb http://apt.postgresql.org/pub/repos/apt bullseye-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
  && wget --no-check-certificate --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && apt-get update -qq \
  && apt-get install -qq -y \
  postgresql-client-14 \
  libpq-dev \
  nodejs \
  && apt-get clean \
  && cd /opt \
  && wget https://github.com/rbenv/ruby-build/archive/refs/tags/v20221101.tar.gz \
  && tar -xzf v20221101.tar.gz \
  && PREFIX=/usr/local ./ruby-build-20221101/install.sh \
  && ruby-build 2.6.2 /opt/ruby-2.6.2 \
  && mkdir /app

RUN echo 'export PATH="/opt/ruby-2.6.2/bin:$PATH"' >> /root/.bashrc

ENV PATH="${PATH}:/opt/ruby-2.6.2/bin"

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle install

COPY . /app

RUN mkdir -p /app/log

CMD ["bundle", "exec", "rake", "db:load2"]
