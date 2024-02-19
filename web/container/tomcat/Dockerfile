FROM public.ecr.aws/docker/library/tomcat:9.0.83-jdk21-corretto-al2

COPY ./webapps /usr/local/tomcat/webapps
COPY ./conf/server.xml /usr/local/tomcat/conf/server.xml

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# ログを標準出力 server.xmlと連携 https://qiita.com/hidekatsu-izuno/items/ab604b6c764b5b5a86ed#%E3%83%AD%E3%82%B0%E3%81%AE%E6%95%B4%E7%90%86
RUN ln -sf /dev/stdout /usr/local/tomcat/logs/access_log.txt

USER nobody

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD ["catalina.sh", "run"]
