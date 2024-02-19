<!DOCTYPE html>
<%@ page import="java.net.InetAddress" %>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
  </head>
  <body>
    <h1>Hello JSP</h1>
    <br />
    <%@ page import="java.time.LocalDateTime" %> <%
    out.println(LocalDateTime.now()); %>
    <%
    // 実行ユーザ名を取得
    String userName = System.getProperty("user.name");

    // ホスト名を取得
    String hostname = "不明";
    try {
        hostname = InetAddress.getLocalHost().getHostName();
    } catch (Exception e) {
        e.printStackTrace();
    }

    // 実行ユーザ名とホスト名を表示
%>
    <p>実行ユーザ名: <%= userName %></p>
    <p>ホスト名: <%= hostname %></p
  </body>
</html>
