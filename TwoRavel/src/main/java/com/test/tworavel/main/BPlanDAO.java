package com.test.tworavel.main;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

public class BPlanDAO {

   private Connection conn = null;
   private Statement stat = null;
   private PreparedStatement pstat = null;
   private ResultSet rs = null;
      
   public BPlanDAO() {
      conn = DBUtil.open();
   }
      
   public ArrayList<BPlanDTO> list() {

      try {
         
         String sql = "select * from (select v.*, dense_rank() over (order by slike desc) rank from vwplan v) where rank <= 3";
         
         stat = conn.createStatement();
         
         rs = stat.executeQuery(sql);
         
         ArrayList<BPlanDTO> list = new ArrayList<BPlanDTO>();
         
         while(rs.next()) {
            
            BPlanDTO dto = new BPlanDTO();
            
            dto.setSseq(rs.getString("sseq"));
            dto.setPname(rs.getString("pname"));
            dto.setLocname(rs.getString("locname"));
            dto.setMname(rs.getString("mname"));
            dto.setSlike(rs.getString("slike"));
            dto.setPtheme(rs.getString("ptheme"));
            dto.setRank(rs.getString("rank"));
            
            list.add(dto);
            
         }
         
         return list;
         
      } catch (Exception e) {
         System.out.println("BPlanDAO.list");
         e.printStackTrace();
      }
      
      return null;
   }

}