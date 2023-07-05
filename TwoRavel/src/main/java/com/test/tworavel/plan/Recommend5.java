package com.test.tworavel.plan;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/plan/recommend5.do")
public class Recommend5 extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		
		String page = req.getParameter("page");
		
		
		
		
		HttpSession session = req.getSession();
		

		String local =req.getParameter("local");
		String start = req.getParameter("start");
		String end = req.getParameter("end");
		String theme1 = req.getParameter("theme1");
		String theme2 = req.getParameter("theme2");
		String theme3 = req.getParameter("theme3");
		String mbti = req.getParameter("mbti");
		String mbti1 = req.getParameter("mbti1");
		String mbti2 = req.getParameter("mbti2");
		String mbti3 = req.getParameter("mbti3");

		req.setAttribute("local", local);
		req.setAttribute("start", start);
		req.setAttribute("end", end);
		req.setAttribute("theme1", theme1);
		req.setAttribute("theme2", theme2);
		req.setAttribute("theme3", theme3);
		req.setAttribute("mbti", mbti);
		req.setAttribute("mbti1", mbti1);
		req.setAttribute("mbti2", mbti2);
		req.setAttribute("mbti3", mbti3);
		
		
		
		HashMap<String, String> map = new HashMap<String, String>();
		
		map.put("local", local);
		map.put("start", start);
		map.put("end", end);
		map.put("theme1", theme1);
		map.put("theme2", theme2);
		map.put("theme3", theme3);
		map.put("mbti", mbti);
		map.put("mbti1", mbti1);
		map.put("mbti2", mbti2);
		map.put("mbti3", mbti3);
		

		PlanDAO dao = new PlanDAO();
		
		
		ArrayList<PlanDTO> list = dao.list(map);
		
		
		req.setAttribute("list", list);
		
		

		RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/plan/recommend5.jsp");
		dispatcher.forward(req, resp);

	}

}