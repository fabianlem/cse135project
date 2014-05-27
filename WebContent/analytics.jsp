<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<html>

	<body>
	<% if(session.getAttribute("username") == null) {
	%>
	<h2>You are not logged in!!!</h2>
	<%
		out.print("<a href='login.jsp'>Log in</a>"); 
		}
	   else {
		String user = session.getAttribute("username").toString(); 
	    String role = session.getAttribute("role").toString();
		%>
	<h1>Welcome, <%=user%> </h1>
	<h2>Sales Analytics</h2>
	<%} %>
		<table>
		<%
                Connection conn = null;
                Statement stmt = null;
                PreparedStatement pstmt = null;
                ResultSet rs= null;
                try{
                    // Registering Postgresql JDBC driver with the DriverManager
                    Class.forName("org.postgresql.Driver");

                    // Open a connection to the database using DriverManager
                    conn = DriverManager.getConnection(
                        "jdbc:postgresql://localhost/cse135", "postgres", "postgres");
                    Statement statement = conn.createStatement();
		%>
			<tr> <!-- outer row -->
				<td> <!-- left row (with options) --> 
					
					<%-- Cutomers Button --%>
					<tr>
			            <SELECT NAME = "main"> 
			            	<OPTION value="Customer">Customer</OPTION>
			            	<OPTION value= "State">State</OPTION>
			            </SELECT>
			        </tr>
					
					<%-- State Dropdown --%>
					<tr>
			            <SELECT NAME="state">
			            	<OPTION value="ALL">All States</OPTION>
							<OPTION value="AL">Alabama</OPTION>
							<OPTION value="AK">Alaska</OPTION>
							<OPTION value="AR">Arkansas</OPTION>
							<OPTION value="AZ">Arizona</OPTION>
							<OPTION value="CA">California</OPTION>
						</SELECT>
		            </tr>

		            <%-- Category Dropdown --%>
		            <tr>

			            <SELECT NAME = "category"> 
			            	<OPTION value="ALL">All Categories</OPTION>

                            <% 
                            	rs = statement.executeQuery("SELECT * FROM Categories");
                            	while(rs.next()){ 
                                //categories.add(rs.getString("name"));
                                %>
                            
                             <option> <%=rs.getString("name")%></option>
                            
                            <%}
                            %>
                        
			            </SELECT>
			        </tr>
		            <%-- Ages Dropdown --%>
		            <tr>
			            <SELECT NAME = "ages"> 
			            	<OPTION value="ALL">All Ages</OPTION>
			            	<OPTION value="1sttier">12-18</OPTION>
			            	<OPTION value="2ndtier">18-45</OPTION>
			            	<OPTION value="3rdtier">45-65</OPTION>
			            	<OPTION value="4thtier">65+</OPTION>
			            </SELECT>
			        </tr>

			        <%-- Run Query --%>
		            <tr>
		            	<form method= "POST">
		            		<input type="submit" value="Run Query">
                		</form>
			        </tr>
				</td> 
				
				
				<td> <!-- right row graph -->
				
					<h1>this will be the table someday</h1> 
				</td>
			</tr>
		
			<%-- -------- Close Connection Code -------- --%>
            
            <%
       	      
            } catch (SQLException e) {

                // Wrap the SQL exception in a runtime exception to propagate
                // it upwards
                //throw new RuntimeException(e);
                //out.println(e.getMessage());
                out.println("Failure to run query");
            }
            finally {
                // Release resources in a finally block in reverse-order of
                // their creation

                if (rs != null) {
                    try {
                        rs.close();
                    } catch (SQLException e) { } // Ignore
                    rs = null;
                }
                if (pstmt != null) {
                    try {
                        pstmt.close();
                    } catch (SQLException e) { } // Ignore
                    pstmt = null;
                }
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) { } // Ignore
                    conn = null;
                }
            }
            %>
		</table>

	</body>

</html>