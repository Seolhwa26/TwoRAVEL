package com.test.tworavel.member;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.test.tworavel.plan.LocalDTO;

@WebServlet("/member/landmarklist.do")
public class LandMarkList extends HttpServlet {
   @Override
   protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
      
      // 랜드마크 정보
      
      req.setCharacterEncoding("UTF-8");
       resp.setCharacterEncoding("UTF-8");
      
      MemberDAO dao = new MemberDAO();
      
      ArrayList<LandMarkDTO> alist = dao.listLandmark();
      
      for (LandMarkDTO dto : alist) {
         
         dto.setLmfile(dto.getLmfile().toLowerCase());
         
      }
      
      req.setAttribute("alist", alist);
      
      // 랜드마크의 한 줄 평가 수
      ArrayList<String> countList = new ArrayList<String>();
      
      for (LandMarkDTO dto : alist) {
         
         dto.getLmseq();
         
         String oLCount = dao.getOLCount(dto.getLmseq());
                  
         countList.add(oLCount);
         
      }
      req.setAttribute("oLCount", countList);
      
      
      // 지역명 + 지역에 있는 랜드마크 수 
      ArrayList<LocalDTO> loclist = dao.getLocal();
      
      ArrayList<String> locresult = new ArrayList<String>();

      for (LocalDTO dto : loclist) {

         dto.getLocseq();

         String locCount = dao.getlocCount(dto.getLocseq());

         locresult.add(locCount);

      }
            
      req.setAttribute("locresult", locresult);
      req.setAttribute("loclist", loclist);
      
      RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/member/landmarklist.jsp");
      dispatcher.forward(req, resp);

   }
}