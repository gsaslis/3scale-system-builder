FROM centos:7

ENV SUMMARY="Base image which allows using of source-to-image."	\
    DESCRIPTION="The s2i-core image provides any images layered on top of it \
with all the tools needed to use source-to-image functionality while keeping \
the image size as small as possible."

#LABEL summary="$SUMMARY" \
#      description="$DESCRIPTION" \
#      io.k8s.description="$DESCRIPTION" \
#      io.k8s.display-name="s2i core" \
#      io.openshift.s2i.scripts-url=image:///usr/libexec/s2i \
#      io.s2i.scripts-url=image:///usr/libexec/s2i \
#      com.redhat.component="s2i-core-container" \
#      name="centos/s2i-core-centos7" \
#      version="1" \
#      release="1" \
#      maintainer="SoftwareCollections.org <sclorg@redhat.com>"
#
#ENV \
#    # DEPRECATED: Use above LABEL instead, because this will be removed in future versions.
#    STI_SCRIPTS_URL=image:///usr/libexec/s2i \
#    # Path to be used in other layers to place s2i scripts into
#    STI_SCRIPTS_PATH=/usr/libexec/s2i \
#    APP_ROOT=/opt/app-root \
#    # The $HOME is not set by default, but some applications needs this variable
#    HOME=/opt/app-root/src \
#    PATH=/opt/app-root/src/bin:/opt/app-root/bin:$PATH


# When bash is started non-interactively, to run a shell script, for example it
# looks for this variable and source the content of this file. This will enable
# the SCL for all scripts without need to do 'scl enable'.
#ENV BASH_ENV=${APP_ROOT}/etc/scl_enable \
#    ENV=${APP_ROOT}/etc/scl_enable \
#    PROMPT_COMMAND=". ${APP_ROOT}/etc/scl_enable"

# This is the list of basic dependencies that all language container image can
# consume.
# Also setup the 'openshift' user that is used for the build execution and for the
# application runtime execution.
# TODO: Use better UID and GID values
#RUN rpmkeys --import file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && \
#  INSTALL_PKGS="bsdtar \
#  findutils \
#  gettext \
#  groff-base \
#  scl-utils \
#  tar \
#  unzip \
#  yum-utils" && \
#  mkdir -p ${HOME}/.pki/nssdb && \
#  chown -R 1001:0 ${HOME}/.pki && \
#  yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
#  rpm -V $INSTALL_PKGS && \
#  yum clean all -y

# Copy extra files to the image.
#COPY ./root/ /

# Directory with the sources is set as the working directory so all STI scripts
# can execute relative to this path.
#WORKDIR ${HOME}

#ENTRYPOINT ["container-entrypoint"]
#CMD ["base-usage"]

# Reset permissions of modified directories and add default user
#RUN rpm-file-permissions && \
#  useradd -u 1001 -r -g 0 -d ${HOME} -s /sbin/nologin \
#      -c "Default Application User" default && \
#  chown -R 1001:0 ${APP_ROOT}

# This image is the base image for all OpenShift v3 language container images.
#FROM centos/s2i-core-centos7

#ENV SUMMARY="Base image with essential libraries and tools used as a base for \
#builder images like perl, python, ruby, etc." \
#    DESCRIPTION="The s2i-base image, being built upon s2i-core, provides any \
#images layered on top of it with all the tools needed to use source-to-image \
#functionality. Additionally, s2i-base also contains various libraries needed for \
#it to serve as a base for other builder images, like s2i-python or s2i-ruby." \
#    NODEJS_SCL=rh-nodejs8
#
#LABEL summary="$SUMMARY" \
#      description="$DESCRIPTION" \
#      io.k8s.description="$DESCRIPTION" \
#      io.k8s.display-name="s2i base" \
#      com.redhat.component="s2i-base-container" \
#      name="centos/s2i-base-centos7" \
#      version="1" \
#      release="1" \
#      maintainer="SoftwareCollections.org <sclorg@redhat.com>"

# This is the list of basic dependencies that all language container image can
# consume.
#RUN yum install -y centos-release-scl && \
#  INSTALL_PKGS="autoconf \
#  automake \
#  bzip2 \
#  gcc-c++ \
#  gd-devel \
#  gdb \
#  git \
#  libcurl-devel \
#  libxml2-devel \
#  libxslt-devel \
#  lsof \
#  make \
#  mariadb-devel \
#  mariadb-libs \
#  openssl-devel \
#  patch \
#  postgresql-devel \
#  procps-ng \
#  ${NODEJS_SCL}-npm \
#  sqlite-devel \
#  unzip \
#  wget \
#  which \
#  zlib-devel" && \
#  yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
#  rpm -V $INSTALL_PKGS && \
#  yum clean all -y

