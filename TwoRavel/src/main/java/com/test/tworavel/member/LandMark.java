package com.test.tworavel.member;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/member/landmark.do")
public class LandMark extends HttpServlet {
   @Override
   protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
      
      HttpSession session = req.getSession();
     
      req.setCharacterEncoding("UTF-8");
      resp.setCharacterEncoding("UTF-8");

      String mseq = (String)session.getAttribute("mseq");

      req.setAttribute("mseq", mseq);
      
      
      String lmname = req.getParameter("lmname");
      
      String lmseq = req.getParameter("lmseq");
      
      MemberDAO dao = new MemberDAO(); 
      
      LandMarkDTO result = dao.getLandMark(lmname); 
      
      if (result != null) {

         req.setAttribute("lmseq", result.getLmseq());
         req.setAttribute("lmname", result.getLmname());
         req.setAttribute("lmaddress", result.getLmaddress());
         req.setAttribute("lmcontent", result.getLmcontent());
         req.setAttribute("lmcount", result.getLmcount());
         req.setAttribute("lmlike", result.getLmlike());
         req.setAttribute("lmfile", result.getLmfile().toLowerCase());
         req.setAttribute("locseq", result.getLocseq());


      }
      
      // getLandMark 정보 받아서 한 줄 평가 내용 및 멤버 아이디 가져오기
      ArrayList<LandMarkDTO> olList = dao.oneLine(lmname);
      
      req.setAttribute("olList", olList);
      
      // lmseq 받아서 한 줄 평가 수 가져오기
      String oLCount = dao.getOLCount(lmseq);
      
      req.setAttribute("oLCount", oLCount);

      dao.addReadCount(lmseq);

      RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/member/landmark.jsp");
      dispatcher.forward(req, resp);

   }
}