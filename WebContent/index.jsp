<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<%
if(session.getAttribute("sessionEmail") == null){
	response.sendRedirect("LoginSignup.jsp");
	return;
}
%>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css">
  <link rel="stylesheet" type="text/css" href="index.css">
  <script src="https://code.jquery.com/jquery-latest.js"></script>
  <script>
    $(document).ready(function(){
    	<%
    	if(request.getParameter("userEmail").equals(session.getAttribute("sessionEmail").toString())){
    		%>
    		$("#changedpbutton").css("display","block");
    		$('.editdetailsbutton').css("display","block");
    		$('.sendfriendrequestbutton').css("display","none");
    		<%
    	} else{
    		%>
    		$("#changedpbutton").css("display","none");
    		$('.editdetailsbutton').css("display","none");
    		$('.sendfriendrequestbutton').css("display","block");
    		<%
    	}
    	%>
    	$('.navbarlinks').css("color","#ffffff");
        $('.navbarlinks').hover(
          function(){
            $(this).css("color","#000000");
          },
          function(){
            $(this).css("color","#ffffff");
          }
        );
        $('.postname').css("color","#000000");
        $('.postname').hover(
          function(){
            $(this).css("color","blue");
          },
          function(){
            $(this).css("color","#000000");
          }
        );
        $('.navbarsearchbutton').css("color","blue");
        $('.navbarsearchbutton').css("background-color","#ffffff");
        $('.navbarsearchbutton').hover(
          function(){
            $(this).css("color","#ffffff");
            $(this).css("background-color","blue");
          },
          function(){
            $(this).css("color","blue");
            $(this).css("background-color","#ffffff");
          }
        );
    });
    function showSuggestions(name){
    	if(name!=""){
    		$.ajax({
    		    url : "ShowSuggestions?term=" + name,
    		    type : "GET",
    		    async : true,
    		    success : function(data) {
    		    	if(data != ""){
    		    		var array = data.split(",");
    		    		var selectList = document.getElementById("datalist");
    		    		while (selectList.hasChildNodes()) {
    		    			selectList.removeChild(selectList.lastChild);
    		    		}
    		    		for (var i = 0; i < array.length; i++) {
    		    		    var option = document.createElement("option");
    		    		    option.value = array[i];
    		    		    option.text = array[i];
    		    		    selectList.appendChild(option);
    		    		}
    				}
    		    }
    		});
    	}
    }
    function changedpclicked(){
    	document.getElementById("changedpfilebutton").click();
    }
  </script>
  <title>Facebook</title>
</head>
<body>
<%!
public String getName(String email){
	String name = "";
	try{
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost/facebook?user=root&password=test123");
		PreparedStatement statement = con.prepareStatement("select firstName,lastName from users where email=?");
		statement.setString(1, email);
		ResultSet rs = statement.executeQuery();
		while(rs.next()){
			name = rs.getString(1) + " " + rs.getString(2);
		}
		con.close();
	} catch(Exception e){
		return name;
	}
	return name;
}
%>
<%!
public ArrayList<String> getFriends(String email, HttpSession session){
	ArrayList<String> friends = new ArrayList<>();
	try{
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost/facebook?user=root&password=test123");
		PreparedStatement statement = con.prepareStatement("SELECT * FROM FRIENDREQUEST WHERE (SENDERSEMAIL=? OR RECEIVERSEMAIL=?) AND REQUESTSTATUS='ACCEPTED'");
		statement.setString(1, email);
		statement.setString(2, email);
		ResultSet rs = statement.executeQuery();
		while(rs.next()){
			if(rs.getString(2).equals(email)){
				friends.add(rs.getString(3));
			} else {
				friends.add(rs.getString(2));
			}
		}
		con.close();
	} catch(Exception e){
		return friends;
	}
	return friends;
}
%>
<%!
public String getLikedByNames(String postId){
	String name = "";
	try{
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost/facebook?user=root&password=test123");
		PreparedStatement statement = con.prepareStatement("select * from likes where postId=?");
		statement.setString(1, postId);
		ResultSet rs = statement.executeQuery();
		while(rs.next()){
			name += getName(rs.getString(2)) + "," + " ";
		}
		con.close();
	} catch(Exception e){
		return name;
	}
	return name;
}
%>
<!--Friend Request Modal -->
<div class="modal fade" id="friendrequestmodal" tabindex="-1" role="dialog" aria-labelledby="friendrequestmodal" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="friendrequestmodal">Friend Request</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <%
        Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost/facebook?user=root&password=test123");
		PreparedStatement statement = con.prepareStatement("select * from friendrequest where receiversEmail=? and requestStatus='NOTACCEPTED'");
		statement.setString(1, session.getAttribute("sessionEmail").toString());
		ResultSet rs = statement.executeQuery();
		while(rs.next()){
			%>
				<div class="card">
				  <div class="card-body">
				    <h5 class="card-title"><%=getName(rs.getString(2))%></h5>
				    <h6 class="card-text"><%=rs.getString(2) %></h6>
				  </div>
				  <div class="card-footer">
				  	<a href="AcceptRequest?id=<%=rs.getString(1) %>&name=<%=getName(rs.getString(2)) %>" class="btn btn-sm btn-info"><span style="color:#ffffff">Accept</span></a>
				  	<a class="btn btn-sm btn-danger"><span style="color:#ffffff">Delete</span></a>
				  </div>
				</div><br>
			<%
		}
		con.close();
        %>
      </div>
    </div>
  </div>
