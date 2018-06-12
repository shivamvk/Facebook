

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class Login
 */
@WebServlet("/Login")
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;
     
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost/facebook?user=root&password=test123");
			PreparedStatement statement = con.prepareStatement("select * from users where email=? and password=?");
			statement.setString(1, request.getParameter("email"));
			statement.setString(2, request.getParameter("password"));
			ResultSet rs = statement.executeQuery();
			if(rs.next()) {
				session.setAttribute("sessionName", rs.getString(1));
				session.setAttribute("sessionLastName", rs.getString(2));
				session.setAttribute("sessionEmail", rs.getString(3));
				con.close();
				response.sendRedirect("index.jsp");
			} else {
				session.setAttribute("sessionMessage", "Invalid email or password");
				con.close();
				response.sendRedirect("LoginSignup.jsp");
			}
		} catch(Exception e) {
			
		}
			
	}

}
