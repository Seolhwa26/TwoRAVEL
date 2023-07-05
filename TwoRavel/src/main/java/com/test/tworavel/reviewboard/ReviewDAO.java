package com.test.tworavel.reviewboard;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import com.test.tworavel.main.BPlanDTO;
import com.test.tworavel.main.DBUtil;
import com.test.tworavel.member.LandMarkDTO;

public class ReviewDAO {

	private Connection conn;
	private Statement stat;
	private PreparedStatement pstat;
	private ResultSet rs;

	public ReviewDAO() {
		conn = DBUtil.open();
	}

	public ArrayList<ReviewDTO> getReviewAll() {
		try {
			String sql = "select * from tblreview";

			stat = conn.createStatement();

			rs = stat.executeQuery(sql);

			ArrayList<ReviewDTO> rList = new ArrayList<ReviewDTO>();

			while(rs.next()) {
				ReviewDTO dto = new ReviewDTO();

				dto.setRseq(rs.getString("rseq"));
				dto.setRcontent(rs.getString("rcontent"));
				dto.setRcount(rs.getString("rcount"));
				dto.setRctitle(rs.getString("rctitle"));
				dto.setMsseq(rs.getString("msseq"));

				rList.add(dto);   
			}
			return rList;
		} catch (Exception e) {
			System.out.println("ReviewDAO.getReviewAll");
			e.printStackTrace();
		}
		return null;
	}

