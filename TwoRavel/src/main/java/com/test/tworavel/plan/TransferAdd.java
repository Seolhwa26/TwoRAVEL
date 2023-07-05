package com.test.tworavel.plan;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;




@WebServlet("/plan/transferadd.do")
public class TransferAdd extends HttpServlet {

   @Override
   protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

      String transname = req.getParameter("transname");
      String transname2 = req.getParameter("transname");
      String transname3 = req.getParameter("transname");

      String day = req.getParameter("day");
      
      //필요한 dao, dto 호출
      
      TransferDAO tdao = new TransferDAO();
       TransferDTO tdto = new TransferDTO();

      //transferdto 가져온 이름
       
    
      tdto.setTrnum(transname);
   
      tdto.setBnum(transname);
      
      tdto.setFnum(transname);
       

       //tdto.setBnum(transname2);
       //tdto.setFnum(transname3);
       
       TransferDTO tresult = tdao.getTrainName(tdto);
       TransferDTO bresult = tdao.getBusName(tdto);
       TransferDTO fresult = tdao.getFlightName(tdto);
       
       

       resp.setCharacterEncoding("UTF-8");
       resp.setContentType("application/json");

       PrintWriter writer = resp.getWriter();

       JSONObject obj = new JSONObject();
         
         
       obj.put("day", day);
       obj.put("transname", transname != null ? transname : "");
       //obj.put("transname2", transname2);
       //obj.put("transname3", transname3);

       
       if (tresult != null) {
          obj.put("trnum", tresult.getTrnum());          
       } else {
          obj.put("trnum", "");
       }
       
       if (bresult != null) {
          obj.put("bnum", bresult.getBnum());          
       } else {
          obj.put("bnum", "");
       }
       
       if (fresult != null) {
          obj.put("fnum", fresult.getFnum());          
       } else {
          obj.put("fnum", "");
       }

       writer.print(obj);

       writer.close();


   }

}