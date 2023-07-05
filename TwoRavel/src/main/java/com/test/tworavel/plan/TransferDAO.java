package com.test.tworavel.plan;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import com.test.tworavel.main.DBUtil;

public class TransferDAO {

      private Connection conn = null;
      private Statement stat = null;
      private PreparedStatement pstat = null;
      private ResultSet rs = null;
      
      public TransferDAO() {
         conn = DBUtil.open();
      }


      ///츄가
      


      public ArrayList<TransferDTO> getTrain(String local) {

         try {
            
            String sql = "select tr.trnum as trnum, tr.trtime as trtime, lo.locname as splace, lo2.locname as eplace from tbltrain tr \r\n"
                  + "            inner join tbllocal lo\r\n"
                  + "                on tr.trstart = lo.locseq  \r\n"
                  + "                    inner join tbllocal lo2\r\n"
                  + "                        on tr.trend = lo2.locseq where lo.locname = ?";
            
            pstat = conn.prepareStatement(sql);
            
            pstat.setString(1, local);
            //pstat.setString(2, date);
            
            rs = pstat.executeQuery();
            
            ArrayList<TransferDTO> trlist = new ArrayList<TransferDTO>();
            
            while(rs.next()) {
               
               TransferDTO trdto = new TransferDTO();
               
               trdto.setTrnum(rs.getString("trnum"));
               trdto.setTrtime(rs.getString("trtime"));
               trdto.setSplace(rs.getString("splace"));
               trdto.setEplace(rs.getString("eplace"));
               
               trlist.add(trdto);
            }
            
            return trlist;
            
         } catch (Exception e) {
            System.out.println("TransferDAO.get");
            e.printStackTrace();
         }
         
         return null;
      }

      
      public ArrayList<TransferDTO> getBus(String local) {
         
         try {
            
            String sql = "select bus.*, lo.locname as splace, lo2.locname as eplace from tblbus bus \r\n"
                  + "            inner join tbllocal lo\r\n"
                  + "                on bus.bstart = lo.locseq  \r\n"
                  + "                    inner join tbllocal lo2\r\n"
                  + "                        on bus.bend = lo2.locseq where lo.locname = ?";
            
            pstat = conn.prepareStatement(sql);
            
            pstat.setString(1, local);
            
            rs = pstat.executeQuery();
            
            ArrayList<TransferDTO> buslist = new ArrayList<TransferDTO>();
            
            while(rs.next()) {
               
               TransferDTO busdto = new TransferDTO();
               
               busdto.setBnum(rs.getString("bnum"));
               busdto.setBtime(rs.getString("btime"));
               busdto.setSplace(rs.getString("splace"));
               busdto.setEplace(rs.getString("eplace"));
               
               buslist.add(busdto);
            }
            
            return buslist;
            
         } catch (Exception e) {
            System.out.println("TransferDAO.get");
            e.printStackTrace();
         }
         
         return null;
      }
      
      
      public ArrayList<TransferDTO> getFlight(String local) {
         
         try {
            
            String sql = "select fl.*, lo.locname as splace, lo2.locname as eplace from tblflight fl \r\n"
                  + "            inner join tbllocal lo\r\n"
                  + "                on fl.fstart = lo.locseq  \r\n"
                  + "                    inner join tbllocal lo2\r\n"
                  + "                        on fl.fend = lo2.locseq where lo.locname = ?";
            
            pstat = conn.prepareStatement(sql);
            
            pstat.setString(1, local);
            
            rs = pstat.executeQuery();
            
            ArrayList<TransferDTO> fllist = new ArrayList<TransferDTO>();
            
            while(rs.next()) {
               
               TransferDTO fldto = new TransferDTO();
               
               fldto.setFnum(rs.getString("fnum"));
               fldto.setFtime(rs.getString("ftime"));
               fldto.setSplace(rs.getString("splace"));
               fldto.setEplace(rs.getString("eplace"));
               
               fllist.add(fldto);
            }
            
            return fllist;
            
         } catch (Exception e) {
            System.out.println("TransferDAO.get");
            e.printStackTrace();
         }
         
         return null;
      }


      
      public TransferDTO getTrainName(TransferDTO tdto) {

          try {
             
             String sql = "select * from tblTrain where trnum = ?";
             
               pstat = conn.prepareStatement(sql);
                
               pstat.setString(1, tdto.getTrnum());

               rs = pstat.executeQuery();
                
               if(rs.next()) {
                  
                  TransferDTO tresult = new TransferDTO();
                   
                   tdto.setTrnum(rs.getString("trnum"));

                   return tdto;
                   
                }
             
          } catch (Exception e) {
             System.out.println("TransferDAO.getTrainName");
             e.printStackTrace();
          }
          
          
          return null;
       }

 //
       public TransferDTO getBusName(TransferDTO tdto) {

          try {
             
             String sql = "select * from tblBus where bnum = ?";
             
               pstat = conn.prepareStatement(sql);
                
               pstat.setString(1, tdto.getBnum());

               rs = pstat.executeQuery();
                
               if(rs.next()) {
                  
                  TransferDTO bresult = new TransferDTO();
                   
                   tdto.setBnum(rs.getString("bnum"));
                
                   return tdto;
                   
                }
             
          } catch (Exception e) {
             System.out.println("TransferDAO.getBusName");
             e.printStackTrace();
          }
          return null;
       }
       
       
       public TransferDTO getFlightName(TransferDTO tdto) {
          
          try {
             
             String sql = "select * from tblFlight where fnum = ?";
             
             pstat = conn.prepareStatement(sql);
             
             pstat.setString(1, tdto.getFnum());
             
             rs = pstat.executeQuery();
             
             if(rs.next()) {
                
                TransferDTO fresult = new TransferDTO();
                
                tdto.setFnum(rs.getString("fnum"));
                
                return tdto;
                
             }
             
          } catch (Exception e) {
             System.out.println("TransferDAO.getFlightName");
             e.printStackTrace();
          }
          return null;
       }
       
       
      
      
      
   
}