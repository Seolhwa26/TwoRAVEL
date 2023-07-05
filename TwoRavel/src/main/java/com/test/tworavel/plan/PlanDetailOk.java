package com.test.tworavel.plan;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/plan/plandetailok.do")
public class PlanDetailOk extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		req.setCharacterEncoding("UTF-8");
		
		HttpSession session = req.getSession();
		//일정명, 공유여부, 인원 모집 여부, 테마
		
		String local = req.getParameter("local");
		String pname = req.getParameter("pname");
		String sdate = req.getParameter("sdate");
		String edate = req.getParameter("edate");
		String mc = req.getParameter("mcount");
		String mbti = req.getParameter("mbti");
		String theme = req.getParameter("theme");
		String share = req.getParameter("cb1");
		String recruit = req.getParameter("cb2");
		
		if(share != null) {
			share = "y";
		} else {
			share = "n";
		}
		
		if(recruit != null) {
			recruit = "y";
		} else {
			recruit = "n";
		}


		//System.out.println(share);
		//System.out.println(recruit);
		
		int result = 0;
		int mresult = 0;
		int mcount = 0;
		
		if (mc != null) {
			mcount = Integer.parseInt(mc);
		} 
		
		//여기서 해야할 것
		//일정 db에 저장하기 > mbti 로그인한 회원 db에 저장하기 update시키기
		//시작일, 종료일, 일정명, 공유여부, 인원 모집 여부, 인원수, 테마 모두 저장
		
		PlanDAO pdao = new PlanDAO();
		PlanDTO pdto = new PlanDTO();
		
		String id = (String)session.getAttribute("auth");
		
		pdto.setId((String)session.getAttribute("auth"));
		pdto.setPstart(sdate);
		pdto.setPend(edate);
		pdto.setPname(pname);
		pdto.setPshare(share);
		pdto.setPconnect(recruit);
		pdto.setPmcount(mcount);
		pdto.setPtheme(theme);
		
		pdto.setLocal(local);

		System.out.println(sdate);
		
		result = pdao.setPlan(pdto);
		
		System.out.println(result);
		
		mresult = pdao.setMBTI(id, mbti);
		
		System.out.println(mresult);
		
		//넘겨줄 데이터 > 지역명, 시작일, 종료일, 인원수, 
		
		
	      if (result == 1 && mresult == 1) {
	          RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/plan/planview.jsp");
	          dispatcher.forward(req, resp);
	          
	       } else {
	          
	          PrintWriter writer = resp.getWriter();
	          writer.print("<script>");
	          writer.print("alert('failed');");
	          writer.print("history.back();");
	          writer.print("</script>");
	          writer.close();
	          
	       }



	}

}
