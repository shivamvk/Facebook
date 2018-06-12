

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
 * Servlet implementation class UpdateDetails
 */
@WebServlet("/UpdateDetails")
public class UpdateDetails extends HttpServlet {
	private static final long serialVersionUID = 1L;
   
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost/facebook?user=root&password=test123");
			PreparedStatement statement = con.prepareStatement("update users set firstName=?,lastName=?,password=?,dobDay=?,dobYear=?,dobMonth=?,gender=?"
					+ " where email=?");
			statement.setString(1, request.getParameter("firstName"));
			statement.setString(2, request.getParameter("lastName"));
			statement.setString(3, request.getParameter("password"));
			statement.setString(4, request.getParameter("dobDay"));
			statement.setString(5, request.getParameter("dobYear"));
			statement.setString(6, request.getParameter("dobMonth"));
			statement.setString(7, request.getParameter("gender"));
			statement.setString(8, request.getParameter("email"));
			statement.executeUpdate();
			con.close();
			session.setAttribute("sessionMessage", "Details Updated");
			response.sendRedirect("index.jsp");
		} catch(Exception e) {
			
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
