FROM public.ecr.aws/docker/library/tomcat:9.0.83-jdk21-corretto-al2

WORKDIR /app

COPY ./content/webapps /usr/local/tomcat/webapps
COPY ./content/conf/server.xml /usr/local/tomcat/conf/server.xml

# COPY tomcat.env .
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
  ln -sf /dev/stdout /usr/local/tomcat/logs/access_log.txt && \
  ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

USER nobody

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD ["catalina.sh", "run"]
