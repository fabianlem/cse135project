<html>

<body>
<% String user = session.getAttribute("username").toString();;
String role = session.getAttribute("role").toString();%>
<h1>Welcome, <%=user%> </h1>
<h2>Successful signup! Thank you for joining us!<h2>

Please wait... while we redirect you!
<%


  if(role.equals("Owner")) {
	response.sendRedirect("category.jsp");
}
else if(role.equals("Customer")) {
	response.sendRedirect("productbrowsing.jsp");
} 
%>

</html>