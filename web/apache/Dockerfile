FROM public.ecr.aws/docker/library/httpd:2.4.58

RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

COPY ./conf/httpd.conf /usr/local/apache2/conf/httpd.conf
