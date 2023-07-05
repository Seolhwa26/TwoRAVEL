package com.test.tworavel.reviewboard;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/reviewboard/redit.do")
public class REdit extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		String rseq = req.getParameter("rseq");
		String id = req.getParameter("id");
		String cCount = req.getParameter("cCount");

		ReviewDAO dao = new ReviewDAO();
		
		ReviewDTO dto = dao.getReviewSeq(rseq);
		
		if(dto != null) {
			
			req.setAttribute("rcontent",  dto.getRcontent());
			req.setAttribute("rcount",  dto.getRcount());
			req.setAttribute("rfile",  dto.getRfile());
			req.setAttribute("rctitle",  dto.getRctitle());
			req.setAttribute("msseq",  dto.getMsseq());
		}
		
		req.setAttribute("rseq", rseq);
		req.setAttribute("id", id);
		req.setAttribute("cCount", cCount);
		
		RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/reviewboard/redit.jsp");
		dispatcher.forward(req, resp);

	}
}
