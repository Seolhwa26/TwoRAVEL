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

@WebServlet("/member/mypage.do")
public class MyPage extends HttpServlet {

   @Override
   protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

     req.setCharacterEncoding("UTF-8");
     
      HttpSession session = req.getSession();
      
      //회원번호 + 이름 얻어오기
      String id = (String)session.getAttribute("auth");

      MPlanDAO dao = new MPlanDAO();
      
      String noname = dao.getName(id);
      
      String name = noname.substring(0, 3);
      
      String no = noname.substring(3);
      
      req.setAttribute("name", name);
      
      //일정정보 조회
      MPlanDTO dto = new MPlanDTO();
      
      ArrayList<MPlanDTO> list = dao.list(no);
      
      req.setAttribute("list", list);
      
      ArrayList<MPlanDTO> list2 = dao.list2(no);
      
      req.setAttribute("list2", list2);
      req.setAttribute("no", no);

     
      RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/member/mypage.jsp");
      dispatcher.forward(req, resp);

   }

}