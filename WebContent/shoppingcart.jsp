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
<h2>Buy Shopping Cart</h2>
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
			
		if(session.getAttribute("username") != null && 
			session.getAttribute("role").equals("Customer"))
		{
		
                // Create the statement
                Statement statement = conn.createStatement();

                // Use the created statement to SELECT
                // the student attributes FROM the Cart table.
                rs = statement.executeQuery("SELECT Products.name, Cart.quantity, Products.price FROM Cart, Products WHERE Cart.product = Products.sku AND Cart.customer = \'" + session.getAttribute("username").toString() +"\'");
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

                <form action="shoppingcart.jsp" method="POST">
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
<%} %>

			<tr>
			<FORM action="confirmation.jsp" method ="post"> 

			<TABLE style="background-color: #ECE5B6;" WIDTH="30%" >
         		<TR>
					<TH width="50%">Your total is: <%=total%> </TH>
              		<TH width="50%">Please Enter Credit Card Number: </TH>
                  	<TD width="50%"><INPUT TYPE="text" NAME="credit"></TD>
          		</TR>
      
		      	<TR>
              		<TH></TH>
                  	<TD width="50%"><INPUT TYPE="submit" NAME="submit"></TD>
          		</TR>

			<%
   			String name = request.getParameter("name");
   			String connectionURL = "jdbc:postgresql://localhost/cse135";
   			String credit ="";
			Connection connection = null;
			PreparedStatement pstatement = null;
			Class.forName("org.postgresql.Driver");
			//if(credit!= null){
				try{
					//connection = DriverManager.getConnection(connectionURL, "postgres", "postgres");
					//String queryString = "INSERT INTO CreditCard (number) VALUES (?)";
						//pstatement = connection.prepareStatement(queryString);
						//pstatement.setString(1, credit);

						int updateQuery = 1;//pstatement.executeUpdate();
						//connection.commit();
						//connection.setAutoCommit(true);

						if(updateQuery != 0){ %>
							<TABLE>
								<TR>
	              					<TH width="50%">Thank you for your purchase!</TH>
	                  			</TR>
							</TABLE>

						<%}

				}catch(Exception e){
					out.println("YOU HAVE FAILED!! Paying error!!!!!!!");
					out.println(e.getMessage());
				}
			//}
			%>
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
			response.setHeader("Refresh", "3; URL=category.jsp;");
		} 
		
            %>

            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
        //        rs.close();

                // Close the Statement
       //         statement.close();

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