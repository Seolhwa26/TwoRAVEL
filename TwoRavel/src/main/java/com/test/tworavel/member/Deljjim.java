package com.test.tworavel.member;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/member/deljjim.do")
public class Deljjim extends HttpServlet {

   @Override
   protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

       //찜 목록 삭제
         String sseq = req.getParameter("sseq");
         String no = req.getParameter("no");
         
         MPlanDAO dao3 = new MPlanDAO();
         
         
         int result = dao3.deljjim(sseq, no);
         System.out.println(result);
         if (result == 1) {
            
            resp.sendRedirect("/tworavel/member/mypage.do");
            
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