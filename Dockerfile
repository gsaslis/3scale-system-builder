FROM ruby:2.3-alpine
MAINTAINER Yorgos Saslis <yorgos@redhat.com>

ENV HOME=/home/ruby

RUN adduser --disabled-password --home ${HOME} --gecos "" ruby \
 && gem update --system --no-document \
 && echo --color > /.rspec > ${HOME}/.rspec

RUN bundle config --global without development \
 && bundle config --global jobs `grep -c processor /proc/cpuinfo` \
 && bundle config --global cache_all true \
 && chown ruby -R ${HOME}/.bundle

ENV DISPLAY=:99.0

RUN apk update \
 && apk add --no-cache redis \
            mariadb-dev \
            xvfb \
            firefox-esr \
            qt-dev \
            icu-libs \
            unzip \
            memcached \
            sphinx \
            dnsmasq \
            imagemagick \
            imagemagick-dev \
            pcre-dev \
            libressl-dev \
            git \
            make \
            nodejs \
            squid \
            yarn \
            libaio \
            bash \
 && sed --in-place "s/databases 16/databases 32/" /etc/redis.conf \
 && echo 'dns_nameservers 8.8.8.8 8.8.4.4' >> /etc/squid.conf

ADD https://github.com/mozilla/geckodriver/releases/download/v0.16.1/geckodriver-v0.16.1-linux64.tar.gz /tmp/geckodriver.tar.gz

RUN tar -xzvf /tmp/geckodriver.tar.gz -C /usr/local/bin/ && rm -rf /tmp/geckodriver.tar.gz

ARG DB=mysql

ENV PATH="./node_modules/.bin:$PATH" \
    SKIP_ASSETS="1" \
    DNSMASQ="#" \
    RAILS_ENV=test \
    BUNDLE_FROZEN=1 \
    TZ=:/etc/localtime \
    LD_LIBRARY_PATH=/opt/oracle/instantclient_12_2/ \
    ORACLE_HOME=/opt/oracle/instantclient_12_2/ \
    DB=$DB

WORKDIR /opt/system/

# Code Climate test reporter
ADD https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 ./tmp/cc-test-reporter
RUN chmod +x ./tmp/cc-test-reporter

VOLUME [ "/opt/system/tmp/cache/", \
         "/opt/system/vendor/bundle", \
         "/opt/system/node_modules", \
         "/opt/system/assets/jspm_packages", \
         "/opt/system/public/assets", \
         "/root/.jspm", "/home/ruby/.luarocks" ]

ADD https://raw.githubusercontent.com/cjpetrus/alpine_webkit2png/master/xvfb-run /usr/bin/xvfb-run
RUN chmod +x /usr/bin/xvfb-run
ENTRYPOINT ["/usr/bin/xvfb-run", "--server-args", "-screen 0 1280x1024x24"]

CMD ["script/jenkins.sh"]

# Oracle special, this needs Oracle to be present in vendor/oracle
RUN if [ "${DB}" = "oracle" ]; then unzip /opt/oracle/instantclient-basiclite-linux.x64-12.2.0.1.0.zip -d /opt/oracle/ \
 && unzip /opt/oracle/instantclient-sdk-linux.x64-12.2.0.1.0.zip -d /opt/oracle/ \
 && unzip /opt/oracle/instantclient-odbc-linux.x64-12.2.0.1.0-2.zip -d /opt/oracle/ \
 && (cd /opt/oracle/instantclient_12_2/ && ln -s libclntsh.so.12.1 libclntsh.so) \
 && rm -rf /opt/system/vendor/oracle \
 && rm -rf /opt/oracle/*.zip; fi