</div>

<!--Edit Profile Modal -->
<div class="modal fade" id="editprofilemodal" tabindex="-1" role="dialog" aria-labelledby="editprofilemodal" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="editprofilemodal">Friend Request</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <%
      Class.forName("com.mysql.jdbc.Driver");
	  Connection con2 = DriverManager.getConnection("jdbc:mysql://localhost/facebook?user=root&password=test123");
	  PreparedStatement statement2 = con2.prepareStatement("select * from users where email=?");
	  statement2.setString(1, session.getAttribute("sessionEmail").toString());
	  ResultSet rs2 = statement2.executeQuery();
	  rs2.next();
      %>
      <div class="modal-body">
        <form action="UpdateDetails" method="get">
        <div class="form-group form-inline">
        <input value="<%=rs2.getString(1) %>" type="text" name="firstName" class="form-control in1 mr-auto" placeholder="First name" required="required">
        <input value="<%=rs2.getString(2) %>" type="text" name="lastName" class="form-control in1 fr" placeholder="Last name" required="required">
        </div>
        <div class="form-group">
        <input value="<%=rs2.getString(3) %>" type="email" name="email" readonly="readonly" class="form-control in2" placeholder="Email" required="required">
        </div>
        <div class="form-group">
        <input value="<%=rs2.getString(4) %>" type="password" name="password" class="form-control in2" placeholder="Password" required="required">
        </div>
        <div class="form-inline">
          <span data-type="selectors">
            <span>
              <select name="dobMonth" required="required" title="Month" class="form-control"><option value="0" selected="1">Month</option><option value="1">Jan</option><option value="2">Feb</option><option value="3">Mar</option><option value="4">Apr</option><option value="5">May</option><option value="6">Jun</option><option value="7">Jul</option><option value="8">Aug</option><option value="9">Sep</option><option value="10">Oct</option><option value="11">Nov</option><option value="12">Dec</option></select>
              <select name="dobDay" required="required" title="Day" class="form-control fl"><option value="0" selected="1">Day</option><option value="1">1</option><option value="2">2</option><option value="3">3</option><option value="4">4</option><option value="5">5</option><option value="6">6</option><option value="7">7</option><option value="8">8</option><option value="9">9</option><option value="10">10</option><option value="11">11</option><option value="12">12</option><option value="13">13</option><option value="14">14</option><option value="15">15</option><option value="16">16</option><option value="17">17</option><option value="18">18</option><option value="19">19</option><option value="20">20</option><option value="21">21</option><option value="22">22</option><option value="23">23</option><option value="24">24</option><option value="25">25</option><option value="26">26</option><option value="27">27</option><option value="28">28</option><option value="29">29</option><option value="30">30</option><option value="31">31</option></select>
              <select name="dobYear" required="required" title="Year" class="form-control fl"><option value="0" selected="1">Year</option><option value="2015">2015</option><option value="2014">2014</option><option value="2013">2013</option><option value="2012">2012</option><option value="2011">2011</option><option value="2010">2010</option><option value="2009">2009</option><option value="2008">2008</option><option value="2007">2007</option><option value="2006">2006</option><option value="2005">2005</option><option value="2004">2004</option><option value="2003">2003</option><option value="2002">2002</option><option value="2001">2001</option><option value="2000">2000</option><option value="1999">1999</option><option value="1998">1998</option><option value="1997">1997</option><option value="1996">1996</option><option value="1995">1995</option><option value="1994">1994</option><option value="1993">1993</option><option value="1992">1992</option><option value="1991">1991</option><option value="1990">1990</option><option value="1989">1989</option><option value="1988">1988</option><option value="1987">1987</option><option value="1986">1986</option><option value="1985">1985</option><option value="1984">1984</option><option value="1983">1983</option><option value="1982">1982</option><option value="1981">1981</option><option value="1980">1980</option><option value="1979">1979</option><option value="1978">1978</option><option value="1977">1977</option><option value="1976">1976</option><option value="1975">1975</option><option value="1974">1974</option><option value="1973">1973</option><option value="1972">1972</option><option value="1971">1971</option><option value="1970">1970</option><option value="1969">1969</option><option value="1968">1968</option><option value="1967">1967</option><option value="1966">1966</option><option value="1965">1965</option><option value="1964">1964</option><option value="1963">1963</option><option value="1962">1962</option><option value="1961">1961</option><option value="1960">1960</option><option value="1959">1959</option><option value="1958">1958</option><option value="1957">1957</option><option value="1956">1956</option><option value="1955">1955</option><option value="1954">1954</option><option value="1953">1953</option><option value="1952">1952</option><option value="1951">1951</option><option value="1950">1950</option><option value="1949">1949</option><option value="1948">1948</option><option value="1947">1947</option><option value="1946">1946</option><option value="1945">1945</option><option value="1944">1944</option><option value="1943">1943</option><option value="1942">1942</option><option value="1941">1941</option><option value="1940">1940</option><option value="1939">1939</option><option value="1938">1938</option><option value="1937">1937</option><option value="1936">1936</option><option value="1935">1935</option><option value="1934">1934</option><option value="1933">1933</option><option value="1932">1932</option><option value="1931">1931</option><option value="1930">1930</option><option value="1929">1929</option><option value="1928">1928</option><option value="1927">1927</option><option value="1926">1926</option><option value="1925">1925</option><option value="1924">1924</option><option value="1923">1923</option><option value="1922">1922</option><option value="1921">1921</option><option value="1920">1920</option><option value="1919">1919</option><option value="1918">1918</option><option value="1917">1917</option><option value="1916">1916</option><option value="1915">1915</option><option value="1914">1914</option><option value="1913">1913</option><option value="1912">1912</option><option value="1911">1911</option><option value="1910">1910</option><option value="1909">1909</option><option value="1908">1908</option><option value="1907">1907</option><option value="1906">1906</option><option value="1905">1905</option></select>
            </span>
            </div>
            <br>
            <div class="formbox mt1">
              <span data-type="radio" class="spanpad">
                <input value="Female" required="" name="gender" type="radio" id="fem" class="m0">
                <label for="fem" class="gender">Female
                </label>
                <input value="Male" required="" name="gender" type="radio" id="male" class="m0">
                <label for="male" class="gender">Male
                </label>
              </span>
            </div>
            <br>
            <div class="form-group">
              <button type="submit" class="btn btn-info btn-md">Update</button>
            </div>
            </form>
            <%
            con2.close();
            %>
      </div>
    </div>
  </div>
