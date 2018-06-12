<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
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
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css">
    <title><%=getName(request.getParameter("userEmail") )%></title>
<script src="https://code.jquery.com/jquery-latest.js"></script>
  <script>
    $(document).ready(function(){
    	<%
		if(session.getAttribute("sessionMessage") != null){
			%>
			var message = '<%=session.getAttribute("sessionMessage")%>';
			alert(message);
			<%
			session.setAttribute("sessionMessage", null);
		}
		%>
   		<%
   		if(!(request.getParameter("userEmail").equals(session.getAttribute("sessionEmail").toString()))){
   			%>
   			$('.addeditdetails').css('display','none');
   			<%
   		}
   		%> 	
   		$('.navbarlinks').css("color","grey");
        $('.navbarlinks').hover(
          function(){
            $(this).css("color","blue");
          },
          function(){
            $(this).css("color","grey");
          }
        );
    });
  </script>
    <style type="text/css">
    	body{margin-top:20px;}

.profile {
  width: 100%;
  position: relative;
  background: #FFF;
  border: 1px solid #D5D5D5;
  padding-bottom: 5px;
  margin-bottom: 20px;
}

.profile .image {
  display: block;
  position: relative;
  z-index: 1;
  overflow: hidden;
  text-align: center;
  border: 5px solid #FFF;
}

.profile .user {
  position: relative;
  padding: 0px 5px 5px;
}

.profile .user .avatar {
  position: absolute;
  left: 20px;
  top: -85px;
  z-index: 2;
}

.profile .user h2 {
  font-size: 16px;
  line-height: 20px;
  display: block;
  float: left;
  margin: 4px 0px 0px 135px;
  font-weight: bold;
}

.profile .user .actions {
  float: right;
}

.profile .user .actions .btn {
  margin-bottom: 0px;
}

.profile .info {
  float: left;
  margin-left: 20px;
}

.img-profile{
    height:100px;
    width:100px;
}

.img-cover{
    width:100%;
    height:300px;
}

@media (max-width: 768px) {
  .btn-responsive {
    padding:2px 4px;
    font-size:80%;
    line-height: 1;
    border-radius:3px;
  }
}

@media (min-width: 769px) and (max-width: 992px) {
  .btn-responsive {
    padding:4px 9px;
    font-size:90%;
    line-height: 1.2;
  }
}
    </style>
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
<%
Class.forName("com.mysql.jdbc.Driver");
Connection con = DriverManager.getConnection("jdbc:mysql://localhost/facebook?user=root&password=test123");
PreparedStatement statement = con.prepareStatement("select * from users where email=?");
statement.setString(1, request.getParameter("userEmail"));
ResultSet rs = statement.executeQuery();
rs.next();
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
        	<input value="<%=rs.getString(10) %>" id="studentat" value="" type="text" name="studentAt" class="form-control" placeholder="Your school" required="required">
        </div>
        <div class="form-group">
        	<label for="worksat">Works at:</label>
        	<input value="<%=rs.getString(11) %>" id="worksat" value="" type="text" name="worksAt" class="form-control" placeholder="Your work place" required="required">
        </div>
        <div class="form-group">
        	<label for="address">Address:</label>
        	<input value="<%=rs.getString(9) %>" id="address" value="" type="text" name="address" class="form-control" placeholder="Your address" required="required">
        </div>
      </div>
      <div class="modal-footer">
      	<button type="submit" class="btn btn-info btn-md">Update</button>
      </div>
      </form>
    </div>
  </div>
