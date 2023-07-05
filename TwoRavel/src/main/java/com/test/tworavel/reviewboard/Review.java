package com.test.tworavel.reviewboard;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.test.tworavel.member.LandMarkDTO;

@WebServlet("/reviewboard/review.do")
public class Review extends HttpServlet {
   @Override
   protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
      
      req.setCharacterEncoding("UTF-8");
      resp.setCharacterEncoding("UTF-8");
      
      HttpSession session = req.getSession();
      
      String mseq = (String)session.getAttribute("mseq");

      req.setAttribute("mseq", mseq);
      
      ReviewDAO dao = new ReviewDAO();
      
      ArrayList<ReviewDTO> rList = dao.getReviewAll();
      
      req.setAttribute("rList", rList);
      
      ArrayList<String> memberId = new ArrayList<String>();
      
      for (ReviewDTO dto : rList) {
         
         dto.getMsseq();
         
         String id = dao.getMemberId(dto.getMsseq());
                  
         memberId.add(id);
         
      }
      req.setAttribute("memberId", memberId);
      
      ArrayList<String> countList = new ArrayList<String>();
      
      for (ReviewDTO dto : rList) {
         
         dto.getRseq();
         
         String oLCount = dao.getCommentCount(dto.getRseq());
                  
         countList.add(oLCount);
         
      }
      req.setAttribute("cCount", countList);
      
      RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/reviewboard/review.jsp");
      dispatcher.forward(req, resp);

   }
}