</div>
<%
Class.forName("com.mysql.jdbc.Driver");
Connection con5 = DriverManager.getConnection("jdbc:mysql://localhost/facebook?user=root&password=test123");
PreparedStatement statement5 = con5.prepareStatement("select * from users where email=?");
statement5.setString(1, request.getParameter("userEmail"));
ResultSet rs5 = statement5.executeQuery();
rs5.next();
%>

<!--Edit Details Modal -->
<div class="modal fade" id="editdetailsmodal" tabindex="-1" role="dialog" aria-labelledby="editdetailsmodal" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="editdetailsmodal">Edit details</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
      <form action="UpdateProfile" method="get">
        <div class="form-group">
        	<label for="studentat">Student at:</label>
        	<input value="<%=rs5.getString(10) %>" id="studentat" value="" type="text" name="studentAt" class="form-control" placeholder="Your school" required="required">
        </div>
        <div class="form-group">
        	<label for="worksat">Works at:</label>
        	<input value="<%=rs5.getString(11) %>" id="worksat" value="" type="text" name="worksAt" class="form-control" placeholder="Your work place" required="required">
        </div>
        <div class="form-group">
        	<label for="address">Address:</label>
        	<input value="<%=rs5.getString(9) %>" id="address" value="" type="text" name="address" class="form-control" placeholder="Your address" required="required">
        </div>
      </div>
      <div class="modal-footer">
      	<button type="submit" class="btn btn-info btn-md">Update</button>
      </div>
      </form>
    </div>
  </div>
