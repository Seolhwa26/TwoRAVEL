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

@WebServlet("/plan/check.do")
public class Check extends HttpServlet {

   @Override
   protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

      HttpSession session = req.getSession();
      
      req.setCharacterEncoding("UTF-8");
      
      String local =req.getParameter("local");
      
      String id = req.getParameter("id");
      
      String stat = req.getParameter("stat");
      
      String pno = req.getParameter("pno");
      
      String cnt1 = req.getParameter("cnt1");
      
      int n = Integer.parseInt(cnt1) - Integer.parseInt(id);
      System.out.println(n);
      String no = n + "";
      
      PlanDAO dao = new PlanDAO();
      
      //2. 
      OpiDTO dto = new OpiDTO();
      
      int result = dao.check(no, stat, pno);
      
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