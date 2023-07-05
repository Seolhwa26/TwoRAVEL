package com.test.tworavel.plan;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.test.tworavel.member.MemberDAO;
import com.test.tworavel.member.MemberDTO;

@WebServlet("/plan/recommendok.do")
public class RecommendOk extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		req.setCharacterEncoding("UTF-8");
		
		HttpSession session = req.getSession();
		
		String pseq = req.getParameter("seq");
		
		
		int result = 0;
		
	    PlanDTO dto = new PlanDTO();
	      
		dto.setPseq(pseq);
		dto.setId((String)session.getAttribute("auth"));
		
		PlanDAO dao = new PlanDAO();
		
		result = dao.join(dto);
		
		
		if (result == 1) {
			PrintWriter writer = resp.getWriter();
			writer.print("<script>");
			writer.print("alert('참여완료')");
			writer.print("</script>");			 
	         resp.sendRedirect("/tworavel/member/mypage.do");
	      } else {
	         
	         PrintWriter writer = resp.getWriter();
	         writer.print("<script>");
	         writer.print("alert('참여에 실패했습니다.');");
	         writer.print("history.back();");
	         writer.print("</script>");
	         writer.close();
	         
	      }

	}

}
