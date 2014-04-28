<%@page import="java.util.*" %>
<%@page import="java.sql.*" %>
<%@page import="java.io.*" %>
<%--@page import="org.postgresql.*" -%>

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
   			</TABLE>
			<%
			String name = request.getParameter("name");
			String role = request.getParameter("role");
			String age = request.getParameter("age");
			String state = request.getParameter("state"); 

			
				String connectionURL = "jdbc:postgresql://localhost:8080/cse135?" +
                    "user=postgres&password=mecagoenlatapa";
				Connection connection = null;
				PreparedStatement pstatement = null;
				Class.forName("org.postgresql.Driver").newInstance();

				if(name!=null && age!=null){
					try{
				
						connection = DriverManager.getConnection(connectionURL, "postgres", "root");
						String queryString = "INSERT INTO stu_info (Name, Role, Age, State) VALUES (?,?,?,?)";
						pstatement = connection.prepareStatement(queryString);
						pstatement.setString(1, name);
						pstatement.setString(2, role);
						pstatement.setString(3, age);
						pstatement.setString(4, state);

						int updateQuery = pstatement.executeUpdate();
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