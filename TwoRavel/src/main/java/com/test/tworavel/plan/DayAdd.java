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

@WebServlet("/plan/dayadd.do")
public class DayAdd extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String day = req.getParameter("day");
		String plname = req.getParameter("plname");
		String local = req.getParameter("local");

		PlanDAO pdao = new PlanDAO();
		PlaceDTO pdto = new PlaceDTO();

		LocalDAO ldao = new LocalDAO();
		String locseq = ldao.getLocalSeq(local);

		pdto.setPlname(plname);
		pdto.setLocseq(locseq);


		PlaceDTO result = pdao.placeInfo(pdto);

		resp.setCharacterEncoding("UTF-8");
		resp.setContentType("application/json");

		PrintWriter writer = resp.getWriter();

		JSONObject obj = new JSONObject();
		
		
		obj.put("day", day);
		obj.put("plname", plname);
		obj.put("local", local);
		obj.put("plseq", result.getPlseq());
		obj.put("locseq", result.getLocseq());
		obj.put("pllat", result.getPllat());
		obj.put("pllng", result.getPllng());
		obj.put("ptheme", result.getPtheme());

		writer.print(obj);

		writer.close();

	}

}
