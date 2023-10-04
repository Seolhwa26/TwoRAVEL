package com.test.tworavel.shareboard;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import com.test.tworavel.main.DBUtil;

public class ShareDAO {

	private Connection conn = null;
	private Statement stat = null;
	private PreparedStatement pstat = null;
	private ResultSet rs = null;

	public ShareDAO() {
		conn = DBUtil.open();
	}

	// 일정 공유
	public ArrayList<ShareDTO> list() {

		try {
			
			String sql = "";
			
			sql = "select sseq, pname, locname, pstart, pend, ptheme, pconnect, slike, scount, mbti, pmcount, particount from vwshareplan";
			
			
			pstat = conn.prepareStatement(sql);
			
			rs = pstat.executeQuery();
			
			ArrayList<ShareDTO> list = new ArrayList<ShareDTO>();
			
			while (rs.next()) {
				
				ShareDTO dto = new ShareDTO();
				
				dto.setSseq(rs.getString("sseq"));
				dto.setPname(rs.getString("pname"));
				dto.setLocname(rs.getString("locname"));
				dto.setPstart(rs.getString("pstart").substring(0,10));
				dto.setPend(rs.getString("pend").substring(0,10));
				dto.setPtheme(rs.getString("ptheme"));
				dto.setPconnect(rs.getString("pconnect"));
				dto.setScount(rs.getString("scount"));
				dto.setSlike(rs.getString("slike"));
				dto.setMbti(rs.getString("mbti"));
				dto.setPmcount(rs.getString("pmcount"));
				dto.setParticount(rs.getString("particount"));
				
				list.add(dto);
				
			}
			
			return list;
			
		} catch (Exception e) {
			System.out.println("ShareDAO.list");
			e.printStackTrace();
		}
		
		return null;
	}

}