</div>
<%con5.close(); %>

<nav class="navbar navbar-expand-lg navbar-light bg-info fixed-top">
  <a class="navbar-brand" href=""><img src="images/facebooklogowhite.png" height="40px" width="270px"></a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>

  <div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav mr-auto">
      
    </ul>
    <ul class="navbar-nav justify-content-end">
      <li class="nav-item">
        <a href="" class="nav-link js-scroll-trigger"><span style="color: #000000;" class="nav-font"><b>Home</b></span></a>
      </li>
      <li class="nav-item">
        <a data-toggle="modal" data-target="#friendrequestmodal" class="nav-link js-scroll-trigger"><span class="nav-font navbarlinks"><b>Friend Requests</b></span></a>
      </li>
      <li class="nav-item">
        <a href="" class="nav-link js-scroll-trigger"><span class="nav-font navbarlinks"><b>Notifications</b></span></a>
      </li>
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          <span style="font-weight: bold;" class="navbarlinks"><%=session.getAttribute("sessionName").toString() %>'s Profile</span>
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
          <a data-toggle="modal" data-target="#editprofilemodal" class="dropdown-item" href="">Edit Profile</a>
          <div class="dropdown-divider"></div>
          <a class="dropdown-item" href="Logout">Logout</a>
        </div>
      </li>
    </ul>
    <datalist id="datalist">
    </datalist>
    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
    <form class="form-inline my-2 my-lg-0">
      <input list="datalist" class="form-control mr-sm-2" onkeyup="showSuggestions(this.value)" type="text" placeholder="Type a name here" aria-label="Search" required="">
      <div id="suggestionbox">
      </div>
      <button class="btn navbarsearchbutton my-2 my-sm-0" type="submit">Send Request</button>
    </form>
  </div>
</nav>
<br><br><br>

<%
      Class.forName("com.mysql.jdbc.Driver");
	  Connection con3 = DriverManager.getConnection("jdbc:mysql://localhost/facebook?user=root&password=test123");
	  PreparedStatement statement3 = con3.prepareStatement("select * from users where email=?");
	  statement3.setString(1, request.getParameter("userEmail"));
	  ResultSet rs3 = statement3.executeQuery();
	  rs3.next();
