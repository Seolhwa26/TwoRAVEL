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

@WebServlet("/plan/accomsearch.do")
public class AccomSearch extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		req.setCharacterEncoding("UTF-8");

		String word = req.getParameter("word");
		String local = req.getParameter("local");
		System.out.println(local);
		PlanDAO dao = new PlanDAO();
		AccomDAO adao = new AccomDAO();
		
		ArrayList<AccomDTO> list = new ArrayList<AccomDTO>();

		adao.listAccomLM(local);

		if ((word == null || word == "")) {
			list = adao.listAccomLM(local);;
		} else if ((word != null || word != "")) { 
			list = adao.searchAccom(word,local);
		} 

		resp.setCharacterEncoding("UTF-8");
		resp.setContentType("application/json");

		JSONArray arr = new JSONArray();

		for (AccomDTO dto : list) {

			//DTO 한개를 JSONObject 한개로 옮겨담아야한다.
			JSONObject obj = new JSONObject();

			obj.put("aseq", dto.getAseq());
			obj.put("aname", dto.getAname());
			obj.put("aaddress", dto.getAaddress());
			obj.put("aprice", dto.getAprice());
			obj.put("locseq", dto.getLocseq());

			//이후에 JSONObject를 JSONArray에 담아준다.

			arr.add(obj);

		}


		//다시 돌려주기
		PrintWriter writer = resp.getWriter();

		writer.print(arr);

		writer.close();

	}
}
