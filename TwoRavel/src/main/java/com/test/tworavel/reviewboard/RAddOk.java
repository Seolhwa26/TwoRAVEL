package com.test.tworavel.reviewboard;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;


@WebServlet("/reviewboard/raddok.do")
public class RAddOk extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		HttpSession session = req.getSession();

		String mseq = (String)session.getAttribute("mseq");

		req.setCharacterEncoding("UTF-8");

		MultipartRequest multi = null;

		String path = req.getRealPath("/asset/files");
		int size = 1024 * 1024 * 100;

		multi = new MultipartRequest(req, path ,size , "UTF-8" , new DefaultFileRenamePolicy());

		String rctitle = multi.getParameter("rctitle");
		String rcontent = multi.getParameter("rcontent");
		String rfile = multi.getFilesystemName("rfile");
		
		ReviewDAO dao = new ReviewDAO();
		ReviewDTO dto = new ReviewDTO();

		String msseq = dao.getMsseq(mseq);
		
		dto.setRctitle(rctitle);
		dto.setRcontent(rcontent);
		dto.setMseq(mseq);
		dto.setRfile(rfile);
		dto.setMsseq(msseq);
		
		int result = dao.addReview(dto);
		
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
