package com.test.tworavel.main;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/main/main.do")
public class Main extends HttpServlet {
   @Override
   protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
      
      req.setCharacterEncoding("UTF-8");
      
      BPlanDTO dto = new BPlanDTO();
      
      BPlanDAO dao = new BPlanDAO();
      
      ArrayList<BPlanDTO> list = dao.list();
      
      req.setAttribute("list", list);
      
      RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/main/main.jsp");
      dispatcher.forward(req, resp);

   }
}




