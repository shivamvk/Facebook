

import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class LikePost
 */
@WebServlet("/LikePost")
public class LikePost extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost/facebook?user=root&password=test123");
			PreparedStatement statement = con.prepareStatement("select * from likes where postId=? and likedBy=?");
			statement.setString(1, request.getParameter("postId"));
			statement.setString(2, session.getAttribute("sessionEmail").toString());
			ResultSet rs = statement.executeQuery();
			if(rs.next()) {
				session.setAttribute("sessionMessage", "You've already liked the post");
				con.close();
				response.sendRedirect(request.getParameter("calledBy"));
			} else {
				PreparedStatement statement1 = con.prepareStatement("insert into likes values(?,?)");
				statement1.setString(1, request.getParameter("postId"));
				statement1.setString(2, session.getAttribute("sessionEmail").toString());
				statement1.executeUpdate();
				session.setAttribute("sessionMessage", "You liked the post!");
				con.close();
				response.sendRedirect(request.getParameter("calledBy"));
				return;
			}
		} catch(Exception e) {
			
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
