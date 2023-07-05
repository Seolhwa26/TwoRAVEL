package com.test.tworavel.plan;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import com.test.tworavel.main.DBUtil;

public class LocalDAO {
	private Connection conn;
	private Statement stat;
	private PreparedStatement pstat;
	private ResultSet rs;
	
	public LocalDAO() {
		conn = DBUtil.open();
	}

	// 지역명 받아서 seq,위도,경도,날씨 지역 코드 가져오기
	public LocalDTO getLocal(LocalDTO dto) {
		
		try {
			String sql ="select locseq, loclat , loclng , loccode from tblLocal where locname = ?";
			
			pstat = conn.prepareStatement(sql);
			
			pstat.setString(1, dto.getLocname());
			
			rs = pstat.executeQuery();
			
			if(rs.next()) {
				LocalDTO result = new LocalDTO();
				
				dto.setLocseq(rs.getString("locseq"));
				dto.setLoclat(rs.getString("loclat"));
				dto.setLoclng(rs.getString("loclng"));
				dto.setLoccode(rs.getString("loccode"));
				
				return dto;		
			}
			
			
		} catch (Exception e) {
			System.out.println("LocalDAO.getLocal");
			e.printStackTrace();
		}
		return null;
	}
	
	//23.01.04 지현 추가내용
	   public String getLocalSeq(String local) {
	      
	      try {
	         String sql ="select locseq from tblLocal where locname = ?";
	         
	         pstat = conn.prepareStatement(sql);
	         
	         pstat.setString(1, local);
	         
	         rs = pstat.executeQuery();
	         
	         if(rs.next()) {
	            
	            return rs.getString("locseq");      
	         }
	         
	         
	      } catch (Exception e) {
	         System.out.println("LocalDAO.getLocal");
	         e.printStackTrace();
	      }
	      return null;
	   }
}
