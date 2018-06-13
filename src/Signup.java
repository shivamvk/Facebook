

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
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
 * Servlet implementation class Signup
 */
@WebServlet("/Signup")
public class Signup extends HttpServlet {
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
			PreparedStatement statement = con.prepareStatement("select * from users where email=?");
			statement.setString(1, request.getParameter("email"));
			ResultSet rs = statement.executeQuery();
			if(rs.next()) {
				con.close();
				response.getWriter().write("not");
			} else {
				PreparedStatement statement1 = con.prepareStatement("insert into users(firstName,lastName,email,password,dobDay,dobYear,dobMonth,gender)"
						+ " values(?,?,?,?,?,?,?,?)");
				statement1.setString(1, request.getParameter("firstName"));
				statement1.setString(2, request.getParameter("lastName"));
				statement1.setString(3, request.getParameter("email"));
				statement1.setString(4, request.getParameter("password"));
				statement1.setString(5, request.getParameter("dobDay"));
				statement1.setString(6, request.getParameter("dobYear"));
				statement1.setString(7, request.getParameter("dobMonth"));
				statement1.setString(8, request.getParameter("gender"));
				statement1.executeUpdate();
				session.setAttribute("sessionName", request.getParameter("firstName"));
				session.setAttribute("sessionLastName", request.getParameter("lastName"));
				session.setAttribute("sessionEmail", request.getParameter("email"));
				con.close();
				File file = new File("C:\\Users\\hp\\eclipse-workspace\\Facebook\\WebContent\\images" + "\\" + request.getParameter("email"));
				file.mkdir();
				String path = "";
				if(request.getParameter("gender").equals("Male")) {
					path = "C:\\Users\\hp\\eclipse-workspace\\Facebook\\WebContent\\images" + "\\placeholderboy.jpg";
				} else {
					path = "C:\\Users\\hp\\eclipse-workspace\\Facebook\\WebContent\\images" + "\\placeholdergirl.jpg";
				}
				FileInputStream fis = new FileInputStream(path);
				FileOutputStream fos = new FileOutputStream("C:\\Users\\hp\\eclipse-workspace\\Facebook\\WebContent\\images"
						+ "\\" + request.getParameter("email") + "\\profilepicture.jpg");
				int i;
				while((i=fis.read())!=-1) {
					fos.write(i);
				}
				fis.close();
				fos.close();
				response.getWriter().write("ok");
			}
		} catch(Exception e) {
			
		}
	}

}
