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
<h2>Products</h2>
<%} %>
<form action="category.jsp" method="POST">
    <input type="submit" name="categories" value="Categories"/>
</form>
<table>
<tr>
        <td>
            <%-- -------- Include menu HTML code -------- --%>
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

                    String action = request.getParameter("action");
                    // Check if an order is requested
                    
            
                    if (action != null && action.equals("search")) {
                        if(request.getParameter("category") != null)
                            response.sendRedirect("products.jsp?category=" + request.getParameter("category") + "&search=" + request.getParameter("query"));
                        else
                            response.sendRedirect("products.jsp?search=" + request.getParameter("query"));
                            }
                    

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

                    rs = statement.executeQuery("SELECT * FROM categories");


                    while(rs.next()){
                    	String catName = rs.getString("name");
                    %>
                    <tr>
                    	<td>
                    		<a href="products.jsp?category=<%=rs.getString("name")%>"><%=rs.getString("name")%></a>
                    	</td>
                    </tr>
                    <%
                    }
                    %>
                </table>
        </td>
    
        <td>
            <%-- Import the java.sql package --%>
         
            <%@ page import="java.math.*"%>
            <%-- -------- Open Connection Code -------- --%>
            <%
            
     //        Connection conn = null;
     //        PreparedStatement pstmt = null;
	    // Statement stmt = null;
     //        ResultSet rs = null;
            
     //        try {
                // Registering Postgresql JDBC driver with the DriverManager
                //Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                //conn = DriverManager.getConnection(
                  //  "jdbc:postgresql://localhost/cse135", "postgres", "postgres");
	    %>
            <%-- -------- SELECT Statement Code -------- --%>
            <%
	        // Create the statement
        	//Statement statement = conn.createStatement();
	
      	        // Use the created statement to SELECT
               	// the student attributes FROM the Student table.
               	rs = statement.executeQuery("SELECT * FROM products");

		if(session.getAttribute("username") != null && session.getAttribute("role").equals("Owner"))
		{
            %>
            
            <%-- -------- INSERT Code -------- --%>
            <%

	                //String action = request.getParameter("action");
        	        // Check if an insertion is requested
                    int insertion = 0;
                    if (action != null && action.equals("insert")) {
                String iName = request.getParameter("name");
                String iSKU = request.getParameter("sku");
                String iPrice = request.getParameter("price");
                	//if (action != null && action.equals("insert")) {
                        if(iName == "")
                {           
        %>
                    <h3>
                    <font color="#ff0000">
                    <%="Please enter a category name."%>
                    </h3>
        <%
                }
                else if(iSKU == "")
                {
        %>
                    <h3>
                    <font color="#ff0000">
                    <%="Please enter a SKU."%>
                    </h3>
        <%
                }
                else if(iPrice == "")
                {
        %>
                    <h3>
                    <font color="#ff0000">
                    <%="Please enter a Price."%>
                    </h3>
        <%
                }
                else
                {
                    boolean exist = false;
                    rs = statement.executeQuery("SELECT * FROM Products WHERE sku = " + Integer.parseInt(iSKU));
                    while(rs.next())
                    {
                    exist = true;
                    }

                    if(exist)
                    {
        %>
                        <h3>
                        <font color="#ff0000">
                        <%="" + iSKU + " already exists."%>
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
	                    .prepareStatement("INSERT INTO products (name, sku, category, price) VALUES (?, ?, ?, ?)");


	                    pstmt.setString(1, request.getParameter("name"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("sku")));
                        pstmt.setString(3, request.getParameter("category2"));
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
                        response.sendRedirect("products.jsp");
                	}
                }
            }

            %>
            
            <%-- -------- UPDATE Code -------- --%>
            <%
	                // Check if an update is requested
        	        if (action != null && action.equals("update")) {
                            String uName = request.getParameter("name");
                            String uSKU = request.getParameter("sku");
                            String uPrice = request.getParameter("price");
                            if(uName == "")
                            {           
                    %>
                            <h3>
                                <font color="#ff0000">
                                <%="Update failed. No category name was provided."%>
                            </h3>
                    <%
                            }
                            else if(uSKU == "")
                            {
                    %>
                            <h3>
                                <font color="#ff0000">
                                <%="Update failed. No SKU was provided."%>
                            </h3>
                    <%
                            }
                            else if(uPrice == "")
                            {
                    %>
                            <h3>
                                <font color="#ff0000">
                                <%="Update failed. No price was provided."%>
                            </h3>
                    <%
                            }
                            else
                            {
                            boolean exist = false;
                            if(!request.getParameter("prev").equals(uSKU))
                            {
                                rs = statement.executeQuery("SELECT * FROM Products WHERE sku =" + Integer.parseInt(uSKU));
                                while(rs.next())
                                {
                                        exist = true;
                                }
                            }
                                if(!exist)
                                {    
        	                    // Begin transaction
                	            conn.setAutoCommit(false);

        	                    // Create the prepared statement and use it to
                	            // UPDATE student values in the Students table.
                        	    pstmt = conn
                                	.prepareStatement("UPDATE products SET name = ?, sku = ?, category = ?, price = ? WHERE sku = ?");

        	                    pstmt.setString(1, request.getParameter("name"));
                	            pstmt.setInt(2, Integer.parseInt(uSKU));
                        	    pstmt.setString(3, request.getParameter("category2"));
                                pstmt.setObject(4, new BigDecimal(Double.parseDouble(uPrice.substring(1))));
                                pstmt.setInt(5, Integer.parseInt(request.getParameter("prev")));
                                out.println(request.getParameter("prev"));
        	                    int rowCount = pstmt.executeUpdate();

        	                    // Commit transaction
                	            conn.commit();
                        	    conn.setAutoCommit(true);
                        	}
                 }  
                 } 
                
                
                    
            %>
            
            <%-- -------- DELETE Code -------- --%>
            <%
	                // Check if a delete is requested
        	        if (action != null && action.equals("delete")) {

	                    // Begin transaction
        	            conn.setAutoCommit(false);

                        rs = statement.executeQuery("select * from cart inner join products on cart.product=products.sku where products.sku=" + Integer.parseInt(request.getParameter("sku")));
                        boolean delFlag = false;
                        while(rs.next()){
                            delFlag = true;
                        }

                        if(!delFlag){
       	                    // Create the prepared statement and use it to
            	            // DELETE students FROM the Students table.
                    	    pstmt = conn
                            	.prepareStatement("DELETE FROM products WHERE sku = ?");

    	                    pstmt.setInt(1, Integer.parseInt(request.getParameter("sku")));
            	            int rowCount = pstmt.executeUpdate();

    	                    // Commit transaction
            	            conn.commit();
                    	    conn.setAutoCommit(true);
                        }else{
                    %>
                            <h3>
                                <font color="#ff0000">
                                <%="Deletion failed. Product in customers cart."%>
                            </h3>
                    <%
                            }

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
                    <th>    
                    <%
                    //Statement statement = conn.createStatement();
    
                // Use the created statement to SELECT
                // the student attributes FROM the Student table.
                    rs = statement.executeQuery("SELECT * FROM Categories");
                    Vector<String> categories = new Vector<String>();

                    %>
                        <!--jsp:rs id="obj" class="store.ListBean" scope="page"/-->

                        <select NAME="category2">
                            <% while(rs.next()){ 
                                categories.add(rs.getString("name"));%>
                            
                             <option> <%=rs.getString("name")%></option>
                            
                            <%}
                            %>
                        </select>
                    </th>
                    <!-- th><input value="" name="category" size="25"/></th -->
                    <th><input value="" name="price" size="25"/></th>
                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%

	                // Iterate over the ResultSet
                    //rs = statement.executeQuery("SELECT * FROM products");
                    if(request.getParameter("category") != null && request.getParameter("search") != null)
                        rs = statement.executeQuery("SELECT * FROM Products WHERE category = \'" + request.getParameter("category") + "\' AND name LIKE \'%" + request.getParameter("search") + "%\'");
                    else if(request.getParameter("search") != null)
                        rs = statement.executeQuery("SELECT * FROM Products WHERE name LIKE \'%" + request.getParameter("search") + "%\'");
                    else if(request.getParameter("category") != null)
                        rs = statement.executeQuery("SELECT * FROM Products WHERE category = \'" + request.getParameter("category") + "\'");
                    else
                        rs = statement.executeQuery("SELECT * FROM Products");
        	        while (rs.next()) {
            %>

            <tr>
                <form action="products.jsp" method="POST">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="prev" value="<%=rs.getString("sku")%>"/>


                <%-- Get the owner --%>
                <td>
                    <%--=rs.getString("")--%>
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
                
                    <select NAME="category2">
                           <% 
                           int i = 0;
                           String hold = rs.getString("category");
                           while(i < categories.size()) { 
                           //out.println(rs.getString("category")); 
                            if(hold.equals(categories.get(i))){%>
                                <option selected> <%=categories.get(i)%></option>
                            <%}else{%>
                                <option><%=categories.get(i)%></option>
                        <%} i++;
                        }%>
                    </select>
                  
                    <!--input value="<%=rs.getString("category")%>" name="category" size="25"/-->
                </td>

                <%-- Get the price --%>
                <td>
                    <input value="<%=rs.getString("price")%>" name="price" size="25"/>
                </td>

                <%-- Button --%>
                <td><input type="submit" value="update"></td>
                </form>
                
                <form action="products.jsp" method="POST">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" value="<%=rs.getString("sku")%>" name="sku"/>
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
    </tr>
</table>
</body>

</html>