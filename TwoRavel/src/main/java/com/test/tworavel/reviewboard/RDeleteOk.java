package com.test.tworavel.reviewboard;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/reviewboard/rdeleteok.do")
public class RDeleteOk extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		String rseq = req.getParameter("rseq");
		
		ReviewDAO dao = new ReviewDAO();
		
		dao.deleteCommentAll(rseq);
		
		int result = dao.deleteReview(rseq);
		
		if (result == 1) {
			resp.sendRedirect("/tworavel/reviewboard/review.do");
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