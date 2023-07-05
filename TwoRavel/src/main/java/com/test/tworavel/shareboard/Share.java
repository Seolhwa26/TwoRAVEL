package com.test.tworavel.shareboard;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet("/shareboard/share.do")
public class Share extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {


		
		HttpSession session = req.getSession();
		
		
		ShareDAO dao = new ShareDAO();
		
		ArrayList<ShareDTO> list = dao.list();
		
		req.setAttribute("list", list);
		

		RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/shareboard/share.jsp");
		dispatcher.forward(req, resp);

	}

}
