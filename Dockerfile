ARG IMG_BASE=alpine:3.11
FROM ${IMG_BASE}
RUN sed -i "s/dl-cdn.alpinelinux.org/mirrors.cloud.tencent.com/g" /etc/apk/repositories \
 && apk update \
 && apk add --no-cache bash tzdata curl\
 && cp -r -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime 

RUN apk add --no-cache --virtual .build-deps git nodejs ruby ruby-dev ruby-rdoc ruby-irb ruby-io-console ruby-nokogiri gcc libc-dev libffi-dev zlib-dev libxml2-dev libxslt-dev build-base
# && apk del .build-deps
# && rm -rf /var/cache/apk/*
RUN gem sources --add https://mirrors.tuna.tsinghua.edu.cn/rubygems/ --remove https://rubygems.org/
RUN gem install bundler \
    && bundle config build.nokogiri --use-system-libraries
WORKDIR /app
COPY docker /app/docker
RUN git clone --depth=1 https://github.com/tuna/mirror-web.git\
 && chmod +x /app/docker/docker-entrypoint.sh
ENTRYPOINT ["/app/docker/docker-entrypoint.sh"]
EXPOSE 4000

