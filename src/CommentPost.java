

import java.io.IOException;
import java.sql.*;
import java.sql.DriverManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class CommentPost
 */
@WebServlet("/CommentPost")
public class CommentPost extends HttpServlet {
	private static final long serialVersionUID = 1L;
   
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost/facebook?user=root&password=test123");
			PreparedStatement statement = con.prepareStatement("insert into comments(postId,commentBy,commentMessage,dateOfComment) values(?,?,?,?)");
			statement.setInt(1, Integer.parseInt(request.getParameter("postId")));
			statement.setString(2, session.getAttribute("sessionEmail").toString());
			statement.setString(3, request.getParameter("commentMessage"));
			statement.setString(4, null);
			statement.executeUpdate();
			response.getWriter().append("hello");
			session.setAttribute("sessionMessage", "Your comment is now live!");
			con.close();
			response.sendRedirect(request.getParameter("calledBy"));
		} catch(Exception e) {
			
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
