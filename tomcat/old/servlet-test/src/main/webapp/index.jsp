<%@ page contentType="text/html; charset=UTF-8" %> <%@ page
import="java.net.InetAddress" %> <%@ page import="java.io.*" %> <%@ page
import="java.time.LocalDateTime" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
  </head>
  <body>
    <h1>Hello Tomcat</h1>
    <%= LocalDateTime.now() %> <% String userName =
    System.getProperty("user.name"); String hostname = "unknown"; try { hostname
    = InetAddress.getLocalHost().getHostName(); } catch (Exception e) {
    e.printStackTrace(); } %>
    <p>実行ユーザ名: <%= userName %></p>
    <p>ホスト名: <%= hostname %></p>
  </body>
</html>
