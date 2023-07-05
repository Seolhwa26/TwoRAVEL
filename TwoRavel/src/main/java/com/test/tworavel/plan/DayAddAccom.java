package com.test.tworavel.plan;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

@WebServlet("/plan/dayaddaccom.do")
public class DayAddAccom extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String day = req.getParameter("day");
		String aname = req.getParameter("aname");
		String local = req.getParameter("local");
		
		
		resp.setCharacterEncoding("UTF-8");
		resp.setContentType("application/json");

		PrintWriter writer = resp.getWriter();

		JSONObject obj = new JSONObject();
		
		
		obj.put("day", day);
		obj.put("aname", aname);
		obj.put("local", local);

		writer.print(obj);

		writer.close();
		
	
	
	}

}

