package com.test.tworavel.member;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/member/joinok.do")
public class JoinOk extends HttpServlet {

   @Override
   protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

      //joinok.java
      //1. 인코딩
      //2. 데이터 가져오기
      //3. DB 작업 > DAO 위임 > insert
      //4. 결과
      //5. 피드백
      
      //1.
      req.setCharacterEncoding("UTF-8");
      
      //2. 
      String id = "";
      String pw = "";
      String mname = "";
      String gender = "";
      String mtel = "";
      String mptel = "";
      String jumin = "";
      String maddress = "";
      String email = "";
      String mbti = "";
      
      int result = 0;
      
      //3. 
      
      id = req.getParameter("id");
      pw = req.getParameter("pw");
      mname = req.getParameter("mname");
      gender = req.getParameter("gender");
      mtel = req.getParameter("mtel");
      mptel = req.getParameter("mptel");
      jumin = req.getParameter("jumin");
      maddress = req.getParameter("maddress");
      email = req.getParameter("email");
      mbti = req.getParameter("mbti");

      
      //4.
      MemberDTO dto = new MemberDTO();
      
      dto.setId(id);
      dto.setPw(pw);
      dto.setMname(mname);
      dto.setGender(gender);
      dto.setMtel(mtel);
      dto.setMptel(mptel);
      dto.setJumin(jumin);
      dto.setMaddress(maddress);
      dto.setEmail(email);
      dto.setMbti(mbti);
      
      System.out.println(dto);
      
      MemberDAO dao = new MemberDAO();
      
      //4 + 5.
      result = dao.joinMember(dto);
      
      
      if (result == 1) {
         RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/member/joinok.jsp");
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