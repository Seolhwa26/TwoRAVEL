package com.test.tworavel.plan;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/plan/planadd.do")
public class PlanAdd extends HttpServlet {

   @Override
   protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	   req.setCharacterEncoding("UTF-8");
	   
	   
	   PlanDAO dao2 = new PlanDAO();
	   
	   // 지역명 받아서 테마 정보 가져오기 + 지역명까지 전달
	   String local = req.getParameter("local");
	   
	   ArrayList<PlaceDTO> list = dao2.listPlace(local);
	   
	   
	   req.setAttribute("list", list);
	   
	     
	   // 지역명 받아서 지역의 seq, 위도, 경도, 날씨 지역코드 가져오기 + 전달 
	   LocalDTO dto = new LocalDTO();
	   
	   dto.setLocname(local);
	   
	   LocalDAO dao = new LocalDAO();
	   
	   LocalDTO result = dao.getLocal(dto);
	   
		if (result != null) {
			
			req.setAttribute("locseq", result.getLocseq());
			
			req.setAttribute("loclat", result.getLoclat());
			
			req.setAttribute("loclng", result.getLoclng());
			
			req.setAttribute("loccode", result.getLoccode());
			
		}
		
		// 지역명 받고 getLocal 결과값 중 하나인 seq를 받아서 숙박 정보 가져오기 + 전달
		AccomDAO adao = new AccomDAO();
		   
		ArrayList<AccomDTO> alist = adao.listAccom(result);
		
		req.setAttribute("alist", alist);
		
		
	      //유찬
	      //날짜값을 여기로 받아와야함
	      //String date = req.getParameter("date1");
	      
	      //유찬 추가 0104
	      //KTX
	      TransferDAO trdao = new TransferDAO();
	      
	      //array리스트
	      ArrayList<TransferDTO> trlist = trdao.getTrain(local);
	      

	      req.setAttribute("trlist", trlist);
	      
	      
	      //항공
	      TransferDAO fldao = new TransferDAO();
	      
	      //array리스트
	      ArrayList<TransferDTO> fllist = fldao.getFlight(local);
	      
	      
	      req.setAttribute("fllist", fllist);
	      
	      
	      //고속버스
	      TransferDAO busdao = new TransferDAO();
	      
	      //array리스트
	      ArrayList<TransferDTO> buslist = busdao.getBus(local);
	      
	      
	      req.setAttribute("buslist", buslist);   //여기까지 추가
	      
	   
	      req.setAttribute("local", local);
		
		
	    //설
	      OpiDTO dto1 = new OpiDTO();
	      
	      String pno = "1"; //해당 회원일정번호의 일정의견 조회
	      
	      PlanDAO dao1 = new PlanDAO();
	      
	      ArrayList<OpiDTO> list1 = dao1.list(pno);
	      
	      String boss = dao1.getBoss(pno);
	      
	      req.setAttribute("list1", list1);      
	      req.setAttribute("pno", pno);
	      req.setAttribute("boss", boss);
		
		
		
		req.setAttribute("local", local);
		
		
      RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/plan/planadd.jsp");

      dispatcher.forward(req, resp);

   }

}