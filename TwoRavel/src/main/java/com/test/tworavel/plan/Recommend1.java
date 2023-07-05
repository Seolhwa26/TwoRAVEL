package com.test.tworavel.plan;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/plan/recommend1.do")
public class Recommend1 extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		HttpSession session = req.getSession();

		String local =req.getParameter("local");

		req.setAttribute("local", local);
		
		RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/plan/recommend1.jsp");
		dispatcher.forward(req, resp);

	}

}
