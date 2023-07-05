package com.test.tworavel.member;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/member/logoutok.do")
public class LogoutOk extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		//LogoutOk.java
		//1. 세션 해제
		//2. 피드백
		
		//1. 
		HttpSession session = req.getSession();
		
		session.removeAttribute("auth");
		session.removeAttribute("pw");
		session.removeAttribute("name");
		session.removeAttribute("mbti");
		
		//2. 
		resp.sendRedirect("/tworavel/main/main.do");
	}

}
