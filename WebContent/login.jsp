<%@page import="java.util.*" %>
<%@page import="java.sql.*" %>
<%@page import="java.io.*" %>

<html>
	<head>
		<title>Login into Store</title>
	</head>
	
	<body>

		<FORM action="login.jsp" method ="post"> 

			<TABLE style="background-color: #ECE5B6;" WIDTH="30%" >
         		<TR>
              		<TH width="50%">Name</TH>
                  	<TD width="50%"><INPUT TYPE="text" NAME="name"></TD>
          		</TR>
      
		      	<TR>
              		<TH></TH>
                  	<TD width="50%"><INPUT TYPE="submit" NAME="submit"></TD>
          		</TR>

   			</TABLE>

   			
   			<%
   			String name = request.getParameter("name");
   			String connectionURL = "jdbc:postgresql://localhost:8080/cse135";
			Connection connection = null;
			PreparedStatement pstatement = null;
			Class.forName("org.postgresql.Driver").newInstance();
			connection = DriverManager.getConnection(connectionURL, "postgres", "mecagoenlatapa");
			//connection.setAutoCommit(false);
			// search in database code HERE
   			%>

		</FORM>
	</body>


</html>