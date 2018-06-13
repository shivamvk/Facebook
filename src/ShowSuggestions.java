

import java.io.IOException;
import java.sql.*;
import java.sql.DriverManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class ShowSuggestions
 */
@WebServlet("/ShowSuggestions")
public class ShowSuggestions extends HttpServlet {
	private static final long serialVersionUID = 1L;
   
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String buffer = "";
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost/facebook?user=root&password=test123");
			PreparedStatement statement = con.prepareStatement("select * from users where firstName like '%"+ request.getParameter("term") + "%'");
			ResultSet rs = statement.executeQuery();
			while(rs.next()) {
				buffer += rs.getString(1) + " " + rs.getString(2) + ",";
			}
			response.getWriter().println(buffer);
			con.close();
		} catch(Exception e) {
			
		}
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
