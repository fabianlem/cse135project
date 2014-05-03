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

%>



<h1>Welcome, <%=user%> </h1>
<%} %>

 <% int productSKU = Integer.parseInt(session.getAttribute("psku").toString()); %> 
<table>
    <tr>
        <td>
<h2>Product Order</h2>
            <%-- Import the java.sql package --%>`
            <%@ page import="java.sql.*"%>
            <%@ page import="java.math.*"%>
            <%-- -------- Open Connection Code -------- --%>
            <%



 			out.println("The items have been successfully added to your cart!"); 
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
            

            <%-- -------- SELECT Statement Code for SHOPPING CART-------- --%>
            <%
		
		
		if(session.getAttribute("username") != null && 
			session.getAttribute("role").equals("Customer"))
		{            
            
                // Create the statement
                Statement statement = conn.createStatement();
				// Use the created statement to SELECT
                // the attributes FROM the Cart table.
                rs = statement.executeQuery("SELECT Products.name, Cart.quantity, Products.price FROM Cart, Products WHERE Cart.product = Products.sku AND Cart.customer = \'" +  session.getAttribute("username").toString() + "\'");
            %>
            
            <!-- Add an HTML table header row to format the results -->

            <table border="1">
            <tr>
                <th>Name</th>
                <th>Quantity</th>
                <th>Price</th>
            </tr>


<h4>Currently in your cart:</h4>
            <%-- -------- Iteration Code for SHOPPING CART-------- --%>
            <%
                // Iterate over the ResultSet
				Double total = 0.0;
                while (rs.next()) {
            %>

            <tr>
                <form action="productorder2.jsp" method="POST">
                    <td>
                	<!-- input type="hidden" name="action" value="update"/--> 
                	<%=rs.getString("name")%> <%-- get customer --%> 
                	</td>
                	<%int quant = rs.getInt("quantity");%> 
                	<td> <%-- get quantity --%> 
                	<%=quant%> 
                	</td> 
                	<%Double cost = (rs.getDouble("price")*quant); //-- get prices --
                	total += cost; %> 
                	<td> <%=cost%> 
                	</td> 
                </form>
            </tr>
            <%
                }
            %>
<br>
			<tr>
			<FORM action="productorder2.jsp" method ="post"> 

			<TABLE WIDTH="75%" >
         		<TR>
         		<TH>
					<br>Your total so far is updated to: $<%=total%> 
          		</TH>
          		</TR>
      		</FORM>
   			</TABLE>
			</tr>
			
			<%
					response.setHeader("Refresh", "3; URL=productbrowsing.jsp;");

			
		}
		else
		{
	    %>
			<h2>You are not an Customer!!!</h2>
	    <%
			response.setHeader("Refresh", "3; URL=category.jsp;");
		} 
		%>
            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                //rs.close();

                // Close the Statement
                //statement.close();

                // Close the Connection
                //conn.close();
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
				/*if (rs1 != null) {
                    try {
                        rs1.close();
                    } catch (SQLException e) { } // Ignore
                    rs1 = null;
                }
                if (rs2 != null) {
                    try {
                        rs2.close();
                    } catch (SQLException e) { } // Ignore
                    rs2 = null;
                }*/
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