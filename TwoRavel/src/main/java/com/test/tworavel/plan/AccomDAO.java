package com.test.tworavel.plan;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import com.test.tworavel.main.DBUtil;

public class AccomDAO {
	private Connection conn;
	private Statement stat;
	private PreparedStatement pstat;
	private ResultSet rs;

	public AccomDAO() {
		conn = DBUtil.open();
	}

	// 지역번호를 받아서  숙박 seq,이름,주소,가격,지역번호seq 가져오기
	public ArrayList<AccomDTO> listAccom(LocalDTO result) {
		try {
			String sql = "select * from tblAccom where locseq = ?";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, result.getLocseq());

			rs = pstat.executeQuery();

			ArrayList<AccomDTO> alist = new ArrayList<AccomDTO>();

			while(rs.next()) {

				AccomDTO dto = new  AccomDTO();

				dto.setAseq(rs.getString("aseq"));
				dto.setAname(rs.getString("aname"));
				dto.setAaddress(rs.getString("aaddress"));
				dto.setAprice(rs.getString("aprice"));
				dto.setLocseq(rs.getString("locseq"));

				alist.add(dto);

			}

			return alist;

		} catch (Exception e) {
			System.out.println("AccomDAO.listAccom");
			e.printStackTrace();
		}
		return null;
	}

	public ArrayList<AccomDTO> listAccom(String local) {
		try {
			String sql = "select * from tblAccom where locseq = ?";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, local);

			rs = pstat.executeQuery();

			ArrayList<AccomDTO> alist = new ArrayList<AccomDTO>();

			while(rs.next()) {

				AccomDTO dto = new  AccomDTO();

				dto.setAseq(rs.getString("aseq"));
				dto.setAname(rs.getString("aname"));
				dto.setAaddress(rs.getString("aaddress"));
				dto.setAprice(rs.getString("aprice"));
				dto.setLocseq(rs.getString("locseq"));

				alist.add(dto);

			}

			return alist;

		} catch (Exception e) {
			System.out.println("AccomDAO.listAccom");
			e.printStackTrace();
		}
		return null;
	}

	public ArrayList<AccomDTO> searchAccom(String word, String local) {
		try {
			String sql = "select * from tblaccom where aname like '%'||?||'%' and aaddress like '%'||?||'%'";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, word);
			pstat.setString(2, local);

			rs = pstat.executeQuery();

			ArrayList<AccomDTO> list = new ArrayList<AccomDTO>();

			while (rs.next()) {

				AccomDTO dto = new AccomDTO();

				dto.setAseq(rs.getString("aseq"));
				dto.setAname(rs.getString("aname"));
				dto.setAaddress(rs.getString("aaddress"));
				dto.setAprice(rs.getString("aprice"));
				dto.setLocseq(rs.getString("locseq"));

				list.add(dto);

			}

			return list;
			
		} catch (Exception e) {
			System.out.println("AccomDAO.searchAccom");
			e.printStackTrace();
		}
		return null;
	}
	
	public ArrayList<AccomDTO> listAccomLM(String local) {
		try {
			String sql = "select * from tblAccom where aaddress like '%'||?||'%'";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, local);

			rs = pstat.executeQuery();

			ArrayList<AccomDTO> alist = new ArrayList<AccomDTO>();

			while(rs.next()) {

				AccomDTO dto = new  AccomDTO();

				dto.setAseq(rs.getString("aseq"));
				dto.setAname(rs.getString("aname"));
				dto.setAaddress(rs.getString("aaddress"));
				dto.setAprice(rs.getString("aprice"));
				dto.setLocseq(rs.getString("locseq"));

				alist.add(dto);

			}

			return alist;

		} catch (Exception e) {
			System.out.println("AccomDAO.listAccom");
			e.printStackTrace();
		}
		return null;
	}

}
