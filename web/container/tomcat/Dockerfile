FROM public.ecr.aws/docker/library/tomcat:9.0.83-jdk21-corretto-al2

COPY ./webapps /usr/local/tomcat/webapps
COPY ./conf/server.xml /usr/local/tomcat/conf/server.xml

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

USER nobody

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD ["catalina.sh", "run"]
