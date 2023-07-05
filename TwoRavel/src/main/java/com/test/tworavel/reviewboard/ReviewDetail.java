package com.test.tworavel.reviewboard;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import javax.imageio.ImageIO;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/reviewboard/reviewdetail.do")
public class ReviewDetail extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8");

		HttpSession session = req.getSession();
		String mseq = (String)session.getAttribute("mseq");
		req.setAttribute("mseq", mseq);

		//후기 seq
		String rseq = req.getParameter("rseq");
		String writeId = req.getParameter("id");
		String cCount = req.getParameter("cCount");

		req.setAttribute("rseq", rseq);
		req.setAttribute("writeId",writeId);
		req.setAttribute("cCount",cCount);

		ReviewDAO dao = new ReviewDAO();

		ReviewDTO review = dao.getReviewSeq(rseq);

		if ( review != null) {

			req.setAttribute("rcontent",  review.getRcontent());
			req.setAttribute("rcount",  review.getRcount());
			req.setAttribute("rfile",  review.getRfile());
			req.setAttribute("rctitle",  review.getRctitle());
			req.setAttribute("msseq",  review.getMsseq());

		}

		ArrayList<ReviewDTO> comment = dao.getRcComment(rseq);
		req.setAttribute("comment", comment);

		dao.addReadCount(rseq);


		RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/reviewboard/reviewdetail.jsp");
		dispatcher.forward(req, resp);

	}
}