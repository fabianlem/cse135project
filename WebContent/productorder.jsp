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
            <%-- Import the java.sql package --%>
            <%@ page import="java.sql.*"%>
            <%@ page import="java.math.*"%>
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
            






			<%-- -------- SELECT Statement Code of the product chosen in productbrowsing.jsp-------- --%>
            <%
			
		if(session.getAttribute("username") != null && 
			session.getAttribute("role").equals("Customer"))
		{   
		
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
         		<TR><br>
					<TH width="50%">How many of these items would you like to add to your cart?</TH>
							      	<TR>
		            <TD width="50%"><INPUT value="" NAME="quantity" size=15></TD>
		        </TR>
          		</TR>
      		      	<TR>
              		<TH></TH>
                  	<TD width="50%"><INPUT TYPE="submit" value="Add to cart"></TD>
          		</TR>
			</form>


			<%
            String action = request.getParameter("action");

				//String quantStr = session.getAttribute("quantity");//.toString();
       	        if (action != null && action.equals("submit")) {

                String quantStr = request.getParameter("quantity");
                out.println(quantStr + " item(s) successfully added to your cart!");
                //int buyQuant= Integer.parseInt(quantStr); 

				Statement statement3 = conn.createStatement();
                Statement statement4 = conn.createStatement();
				ResultSet rs1 = null;
				ResultSet rs2 = null;


                // Use the created statement to UPDATE quantity of the Cart table.
				rs1 = statement3.executeQuery("SELECT product AS Product FROM Cart WHERE product = " + productSKU + "AND Cart.customer = \'" + session.getAttribute("username").toString() + "\'");
				if(rs1.next()) {		// product already exists in cart - would UPDATE ONLY quantity
					rs2 = statement4.executeQuery("UPDATE Cart SET quantity = (" + Integer.parseInt(quantStr) + " + (SELECT quantity FROM Cart WHERE product = "+ productSKU + "AND Cart.customer = \'" + session.getAttribute("username").toString() + "\')) WHERE Cart.product = " + productSKU + " AND Cart.customer = \'" + session.getAttribute("username").toString() + "\'");

					conn.commit();
					conn.setAutoCommit(true);

					//if(updateQuery != 0){ 
						// should be product browsing
						//response.sendRedirect("signup2.jsp");
						// out.println(quantStr + " item(s) successfully added to your cart!");
						//response.setHeader("Refresh", "3; URL=productorder2.jsp;");
 
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
					conn.commit();
					updateQuery = pstmt.executeUpdate();
					conn.setAutoCommit(true);

					if(updateQuery != 0){ 
						// should be product browsing
						//out.println("Inserted to Shopping Cart!");
						//response.sendRedirect("signup2.jsp");	
						out.println(quantStr + " item(s) successfully added to your cart!");						
						response.setHeader("Refresh", "2; URL=productorder2.jsp");				
 
					} else{
						out.println("Uh oh, please try again!");
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
                rs = statement.executeQuery("SELECT Products.name, Cart.quantity, Products.price FROM Cart, Products WHERE Cart.product = Products.sku AND Cart.customer = \'" +  session.getAttribute("username").toString() + "\'");
            %>
            
            <!-- Add an HTML table header row to format the results -->

            <table border="1">
            <tr>
                <th>Name</th>
                <th>Quantity</th>
                <th>Price</th>
            </tr>


			<% out.println("Currently in your cart:");%>
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
            <%
                }
            %>
<br>
			<tr>
			<FORM action="productorder.jsp" method ="post"> 

			<TABLE WIDTH="75%" >
         		<TR>
         		<TH>
					<br>Your total so far is: $<%=total%> 
          		</TH>
          		</TR>
      


			</FORM>
   			</TABLE>
			</tr>
<%
}
		else
		{
	    %>
			<h2>You are not an Customer!!!</h2>
	    <%
			response.setHeader("Refresh", "2; URL=category.jsp;");
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