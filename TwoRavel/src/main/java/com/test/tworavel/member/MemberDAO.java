package com.test.tworavel.member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import com.test.tworavel.main.DBUtil;
import com.test.tworavel.plan.AccomDTO;
import com.test.tworavel.plan.LocalDTO;
import com.test.tworavel.plan.PlaceDTO;



public class MemberDAO {

	private Connection conn;
	private Statement stat;
	private PreparedStatement pstat;
	private ResultSet rs;

	public MemberDAO() {
		conn = DBUtil.open();
	}

	public MemberDTO login(MemberDTO dto) {

		try {

			String sql;
			if (dto.getPw().equals("1111")) {
				sql = "select * from tblAdmin where id=? and pw=?";
			} else {
				sql = "select * from tblMember where id=? and pw=? and active = 'y'";
			}


			pstat = conn.prepareStatement(sql);

			pstat.setString(1, dto.getId());
			pstat.setString(2, dto.getPw());

			rs = pstat.executeQuery();

			if (rs.next()) {
				MemberDTO result = new MemberDTO();

				dto.setMname(rs.getString("mname"));
				dto.setMseq(rs.getString("mseq"));

				return dto;
			}

		} catch (Exception e) {
			System.out.println("MemberDAO.login");
			e.printStackTrace();
		}

		return null;
	}

	public int joinMember(MemberDTO dto) {

		try {

			String sql = "insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, ?, ?, ?, ?, ?, ?, ?, ?, ?, default, ?)";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, dto.getId());
			pstat.setString(2, dto.getPw());
			pstat.setString(3, dto.getMname());
			pstat.setString(4, dto.getGender());
			pstat.setString(5, dto.getMtel());
			pstat.setString(6, dto.getMptel());
			pstat.setString(7, dto.getJumin());
			pstat.setString(8, dto.getMaddress());
			pstat.setString(9, dto.getEmail());
			pstat.setString(10, dto.getMbti());

			return pstat.executeUpdate();

		} catch (Exception e) {
			System.out.println("MemberDAO.joinMember");
			e.printStackTrace();
		}

