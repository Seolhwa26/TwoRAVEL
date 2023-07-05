package com.test.tworavel.plan;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

@WebServlet("/plan/placesearch.do")
public class PlaceSearch extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		req.setCharacterEncoding("UTF-8");
		
		String word = req.getParameter("word");
		String local = req.getParameter("local");
		String theme = req.getParameter("theme");

		
		PlanDAO dao = new PlanDAO();
		
		ArrayList<PlaceDTO> list = new ArrayList<PlaceDTO>();
		
		if ((word == null || word == "") && (theme.equals("none"))) {
			list = dao.listPlace(local);
		} else if ((word != null || word != "") && (theme.equals("none"))) { 
			list = dao.searchPlace(word);
		} else if ((word == null || word == "") && !(theme.equals("none"))) {
			list = dao.searchPlaceTheme(local, theme);
			//System.out.println(theme);
		}

		resp.setCharacterEncoding("UTF-8");
		resp.setContentType("application/json");
		
		JSONArray arr = new JSONArray();
		
		for (PlaceDTO dto : list) {
			
			//DTO 한개를 JSONObject 한개로 옮겨담아야한다.
			JSONObject obj = new JSONObject();
			
			obj.put("plseq", dto.getPlseq());
			obj.put("plname", dto.getPlname());
			obj.put("locseq", dto.getLocseq());
			obj.put("pllat", dto.getPllat());
			obj.put("pllng", dto.getPllng());
			obj.put("ptheme", dto.getPtheme());
			
			//이후에 JSONObject를 JSONArray에 담아준다.
			
			arr.add(obj);
			
		}

		
		//다시 돌려주기
		PrintWriter writer = resp.getWriter();
		
		writer.print(arr);
		
		writer.close();
		
		

	}

}

