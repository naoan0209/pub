<!DOCTYPE html>
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
  </body>
</html>
