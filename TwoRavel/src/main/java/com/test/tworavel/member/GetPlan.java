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
import com.test.tworavel.plan.TransferDAO;
import com.test.tworavel.plan.TransferDTO;

@WebServlet("/member/getPlan.do")
public class GetPlan extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

	  
	     
	  HttpSession session = req.getSession();
	  
	  MPlanDAO dao = new MPlanDAO();
	  
	  String sseq = req.getParameter("sseq");
	  String mseq = (String)session.getAttribute("mseq");
	 
	  //회원일정 정보로 일정번호 찾기
	  String pseq = dao.mplanno(sseq);
	  
	  //일정번호 찾음 > dto로 데이터 가져오기 1
	  PlanDAO pdao = new PlanDAO();
	  PlanDTO pdto = pdao.findplan(pseq);
	
	  //겹치는 일정인지 확인
	  String pname = pdao.checkplan(mseq, pdto);
	 
	  if (pname != null) {
		  
		  req.setCharacterEncoding("UTF-8");
		  resp.setContentType("text/html; charset=UTF-8");
			
		  PrintWriter writer = resp.getWriter();
		  writer.print("<script>");
		  writer.print("alert('<<" + pname + ">>과 동일한 일정이 존재합니다.');");
		  writer.print("window.location.href = '/tworavel/member/mypage.do';");
		  writer.print("</script>");
		  writer.close();  
		  
	  } else {
		
		  int result = pdao.addplan(pdto);
		  System.out.println("결과 1:" + result);
					  
		  //추가한 시퀀스 가져오기
		  String npseq = pdao.findnpseq();
					  
		  //회원일정테이블에 추가 2
		  result *= dao.addmplan(npseq, mseq); 
		  System.out.println("결과 2:" + result);
					  
		  //교통테이블에 데이터 추가 3
		  TransferDAO tdao = new TransferDAO();
		  TransferDTO tdto = tdao.findplan(pseq);
		  result *= tdao.addtransfer(npseq, tdto);
		  System.out.println("결과 3:" + result);
				
		  MPlanDTO mdto = dao.planName(npseq, mseq);

		  if (result == 1) {
				    	  
		     req.setCharacterEncoding("UTF-8");
			 resp.setContentType("text/html; charset=UTF-8");
			
			 PrintWriter writer = resp.getWriter();
			 writer.print("<script>");
			 writer.print("alert('<<" + mdto.getPname() + ">> 일정을 가져왔습니다.');");
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
