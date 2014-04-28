<%@page import="java.util.*" %>
<%@page import="java.sql.*" %>
<%@page import="java.io.*" %>

<html>
	<%--Signup page--%>

	<head>
		<title>Welcome to the Store</title>
	</head>
	
	<body>
		<FORM action="signup.jsp" method ="get"> 
			<%
			String name = request.getParameter("name");

			String age = request.getParameter("age");


			
				String connectionURL = "jdbc:mysql://localhost:8080/dbname";
				Connection connection = null;
				PreparedStatement pstatement = null;
				Class.forName("com.mysql.jdbc.Driver").newInstance();

				if(name!=null && age!=null){
					try{
				
						connection = DriverManager.getConnection(connectionURL, "root", "root");
						String queryString = "INSERT INTO stu_info (Name, Role, Age, State) VALUES (?,?,?)"
						pstatement = connection.prepareStatement(queryString);
						pstatement.setString(1, name);
						pstatement.setString(2, role);
						pstatement.setString(3, age);
						pstatement.setString(4, state);

						updateQuery = pstatement.executeUpdate();
					}
					catch(Exception e){
						out.println("Unable to connect to db")
					}
				}
		%>
			<SELECT ROLE="role">
				<OPTION value="Owner">Owner</OPTION>
				<OPTION value="Customer">Customer</OPTION>
			</SELECT>

			<SELECT STATE="state">
				<OPTION value="AL">Alabama</OPTION>
				<OPTION value="AK">Alaska</OPTION>
				<OPTION value="AR">Arkansas</OPTION>
				<OPTION value="AZ">Arizona</OPTION>
				<OPTION value="CA">California</OPTION>
			</SELECT>

		<%
		finally{
			pstatement.close();
			connection.close();
		}
		
			%>
			<!-- Drop down menu -->
			
		</FORM>
	</body>


</html>