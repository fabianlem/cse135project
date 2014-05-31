<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.lang.*"%>
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
		<table>
		<%
                Connection conn = null;
                Statement stmt = null;
                PreparedStatement pstmt = null;
                ResultSet rs= null;
                ResultSet rs1 = null;
                ResultSet test1 = null;
                ResultSet test2 = null;
                long endProd, endCust, end;
                long start = System.currentTimeMillis();
                long endTable = 0;
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
					<input type="hidden" name="action" value="filter">
					<% if(session.getAttribute("flag") == null || session.getAttribute("flag").equals("true")) { %>
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
							<OPTION value="Alabama">Alabama</OPTION>
							<OPTION value="Alaska">Alaska</OPTION>
							<OPTION value="Arkansas">Arkansas</OPTION>
							<OPTION value="Arizona">Arizona</OPTION>
							<OPTION value="California">California</OPTION>
							<OPTION value='Colorado'>Colorado</OPTION>
							<OPTION value='Connecticut'>Connecticut</OPTION>
							<OPTION value='Delaware'>Delaware</OPTION>
							<OPTION value='District Of Columbia'>District Of Columbia</OPTION>
							<OPTION value='Florida'>Florida</OPTION>
							<OPTION value='Georgia'>Georgia</OPTION>
							<OPTION value='Hawaii'>Hawaii</OPTION>
							<OPTION value='Idaho'>Idaho</OPTION>
							<OPTION value='Illinois'>Illinois</OPTION>
							<OPTION value='Indiana'>Indiana</OPTION>
							<OPTION value='Iowa'>Iowa</OPTION>
							<OPTION value='Kansas'>Kansas</OPTION>
							<OPTION value='Kentucky'>Kentucky</OPTION>
							<OPTION value='Louisiana'>Louisiana</OPTION>
							<OPTION value='Maine'>Maine</OPTION>
							<OPTION value='Maryland'>Maryland</OPTION>
							<OPTION value='Massachusetts'>Massachusetts</OPTION>
							<OPTION value='Michigan'>Michigan</OPTION>
							<OPTION value='Minnesota'>Minnesota</OPTION>
							<OPTION value='Mississippi'>Mississippi</OPTION>
							<OPTION value='Missouri'>Missouri</OPTION>
							<OPTION value='Montana'>Montana</OPTION>
							<OPTION value='Nebraska'>Nebraska</OPTION>
							<OPTION value='Nevada'>Nevada</OPTION>
							<OPTION value='New Hampshire'>New Hampshire</OPTION>
							<OPTION value='New Jersey'>New Jersey</OPTION>
							<OPTION value='New Mexico'>New Mexico</OPTION>
							<OPTION value='New York'>New York</OPTION>
							<OPTION value='North Carolina'>North Carolina</OPTION>
							<OPTION value='North Dakota'>North Dakota</OPTION>
							<OPTION value='Ohio'>Ohio</OPTION>
							<OPTION value='Oklahoma'>Oklahoma</OPTION>
							<OPTION value='Oregon'>Oregon</OPTION>
							<OPTION value='Pennsylvania'>Pennsylvania</OPTION>
							<OPTION value='Rhode Island'>Rhode Island</OPTION>
							<OPTION value='Sout Carolina'>South Carolina</OPTION>
							<OPTION value='South Dakora'>South Dakota</OPTION>
							<OPTION value='Tennessee'>Tennessee</OPTION>
							<OPTION value='Texas'>Texas</OPTION>
							<OPTION value='Utah'>Utah</OPTION>
							<OPTION value='Vermont'>Vermont</OPTION>
							<OPTION value='Virginia'>Virginia</OPTION>
							<OPTION value='West Virginia'>Washington</OPTION>
							<OPTION value='West Virginia'>West Virginia</OPTION>
							<OPTION value='Wisconsin'>Wisconsin</OPTION> 
							<OPTION value='Wyoming'>Wyoming</OPTION> 
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
			            	<OPTION value="between 12 and 18">12-18</OPTION>
			            	<OPTION value="between 18 and 45">18-45</OPTION>
			            	<OPTION value="between 45 and 65">45-65</OPTION>
			            	<OPTION value="between 65 and 200">65+</OPTION>
			            </SELECT>
			        </tr>

			        <%-- Run Query --%>
		            <tr>
		            		<input type="submit" value="Run Query">
                			
			        </tr>
			        <% } 
			        else { %>
			        <tr>
			        	<input type="submit" value = "New Query">
			        </tr>
			        <% } %>
			        </form>
				</td> 


				<td> <!-- right row graph -->
					<table border = "1">
					<tr>

						<th>Customers</th>

						<%
							String main = request.getParameter("main");
							String state = request.getParameter("state");
							String category = request.getParameter("category");
							String age = request.getParameter("ages");
						
							int rowOff = (session.getAttribute("rowOff") != null) ? (Integer.parseInt(session.getAttribute("rowOff").toString())) : 0; 
							//int rowOffNext = 20; 
							int colOff = (session.getAttribute("colOff") != null) ? (Integer.parseInt(session.getAttribute("colOff").toString())) : 0; 
							//int colOffNext = 10; 
							//out.println();
							//if(session.getAttribute("cus"))

							String action = request.getParameter("action");

							if(action != null && action.equals("row"))
							{
								session.setAttribute("rowOff", rowOff+20);
								session.setAttribute("flag", "false");
								response.sendRedirect("analytics.jsp");
							}

							if(action != null && action.equals("col"))
							{
								session.setAttribute("colOff", colOff+10);
								session.setAttribute("flag", "false");
								response.sendRedirect("analytics.jsp");
							}

							if(action != null && action.equals("filter"))
							{
								if(session.getAttribute("flag") == null || session.getAttribute("flag").equals("true")) {
									session.setAttribute("main", main);
									session.setAttribute("state", state);
									session.setAttribute("category", category);
									session.setAttribute("ages", age);
									session.setAttribute("rowOff", 0);
									session.setAttribute("colOff", 0);
								}
								else
								{
									session.setAttribute("flag", "true");
									response.sendRedirect("analytics.jsp");
								}
							}
							/* FILTERING STRINGS */

							String stateStr = ""; 
							String categoryStr = ""; 
							String ageStr = ""; 
							// STATE FILTER 
							if(state != null && !state.equals("ALL"))  
								stateStr = " AND users.state = \'" + state + "\'"; 
							//out.println(stateStr);	
							// CATEGORY FILTER 
							if(category != null && !category.equals("ALL"))  
								categoryStr = " AND categories.name = \'" + category + "\'"; 
							// AGE FILTER 
							if(age != null && !age.equals("ALL")) 
								ageStr = " AND users.age " + age;
							

							/*if(session.getAttribute("rowOff") != null && !session.getAttribute("rowOff").equals("0")) { 
								rowOff = Integer.parseInt(session.getAttribute("rowOff").toString()); 
								out.println(rowOff);
								rowOffNext = rowOff + 20; 
							} if(session.getAttribute("colOff") != null && !session.getAttribute("colOff").equals("0")) { 
								colOff = Integer.parseInt(session.getAttribute("colOff").toString()); 	
								out.println(colOff);
								colOffNext = colOff + 10; 
							}*/
							
							
							// PRODUCT NAMES (TOP ROW)
							//out.println("before query "+stateStr );
							
							//startProd = System.currentTimeMillis();

