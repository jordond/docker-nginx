FROM debian:jessie
MAINTAINER jordond

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list

ENV NGINX_VERSION 1.9.2-1~jessie

RUN apt-get update && \
    apt-get install -y ca-certificates nginx=${NGINX_VERSION} && \
    rm -rf /var/lib/apt/lists/*

ADD nginx.conf /etc/nginx/nginx.conf


ADD start.sh /start.sh
RUN chmod u+x /start.sh

RUN mkdir -p /root/{default,errors}
ADD default-site/ /root/default
ADD error-pages/ /root/errors
ADD conf.d/ /etc/nginx/conf.d

RUN useradd http

VOLUME /data

# expose port for http
EXPOSE 80

# expose port for https
EXPOSE 443

CMD ["/start.sh"]