package com.test.tworavel.plan;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

@WebServlet("/plan/placeadd.do")
public class PlaceAdd extends HttpServlet {

   @Override
   protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

      req.setCharacterEncoding("UTF-8");
      
      // 장소 등록하기 버튼 누른경우
      String local = req.getParameter("local");
      String plname = req.getParameter("plname");
      String lat = req.getParameter("lat");
      String lng = req.getParameter("lng");
      String theme = req.getParameter("theme");

      PlanDAO dao2 = new PlanDAO();
      PlaceDTO pdto = new PlaceDTO();
      
      LocalDAO dao = new LocalDAO();
      String locseq = dao.getLocalSeq(local);

      pdto.setPlname(plname);
      pdto.setPllat(lat);
      pdto.setPllng(lng);
      pdto.setPtheme(theme);
      pdto.setLocseq(locseq);

      int addResult = dao2.addPlace(pdto);
      

      resp.setCharacterEncoding("UTF-8");
      resp.setContentType("application/json");

      PrintWriter writer = resp.getWriter();
      
      JSONObject obj = new JSONObject();
      
      obj.put("addResult", addResult);
      obj.put("lat", lat);
      obj.put("lng", lng);
      
      writer.print(obj);
      
      
      writer.close();
   
   }

}