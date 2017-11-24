FROM alpine:3.6

MAINTAINER The Software Development Team at InfoRLife SA <dev@inforlife.ch>

ENV TIMEZONE Europe/Rome
ENV RUBY_VERSION 2.4.2
ENV BUNDLER_VERSION 1.16.0
ENV APP_ROOT /dm4sea
ENV APP_ENVIRONMENT production
ENV PATH /usr/local/ruby/bin:$PATH

RUN apk update && \
    apk upgrade && \
    apk --no-cache add tzdata git bash wget yaml openssl-dev readline-dev build-base linux-headers && \
    apk --no-cache add sqlite sqlite-libs sqlite-dev && \
    apk --no-cache add supervisor  && \
    ls /usr/share/zoneinfo && \
    cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
    echo $TIMEZONE >  /etc/timezone && \
    apk del tzdata && \
    rm -rf /var/cache/apk/* && \
    git clone https://github.com/sstephenson/ruby-build.git && \
    cd ruby-build && \
    ./install.sh && \
    ruby-build $RUBY_VERSION /usr/local/ruby-$RUBY_VERSION && \
    ln -s /usr/local/ruby-$RUBY_VERSION/ /usr/local/ruby && \
    wget -O /usr/remote_syslog_linux_i386.tar.gz https://github.com/papertrail/remote_syslog2/releases/download/v0.19/remote_syslog_linux_i386.tar.gz  && \
    tar xzf /usr/remote_syslog_linux_i386.tar.gz -C /usr && \
    cp /usr/remote_syslog/remote_syslog /usr/local/bin && \
    rm /usr/remote_syslog_linux_i386.tar.gz && \
    rm -Rf /usr/remote_syslog

COPY docker/log_files.yml /etc/log_files.yml
RUN chmod +x /etc/log_files.yml

WORKDIR $APP_ROOT
COPY . $APP_ROOT

RUN gem install bundler -v $BUNDLER_VERSION --no-ri --no-rdoc && \
    bundle install --jobs 20 --retry 5 --without development test

RUN echo $(git describe --tags $(git rev-list --tags --max-count=1)) > RELEASE && \
    rm -rf $APP_ROOT/.git

COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
