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
<h2>Products</h2>
<%} %>
<table>
    <tr>
        <td>
            <%-- Import the java.sql package --%>
            <%@ page import="java.sql.*"%>
            <%@ page import="java.math.*"%>
            <%-- -------- Open Connection Code -------- --%>
            <%
            
            Connection conn = null;
            PreparedStatement pstmt = null;
	    Statement stmt = null;
            ResultSet rs = null;
            
            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/cse135", "postgres", "postgres");
	    %>
            <%-- -------- SELECT Statement Code -------- --%>
            <%
	        // Create the statement
        	Statement statement = conn.createStatement();
	
      	        // Use the created statement to SELECT
               	// the student attributes FROM the Student table.
               	rs = statement.executeQuery("SELECT * FROM products");

		if(session.getAttribute("username") != null && 
			session.getAttribute("role").equals("Owner"))
		{
            %>
            
            <%-- -------- INSERT Code -------- --%>
            <%

	                String action = request.getParameter("action");
        	        // Check if an insertion is requested
                    int insertion = 0;
                	if (action != null && action.equals("insert")) {

	                    // Begin transaction
        	            conn.setAutoCommit(false);

	                    // Create the prepared statement and use it to
        	            // INSERT student values INTO the Categories table.
                	    pstmt = conn
	                    .prepareStatement("INSERT INTO products (name, sku, category, price) VALUES (?, ?, ?, ?)");


	                    pstmt.setString(1, request.getParameter("name"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("sku")));
                        pstmt.setString(3, request.getParameter("category"));
                        pstmt.setObject(4, new BigDecimal(request.getParameter("price")));
	                    insertion = pstmt.executeUpdate();

	                    // Commit transaction
        	            conn.commit();
                	    conn.setAutoCommit(true);
                        if(insertion != 0){ 
                            out.println("Successful input");
                            //Owner or Customer
                            //response.sendRedirect("signup2.jsp");   
 
                        }
                	}
            %>
            
            <%-- -------- UPDATE Code -------- --%>
            <%
	                // Check if an update is requested
        	        if (action != null && action.equals("update")) {

	                    // Begin transaction
        	            conn.setAutoCommit(false);

	                    // Create the prepared statement and use it to
        	            // UPDATE student values in the Students table.
                	    pstmt = conn
                        	.prepareStatement("UPDATE products SET name = ?, sku = ?, "
	                            + "category = ?, price = ?");

	                    pstmt.setString(1, request.getParameter("name"));
        	            pstmt.setInt(2, Integer.parseInt(request.getParameter("sku")));
                	    pstmt.setString(3, request.getParameter("category"));
                        pstmt.setDouble(4, Double.parseDouble(request.getParameter("price")));
	                    int rowCount = pstmt.executeUpdate();

	                    // Commit transaction
        	            conn.commit();
                	    conn.setAutoCommit(true);
                	}
            %>
            
            <%-- -------- DELETE Code -------- --%>
            <%
	                // Check if a delete is requested
        	        if (action != null && action.equals("delete")) {

	                    // Begin transaction
        	            conn.setAutoCommit(false);

	                    // Create the prepared statement and use it to
        	            // DELETE students FROM the Students table.
                	    pstmt = conn
                        	.prepareStatement("DELETE FROM products WHERE name = ?");

	                    pstmt.setString(1, request.getParameter("name"));
        	            int rowCount = pstmt.executeUpdate();

	                    // Commit transaction
        	            conn.commit();
                	    conn.setAutoCommit(true);
                	}
            %>
            
            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
                <th>Owner</th>
                <th>Name</th>
                <th>SKU</th>
                <th>Category</th>
                <th>Price</th>

            </tr>

            <tr>
                <form action="products.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th>&nbsp;</th>
                    <th><input value="" name="name" size="15"/></th>
                    <th><input value="" name="sku" size="25"/></th>
                    <th><input value="" name="category" size="25"/></th>
                    <th><input value="" name="price" size="25"/></th>
                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
	                // Iterate over the ResultSet
        	        while (rs.next()) {
            %>

            <tr>
                <form action="products.jsp" method="POST">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="owner" value="<%=rs.getString("name")%>"/>

                <%-- Get the owner --%>
                <td>
                    <%--=rs.getString("name")--%>
                </td>

                <%-- Get the name --%>
                <td>
                    <input value="<%=rs.getString("name")%>" name="name" size="15"/>
                </td>

                <%-- Get the sku --%>
                <td>
                    <input value="<%=rs.getString("sku")%>" name="sku" size="25"/>
                </td>

                <%-- Get the category --%>
                <td>
                    <input value="<%=rs.getString("category")%>" name="category" size="25"/>
                </td>

                <%-- Get the price --%>
                <td>
                    <input value="<%=rs.getString("price")%>" name="price" size="25"/>
                </td>

                <%-- Button --%>
                <td><input type="submit" value="Update"></td>
                </form>
                
                <form action="products.jsp" method="POST">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" value="<%=rs.getString("name")%>" name="name"/>
                    <%-- Button --%>
                <td><input type="submit" value="Delete"/></td>
               
                </form>
            </tr>

            <%
			}
                }
            %>

            <%-- -------- Close Connection Code -------- --%>
            <%
       	        // Close the ResultSet
                //rs.close();

               	// Close the Statement
       	        //statement.close();
	
	        // Close the Connection
               // conn.close();

            } catch (SQLException e) {

                // Wrap the SQL exception in a runtime exception to propagate
                // it upwards
                //throw new RuntimeException(e);
                //out.println(e.getMessage());
                out.println("Failure to insert new product");
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
        </td>
    </tr>
</table>
</body>

</html>