		return 0;
	}

	public int checkid(String id) {

		try {

			String sql = "select count(*) as cnt from tblMember where id = ?";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, id);

			rs = pstat.executeQuery();

			if (rs.next()) {

				return rs.getInt("cnt"); //1 or 0
			}

		} catch (Exception e) {
			System.out.println("MemberDAO.checkid");
			e.printStackTrace();
		}

		return 0;
	}

	// 랜드마크명 받아서 정보 싹 다 가져오기
	public LandMarkDTO getLandMark(String lmname) {
		try {
			String sql ="select * from tblLandmark where lmname = ?";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, lmname);

			rs = pstat.executeQuery();

			if(rs.next()) {
				LandMarkDTO dto = new LandMarkDTO();

				dto.setLmseq(rs.getString("lmseq"));
				dto.setLmname(rs.getString("lmname"));
				dto.setLmaddress(rs.getString("lmaddress"));
				dto.setLmcontent(rs.getString("lmcontent"));
				dto.setLmcount(rs.getString("lmcount"));
				dto.setLmlike(rs.getString("lmlike"));
				dto.setLmfile(rs.getString("lmfile"));
				dto.setLocseq(rs.getString("locseq"));


				return dto;      
			}




		} catch (Exception e) {
			System.out.println("MemberDAO.getLandMark");
			e.printStackTrace();
		}
		return null;
	}

	// 한 줄 평가 작성한 내용 및 회원 ID 가져오기
	public ArrayList<LandMarkDTO> oneLine(String lmname) {
		try {
			String sql ="select\r\n"
					+ "o.olseq as \"olseq\",\r\n"
					+ "o.olcontent as \"olcontent\",\r\n"
					+ "m.id as \"id\"\r\n"
					+ "from tblOneLine o\r\n"
					+ "inner join tblLandMark lm on lm.lmseq = o.lmseq\r\n"
					+ "inner join tblMember m on m.mseq = o.mseq\r\n"
					+ "where lm.lmname = ?";
			pstat = conn.prepareStatement(sql);

			pstat.setString(1, lmname);

			rs = pstat.executeQuery();

			ArrayList<LandMarkDTO> ollist = new ArrayList<LandMarkDTO>();

			while(rs.next()) {
				LandMarkDTO dto = new  LandMarkDTO();

				dto.setOlcontent(rs.getString("olcontent"));
				dto.setId(rs.getString("id"));
				dto.setOlseq(rs.getString("olseq"));

				ollist.add(dto);

			}

			return ollist;

		} catch (Exception e) {
			System.out.println("MemberDAO.oneLine");
			e.printStackTrace();
		}
		return null;
	}



	// 한 줄 평가 수 가져오기
	public String getOLCount(String lmseq) {
		try {

			String sql ="select count(olcontent) as cnt from tbloneline where lmseq = ?";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, lmseq);

			rs = pstat.executeQuery();

			rs.next();

			String result = rs.getString("cnt");

			return result;

		} catch (Exception e) {
			System.out.println("MemberDAO.getOLCount");
			e.printStackTrace();
		}
		return null;
	}



	public ArrayList<LandMarkDTO> listLandmark() {
		try {
			String sql ="select * from tblLandMark";

			// pstat = ? 매개변수있을떄

			stat = conn.createStatement();

			rs = stat.executeQuery(sql);

			ArrayList<LandMarkDTO> list = new ArrayList<LandMarkDTO>();

			while(rs.next()) {
				LandMarkDTO dto = new  LandMarkDTO();

				dto.setLmseq(rs.getString("lmseq"));
				dto.setLmname(rs.getString("lmname"));
				dto.setLmaddress(rs.getString("lmaddress"));
				dto.setLmcontent(rs.getString("lmcontent"));
				dto.setLmcount(rs.getString("lmcount"));
				dto.setLmlike(rs.getString("lmlike"));
				dto.setLmfile(rs.getString("lmfile"));
				dto.setLocseq(rs.getString("locseq"));

				list.add(dto);

			}

			return list;

		} catch (Exception e) {
			System.out.println("MemberDAO.listLandmark");
			e.printStackTrace();
		}
		return null;
	}

	public void addReadCount(String lmseq) {
		try {
			String sql = "update tblLandmark set lmcount = lmcount + 1 where lmseq = ?";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, lmseq);

			pstat.executeUpdate();

		} catch (Exception e) {
			System.out.println("MemberDAO.addReadCount");
			e.printStackTrace();
		}

	}

	public ArrayList<LandMarkDTO> searchLandMark(String landmark) {
		try {
			String sql ="select * from tblLandmark where lmname like '%'||?||'%'";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, landmark);

			rs = pstat.executeQuery();

			ArrayList<LandMarkDTO> lmList = new ArrayList<LandMarkDTO>();

			while(rs.next()) {

				LandMarkDTO dto = new LandMarkDTO();

				dto.setLmseq(rs.getString("lmseq"));
				dto.setLmname(rs.getString("lmname"));
				dto.setLmaddress(rs.getString("lmaddress"));
				dto.setLmcontent(rs.getString("lmcontent"));
				dto.setLmcount(rs.getString("lmcount"));
				dto.setLmlike(rs.getString("lmlike"));
				dto.setLmfile(rs.getString("lmfile"));
				dto.setLocseq(rs.getString("locseq"));

				lmList.add(dto);
			}
			return lmList;

		} catch (Exception e) {
			System.out.println("MemberDAO.searchPlace");
			e.printStackTrace();
		}
		return null;
	}

	public ArrayList<LocalDTO> getLocal() {
		try {
			String sql = "select locseq, locname from tblLocal";

			stat = conn.createStatement();

			rs = stat.executeQuery(sql);

			ArrayList<LocalDTO> localList = new ArrayList<LocalDTO>();

			while(rs.next()) {
				LocalDTO dto = new LocalDTO();

				dto.setLocseq(rs.getString("locseq"));
				dto.setLocname(rs.getString("locname"));

				localList.add(dto);
			}
			return localList;

		} catch (Exception e) {
			System.out.println("MemberDAO.getLocal");
			e.printStackTrace();
		}
		return null;
	}

	public String getlocCount(String locseq) {
		try {
			String sql = "select count(*) as cnt from tblLandmark where locseq = ?";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, locseq);

			rs = pstat.executeQuery();

			rs.next();

			String result = rs.getString("cnt");

			//System.out.print(rs.getString("cnt"));

			return result;

		} catch (Exception e) {
			System.out.println("MemberDAO.getlocCount");
			e.printStackTrace();
		}
		return null;
	}

	public ArrayList<LandMarkDTO> searchLandMarkLocal(String locseq) {
		try {
			String sql ="select * from tblLandmark where locseq = ?";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, locseq);

			rs = pstat.executeQuery();

			ArrayList<LandMarkDTO> lmList = new ArrayList<LandMarkDTO>();

			while(rs.next()) {

				LandMarkDTO dto = new LandMarkDTO();

				dto.setLmseq(rs.getString("lmseq"));
				dto.setLmname(rs.getString("lmname"));
				dto.setLmaddress(rs.getString("lmaddress"));
				dto.setLmcontent(rs.getString("lmcontent"));
				dto.setLmcount(rs.getString("lmcount"));
				dto.setLmlike(rs.getString("lmlike"));
				dto.setLmfile(rs.getString("lmfile"));
				dto.setLocseq(rs.getString("locseq"));

				lmList.add(dto);
			}
			return lmList;
		} catch (Exception e) {
			System.out.println("MemberDAO.searchLandMarkLocal");
			e.printStackTrace();
		}
		return null;
	}

	public int addOneLine(LandMarkDTO dto) {
		try {

			String sql ="insert into tblOneLine values(seqoneline.nextval,?,?,?)";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, dto.getOlcontent());
			pstat.setString(2, dto.getLmseq());
			pstat.setString(3, dto.getMseq());

			int result = pstat.executeUpdate();

			return result;

		} catch (Exception e) {
			System.out.println("MemberDAO.addOneLine");
			e.printStackTrace();
		}

		return 0;

	}

	public int landMarkLike(String lmname) {
		try {
			String sql ="UPDATE tblLandmark\r\n"
					+ "SET \r\n"
					+ "lmlike = lmlike + 1\r\n"
					+ "WHERE\r\n"
					+ "lmname=?";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, lmname);

			int result = pstat.executeUpdate();

			return result;

		} catch (Exception e) {
			System.out.println("MemberDAO.landMarkLike");
			e.printStackTrace();
		}
		return 0;
	}

	public int delOneLine(String olseq) {
		try {
			String sql = "delete from tblOneLine where olseq = ?";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, olseq);

			int result = pstat.executeUpdate();

			return result;
			
		} catch (Exception e) {
			System.out.println("MemberDAO.delOneLine");
			e.printStackTrace();
		}
		return 0;
	}
}