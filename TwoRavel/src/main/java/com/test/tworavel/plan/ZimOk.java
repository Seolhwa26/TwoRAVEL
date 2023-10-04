package com.test.tworavel.plan;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/plan/zimok.do")
public class ZimOk extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		req.setCharacterEncoding("UTF-8");
		
		HttpSession session = req.getSession();
		
		String sseq = req.getParameter("sseq");
		String mseq = (String)session.getAttribute("mseq");
		
		
		int result = 0;
		
	    PlanDTO dto = new PlanDTO();
	      
		dto.setSseq(sseq);
		dto.setId((String)session.getAttribute("auth"));
		dto.setMseq(mseq);

		PlanDAO dao = new PlanDAO();
		
		result = dao.zim(dto);

		if (result == 1) {
			PrintWriter writer = resp.getWriter();
			writer.print("<script>");
			writer.print("alert('참여완료')");
			writer.print("</script>");
			resp.sendRedirect("/tworavel/shareboard/share.do"); 
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
