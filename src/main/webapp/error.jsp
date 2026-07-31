<%@ page isErrorPage="true" %>

<h1>Application Error</h1>

<%
if (exception != null) {
    exception.printStackTrace(new java.io.PrintWriter(out));
}
%>