	public String getMemberId(String msseq) {
		try {
			String sql ="select\r\n"
					+ "m.mseq as \"mseq\",\r\n"
					+ "m.id as \"id\",\r\n"
					+ "r.rseq as \"rseq\"\r\n"
					+ "from tblmember m\r\n"
					+ "inner join tblMSchedule ms  on ms.mseq = m.mseq\r\n"
					+ "inner join tblReview r on r.msseq = ms.msseq\r\n"
					+ "where r.msseq = ?";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, msseq);

			rs = pstat.executeQuery();

			rs.next();

			String result = rs.getString("id");

			return result;

		} catch (Exception e) {
			System.out.println("ReviewDAO.getMemberId");
			e.printStackTrace();
		}
		return null;
	}

	public ReviewDTO getReviewSeq(String rseq) {
		try {
			String sql = "select * from tblReview where rseq = ?";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, rseq);

			rs = pstat.executeQuery();

			if(rs.next()) {
				ReviewDTO dto = new ReviewDTO();

				dto.setRcontent(rs.getString("rcontent"));
				dto.setRcount(rs.getString("rcount"));
				dto.setRfile(rs.getString("rfile"));
				dto.setRctitle(rs.getString("rctitle"));
				dto.setMsseq(rs.getString("msseq"));

				return dto;	
			}

		} catch (Exception e) {
			System.out.println("ReviewDAO.getReviewSeq");
			e.printStackTrace();
		}
		return null;
	}

	public String getCommentCount(String rseq) {
		try {
			String sql ="select count(*) as cnt \r\n"
					+ "from tblRcomment\r\n"
					+ "where rseq = ?";
			pstat = conn.prepareStatement(sql);

			pstat.setString(1, rseq);
			rs = pstat.executeQuery();

			rs.next();

			String result = rs.getString("cnt");

			return result;

		} catch (Exception e) {
			System.out.println("ReviewDAO.getCommentCount");
			e.printStackTrace();
		}
		return null;
	}

	public void addReadCount(String rseq) {
		try {
			String sql = "update tblReview set rcount = rcount + 1 where rseq = ?";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, rseq);

			pstat.executeUpdate();

		} catch (Exception e) {
			System.out.println("MemberDAO.addReadCount");
			e.printStackTrace();
		}

	}

	public ArrayList<ReviewDTO> getRcComment(String rseq) {
		try {
			String sql ="select\r\n"
					+ "rc.rcseq as \"rcseq\",\r\n"
					+ "m.mseq as \"mseq\",\r\n"
					+ "m.id as \"id\",\r\n"
					+ "rc.rccontent as \"rccontent\"\r\n"
					+ "from tblReview r\r\n"
					+ "inner join tblRcomment rc on rc.rseq = r.rseq\r\n"
					+ "inner join tblMember m on m.mseq = rc.mseq\r\n"
					+ "where r.rseq = ?";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, rseq);

			rs = pstat.executeQuery();

			ArrayList<ReviewDTO> rcList = new ArrayList<ReviewDTO>();

			while(rs.next()) {
				ReviewDTO dto = new ReviewDTO();

				dto.setMseq(rs.getString("mseq"));
				dto.setId(rs.getString("id"));
				dto.setRccontent(rs.getString("rccontent"));
				dto.setRcseq(rs.getString("rcseq"));

				rcList.add(dto);
			}

			return rcList;

		} catch (Exception e) {
			System.out.println("ReviewDAO.getRcComment");
			e.printStackTrace();
		}
		return null;
	}

	public int addRcComment(ReviewDTO dto) {
		try {
			String sql ="insert into tblRcomment values (seqrcomment.nextval,0,0,?,?,?)";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, dto.getRccontent());
			pstat.setString(2, dto.getRseq());
			pstat.setString(3, dto.getMseq());

			int result = pstat.executeUpdate();

			return result;
		} catch (Exception e) {
			System.out.println("ReviewDAO.addRcComment");
			e.printStackTrace();
		}
		return 0;
	}

	public String getMsseq(String mseq) {
		try {
			String sql ="select\r\n"
					+ "ms.msseq as \"msseq\"\r\n"
					+ "from tblmschedule ms\r\n"
					+ "inner join tblMember m on m.mseq = ms.mseq\r\n"
					+ "where m.mseq = ?";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, mseq);

			rs = pstat.executeQuery();

			rs.next();

			String result = rs.getString("msseq");

			return result;

		} catch (Exception e) {
			System.out.println("ReviewDAO.getMsseq");
			e.printStackTrace();
		}
		return null;
	}

	public int addReview(ReviewDTO dto) {
		try {
			String sql = "insert into tblReview values (seqreview.nextval,?,default,?,?,?)";

			// rcontent , rfile , rctitle , msseq
			pstat = conn.prepareStatement(sql);

			pstat.setString(1, dto.getRcontent());
			pstat.setString(2, dto.getRfile());
			pstat.setString(3, dto.getRctitle());
			pstat.setString(4, dto.getMsseq());

			return pstat.executeUpdate();

		} catch (Exception e) {
			System.out.println("ReviewDAO.addReview");
			e.printStackTrace();
		}
		return 0;
	}

	public int delRComment(String rcseq) {
		try {
			String sql = "delete from tblrcomment where rcseq = ?";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, rcseq);

			return pstat.executeUpdate();

		} catch (Exception e) {
			System.out.println("ReviewDAO.delRComment");
			e.printStackTrace();
		}
		return 0;
	}

	public int reviewEdit(ReviewDTO dto) {
		try {
			String sql ="update tblReview set rcontent = ?, rctitle = ?, rfile = ? where rseq = ?";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, dto.getRcontent());
			pstat.setString(2, dto.getRctitle());
			pstat.setString(3, dto.getRfile());
			pstat.setString(4, dto.getRseq());

			return pstat.executeUpdate();


		} catch (Exception e) {
			System.out.println("ReviewDAO.reviewEdit");
			e.printStackTrace();
		}
		return 0;
	}

	public int deleteCommentAll(String rseq) {
		try {
			String sql ="delete from tblrcomment where rseq = ?";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, rseq);

			return pstat.executeUpdate();

		} catch (Exception e) {
			System.out.println("ReviewDAO.deleteCommentAll");
			e.printStackTrace();
		}
		return 0;
	}

	public int deleteReview(String rseq) {
		try {

			String sql ="delete from tblreview where rseq = ?";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, rseq);

			return pstat.executeUpdate();

		} catch (Exception e) {
			System.out.println("ReviewDAO.deleteReview");
			e.printStackTrace();
		}
		return 0;
	}

	public ArrayList<ReviewDTO> getInfo() {
		try {
			String sql ="select p.ptheme as \"ptheme\",l.locname as \"locname\", p.pseq as \"pseq\" from (select * from tblLocal l \r\n"
					+ "inner join tblTrain tr on l.locseq = tr.trend \r\n"
					+ "inner join tblTransfer t on tr.trseq = t.trseq union all select * from tblLocal l \r\n"
					+ "inner join tblFlight f on l.locseq = f.fend inner join tblTransfer t on f.fseq = t.fseq union all select * from tblLocal l \r\n"
					+ "inner join tblBus b on l.locseq = b.bend \r\n"
					+ "inner join tblTransfer t on b.busseq = t.busseq) u \r\n"
					+ "inner join tblPlan p on u.pseq = p.pseq;";

			stat = conn.createStatement();

			rs = stat.executeQuery(sql);

			ArrayList<ReviewDTO> list = new ArrayList<ReviewDTO>();

			while(rs.next()) {

				ReviewDTO dto = new ReviewDTO();

				dto.setPtheme(rs.getString("ptheme"));
				dto.setLocalname(rs.getString("locname"));
				dto.setPseq(rs.getString("pseq"));
				
				list.add(dto);

			}

			return list;
		} catch (Exception e) {
			System.out.println("ReviewDAO.getInfo");
			e.printStackTrace();
		} 
		return null;
	}

	public ArrayList<ReviewDTO> searchReview(String word) {
		try {

			String sql ="select * from tblreview where rcontent like '%'||?||'%' or rctitle like '%'||?||'%'";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, word);
			pstat.setString(2, word);

			rs = pstat.executeQuery();

			ArrayList<ReviewDTO> lmList = new ArrayList<ReviewDTO>();

			while(rs.next()) {

				ReviewDTO dto = new ReviewDTO();

				dto.setRseq(rs.getString("rseq"));
				dto.setRcontent(rs.getString("rcontent"));
				dto.setRcount(rs.getString("rcount"));
				dto.setRfile(rs.getString("rfile"));
				dto.setRctitle(rs.getString("rctitle"));
				dto.setMsseq(rs.getString("msseq"));

				lmList.add(dto);
			}
			return lmList;
			
		} catch (Exception e) {
			System.out.println("ReviewDAO.searchReview");
			e.printStackTrace();
		}
		return null;
	}



}