%>
<div class="container">
    <div class="row profile">
		<div class="col-md-3">
			<div class="profile-sidebar" style="padding: 5px;">
				<!-- SIDEBAR USERPIC -->
				<div class="profile-userpic text-center">
				<br>
					<%String profilepicpath = "images\\"
					                           + request.getParameter("userEmail") + "\\profilepicture.jpg?" + Math.random(); %>
					<img onclick="changedpclicked()" src="<%=profilepicpath %>" class="img-responsive" alt=""><p></p>
					<div id="changedpbutton">
						<form  ENCTYPE="multipart/form-data" ACTION="fileupload.jsp" METHOD=POST>
					       <input id="changedpfilebutton" style="display:none;" type="file" name="f1" required>
					       <input class="btn btn-info btn-sm" type="submit" value="Upload">
					
					    </form>
					</div>
				</div>
				<!-- END SIDEBAR USERPIC -->
				<!-- SIDEBAR USER TITLE -->
				<div class="profile-usertitle">
					<div class="profile-usertitle-name">
						<%=getName(request.getParameter("userEmail")) %>
						<p><%=request.getParameter("userEmail") %></p>
					</div>
					<br>
					<div class="profile-usertitle-job">
						<span style="color:#000000; font-weight:bold">Address:</span> <%=rs3.getString(9) %>
					</div>
					<div class="profile-usertitle-job">
						<span style="color:#000000; font-weight:bold">Student at:</span> <%=rs3.getString(10) %>
					</div>
					<div class="profile-usertitle-job">
						<span style="color:#000000; font-weight:bold">Works at:</span> <%=rs3.getString(11) %>
					</div>
				</div>
				<div class="profile-userbuttons editdetailsbutton">
					<button data-toggle="modal" data-target="#editdetailsmodal" type="button" class="btn btn-danger btn-sm">Edit details</button>
				</div>
				<div class="profile-userbuttons sendfriendrequestbutton">
					<button type="button" class="btn btn-danger btn-sm">Add as friend</button>
				</div>
				<br>
			</div>
		</div>
		<%con3.close(); %>
		<div class="col-md-9 postsection">
            <div class="profile-content">
				<div class="card" style="">
				  <div class="card-body">
				  	<form action="UploadPost" method="get">
				  		<textarea placeholder="What's on your mind?" style="border:none; resize: none; width:100%; height:100px" class="form-control" name="postMessage" required=""></textarea>
				  </div>
				  <div class="card-footer">
				  		<button type="submit" class="btn btn-info btn-md">Post</button>
				  	</form>
				  </div>
				</div>
				<br>
				<%
				ArrayList<String> friends = new ArrayList<>();
				friends = getFriends(request.getParameter("userEmail"), session);
				friends.add(request.getParameter("userEmail"));
				Class.forName("com.mysql.jdbc.Driver");
				Connection con1 = DriverManager.getConnection("jdbc:mysql://localhost/facebook?user=root&password=test123");
				PreparedStatement statement1 = con1.prepareStatement("select * from wallposts order by id desc");
				ResultSet rs1 = statement1.executeQuery();
				while(rs1.next()){
					if(friends.contains(rs1.getString(1))){
						%>
						<div class="card">
						  <div class="card-body">
						  	<h6 onclick="window.location.assign('index.jsp?userEmail=<%=rs1.getString(1) %>')" class="card-title postname"><%=getName(rs1.getString(1)) %></h6>
							<h6 class="card-text"><%=rs1.getString(2) %></h6>
							<p>Liked By: <span class="text-muted"><%=getLikedByNames(rs1.getString(5)) %></span></p>
							<a href="LikePost?postId=<%=rs1.getInt(5) %>&calledBy=index.jsp?userEmail=<%=request.getParameter("userEmail") %>" class="btn btn-info btn-sm"><span style="color:#ffffff">Like Post</span></a>
						  </div>
						  <div class="card-footer" style="max-height:130px; overflow-y: scroll;">
						  <%
						  Class.forName("com.mysql.jdbc.Driver");
						  Connection con6 = DriverManager.getConnection("jdbc:mysql://localhost/facebook?user=root&password=test123");
						  PreparedStatement statement6 = con6.prepareStatement("select * from comments where postId=? order by commentId desc");
						  statement6.setString(1, rs1.getString(5));
						  ResultSet rs6 = statement6.executeQuery();
						  while(rs6.next()){
						  %>
						  <p class="card-subtitle"><span style="font-weight:bold;"><%=getName(rs6.getString(2)) %>:</span> <%=rs6.getString(3) %></p>
						  <p></p>
						  <%
						  }
						  %>
					       <form action="CommentPost" method="get" class="form-inline">
							<input type="text" value="<%=rs1.getString(5)%>" readonly="readonly" name="postId" style="display:none;">
							<input type="text" value="index.jsp?userEmail=<%=session.getAttribute("sessionEmail") %>" readonly="readonly" name="calledBy" style="display:none;">
								<input style="width:85%;" class="form-control mr-auto" type="text" placeholder="Write your comment here" required="required" name="commentMessage">
								<button class="btn btn-sm btn-info" type="submit">Comment</button>
						   </form>
						  </div>
						</div><br>
						<%
					}
				}
				%>
            </div>
		</div>
	</div>
</div>
<%con1.close(); %>
<br>
<br>

</body>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.slim.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
</html>