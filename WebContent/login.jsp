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
                  	<TD width="50%"><INPUT TYPE="submit" NAME="submit" Value ="Login"></TD>
          		</TR>

   			</TABLE>

   			
   			<%
   			String name = request.getParameter("name");
   			String connectionURL = "jdbc:postgresql://localhost/cse135";
			Connection connection = null;
			PreparedStatement pstatement = null;
			Statement stmt = null;
			Class.forName("org.postgresql.Driver");
//			out.println("here");
			if(name!= null){
				try{
					connection = DriverManager.getConnection(connectionURL, "postgres", "postgres");
					//connection.setAutoCommit(false);
	   		        stmt = connection.createStatement();

			        String sql = "SELECT * FROM USERS WHERE NAME =\'"+ name+"\'";
			        ResultSet rs = stmt.executeQuery(sql);
			        String role = null;
			       
				    //STEP 5: Extract data from result set
				    while(rs.next()){
				        //Retrieve by column name
				        role = rs.getString("role");

				         //Display values
				         out.print("Role: " + role);
				         }
      				rs.close();
      				if(role!=null){
      					session.setAttribute("username", name);
      					session.setAttribute("role", role);
      					out.println("Welcome " + name);
      					if(role.equals("Owner")){
      						response.sendRedirect("category.jsp");
      					%>
      					<a class="btn btn-default" href ="category.jsp" >View Categories</a>
      					<% 
      					}
      					else if(role.equals("Customer")){
      						%>
      						<a class="btn btn-default" href ="category.jsp" >View Products</a>
      						<%
      					}
      				}else{
      					out.println("The provided name " + name + " is not known.");
      				}
      			}catch (SQLException e){
      				out.println(e.getMessage());
      			}
				catch(Exception e){
					out.println(e.getMessage());
				}
			}
   			%>
		

		</FORM>
		<TR>
              		<TH></TH>
              		<FORM action="signup.jsp" method ="post">
                  		<TD width="50%"><INPUT TYPE="submit" value="signup"></TD>
                  	</FORM>
          		</TR>
	</body>


</html>