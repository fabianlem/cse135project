<html>

<body>
<% if(session.getAttribute("username") == null)
		out.print("<a href='login.jsp'>Log in</a>");
	else{
 		String user = session.getAttribute("username").toString(); %>

<h1>Welcome, <%=user%> </h1>
<%} %>
<h2>Confirmation</h2>
<h3>Thank you for your purchase! Here are the items you have purchased:</h3>
<table>
    <tr>
        <td>
            <%-- Import the java.sql package --%>
            <%@ page import="java.sql.*"%>
            <%-- -------- Open Connection Code -------- --%>
            <%
            
            Connection conn = null;
            PreparedStatement pstmt = null;
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
                // the student attributes FROM the Cart table.
                //rs = statement.executeQuery("SELECT Cart.product, Products.price, Cart.quantity FROM Cart, Products WHERE Cart.product = Products.name");
                rs = statement.executeQuery("SELECT Products.name, Cart.quantity, Products.price FROM Cart, Products WHERE Cart.product = Products.sku");
            %>
            
            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
                <th>Name</th>
                <th>Quantity</th>
                <th>Price</th>
            </tr>

 <!--           <tr>
                <form action="category.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th>&nbsp;</th>
                    <th><input value="" name="name" size="15"/></th>
                    <th><input value="" name="description" size="25"/></th>
                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>
-->
            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
				Double total = 0.0;
                while (rs.next()) {
            %>

            <tr>

                <form action="confirmation.jsp" method="POST"> 
                	<td>
                	<!--input type="hidden" name="action" value="update"/--> 
                	<%=rs.getString("name")%> <%-- get customer --%>
                	</td> 
                	<%int quant = rs.getInt("quantity");%> 
                	
                	<td> <%-- get quantity --%> 
                	<%=quant%> 
                	</td> 
                	<%Double cost = (rs.getDouble("price")*quant); //<%--get prices --
                	 
                	total += cost; %> 
                	<td> <%=cost%> 
                	</td> 
                </form>
            </tr>
				
		
  			  <%
            }
            %>
            <TABLE WIDTH="70%" >
         		<TR>
					<TH>Thank you for your payment of $ <%=total%> </TH>
</TR>
   			</TABLE>
			
          

            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                rs.close();

                // Close the Statement
                statement.close();

                // Close the Connection
                conn.close();
            } catch (SQLException e) {

                // Wrap the SQL exception in a runtime exception to propagate
                // it upwards
                //throw new RuntimeException(e);
                out.print(e.getMessage());
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


    <FORM action="category.jsp" method ="post">
    	<TD width="50%"><INPUT TYPE="submit" value="More shopping!"></TD>
    </FORM>


</body>

</html>