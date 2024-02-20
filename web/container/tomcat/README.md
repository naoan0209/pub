# Tomcatコンテナサンプル

## 起動方法

`docker image build -t tomcat`

`docker container run --name tomcat --rm -d -p 8080:8080 tomcat`


## デバッグ

### -dを消すとログが標準出力される

`docker container run --name tomcat --rm -p 8080:8080 tomcat`