</div>
<div class="container">
  <div class="col-md-12" style="padding-left: 5%; padding-right: 5%;">
    <div class="profile clearfix">                            
        <div class="image">
            <img src="https://lorempixel.com/700/300/nature/2/" class="img-cover">
        </div>                            
        <div class="user clearfix">
            <div class="avatar">
                <img src="https://bootdey.com/img/Content/user-453533-fdadfd.png" class="img-thumbnail img-profile">
            </div>                                
            <h2><%=getName(request.getParameter("userEmail")) %></h2>                                
            <div class="actions">
                <div class="btn-group">
                    <button class="btn btn-info btn-sm btn-responsive" title="" data-original-title="Add to friends">Friends</button>
                    <button class="btn btn-info btn-sm btn-responsive" title="" data-original-title="Send message">Message</button>
                    <button class="btn btn-info btn-sm btn-responsive" title="" data-original-title="Recommend">Recommend</button>
                </div>
            </div>                                                                                                
        </div>                          
        <div class="info">
            <p><span class=""></span> <span style="font-weight: bold;">Student at:</span> <%=rs.getString(10) %></p>                                    
            <p><span class=""></span> <span style="font-weight: bold;">Works at:</span> <%=rs.getString(11) %></p>
            <p><span class=""></span> <span style="font-weight: bold;">Address:</span> <%=rs.getString(9) %></p> 
            <a data-toggle="modal" data-target="#editdetailsmodal" style="display: block;" class="btn btn-md btn-info addeditdetails"><span style="color: #ffffff">Add/Edit details</span></a>                               
        </div>                              
    </div>
</div>
</div>
<%
con.close();
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
	} catch(Exception e){
		return name;
	}
	return name;
}
%>
<%
Class.forName("com.mysql.jdbc.Driver");
Connection con1 = DriverManager.getConnection("jdbc:mysql://localhost/facebook?user=root&password=test123");
PreparedStatement statement1 = con1.prepareStatement("select * from wallposts where email=? order by id desc");
statement1.setString(1, request.getParameter("userEmail"));
ResultSet rs1 = statement1.executeQuery();
while(rs1.next()){
		%>
			<div class="container">
				<div class="card" style="margin-left:5%; margin-right:5%">
				  <div class="card-body">
				  	<h6 onclick="window.location.assign('ProfilePage.jsp?userEmail=<%=rs1.getString(1) %>')" class="card-title navbarlinks"><%=getName(rs1.getString(1)) %></h6>
					<h6 class="card-text"><%=rs1.getString(2) %></h6>
					<p>Liked By: <span class="text-muted"><%=getLikedByNames(rs1.getString(5)) %></span></p>
					<a href="LikePost?postId=<%=rs1.getInt(5) %>&calledBy=ProfilePage.jsp?userEmail=<%=session.getAttribute("sessionEmail") %>" class="btn btn-info btn-sm"><span style="color:#ffffff">Like Post</span></a>
				  </div>
				  <div class="card-footer" style="max-height:130px; overflow-y: scroll;">
				  <%
				  Class.forName("com.mysql.jdbc.Driver");
				  Connection con3 = DriverManager.getConnection("jdbc:mysql://localhost/facebook?user=root&password=test123");
				  PreparedStatement statement3 = con3.prepareStatement("select * from comments where postId=? order by commentId desc");
				  statement3.setString(1, rs1.getString(5));
				  ResultSet rs3 = statement3.executeQuery();
				  while(rs3.next()){
					  %>
					  	<p class="card-subtitle"><span onclick="window.location.assign('ProfilePage.jsp?userEmail=<%=rs3.getString(2) %>')" style="font-weight:bold"><%=getName(rs3.getString(2)) %></span>: <%=rs3.getString(3) %></p>
					  	<p></p>
					  <%
				  }
				  %>
				  		
						<form action="CommentPost" method="get" class="form-inline">
						<input type="text" value="<%=rs1.getString(5)%>" readonly="readonly" name="postId" style="display:none;">
						<input type="text" value="ProfilePage.jsp?userEmail=<%=request.getParameter("userEmail") %>" readonly="readonly" name="calledBy" style="display:none;">
							<input style="width:85%;" class="form-control mr-auto" type="text" placeholder="Write your comment here" required="required" name="commentMessage">
							<button class="btn btn-sm btn-info" type="submit">Comment</button>
						</form>
				  </div>
				</div>
			</div>
			
			<br><br>
		<%
}
con1.close();
%>

</body>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.slim.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
</html>