package com.test.tworavel.reviewboard;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/reviewboard/radd.do")
public class RAdd extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		HttpSession session = req.getSession();
	      
	    String mseq = (String)session.getAttribute("mseq");
	    
	    req.setAttribute("mseq", mseq);
		
		RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/reviewboard/radd.jsp");
		dispatcher.forward(req, resp);

	}
}
