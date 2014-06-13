<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" import="database.*"   import="java.util.*" errorPage="" %>
<%@include file="welcome.jsp" %>
<%
if(session.getAttribute("name")!=null)
{

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSE135</title>
</head>

<body>

<div style="width:20%; position:absolute; top:50px; left:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
	<table width="100%">
		<tr><td><a href="products_browsing.jsp" target="_self">Show Produts</a></td></tr>
		<tr><td><a href="buyShoppingCart.jsp" target="_self">Buy Shopping Cart</a></td></tr>
	</table>	
</div>
<div style="width:79%; position:absolute; top:50px; right:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
<p><table align="center" width="80%" style="border-bottom-width:2px; border-top-width:2px; border-bottom-style:solid; border-top-style:solid">
	<tr><td align="left"><font size="+3">
	<%
	String uName=(String)session.getAttribute("name");
	int userID  = (Integer)session.getAttribute("userID");
	String role = (String)session.getAttribute("role");
	String card=null;
	int card_num=0;
	try {card=request.getParameter("card"); }catch(Exception e){card=null;}
	try
	{
		 card_num    = Integer.parseInt(card);
		 if(card_num>0)
		 {
	
				Connection conn=null;
				Statement stmt=null;
				PreparedStatement pcust = null, pstate = null, pprod = null, psf = null, prc1 = null, prc2 = null;
				try
				{
					
					String SQL_copy="INSERT INTO sales (uid, pid, quantity, price) select c.uid, c.pid, c.quantity, c.price from carts c where c.uid="+userID+";";
					String  SQL="delete from carts where uid="+userID+";";
					
					try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
					String url="jdbc:postgresql://127.0.0.1:5432/P1";
					String user="postgres";
					String password="880210";
					//conn =DriverManager.getConnection(url, user, password);
					conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/cse135", "postgres", "postgres");
					stmt =conn.createStatement();
				
					try{
					
							conn.setAutoCommit(false);
							/**record log,i.e., sales table**/
							stmt.execute(SQL_copy);
							//stmt.execute(SQL);
							pcust = conn.prepareStatement("UPDATE CustomerSales SET total = (total + (carts.quantity * carts.price)) FROM carts WHERE CustomerSales.uName = \'" + uName + "\' AND carts.uid = " + userID + " AND CustomerSales.pId = carts.pid;");
							if(pcust.executeUpdate() == 0) {
								stmt.execute("INSERT INTO CustomerSales (uName, pId, cName, total) select \'" + uName + "\' AS uName, c.pid AS pId, c1.name AS cName, (c.price * c.quantity) AS total from carts AS c left outer join products AS p ON (c.pid = p.id) left outer join categories AS c1 ON (p.cid = c1.id) where c.uid="+userID+";");
							}
							pstate = conn.prepareStatement("UPDATE StateSales SET total = (total + (carts.quantity * carts.price)) FROM carts left outer join users ON (carts.uid = users.id) WHERE carts.uid = " + userID + " AND StateSales.state = users.state AND StateSales.pId = carts.pid;");
							if(pstate.executeUpdate() == 0) {
								stmt.execute("INSERT INTO StateSales (state, pId, cName, total) select u.state AS state, c.pid AS pId, c1.name AS cName, (c.price * c.quantity) AS total from carts AS c left outer join products AS p ON (c.pid = p.id) left outer join categories AS c1 ON (p.cid = c1.id) left outer join users AS u ON (c.uid = u.id) where c.uid="+userID+";");
							}
							pprod = conn.prepareStatement("UPDATE ProductSales SET total = (total + (carts.quantity * carts.price)) FROM carts WHERE carts.uid = " + userID + " AND ProductSales.pId = carts.pid;");
							if(pprod.executeUpdate() == 0) {
								stmt.execute("INSERT INTO ProductSales (pName, pId, cName, total) select p.name AS pName, c.pid AS pId, c1.name AS cName, (c.price * c.quantity) AS total from carts AS c left outer join products AS p ON (c.pid = p.id) left outer join categories AS c1 ON (p.cid = c1.id) where c.uid="+userID+";");
							}
							psf = conn.prepareStatement("UPDATE StateFilterSales SET total = (total + (carts.quantity * carts.price)) FROM carts WHERE StateFilterSales.uName = \'" + uName + "\' AND carts.uid = " + userID + " AND StateFilterSales.pId = carts.pid;");
							if(psf.executeUpdate() == 0) {
								stmt.execute("INSERT INTO StateFilterSales (uName, state, pId, cName, total) select \'" + uName + "\' AS uName, u.state AS state, c.pid AS pId, c1.name AS cName, (c.price * c.quantity) AS total from carts AS c left outer join products AS p ON (c.pid = p.id) left outer join categories AS c1 ON (p.cid = c1.id) left outer join users AS u ON (c.uid = u.id) where c.uid="+userID+";");
							}
							prc1 = conn.prepareStatement("UPDATE RightColumnCust1 SET total = (total + (carts.quantity * carts.price)) FROM carts WHERE carts.uid = " + userID + " AND RightColumnCust1.uName = \'" + uName + "\';");
							if(prc1.executeUpdate() == 0) {
								stmt.execute("INSERT INTO RightColumnCust1 (uName, total) select \'" + uName + "\' AS uName, (c.price * c.quantity) AS total from carts AS c where c.uid="+userID+";");
							}
							prc2 = conn.prepareStatement("UPDATE RightColumnCust2 SET total = (total + (carts.quantity * carts.price)) FROM carts WHERE carts.uid = " + userID + " AND RightColumnCust2.uName = \'" + uName + "\';");
							if(prc2.executeUpdate() == 0) {
								stmt.execute("INSERT INTO RightColumnCust2 (uName, state, total) select \'" + uName + "\' AS uName, u.state AS state, (c.price * c.quantity) AS total from carts AS c left outer join users AS u ON (c.uid = u.id) where c.uid="+userID+";");
							}
							stmt.execute(SQL);
							conn.commit();
							
							conn.setAutoCommit(true);
							out.println("Dear customer '"+uName+"', Thanks for your purchasing.<br> Your card '"+card+"' has been successfully proved. <br>We will ship the products soon.");
							out.println("<br><font size=\"+2\" color=\"#990033\"> <a href=\"products_browsing.jsp\" target=\"_self\">Continue purchasing</a></font>");
					}
					catch(Exception e)
					{
						out.println(e.getMessage());
						out.println("Fail! Please try again <a href=\"purchase.jsp\" target=\"_self\">Purchase page</a>.<br><br>");
						
					}
					conn.close();
				}
				catch(Exception e)
				{
						out.println("<font color='#ff0000'>Error.<br><a href=\"purchase.jsp\" target=\"_self\"><i>Go Back to Purchase Page.</i></a></font><br>");
						
				}
			}
			else
			{
			
				out.println("Fail! Please input valid credit card numnber.  <br> Please <a href=\"purchase.jsp\" target=\"_self\">buy it</a> again.");
			}
		}
	catch(Exception e) 
	{ 
		out.println("Fail! Please input valid credit card numnber.  <br> Please <a href=\"purchase.jsp\" target=\"_self\">buy it</a> again.");
	}
%>
	
	</font><br>
</td></tr>
</table>
</div>
</body>
</html>
<%}%>