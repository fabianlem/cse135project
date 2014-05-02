<html>

<body>
<% if(session.getAttribute("username") == null) {
%>
<h2>You are not logged in!!!</h2>
<%
	response.setHeader("Refresh", "3; URL=login.jsp;"); 
	}
   else {
	String user = session.getAttribute("username").toString(); 
	%>
<h1>Welcome, <%=user%> </h1>
<h2>Categories</h2>
<%} %>
<table>
    <tr>
        <td>
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
			session.getAttribute("role").equals("Owner"))
		{
            %>
            
            <%-- -------- INSERT Code -------- --%>
            <%

	                String action = request.getParameter("action");
        	        // Check if an insertion is requested
                	if (action != null && action.equals("insert")) {
				String iName = request.getParameter("name");
				String iDescription = request.getParameter("description");
				if(iName == "")
				{			
	    %>
				    <h3>
					<font color="#ff0000">
					<%="Please enter a category name."%>
				    </h3>
	    <%
				}
				else if(iDescription == "")
				{
	    %>
				    <h3>
					<font color="#ff0000">
					<%="Please enter a description."%>
				    </h3>
	    <%
				}
				else
				{
				    boolean exist = false;
				    rs = statement.executeQuery("SELECT * FROM Categories WHERE name = \'" + iName + "\'");
				    while(rs.next())
				    {
					exist = true;
				    }

				    if(exist)
				    {
	    %>
				    	<h3>
						<font color="#ff0000">
						<%="" + iName + " already exists."%>
				    	</h3>
	    <%
				    }
				    else
				    {
			                    // Begin transaction
			       	            conn.setAutoCommit(false);

			                    // Create the prepared statement and use it to
		        	            // INSERT student values INTO the Categories table.
        		        	    pstmt = conn
	        		            .prepareStatement("INSERT INTO Categories (name, description, owner) VALUES (?, ?, ?)");

			                    pstmt.setString(1, request.getParameter("name"));
        			            pstmt.setString(2, request.getParameter("description"));
                			    pstmt.setString(3, (String)session.getAttribute("username"));
	                		    int rowCount = pstmt.executeUpdate();

			                    // Commit transaction
        			            conn.commit();
                			    conn.setAutoCommit(true);
					    response.sendRedirect("category.jsp");
				    }
				}
                	}
            %>
            
            <%-- -------- UPDATE Code -------- --%>
            <%
	                // Check if an update is requested
        	        if (action != null && action.equals("update")) {
			    String uName = request.getParameter("name");
			    String uDescription = request.getParameter("description");
			    if(uName == "")
			    {			
	    %>
				<h3>
				    <font color="#ff0000">
				    <%="Update failed. No category name was provided."%>
				</h3>
	    <%
			    }
			    else if(uDescription == "")
			    {
	    %>
				<h3>
				    <font color="#ff0000">
				    <%="Update failed. No description was provided."%>
				</h3>
	    <%
			    }
			    else
			    {
				boolean exist = false;
				if(!request.getParameter("prev").equals(uName))
				{
					rs = statement.executeQuery("SELECT * FROM Categories WHERE name = \'" + uName + "\'");
					while(rs.next())
					{
				    		exist = true;
					}
				}
			    	if(!exist)
			    	{
					if(!request.getParameter("name").equals(uName))
					{
	    %>
				    	<h3>
						<font color="#ff0000">
						<%="Update failed. Category has been updated."%>
				    	</h3>
	    <%
					}
					else if (!request.getParameter("description").equals(uDescription))
					{
	    %>
				    	<h3>
						<font color="#ff0000">
						<%="Update failed. Category has been updated."%>
				    	</h3>
	    <%
					}
					else
					{
		                    		// Begin transaction
		        	            	conn.setAutoCommit(false);

			                    	// Create the prepared statement and use it to
        			            	// UPDATE student values in the Students table.
                			    	pstmt = conn
                        				.prepareStatement("UPDATE Categories SET name = ?, description = ? WHERE name = ?");

			                    	pstmt.setString(1, uName);
        			            	pstmt.setString(2, uDescription);
                			    	pstmt.setString(3, request.getParameter("prev"));
	                		    	int rowCount = pstmt.executeUpdate();

			                    	// Commit transaction
        			            	conn.commit();
                			    	conn.setAutoCommit(true);
					    	out.println("Successfully updated.");
					}
				}
				else
				{
	    %>
				    	<h3>
						<font color="#ff0000">
						<%="Update failed. " + uName + " already exists."%>
				    	</h3>
	    <%
				}
			    }
                	}
            %>
            
            <%-- -------- DELETE Code -------- --%>
            <%
	                // Check if a delete is requested
        	        if (action != null && action.equals("delete")) {
			    String dName = request.getParameter("name");
			    String dDescription = request.getParameter("description");
			    boolean exist = false;
			    rs = statement.executeQuery("SELECT * FROM Products WHERE category = \'" + dName + "\'");
			    while(rs.next())
			    {
				exist = true;
			    }

			    if(exist)
			    {
	    %>
			    	<h3>
					<font color="#ff0000">
					<%="Unable to delete. Category has products associated with it."%>
			    	</h3>
	    <%
			    }
			    else
			    {
				if(!request.getParameter("name").equals(dName))
				{
	    %>
			    	<h3>
					<font color="#ff0000">
					<%="Unable to delete. Category has been updated."%>
			    	</h3>
	    <%
				}
				else if(!request.getParameter("description").equals(dDescription))
				{
	    %>
			    	<h3>
					<font color="#ff0000">
					<%="Unable to delete. Category has been updated."%>
			    	</h3>
	    <%
				}
				else
				{
		                    // Begin transaction
        		            conn.setAutoCommit(false);

		                    // Create the prepared statement and use it to
        		            // DELETE students FROM the Students table.
                		    pstmt = conn
                        	    .prepareStatement("DELETE FROM Categories WHERE name = ?");

		                    pstmt.setString(1, dName);
        		            int rowCount = pstmt.executeUpdate();

		                    // Commit transaction
        		            conn.commit();
                		    conn.setAutoCommit(true);
				}
			    }
                	}
            %>
            
            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
                <th>Owner</th>
                <th>Name</th>
                <th>Description</th>
            </tr>

            <tr>
                <form action="category.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th>&nbsp;</th>
                    <th><input value="" name="name" size="15"/></th>
                    <th><input value="" name="description" size="25"/></th>
                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
      	        	// Use the created statement to SELECT
               		// the student attributes FROM the Student table.
               		rs = statement.executeQuery("SELECT owner, Categories.name as name, description, COUNT(Products.name) as products FROM Categories LEFT OUTER JOIN Products ON Products.category = Categories.name GROUP BY Categories.name");

	                // Iterate over the ResultSet
        	        while (rs.next()) {
            %>

            <tr>
                <form action="category.jsp" method="POST">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="prev" value="<%=rs.getString("name")%>"/>

                <%-- Get the owner --%>
                <td>
                    <%=rs.getString("owner")%>
                </td>

                <%-- Get the name --%>
                <td>
                    <input value="<%=rs.getString("name")%>" name="name" size="15"/>
                </td>

                <%-- Get the description --%>
                <td>
                    <input value="<%=rs.getString("description")%>" name="description" size="25"/>
                </td>

                <%-- Button --%>
                <td><input type="submit" value="Update"></td>
		</form>
	    <%
		if(rs.getInt("products") == 0)
		{
	    %>
		<form action="category.jsp" method="POST">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" value="<%=rs.getString("name")%>" name="name"/>
		    <input type="hidden" value="<%=rs.getString("description")%>" name="description"/>
                    <%-- Button --%>
                <td><input type="submit" value="Delete"/></td>
                </form>
	    <%
		}
	    %>
            </tr>

            <%
			}
    	        	// Close the ResultSet
                	rs.close();
                }
		else
		{
	    %>
			<h2>You are not an Owner!!!</h2>
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
        </table>
        </td>
    </tr>
</table>
</body>

</html>