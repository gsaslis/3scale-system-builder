FROM centos/ruby-25-centos7

ENV BUNDLER_VERSION="1.17.3" \
    OPENRESTY_VERSION=1.11.2.1 \
    LUAROCKS_VERSION=2.3.0 \
    NODEJS_SCL=rh-nodejs8

ARG DB=mysql

ENV PATH="./node_modules/.bin:$PATH:/usr/local/nginx/sbin/:/usr/local/luajit/bin/" \
    DISPLAY=:99.0 \
    SKIP_ASSETS="1" \
    TZ=:/etc/localtime \
    LD_LIBRARY_PATH=/opt/oracle/instantclient_12_2/ \
    ORACLE_HOME=/opt/oracle/instantclient_12_2/ \
    DB=$DB

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
                   rh-nodejs8 \
                   file \
 && echo 'default        ALL=(ALL)       NOPASSWD: ALL' >> /etc/sudoers

RUN echo --color > ~/.rspec \
# enables SCL collections, so that we can use bundler
 && source $ENV \
 && gem install bundler --version ${BUNDLER_VERSION} --no-doc


# various system deps
RUN echo $'\n\
[google-chrome]\n\
name=google-chrome\n\
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64\n\
enabled=1\n\
gpgcheck=1\n\
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub' \
 > /etc/yum.repos.d/google-chrome.repo \
  && yum install -y epel-release \
  && yum install -y mysql-devel \
                   firefox \
                   google-chrome-stable \
                   unzip \
                   ImageMagick \
                   ImageMagick-devel \
                   pcre-devel \
                   openssl-devel \
                   libaio \
                   dbus \
                   postgresql-libs \
                   unixODBC \
  && wget http://mirror.centos.org/centos/7/os/x86_64/Packages/urw-fonts-2.4-16.el7.noarch.rpm \
  && rpm -ivh --nodeps urw-fonts-2.4-16.el7.noarch.rpm \
  && rm urw-fonts-2.4-16.el7.noarch.rpm  \
  && yum update -y \
  && yum clean all -y \
  && curl http://sphinxsearch.com/files/sphinx-2.2.11-1.rhel7.x86_64.rpm > /tmp/sphinx-2.2.11-1.rhel7.x86_64.rpm \
  && yum install -y /tmp/sphinx-2.2.11-1.rhel7.x86_64.rpm \
  && wget -N https://chromedriver.storage.googleapis.com/$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip -P /tmp \
  && unzip /tmp/chromedriver_linux64.zip -d /tmp \
  && rm /tmp/chromedriver_linux64.zip \
  && mv -f /tmp/chromedriver /usr/local/bin/chromedriver \
  && chown root:root /usr/local/bin/chromedriver \
  && chmod 0755 /usr/local/bin/chromedriver



RUN source $ENV \
 && npm install npm@^6.9.0 -g \
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

USER default

ENTRYPOINT ["container-entrypoint"]