//							test1 = statement.executeQuery("CREATE INDEX sales_uid_index ON sales(uid)");

							rs = statement.executeQuery("SELECT p.name, p.id, sum(sales.quantity*sales.price) as amount FROM (select * from Products group by products.id order by products.name asc) as p inner join Sales on (sales.pid = p.id) inner join categories on (categories.id = p.cid) where 1=1" + categoryStr + " group by p.id, p.name order by p.name asc limit 10 offset " + colOff);
							endProd = System.currentTimeMillis();

							int rowCounter = 0;
							int colCounter = 0;
								while(rs.next()){ 	
									colCounter++;
									String pName = rs.getString("name");
									if (pName.length() > 10) {
										pName = pName.substring(0,10);
									}%>
									<th><%=pName%> ($<%=rs.getString("amount")%>)</th>
								<%}
								if (colCounter - 10 >= 0){%>
								<th>
									<form method= "POST">
		            					<% //session.setAttribute("colOff", colOff+10);
		            					//out.println(colOff);
		            					//out.println(session.getAttribute("colOff"));
		            					%>
		            					<input type="hidden" name="action" value="col">
		            					<input type="submit" value="Next 10">
                					</form> 
								</th>
								<%}%>
					</tr>
						<%
						// *** CUSTOMER *** NAMES (LEFT COLUMN)
						if(session.getAttribute("main") != null && session.getAttribute("main").equals("State")) {
							/*rs = statement.executeQuery("SELECT users.name, users.id, sum(sales.quantity * sales.price) as amount FROM users, sales where sales.uid = users.id group by users.id order by users.name asc limit 20 offset " + rowOff);*/
							//out.println("before query "+ categoryStr );
							//startCust = System.currentTimeMillis();
							rs = statement.executeQuery("SELECT u.state, SUM(sales.quantity * sales.price) AS amount FROM (select * from users where 1=1" + stateStr + ageStr + ") as u, sales inner join products on (sales.pid = products.id) inner join categories on (products.cid = categories.id) WHERE sales.uid = u.id" + categoryStr + " GROUP BY u.state ORDER BY u.state ASC LIMIT 20 offset "+ rowOff);
							endCust = System.currentTimeMillis();
								while(rs.next()){
								rowCounter++; 	
								%>
									<tr>
										<th><%=rs.getString("state")%> ($<%=rs.getString("amount")%>)</th>
										<%
										/*rs1 = statement.executeQuery("select products.id, sum(sales.quantity) as res from products, sales where sales.uid= "+ rs.getInt("users.id") +" and products.id = sales.pid group by products.id");*/
										/*rs1 = statement2.executeQuery("select sum(sales.quantity) as res from products cross join sales where sales.uid ="+ rs.getInt("id")+" and sales.pid = products.id group by sales.pid, products.id order by products.name asc");*/
								//		startTable = System.currentTimeMillis();
										rs1 = statement2.executeQuery("select result.res from ( (select p.id as id, p.name as name, sum(sales.quantity * p.price) as res from (select * from products group by products.id order by products.name asc) as p inner join sales on (sales.pid = p.id) inner join users on (sales.uid = users.id) inner join categories  on (p.cid = categories.id) where users.state = \'"+ rs.getString("state")+"\'" + ageStr + categoryStr + " group by p.id, p.name order by p.name asc) UNION (select products.id as id, products.name as name, 0 as res from products where products.id not in (select products.id from products, sales, users where sales.uid = users.id and users.state =\'"+ rs.getString("state")+"\' and products.id = sales.pid" + ageStr + " )) ) as result order by result.name asc limit 10 offset " + colOff);
										endTable = System.currentTimeMillis();
										 while(rs1.next()){
										%>
											<td><%=rs1.getString("res")%></td>
										<%}%>
									</tr>
								<%}
						}
						else{ //(main != null && main.equals("State")) {		// *** STATE *** NAMES (LEFT COLUMN)
							/*rs = statement.executeQuery("SELECT users.state, SUM(sales.quantity * sales.price) AS amount FROM users, sales, products WHERE sales.uid = users.id AND sales.pid = products.id GROUP BY users.state ORDER BY users.state ASC LIMIT 20 OFFSET " + rowOff);*/
							//out.println("before query "+ stateStr + categoryStr + ageStr + rowOff );
							//startCust = System.currentTimeMillis();
							rs = statement.executeQuery("SELECT u.name, u.id, sum(sales.quantity * sales.price) as amount FROM (select * from users where 1=1" + stateStr + ageStr + " group by users.id order by users.name) as u, sales inner join products on (sales.pid = products.id) inner join categories on (products.cid = categories.id) where sales.uid = u.id" + categoryStr + " group by u.id, u.name order by u.name limit 20 offset " + rowOff);
							/*rs = statement.executeQuery("SELECT users.name, users.id, sum(sales.quantity * sales.price) as amount FROM users, sales, categories, products where sales.uid = users.id " + stateStr + categoryStr + ageStr + " group by users.id order by users.name asc limit 20 offset " + rowOff);*/
							endCust = System.currentTimeMillis();
							
                        	while(rs.next()){
                        	rowCounter++; 	
							//	colCounter = 0;
								%>

								<tr>
									<th><%=rs.getString("name")%> ($<%=rs.getString("amount")%>)</th>
									<% // *********needs changing here :(
							//			startTable = System.currentTimeMillis();
										rs1 = statement2.executeQuery("select result.res from ( (select products.id as id, products.name as name, sum(sales.quantity * products.price) as res from products cross join sales where sales.uid ="+ rs.getInt("id")+" and sales.pid = products.id group by sales.pid, products.id order by products.name asc) UNION (select products.id as id, products.name as name, 0 as res from products where products.id not in (select products.id from products, sales where sales.uid = "+ rs.getInt("id")+" and products.id = sales.pid)) ) as result order by result.name asc limit 10 offset " + colOff);
										endTable = System.currentTimeMillis();
										while(rs1.next()){
							//				colCounter++; 
									%>
										<td><%=rs1.getString("res")%></td>
									<%}%>
								</tr>
							<%}
						}		//out.println("col count "+colCounter);
								if(rowCounter - 20 >= 0) {%>

								<th>
									<form method= "POST">
										<%// session.setAttribute("rowOff", rowOff+20);
										//out.println(rowOff);
										%>
										<input type="hidden" name="action" value="row">
		            					<input type="submit" value="Next 20">
                					</form> 
								</th>
								<%}%>
					</table>
					<%end = System.currentTimeMillis();%>
					<tr>
					
						<td>
						<h4>Execution Time</h4>
						</td>
						<td><h4>Time Taken (in ms)</h4>
						</td>
					</tr>
					 <tr> 
					 	<td>Products Header</td> 
					 	<td><%=(endProd-start)%></td> 
					 </tr> 
					 <tr> 
					 	<td>Customer/State Header</td> 
					 	<td><%=(endCust-endProd)%></td> 
					 </tr> 
					 <tr> 
					 	<td>Populating Charts</td> 
					 	<td><%=(endTable-endCust)%></td> 
					 </tr> 
					 <tr> 
					 	<td>Total Time</td> 
					 	<td><%=(endTable-start)%></td> 
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
	   }
            %>
		</table>

	</body>

</html>
