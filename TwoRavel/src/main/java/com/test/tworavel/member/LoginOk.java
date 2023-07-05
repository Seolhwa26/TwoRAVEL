package com.test.tworavel.member;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/member/loginok.do")
public class LoginOk extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		//Login.java
		//1. 데이터 가져오기
		//2. DB 작업 > DAO 위임 > select
		//3. 결과 > 인증 티켓 발급
		//4. 피드백

		req.setCharacterEncoding("UTF-8");
		
		//1.
		String id = req.getParameter("id");
		String pw = req.getParameter("pw");
		
		//2. 
		MemberDTO dto = new MemberDTO();
		
		dto.setId(id);
		dto.setPw(pw);
		
		MemberDAO dao = new MemberDAO();
		
		MemberDTO result = dao.login(dto);
		
		//System.out.println(result);
		
		if (result != null) {
			
			HttpSession session = req.getSession();
			
			session.setAttribute("auth", id); //로그인 
			session.setAttribute("pw", pw); 
			session.setAttribute("name", result.getMname());      
	        session.setAttribute("mseq", result.getMseq());
	        session.setAttribute("mbti", result.getMbti());
	
			resp.sendRedirect("/tworavel/main/main.do");
			
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
