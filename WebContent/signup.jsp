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

		<FORM action="signup.jsp" method ="post"> 

			<TABLE style="background-color: #ECE5B6;" WIDTH="30%" >
         		<TR>
              		<TH width="50%">Name</TH>
                  	<TD width="50%"><INPUT TYPE="text" NAME="name"></TD>
          		</TR>
      
		      	<TR>
		            <TH width="50%">Age</TH>
		            <TD width="50%"><INPUT TYPE="text" NAME="age"></TD>
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

          		

   			</TABLE>
			<%
			String name = request.getParameter("name");
			String role = request.getParameter("role");
			String age = request.getParameter("age");
			String state = request.getParameter("state");

			
				String connectionURL = "jdbc:postgresql://localhost/cse135";
				Connection connection = null;
				PreparedStatement pstatement = null;
				

				int updateQuery = 0;
				//out.println(name);
				//out.println(age);
				if(name!=null && age!=null){
					try{

						Class.forName("org.postgresql.Driver");
					//out.println("here");
				
						connection = DriverManager.getConnection("jdbc:postgresql://localhost/cse135?", "postgres", "postgres");
						//out.println("got connection");
					// Begin Transaction
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
						if(updateQuery != 0){ 
							session.setAttribute("username", name);
							session.setAttribute("role", role);

							//Owner or Customer
      							response.sendRedirect("signup2.jsp");	
 
						}else{
						
						}
					}
					catch(Exception e){
						//out.println(e.getMessage());
						%>
						<h2 style="color:red;">Pick a different Username</h2> 
						<%
					}
							
					finally{ 

						if (pstatement != null) {
		                    try {
			                        pstatement.close();
			                    } catch (SQLException e) { } // Ignore
			                    pstatement = null;
			                }
		                
		                if (connection != null) {
		                    try {
		                        connection.close();
		                    } catch (SQLException e) { } // Ignore
		                    connection = null;
		                }
					}
					}
		
			%>
			<%-- Drop down menu --%>
			
		</FORM>
			<TR>
              		<TH></TH>
              		<FORM action="login.jsp" method ="post">
                  		<TD width="50%"><INPUT TYPE="submit" value="login"></TD>
                  	</FORM>
          		</TR>
	</body>


</html>