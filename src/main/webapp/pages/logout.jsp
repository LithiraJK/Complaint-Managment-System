<%@ page contentType="text/html;charset=UTF-8" %>
<%
    HttpSession httpSession = request.getSession(false);
    if (httpSession != null) {
        httpSession.invalidate();
    }
    response.sendRedirect("signin.jsp");
%>