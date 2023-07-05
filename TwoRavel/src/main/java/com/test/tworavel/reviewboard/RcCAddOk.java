package com.test.tworavel.reviewboard;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.test.tworavel.member.LandMarkDTO;
import com.test.tworavel.member.MemberDAO;

@WebServlet("/reviewboard/rccaddok.do")
public class RcCAddOk extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		HttpSession session = req.getSession();
		
		req.setCharacterEncoding("UTF-8");
		
		String rseq = req.getParameter("rseq");
		
		String mseq = req.getParameter("mseq");

		String rccontent = req.getParameter("rccontent");
		
		String writeId = req.getParameter("writeId");
		
		String cCount = req.getParameter("cCount");
		
		ReviewDTO dto = new ReviewDTO();
		
		dto.setRseq(rseq);
		dto.setMseq(mseq);
		dto.setRccontent(rccontent);
		
		ReviewDAO dao = new ReviewDAO();
		
		//한 줄 평가 추가
		int result = dao.addRcComment(dto);
		

		resp.setCharacterEncoding("UTF-8");
		PrintWriter writer = resp.getWriter();
		writer.print("<html>");
		writer.print("<head>");
		writer.print("<meta charset='UTF-8'>");
		writer.print("<script>");
		
		if (result == 1) {
			
			int cCountI = Integer.parseInt(cCount) + 1;  
			
			writer.print("location.href='/tworavel/reviewboard/reviewdetail.do?rseq=" + rseq + "&id=" + writeId + "&cCount="+ cCountI +  "';");
			
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
