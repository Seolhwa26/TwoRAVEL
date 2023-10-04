package com.test.tworavel.member;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.test.tworavel.plan.PlanDAO;
import com.test.tworavel.plan.PlanDTO;

@WebServlet("/member/participation.do")
public class Participation extends HttpServlet {
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	
		HttpSession session = req.getSession();
	
		MPlanDAO dao = new MPlanDAO();
	
		String sseq = req.getParameter("sseq");
		String mseq = (String)session.getAttribute("mseq");
	    
		//회원일정 정보로 일정번호 찾기
		String pseq = dao.mplanno(sseq);
		
		//중복 참여인지 확인 맞으면 알림창 
		MPlanDTO mdto = dao.inPlan(pseq, mseq);
		
		//겹치는 일정인지 확인
		PlanDAO pdao = new PlanDAO();
		PlanDTO pdto = pdao.findplan(pseq);
		
		String pname = pdao.checkplan(mseq, pdto);
		
		if (mdto.getMsseq() != null) {
			
			req.setCharacterEncoding("UTF-8");
			resp.setContentType("text/html; charset=UTF-8");
	
			PrintWriter writer = resp.getWriter();
	        writer.print("<script>");
	        writer.print("alert('이미 참여 중인 일정입니다.');");
	        writer.print("history.back();");
	        writer.print("</script>");
	        writer.close();  
			
		} else if (pname != null) {
		
			req.setCharacterEncoding("UTF-8");
			resp.setContentType("text/html; charset=UTF-8");
				
			PrintWriter writer = resp.getWriter();
			writer.print("<script>");
			writer.print("alert('<<" + pname + ">>과 동일한 일정이 존재합니다.');");
			writer.print("window.location.href = '/tworavel/member/mypage.do';");
			writer.print("</script>");
			writer.close(); 
			
		} else {    
		
			//중복 참여 아니면 실행
			
			int result = dao.addmparti(mseq, pseq);
			System.out.println("결과 1:" + result);
			
			MPlanDTO dto = dao.mplanInfo(mseq, pseq);
			
			//인원수 == 모집수 > 모집여부 n 수정
			if (dto.getPmcount().equals(dto.getParticount())) {
				
				result *= dao.updatePlan(pseq);
				System.out.println("결과 2:" + result);
			}
			
			mdto = dao.planName(pseq, mseq);
			
			if (result == 1) {
				
				req.setCharacterEncoding("UTF-8");
				resp.setContentType("text/html; charset=UTF-8");
		
				PrintWriter writer = resp.getWriter();
		        writer.print("<script>");
		        writer.print("alert('<<" + mdto.getPname() + ">> 일정에 참여되었습니다.');");
		        writer.print("window.location.href = '/tworavel/member/mypage.do';");
		        writer.print("</script>");
		        writer.close();  
		         
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
}
