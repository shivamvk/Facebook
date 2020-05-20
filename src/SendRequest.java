
import java.sql.*;
import java.sql.DriverManager;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class SendRequest
 */
@WebServlet("/SendRequest")
public class SendRequest extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		String sendersEmail = session.getAttribute("sessionEmail").toString();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost/facebook?user=root&password=test123");
			System.out.print(sendersEmail + ", " + request.getParameter("email"));
			PreparedStatement statement = 
					con.prepareStatement(
							"insert into friendrequest "
							+ "(sendersEmail, receiversEmail) "
							+ "values(?,?)");
			statement.setString(1, sendersEmail);
			statement.setString(2, request.getParameter("email"));
			statement.executeUpdate();
			session.setAttribute("sessionMessage", "Request sent!");
			response.sendRedirect("index.jsp?userEmail=" + session.getAttribute("sessionEmail"));
			con.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

}
