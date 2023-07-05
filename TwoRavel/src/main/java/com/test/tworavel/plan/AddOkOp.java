package com.test.tworavel.plan;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/plan/addokop.do")
public class AddOkOp extends HttpServlet {

   @Override
   protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

      //AddOkOp.java
      //1. 인코딩 + 데이터 가져오기
      //2. DB 작업 + DAO 위임 > insert
      //3. 결과
      //4. 피드백
      
      HttpSession session = req.getSession();
      
      //1.
      req.setCharacterEncoding("UTF-8");
      
      String local =req.getParameter("local");
   
      String opinion = req.getParameter("opinion");
      opinion = opinion.replace("\r\n", "<br>");
      
      String pno = req.getParameter("pno");
      
      PlanDAO dao = new PlanDAO();
      
      //2. 
      OpiDTO dto = new OpiDTO();
      
      dto.setOid((String)session.getAttribute("auth"));
      
      dto.setOcontent(opinion);
      
      dto.setOcheck("n");
      
      int result = dao.add(dto, pno); 
      
      if (result == 1) {
         
          String encodedParam = URLEncoder.encode(local, "UTF-8");
            
            resp.sendRedirect("/tworavel/plan/planadd.do?local="+encodedParam);
         
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