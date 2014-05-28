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
                ResultSet rs1 = null;
                try{
                    // Registering Postgresql JDBC driver with the DriverManager
                    Class.forName("org.postgresql.Driver");

                    // Open a connection to the database using DriverManager
                    conn = DriverManager.getConnection(
                        "jdbc:postgresql://localhost/cse135", "postgres", "postgres");
                    Statement statement = conn.createStatement();
                    Statement statement2 = conn.createStatement();
		%>

			<tr> <!-- outer row -->
				<td> <!-- left row (with options) --> 
					<form method= "POST">
					<%-- Cutomers Dropdown --%>
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
		            	
		            		<input type="submit" value="Run Query">
                		
			        </tr>
			        </form>
				</td> 
				
				
				<td> <!-- right row graph -->
					<table border = "1">
					<tr>

						<th>----</th>
					
						<%
							int rowOff = (session.getAttribute("rowOff") != null) ? (Integer.parseInt(session.getAttribute("rowOff").toString())) : 0; 
							//int rowOffNext = 20; 
							int colOff = (session.getAttribute("colOff") != null) ? (Integer.parseInt(session.getAttribute("colOff").toString())) : 0; 
							//int colOffNext = 10; 
							out.println();

							String action = request.getParameter("action");

							if(action != null && action.equals("row"))
							{
								session.setAttribute("rowOff", rowOff+20);
								response.sendRedirect("analytics.jsp");
							}

							if(action != null && action.equals("col"))
							{
								session.setAttribute("colOff", colOff+10);
								response.sendRedirect("analytics.jsp");
							}
							/*if(session.getAttribute("rowOff") != null && !session.getAttribute("rowOff").equals("0")) { 
								rowOff = Integer.parseInt(session.getAttribute("rowOff").toString()); 
								out.println(rowOff);
								rowOffNext = rowOff + 20; 
							} if(session.getAttribute("colOff") != null && !session.getAttribute("colOff").equals("0")) { 
								colOff = Integer.parseInt(session.getAttribute("colOff").toString()); 	
								out.println(colOff);
								colOffNext = colOff + 10; 
							}*/
							rs = statement.executeQuery("SELECT products.name, products.id, sum(sales.quantity*sales.price) as amount FROM Products, Sales where sales.pid = products.id group by products.id order by products.name asc limit 10 offset " + colOff);
								while(rs.next()){ 	
								%>
									<th><%=rs.getString("name")%> ($<%=rs.getString("amount")%>)</th>
								<%}%>
								<th>
									<form action="analytics.jsp" method= "POST">
		            					<% //session.setAttribute("colOff", colOff+10);
		            					//out.println(colOff);
		            					//out.println(session.getAttribute("colOff"));
		            					%>
		            					<input type="hidden" name="action" value="col">
		            					<input type="submit" value="Next 10">
                					</form> 
								</th>
					</tr>
						<%
							rs = statement.executeQuery("SELECT users.name, users.id, sum(sales.quantity * sales.price) as amount FROM users, sales where sales.uid = users.id group by users.id order by users.name asc limit 20 offset " + rowOff);
                            	while(rs.next()){ 	
								%>
									<tr>
										<th><%=rs.getString("name")%> ($<%=rs.getString("amount")%>)</th>
										<%
										 /*rs1 = statement.executeQuery("select products.id, sum(sales.quantity) as res from products, sales where sales.uid= "+ rs.getInt("users.id") +" and products.id = sales.pid group by products.id");*/
										 /*rs1 = statement2.executeQuery("select sum(sales.quantity) as res from products cross join sales where sales.uid ="+ rs.getInt("id")+" and sales.pid = products.id group by sales.pid, products.id order by products.name asc");*/
										 rs1 = statement2.executeQuery("select result.res from ( (select products.id as id, products.name as name, sum(sales.quantity * products.price) as res from products cross join sales where sales.uid ="+ rs.getInt("id")+" and sales.pid = products.id group by sales.pid, products.id order by products.name asc) UNION (select products.id as id, products.name as name, 0 as res from products where products.id not in (select products.id from products, sales where sales.uid = "+ rs.getInt("id")+" and products.id = sales.pid)) ) as result order by result.name asc limit 10 offset " + colOff);
										while(rs1.next()){
										%>
											<td><%=rs1.getString("res")%></td>
										<%}%>
									</tr>
								<%}%>
								<th>
									<form action="analytics.jsp" method= "POST">
										<%// session.setAttribute("rowOff", rowOff+20);
										//out.println(rowOff);
										%>
										<input type="hidden" name="action" value="row">
		            					<input type="submit" value="Next 20">
                					</form> 
								</th>
					</table>
					<tr>
						<td>
						<h2>what is this</h2>
						</td>
						<td>format2
						</td>
					</tr>
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