package com.test.tworavel.reviewboard;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;


@WebServlet("/reviewboard/reditok.do")
public class REditOk extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		req.setCharacterEncoding("UTF-8");
		
		MultipartRequest multi = null;

		String path = req.getRealPath("/asset/files");
		int size = 1024 * 1024 * 100;

		multi = new MultipartRequest(req, path ,size , "UTF-8" , new DefaultFileRenamePolicy());
		
		
		String rctitle = multi.getParameter("rctitle");
		String rcontent = multi.getParameter("rcontent");
		String rfile = multi.getFilesystemName("rfile");
		
		String rseq = multi.getParameter("rseq");
		String id = multi.getParameter("id");
		String cCount = multi.getParameter("cCount");
		
		
		
		//2.
		ReviewDTO dto = new ReviewDTO();
		
		dto.setRctitle(rctitle);
		dto.setRcontent(rcontent);
		dto.setRfile(rfile);
		dto.setRseq(rseq);

		ReviewDAO dao = new ReviewDAO();
		
		int result = dao.reviewEdit(dto);
				
		//4.
		if (result == 1) {
			resp.sendRedirect("/tworavel/reviewboard/reviewdetail.do?rseq=" + rseq + "&id=" + id + "&cCount=" + cCount );
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
