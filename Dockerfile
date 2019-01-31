FROM centos/ruby-23-centos7

ENV RUBY_VERSION="2.3.7" \
    BUNDLER_VERSION="1.16.6" \
    OPENRESTY_VERSION=1.11.2.1 \
    LUAROCKS_VERSION=2.3.0

ARG DB=mysql

ENV PATH="./node_modules/.bin:$PATH:/usr/local/nginx/sbin/:/usr/local/luajit/bin/" \
    DISPLAY=:99.0 \
    SKIP_ASSETS="1" \
    RAILS_ENV=test \
    TZ=:/etc/localtime \
    LD_LIBRARY_PATH=/opt/oracle/instantclient_12_2/ \
    ORACLE_HOME=/opt/oracle/instantclient_12_2/ \
    DB=$DB \
    QMAKE=/usr/bin/qmake-qt5

RUN echo --color > ~/.rspec \
# enables SCL collections, so that we can use bundler
 && source $ENV \
 && gem install bundler --version ${BUNDLER_VERSION} --no-doc

USER root

# rbenv-installer deps
RUN yum install -y git \
                   bzip2 \
                   which \
                   openssl-devel \
                   readline-devel \
                   zlib-devel \
                   gcc \
                   gcc-c++ \
                   make \
                   sudo \
 && echo 'default        ALL=(ALL)       NOPASSWD: ALL' >> /etc/sudoers


# various system deps
RUN yum install -y epel-release \
 && yum install -y mysql-devel \
                   Xvfb \
                   firefox \
                   qt5-qtwebkit-devel \
                   libicu \
                   unzip \
                   ImageMagick \
                   ImageMagick-devel \
                   pcre-devel \
                   openssl-devel \
                   libaio \
                   dbus \
# sphinx deps + installation
                   postgresql-libs \
                   unixODBC \
  && yum clean all -y \
  && curl http://sphinxsearch.com/files/sphinx-2.2.11-1.rhel7.x86_64.rpm > /tmp/sphinx-2.2.11-1.rhel7.x86_64.rpm \
  && yum install -y /tmp/sphinx-2.2.11-1.rhel7.x86_64.rpm

RUN source $ENV \
 && npm install yarn -g \
 && rm -rf ~/.npm ~/.config


ADD https://github.com/mozilla/geckodriver/releases/download/v0.16.1/geckodriver-v0.16.1-linux64.tar.gz /tmp/geckodriver.tar.gz
RUN tar -xzvf /tmp/geckodriver.tar.gz -C /usr/local/bin/ && rm -rf /tmp/geckodriver.tar.gz


WORKDIR /opt/system/

RUN mkdir -p  /opt/system/tmp/cache/ \
              /opt/system/vendor/bundle \
              /opt/system/node_modules \
              /opt/system/assets/jspm_packages \
              /opt/system/public/assets \
              /root/.jspm \
              /home/ruby/.luarocks \
 && groupadd --gid 1042 3scale-dev \
 && usermod -aG 1042 default \
 && dbus-uuidgen | sudo tee /etc/machine-id \
 && chown -R default /opt/system

VOLUME [ "/opt/system/tmp/cache/", \
         "/opt/system/vendor/bundle", \
         "/opt/system/node_modules", \
         "/opt/system/assets/jspm_packages", \
         "/opt/system/public/assets", \
         "/root/.jspm", \
         "/home/ruby/.luarocks" \
       ]

#
#ADD http://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz /tmp/openresty.tar.gz
#ADD https://github.com/keplerproject/luarocks/archive/v${LUAROCKS_VERSION}.tar.gz /tmp/luarocks.tar.gz
#
#RUN tar xzf /tmp/openresty.tar.gz -C /tmp/ \
# && cd /tmp/openresty-${OPENRESTY_VERSION} \
# && ./configure --with-pcre --prefix=/usr/local \
# && make -j`grep -c processor /proc/cpuinfo` && make install \
# && ln -sf /usr/local/luajit/bin/luajit-* /usr/local/luajit/bin/luajit \
# && ln -sf /usr/local/luajit/include/luajit-* /usr/local/luajit/include/lua5.1 \
# && rm -r /tmp/openresty-${OPENRESTY_VERSION} \
# && tar xzf /tmp/luarocks.tar.gz -C /tmp/ \
# && cd /tmp/luarocks-${LUAROCKS_VERSION} \
# && ./configure --prefix=/usr/local/luajit --with-lua=/usr/local/luajit \
#    --with-lua-lib=/usr/local/lualib --lua-version=5.1 --lua-suffix=jit \
# && make build && make install \
# && rm -rf /tmp/luarocks-${LUAROCKS_VERSION}

USER default

ENTRYPOINT ["container-entrypoint", "/usr/bin/xvfb-run", "-s", "-screen 0 1280x1024x24"]

CMD ["script/jenkins.sh"]
