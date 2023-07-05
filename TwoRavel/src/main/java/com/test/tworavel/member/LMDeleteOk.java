package com.test.tworavel.member;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/member/lmdeleteok.do")
public class LMDeleteOk extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		req.setCharacterEncoding("UTF-8");
		
		String lmseq = req.getParameter("lmseq");
		
		String lmname = req.getParameter("lmname");
		
		String olseq = req.getParameter("olseq");
		
		LandMarkDTO dto = new LandMarkDTO();
		
		MemberDAO dao = new MemberDAO();
		
		int result = dao.delOneLine(olseq);
		
		resp.setCharacterEncoding("UTF-8");
		
		PrintWriter writer = resp.getWriter();
		
		writer.print("<html>");
		writer.print("<head>");
		writer.print("<meta charset='UTF-8'>");
		writer.print("<script>");
		
		if (result == 1) {

			writer.print("location.href='/tworavel/member/landmark.do?lmname=" + lmname + "&lmseq=" + lmseq + "';");
			
		} else {
			writer.print("alert('failed');");
			writer.print("history.back();");
		}
		
		writer.print("</script>");
		writer.print("</head>");
		writer.print("</html>");
		writer.close();			

	}
}
