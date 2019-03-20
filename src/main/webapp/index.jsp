<%@ page import="java.io.InputStream" %>
<html>
<body>
<h2>Hello World!</h2>
<%
    StringBuilder buf = new StringBuilder();
    try (InputStream is = getClass().getResourceAsStream("/version.txt")) {
        int c;
        while (-1 != (c = is.read())) {
            buf.append((char)c);
        }
    }
%>
<%=buf%>
</body>
</html>
