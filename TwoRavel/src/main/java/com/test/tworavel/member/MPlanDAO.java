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

   
   public ArrayList<MPlanDTO> list(String mseq) {

      try {
      
         String sql = "select vwmp.*, vwl.locname from vwmypageplan vwmp inner join vwloc vwl on vwmp.pseq = vwl.pseq where mseq = ?";
         
         pstat = conn.prepareStatement(sql);
         
         pstat.setString(1, mseq);
         
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
            dto.setParticount(rs.getString("particount"));
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

   
   public ArrayList<MPlanDTO> list2(String mseq) {

      try {
         
         String sql = "select * from vwmjjim where mseq = ?";
         
         pstat = conn.prepareStatement(sql);
         
         pstat.setString(1, mseq);
         
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
            dto2.setParticount(rs.getString("particount"));
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

   
   public int deljjim(String sseq, String mseq) {

      try {
         
         String sql = "delete from tbllike where mseq = ? and sseq = ?";
         
         pstat = conn.prepareStatement(sql);
         
         pstat.setString(1, mseq);
         pstat.setString(2, sseq);
   
         return pstat.executeUpdate();
         
      } catch (Exception e) {
         System.out.println("MPlanDAO.deljjim");
         e.printStackTrace();
      }
      
      return 0;
   }

   
   public String mplanno(String sseq) {
	   try {
	         
	      String sql = "select pseq from tblShare where sseq = ?";
	         
	      pstat = conn.prepareStatement(sql);
	         
	      pstat.setString(1, sseq);
	         
	      rs = pstat.executeQuery();
	         
	      if (rs.next()) {
	         String pseq = rs.getString("pseq");
	            
	         return pseq;
	      }
	         
	   } catch (Exception e) {
	      System.out.println("MPlanDAO.mplanno");
	      e.printStackTrace();
	   }
	      
	   return null;
   }

   
   public int addmplan(String npseq, String mseq) {
	  
	   try {
	         
	      String sql = "insert into tblmschedule(msseq, mseq, pseq, msauth) values ((select nvl(max(msseq), 0) + 1 from tblmschedule), ?, ?, 1)";
	         
	      pstat = conn.prepareStatement(sql);
	         
	      pstat.setString(1, mseq);
	      pstat.setString(2, npseq);
	   
	      return pstat.executeUpdate();
	         
	   } catch (Exception e) {
	      System.out.println("MPlanDAO.addmplan");
	      e.printStackTrace();
	   }
	   return 0;
   }

   public int addmparti(String mseq, String pseq) {

	   try {
	         
		      String sql = "insert into tblmschedule(msseq, mseq, pseq, msauth) values ((select nvl(max(msseq), 0) + 1 from tblmschedule), ?, ?, 2)";
		         
		      pstat = conn.prepareStatement(sql);
		         
		      pstat.setString(1, mseq);
		      pstat.setString(2, pseq);
		   
		      return pstat.executeUpdate();
		         
		   } catch (Exception e) {
		      System.out.println("MPlanDAO.addmparti");
		      e.printStackTrace();
		   }
		   return 0;
   }


   public MPlanDTO mplanInfo(String mseq, String pseq) {
	   try {
	         
	         String sql = "select * from vwmjjim where mseq = ? and pseq = ?";
	         
	         pstat = conn.prepareStatement(sql);
	         
	         pstat.setString(1, mseq);
	         pstat.setString(2, pseq);
	         
	         rs = pstat.executeQuery();
	         
	         MPlanDTO dto = new MPlanDTO();
	         
	         while (rs.next()) {
	            
	            dto.setPmcount(rs.getString("pmcount")); 
	            dto.setParticount(rs.getString("particount"));
	            
	         }
	         
	         return dto;
	         
	      } catch (Exception e) {
	         System.out.println("MPlanDAO.mplanInfo");
	         e.printStackTrace();
	      }
	      
	      return null;
   }


   public int updatePlan(String pseq) {

	   try {

			String sql = "update tblPlan set pconnect = 'n' where pseq = ?";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, pseq);

			return pstat.executeUpdate();

		} catch (Exception e) {
			System.out.println("PlanDAO.updatePlan");
			e.printStackTrace();
		}

		return 0;
		
   }


   public MPlanDTO planName(String pseq, String mseq) {
	   
	   try {
	         
	         String sql = "select vwmp.*, vwl.locname from vwmypageplan vwmp inner join vwloc vwl on vwmp.pseq = vwl.pseq where vwmp.pseq = ? and mseq = ?";
	         
	         pstat = conn.prepareStatement(sql);
	         
	         pstat.setString(1, pseq);
	         pstat.setString(2, mseq);
	         
	         rs = pstat.executeQuery();
	         
	         MPlanDTO dto = new MPlanDTO();
	         
	         while (rs.next()) {
	            
	            dto.setPname(rs.getString("pname")); 
	            
	         }
	         
	         return dto;
	         
	      } catch (Exception e) {
	         System.out.println("MPlanDAO.planName");
	         e.printStackTrace();
	      }
	      
	      return null;
	   
   }


   public MPlanDTO inPlan(String pseq, String mseq) {
	   
	   try {
	         
	         String sql = "select * from tblMschedule where pseq = ? and mseq = ?";
	         
	         pstat = conn.prepareStatement(sql);
	         
	         pstat.setString(1, pseq);
	         pstat.setString(2, mseq);
	         
	         rs = pstat.executeQuery();
	         
	         MPlanDTO dto = new MPlanDTO();
	         
	         while (rs.next()) {
	            
	            dto.setMsseq(rs.getString("msseq")); 
	            dto.setMsauth(rs.getString("msauth"));
	            
	         }
	         
	         return dto;
	         
	      } catch (Exception e) {
	         System.out.println("MPlanDAO.inPlan");
	         e.printStackTrace();
	      }
	      
	      return null;
	      
   }

   
}