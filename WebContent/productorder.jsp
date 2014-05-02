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



 <% //int productSKU = session.getAttribute("psku"); %> 
<h1>Welcome, <%=user%> </h1>
<%} %>
<table>
    <tr>
        <td>
<h2>Product Order</h2>
            <%-- Import the java.sql package --%>`
            <%@ page import="java.sql.*"%>
            <%@ page import="java.math.*"%>
            <%-- -------- Open Connection Code -------- --%>
            <%
			
int productSKU = 1679;

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
            
			
			
			
			
			
						
			<%-- -------- SELECT Statement Code of the product chosen in productbrowsing.jsp-------- --%>
            <%
                // Create the statement
                Statement statement2 = conn.createStatement();

                // Use the created statement to SELECT
                // the student attributes FROM the Cart table.
                rs = statement2.executeQuery("SELECT Products.name, Products.price FROM Products WHERE Products.sku = " + productSKU);
            %>
            
            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
                <th>Name</th>
                <th>Price</th>
            </tr>


            <%-- -------- Iteration Code - display the product chosen in productbrowsing.jsp -------- --%>
            <%
                // Iterate over the ResultSet
				String productName = null;
				Double productPrice = 0.0;
                while (rs.next()) {
            %>

            <tr>

                <form action="productorder.jsp" method="POST">
                    <td>
                	<!-- input type="hidden" name="action" value="update"/--> 
					
                	<%
						productName = rs.getString("name");
						productPrice = rs.getDouble("price");
					%> 
					<%=productName%>
                	</td>
					<td>
                	<%=productPrice%>
                	</td> 
                </form>
            </tr>
			
            <%}%>
			
			
			<FORM action="productorder.jsp" method ="post"> 
			<input type="hidden" name="action" value="submit"/>
			<TABLE style="background-color: #ECE5B6;" WIDTH="30%" >
         		<TR>
					<TH width="50%">How many of these items would you like to purchase?</TH>
							      	<TR>
		            <TD width="50%"><INPUT value="" NAME="quantity" size=15></TD>
		        </TR>
          		</TR>
      		      	<TR>
              		<TH></TH>
                  	<TD width="50%"><INPUT TYPE="submit" NAME="submit"></TD>
          		</TR>
			</form>
			
			
			<%
            String action = request.getParameter("action");

				//String quantStr = session.getAttribute("quantity");//.toString();
       	        if (action != null && action.equals("submit")) {

                String quantStr = request.getParameter("quantity");
                out.println(quantStr);
                //int buyQuant= Integer.parseInt(quantStr); 
			
				Statement statement3 = conn.createStatement();
                Statement statement4 = conn.createStatement();
				ResultSet rs1 = null;
				ResultSet rs2 = null;
			
				
                // Use the created statement to UPDATE quantity of the Cart table.
				rs1 = statement3.executeQuery("SELECT product FROM Cart WHERE product = " + productSKU);
				if(rs1.next()) {		// product already exists in cart - would UPDATE ONLY quantity
					rs2 = statement4.executeQuery("UPDATE Cart SET quantity = (" + Integer.parseInt(quantStr) + " + (SELECT quantity FROM Cart WHERE product = "+ productSKU + ")) WHERE Cart.product = " + productSKU);
				
					conn.commit();
					conn.setAutoCommit(true);
				
					//if(updateQuery != 0){ 
						// should be product browsing
						//response.sendRedirect("signup2.jsp");
						out.println("go back to browsing");
 
					//} else{
					//}
				}
				else {	// product does not already exist in cart - add into cart
					//rs2 = statement4.executeQuery( );
					pstmt = conn.prepareStatement("INSERT INTO Cart (product, quantity, customer) VALUES (?, ?, ?)");
                    pstmt.setInt(1, productSKU);
                    pstmt.setInt(2, Integer.parseInt(quantStr));
                    pstmt.setString(3, session.getAttribute("username").toString());
					int updateQuery = 0;
					updateQuery = pstmt.executeUpdate();
					conn.commit();
					conn.setAutoCommit(true);
				
					if(updateQuery != 0){ 
						// should be product browsing
						out.println("Inserted to Shopping Cart");
					//	response.sendRedirect("signup2.jsp");	
 
					} else{
					}
				}
       	        
       	        }				
			%>

			
			

            <%-- -------- SELECT Statement Code for SHOPPING CART-------- --%>
            <%
                // Create the statement
                Statement statement = conn.createStatement();

                // Use the created statement to SELECT
                // the attributes FROM the Cart table.
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
            <%-- -------- Iteration Code for SHOPPING CART-------- --%>
            <%
                // Iterate over the ResultSet
				Double total = 0.0;
                while (rs.next()) {
            %>

            <tr>

                <form action="productorder.jsp" method="POST">
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


			<tr>
			<FORM action="productorder.jsp" method ="post"> 

			<TABLE style="background-color: #ECE5B6;" WIDTH="30%" >
         		<TR>
					<TH width="50%">Your total so far is: <%=total%> </TH>
          		</TR>
      
		      	<TR>
              		<TH></TH>
                  	<TD width="50%"><INPUT TYPE="submit" NAME="submit"></TD>
          		</TR>

			</FORM>
   			

   			</TABLE>
			</tr>
            <%
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