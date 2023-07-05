package com.test.tworavel.plan;

import java.io.IOException;
import java.io.PrintWriter;

import javax.security.auth.message.callback.PrivateKeyCallback.Request;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/plan/recommend2.do")
public class Recommend2 extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		
		HttpSession session = req.getSession();
		
		String local =req.getParameter("local");
		String start =req.getParameter("start");
		String end = req.getParameter("end");

		
		req.setAttribute("local", local);
		req.setAttribute("start", start);
		req.setAttribute("end", end);
		
		RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/plan/recommend2.jsp");
		dispatcher.forward(req, resp);

	}

}
