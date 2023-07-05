package com.test.tworavel.reviewboard;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/reviewboard/rcdelok.do")
public class RCDeleteOk extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		HttpSession session = req.getSession();
		
		req.setCharacterEncoding("UTF-8");
		
		String rcseq = req.getParameter("rcseq");
		String rseq = req.getParameter("rseq");
		
		String id = req.getParameter("id");
		
		String cCount = req.getParameter("cCount");
		
		ReviewDAO dao = new ReviewDAO();
		
		int result = dao.delRComment(rcseq);

		//rseq=1&id=qlwn7&cCount=8
		if (result == 1) {
			int cCountI = Integer.parseInt(cCount) - 1; 
			resp.sendRedirect("/tworavel/reviewboard/reviewdetail.do?rseq=" + rseq +"&id=" + id + "&cCount=" + cCountI);
		} else {
			PrintWriter writer = resp.getWriter();
			writer.print("<script>");
			writer.print("alert('failed');");
			writer.print("history.back();");
			writer.print("</script>");
			writer.close();			
		}
		
		
		

	}
}