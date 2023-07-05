package com.test.tworavel.member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import com.test.tworavel.main.DBUtil;

public class MPlanDAO {

   private Connection conn = null;
   private Statement stat = null;
   private PreparedStatement pstat = null;
   private ResultSet rs = null;

   public MPlanDAO() {
      conn = DBUtil.open();
   }

   public String getName(String id) {

      try {
         
         String sql = "select mseq, mname from tblMember where id = ?";
         
         pstat = conn.prepareStatement(sql);
         
         pstat.setString(1, id);
         
         rs = pstat.executeQuery();
         
         if (rs.next()) {
            String name = rs.getString("mname");
            String mseq = rs.getString("mseq");
            
            String noname = name + mseq;
            
            return noname;
         }
         
      } catch (Exception e) {
         System.out.println("MPlanDAO.getName");
         e.printStackTrace();
      }
      
      return null;
   }

   public ArrayList<MPlanDTO> list(String no) {

      try {
      
         String sql = "select * from vwmyplan where mseq = ?";
         
         pstat = conn.prepareStatement(sql);
         
         pstat.setString(1, no);
         
         rs = pstat.executeQuery();
         
         ArrayList<MPlanDTO> list = new ArrayList<MPlanDTO>();
         
         while (rs.next()) {
            
            MPlanDTO dto = new MPlanDTO();
            
            dto.setMsauth(rs.getString("msauth"));
            if (rs.getString("pname").length() > 9) {
                  dto.setPname(rs.getString("pname").substring(0, 9) + "..");
              } else {               
                  dto.setPname(rs.getString("pname"));
              }
            dto.setPstart(rs.getString("pstart").substring(0, 10));
            dto.setPend(rs.getString("pend").substring(0, 10));
            dto.setLocname(rs.getString("locname"));
            dto.setPtheme(rs.getString("ptheme"));
            dto.setCo(rs.getString("co"));
            dto.setPmcount(rs.getString("pmcount"));
            
            list.add(dto);
            System.out.println(list);
         }
         System.out.println(list);
         return list;
         
      } catch (Exception e) {
         System.out.println("MPlanDAO.list");
         e.printStackTrace();
      }
      
      return null;
   }

   public ArrayList<MPlanDTO> list2(String no) {

      try {
         
         String sql = "select * from vwjjim where mlseq = ?";
         
         pstat = conn.prepareStatement(sql);
         
         pstat.setString(1, no);
         
         rs = pstat.executeQuery();
         
         ArrayList<MPlanDTO> list2 = new ArrayList<MPlanDTO>();
         
         while (rs.next()) {
            
            MPlanDTO dto2 = new MPlanDTO();
            
            dto2.setSseq(rs.getString("sseq"));
            dto2.setPname(rs.getString("pname"));
            dto2.setLocname(rs.getString("locname"));
            dto2.setPstart(rs.getString("pstart").substring(0, 10));
            dto2.setPend(rs.getString("pend").substring(0, 10));
            dto2.setPtheme(rs.getString("ptheme"));
            dto2.setPconnect(rs.getString("pconnect"));
            dto2.setCo(rs.getString("co"));
            dto2.setPmcount(rs.getString("pmcount"));
            dto2.setSlike(rs.getString("slike"));
            dto2.setScount(rs.getString("scount"));
            
            list2.add(dto2);
            
         }
         
         return list2;
      } catch (Exception e) {
         System.out.println("MPlanDAO.list2");
         e.printStackTrace();
      }
      
      return null;
   }

   public int deljjim(String sseq, String no) {

      try {
         
         String sql = "delete from tbllike where mseq = ? and sseq = ?";
         
         pstat = conn.prepareStatement(sql);
         
         pstat.setString(1, no);
         pstat.setString(2, sseq);
   
         return pstat.executeUpdate();
         
      } catch (Exception e) {
         System.out.println("MPlanDAO.deljjim");
         e.printStackTrace();
      }
      
      return 0;
   }
   
}