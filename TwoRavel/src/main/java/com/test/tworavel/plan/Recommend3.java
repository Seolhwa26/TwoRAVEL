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

@WebServlet("/plan/recommend3.do")
public class Recommend3 extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		
		HttpSession session = req.getSession();

		String local =req.getParameter("local");
		String start =req.getParameter("start");
		String end = req.getParameter("end");
		String theme1 = req.getParameter("theme1");
		String theme2 = req.getParameter("theme2");
		String theme3 = req.getParameter("theme3");

		req.setAttribute("local", local);
		req.setAttribute("start", start);
		req.setAttribute("end", end);
		req.setAttribute("theme1", theme1);
		req.setAttribute("theme2", theme2);
		req.setAttribute("theme3", theme3);
		
		RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/plan/recommend3.jsp");
		dispatcher.forward(req, resp);

	}

}
