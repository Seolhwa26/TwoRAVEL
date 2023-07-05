package com.test.tworavel.plan;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/plan/plandetail.do")
public class PlanDetail extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		
		HttpSession session = req.getSession();
		
		
		String[] day = req.getParameterValues("day");
		String[] accomlist = req.getParameterValues("accomlist");
		String[] spotlist = req.getParameterValues("spotlist");
		String[] translist = req.getParameterValues("translist");

		//System.out.println(Arrays.toString(accomlist));
		
		
		//앞에 day 뒤에 accomlist, spotlist, translist 각각 가져오기
		HashMap<String, String> map = new HashMap<String, String>();
		
		
		for (int i=0; i<day.length; i++) {

			//i = 데이
			//s = 장소
			//a = 숙밗
			//t = 교통
			
			if(spotlist != null) {
				for (int s=0; s<spotlist.length; s++) {
					
					if((spotlist[s].substring(spotlist[s].length()-1)).equals(day[i])) {
						map.put(spotlist[s], day[i]);
					}
					
				}
			}
			
			if(accomlist != null) {
				for (int a=0; a<accomlist.length; a++) {
					
					if((accomlist[a].substring(accomlist[a].length()-1)).equals(day[i])) {
						map.put(accomlist[a], day[i]);
					}
					
				}
			}
			
			if(translist != null) {			
				for (int t=0; t<translist.length; t++) {
					
					if((translist[t].substring(translist[t].length()-1)).equals(day[i])) {
						map.put(translist[t], day[i]);
					}
					
				}
			}
		}
		
		//System.out.println(map);
		
		String local = req.getParameter("local");
		String sdate = req.getParameter("sdate");
		String edate = req.getParameter("edate");
		String mcount = req.getParameter("mcount");
		String mbti = (String)session.getAttribute("mbti");
		
		//System.out.println(mbti);

		Date stdate;
		Date endate;
		int diffDays = 0;

		// 몇일인지 구하는것
		try {

			stdate = new SimpleDateFormat("yyyy-MM-dd").parse(sdate);
			endate = new SimpleDateFormat("yyyy-MM-dd").parse(edate);

			long diffSec = (endate.getTime() - stdate.getTime()) / 1000; // 초 차이
			diffDays = (int)(diffSec / (24 * 60 * 60)) + 1; // 일 차이

		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		/*
		// 날짜마다 해당되는 값 가져오기
		int spotcount = 0;
		int accomcount = 0;
		int transcount = 0;

		String spot[];
		String array[];
		String trans[];

		String spotname = "";
		String accomname = "";
		String transname = "";

		HashMap<String, String> map = new HashMap<String, String>();

		for (int i = 1; i <= diffDays; i++) {

			String spcount = req.getParameter(i + "spotcount");
			String account = req.getParameter(i + "accomcount");
			String trcount = req.getParameter(i + "transcount");
			
			System.out.printf("spcount: %d", spcount);
			System.out.printf("account: %d", account);
			System.out.printf("trcount: %d", trcount);

			
			if (spcount != "" && account != "" && trcount != "") {

				spotcount = Integer.parseInt(spcount) - 2;
				accomcount = Integer.parseInt(account) - 2;
				transcount = Integer.parseInt(trcount) - 2;

				spotname = i + "spotname";
				accomname = i + "accomname";
				transname = i + "transname";

				spot = req.getParameterValues("spotname");
				array = req.getParameterValues("accomname");
				trans = req.getParameterValues("transname");

				String day = "day" + i;

				for (int j = 1; j <= spotcount; j++) {

					map.put(day + j, spot[i - 1]);

				}
			}

		}
		
		*/
		
		int daylength = day.length;

		req.setAttribute("local", local);
		req.setAttribute("sdate", sdate);
		req.setAttribute("edate", edate);
		req.setAttribute("mcount", mcount);
		req.setAttribute("diffDays", diffDays);
		req.setAttribute("mbti", mbti);
		req.setAttribute("map", map);
		req.setAttribute("daylength", daylength);

		RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/plan/plandetail.jsp");
		dispatcher.forward(req, resp);

	}

}