#FROM centos/s2i-base-centos7

# This image provides a Ruby 2.3 environment you can use to run your Ruby
# applications.

#EXPOSE 8080

ENV RUBY_VERSION 2.3.7
ENV BUNDLER_VERSION 1.16.5

#ENV SUMMARY="Platform for building and running Ruby $RUBY_VERSION applications" \
#    DESCRIPTION="Ruby $RUBY_VERSION available as container is a base platform for \
#building and running various Ruby $RUBY_VERSION applications and frameworks. \
#Ruby is the interpreted scripting language for quick and easy object-oriented programming. \
#It has many features to process text files and to do system management tasks (as in Perl). \
#It is simple, straight-forward, and extensible."
#
#LABEL summary="$SUMMARY" \
#      description="$DESCRIPTION" \
#      io.k8s.description="$DESCRIPTION" \
#      io.k8s.display-name="Ruby 2.3" \
#      io.openshift.expose-services="8080:http" \
#      io.openshift.tags="builder,ruby,ruby23,rh-ruby23" \
#      com.redhat.component="rh-ruby23-container" \
#      name="centos/ruby-23-centos7" \
#      version="2.3" \
#      usage="s2i build https://github.com/sclorg/s2i-ruby-container.git --context-dir=2.4/test/puma-test-app/ centos/ruby-23-centos7 ruby-sample-app" \
#      maintainer="SoftwareCollections.org <sclorg@redhat.com>"

#RUN yum install -y centos-release-scl && \
#    INSTALL_PKGS="rh-ruby23 rh-ruby23-ruby-devel rh-ruby23-rubygem-rake rh-ruby23-rubygem-bundler" && \
#    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && rpm -V $INSTALL_PKGS && \
#    yum clean all -y

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
#COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# Copy extra files to the image.
#COPY ./root/ /

# Drop the root user and make the content of /opt/app-root owned by user 1001
#RUN chown -R 1001:0 ${APP_ROOT} && chmod -R ug+rwx ${APP_ROOT} && \
#    rpm-file-permissions

#USER 1001

# Set the default CMD to print the usage of the language image
#CMD $STI_SCRIPTS_PATH/usage


ENV HOME=/home/ruby
ENV PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$HOME/.rbenv/versions/$RUBY_VERSION/bin:$PATH"

# rbenv-installer deps
RUN yum install -y git \
                   bzip2 \
                   which \
   && curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash

# rbenv deps
RUN yum install -y openssl-devel \
               readline-devel \
               zlib-devel \
               gcc \
               gcc-c++ \
               make \
 && rbenv install $RUBY_VERSION \
 && rbenv global $RUBY_VERSION \
 && adduser --home ${HOME} --comment "" ruby \
 && echo --color > /.rspec > ${HOME}/.rspec

RUN  eval "$(rbenv init -)" \
 && gem update --system --no-document \
 && bundle config --global without development \
 && bundle config --global jobs `grep -c processor /proc/cpuinfo` \
 && bundle config --global cache_all true \
 && chown ruby -R ${HOME}/.bundle

ENV DISPLAY=:99.0

# various system deps
RUN yum install -y epel-release \
 && yum install -y redis \
                   mysql-devel \
                   Xvfb \
                   firefox \
                   qt5-qtwebkit-devel \
                   libicu \
                   unzip \
                   memcached \
                   dnsmasq \
                   ImageMagick \
                   ImageMagick-devel \
                   pcre-devel \
                   openssl-devel

ENV QMAKE="$(which qmake-qt5)"

# sphinx deps + installation
RUN yum install -y postgresql-libs \
                   unixODBC \
  && yum clean all -y \
  && curl http://sphinxsearch.com/files/sphinx-2.2.11-1.rhel7.x86_64.rpm > /tmp/sphinx-2.2.11-1.rhel7.x86_64.rpm \
  && yum install -y /tmp/sphinx-2.2.11-1.rhel7.x86_64.rpm \
  && sed --in-place "s/databases 16/databases 32/" /etc/redis.conf
