<%@page import="java.util.*" %>
<%@page import="java.sql.*" %>
<%@page import="java.io.*" %>
<%@page import="org.postgresql.*" %>

<html>
	<%--Signup page--%>

	<head>
		<title>Welcome to the Store</title>
	</head>
	
	<body>

		<FORM action="signup.jsp" method ="get"> 

			<TABLE style="background-color: #ECE5B6;" WIDTH="30%" >
         		<TR>
              		<TH width="50%">Name</TH>
                  	<TD width="50%"><INPUT TYPE="text" NAME="name"></TD>
          		</TR>
      
		      	<TR>
		            <TH width="50%">Age</TH>
		            <TD width="50%"><INPUT TYPE="text" NAME="Age"></TD>
		        </TR>
          
	          	<TR>
	            	<TH width="50%">Role</TH>
	                <TD width="50%">
	                	<%--INPUT TYPE="text" NAME="phone"--%>
	                	<SELECT NAME="role">
							<OPTION value="Owner">Owner</OPTION>
							<OPTION value="Customer">Customer</OPTION>
						</SELECT>
	                </TD>
	          	</TR>
                
                 <TR>
              		<TH width="50%">State</TH>
                  	<TD width="50%">
                  	<%--INPUT TYPE="submit" VALUE="submit"--%>
                  	<SELECT NAME="state">
						<OPTION value="AL">Alabama</OPTION>
						<OPTION value="AK">Alaska</OPTION>
						<OPTION value="AR">Arkansas</OPTION>
						<OPTION value="AZ">Arizona</OPTION>
						<OPTION value="CA">California</OPTION>
					</SELECT>
                  	</TD>
          		</tr>

          		<TR>
              		<TH></TH>
                  	<TD width="50%"><INPUT TYPE="submit" NAME="submit"></TD>
          		</TR>

          		<TR>
              		<TH></TH>
                  	<TD width="50%"><INPUT TYPE="button" NAME="login" ONCLICK="window.location.href = 'login.jsp';">Login</TD>
          		</TR>

   			</TABLE>
			<%
			String name = request.getParameter("name");
			String role = request.getParameter("role");
			String age = request.getParameter("age");
			String state = request.getParameter("state");

			
				String connectionURL = "jdbc:postgresql://localhost:8080/cse135";
				Connection connection = null;
				PreparedStatement pstatement = null;
				Class.forName("org.postgresql.Driver").newInstance();

				int updateQuery = 0;

				if(name!=null && age!=null){
					try{
				
						connection = DriverManager.getConnection(connectionURL, "postgres", "mecagoenlatapa");
						connection.setAutoCommit(false);
						String queryString = "INSERT INTO USERS (Name, Role, Age, State) VALUES (?,?,?,?)";
						pstatement = connection.prepareStatement(queryString);
						pstatement.setString(1, name);
						pstatement.setString(2, role);
						pstatement.setInt(3, Integer.parseInt(age));
						pstatement.setString(4, state);

						updateQuery = pstatement.executeUpdate();
						connection.commit();
						connection.setAutoCommit(true);
						if(updateQuery != 0){ %>
							<TABLE>
								<TR>
	              					<TH width="50%">data inserted</TH>
	                  			</TR>
							</TABLE>

						<%}
					}
					catch(Exception e){
						out.println("Unable to connect to db");
					}
							
					finally{
						pstatement.close();
						connection.close();
					}
				}
		
			%>
			<%-- Drop down menu --%>
			
		</FORM>
	</body>


</html>