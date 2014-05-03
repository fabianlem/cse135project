<html>

<body>
<% if(session.getAttribute("username") == null) {
%>
<h2>You are not logged in!!!</h2>
<%
	// <a href="login.jsp">log in</a>
	response.setHeader("Refresh", "3; URL=login.jsp;"); 
	}
   else {
	String user = session.getAttribute("username").toString(); 
	%>
<h1>Welcome, <%=user%> </h1>
<h2>Products</h2>
<%} %>
<table>
    <tr>
            <%-- Import the java.sql package --%>
            <%@ page import="java.sql.*"%>
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


		if(session.getAttribute("username") != null && 
			session.getAttribute("role").equals("Customer"))
		{
            %>
            
            <%-- -------- order Code -------- --%>
            <%

	                String action = request.getParameter("action");
        	        // Check if an order is requested
                	if (action != null && action.equals("order")) {
				session.setAttribute("psku", request.getParameter("SKU"));
				response.sendRedirect("productorder.jsp");
                	}
            
                	if (action != null && action.equals("search")) {
        				if(request.getParameter("category") != null)
        					response.sendRedirect("productbrowsing.jsp?category=" + request.getParameter("category") + "&search=" + request.getParameter("query"));
        				else
        					response.sendRedirect("productbrowsing.jsp?search=" + request.getParameter("query"));
                        	}
                	
			rs = statement.executeQuery("SELECT * FROM Categories");
            %>
            
	    <td>
		<table>
			<tr>
				<form method="POST">
				<input type="hidden" name="action" value="search"/>
				<td>
                    <input value="" name="query" size="15"/>
                </td>
                <%-- Button --%>
                <td><input type="submit" value="search"></td>
                </form>
			</tr>
	    <%
        	        while (rs.next()) {
	    %>
            	  <tr>
			<td>
				<a href="productbrowsing.jsp?category=<%=rs.getString("name")%>"><%=rs.getString("name")%></a>
			</td>
            	  </tr>
	    <%
			}
	    %>
		</table>
	    </td>

	    <td>
            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
                <th>SKU</th>
                <th>Name</th>
                <th>Price</th>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
      	        	// Use the created statement to SELECT
               		// the student attributes FROM the Student table.
               		if(request.getParameter("category") != null && request.getParameter("search") != null)
               			rs = statement.executeQuery("SELECT * FROM Products WHERE category = \'" + request.getParameter("category") + "\' AND name LIKE \'%" + request.getParameter("search") + "%\'");
               		else if(request.getParameter("search") != null)
               			rs = statement.executeQuery("SELECT * FROM Products WHERE name LIKE \'%" + request.getParameter("search") + "%\'");
               		else if(request.getParameter("category") != null)
               			rs = statement.executeQuery("SELECT * FROM Products WHERE category = \'" + request.getParameter("category") + "\'");
               		else
               			rs = statement.executeQuery("SELECT * FROM Products");
	                // Iterate over the ResultSet
        	        while (rs.next()) {
            %>

            <tr>
                <form action="productbrowsing.jsp" method="POST">
                    <input type="hidden" name="action" value="order"/>
                    <input type="hidden" name="product" value="<%=rs.getString("name")%>"/>

                <%-- Get the SKU --%>
                <td>
                    <input readonly value="<%=rs.getInt("SKU")%>" name="SKU" size="15"/>
                </td>

                <%-- Get the name --%>
                <td>
                    <input readonly value="<%=rs.getString("name")%>" name="name" size="15"/>
                </td>

                <%-- Get the price --%>
                <td>
                    <input readonly value="<%=rs.getDouble("price")%>" name="price" size="15"/>
                </td>

                <%-- Button --%>
                <td><input type="submit" value="order"></td>
		</form>
            </tr>
            <%
			}
    	        	// Close the ResultSet
                	rs.close();
                }
		else
		{
	    %>
			<h2>You are not a Customer!!!</h2>
	    <%
			response.setHeader("Refresh", "3; URL=products.jsp;");
		} 
            %>

            <%-- -------- Close Connection Code -------- --%>
            <%

               	// Close the Statement
       	        statement.close();

	        // Close the Connection
                conn.close();

            } catch (SQLException e) {

                // Wrap the SQL exception in a runtime exception to propagate
                // it upwards
                //throw new RuntimeException(e);
		out.println(e.getMessage());
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
            <tr>
            <form action="shoppingcart.jsp" method="POST">
				<input type="submit" value="My shopping cart">
			</form>
			</tr>
        </table>
	</td>
    </tr>
</table>
</body>

</html>