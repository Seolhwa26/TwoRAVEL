package com.test.tworavel.plan;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

import com.test.tworavel.main.DBUtil;

public class PlanDAO {

	private Connection conn = null;
	private Statement stat = null;
	private PreparedStatement pstat = null;
	private ResultSet rs = null;

	public PlanDAO() {
		conn = DBUtil.open();
	}

	// 지역명 검색해서 장소 seq, 이름, 지역seq, 위도, 경도 가져오기
	public ArrayList<PlaceDTO> listPlace(String local) {

		try {

			String sql = "select * from tblPlace where locseq=(select locseq from tblLocal where locname like '%'||?||'%')";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, local);

			rs = pstat.executeQuery();

			ArrayList<PlaceDTO> list = new ArrayList<PlaceDTO>();

			while (rs.next()) {

				PlaceDTO dto = new PlaceDTO();

				dto.setPlseq(rs.getString("plseq"));
				dto.setPlname(rs.getString("plname"));
				dto.setLocseq(rs.getString("locseq"));
				dto.setPllat(rs.getString("pllat"));
				dto.setPllng(rs.getString("pllng"));
				dto.setPtheme(rs.getString("ptheme"));

				list.add(dto);

			}

			return list;

		} catch (Exception e) {
			System.out.println("PlanDAO.listPlace");
			e.printStackTrace();
		}

		return null;
	}

	public int addPlace(PlaceDTO pdto) {

		try {

			String sql = "insert into tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) values (seqPlace.nextVal, ?, ?, ?, ?, ?)";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, pdto.getPlname());
			pstat.setString(2, pdto.getLocseq());
			pstat.setString(3, pdto.getPllat());
			pstat.setString(4, pdto.getPllng());
			pstat.setString(5, pdto.getPtheme());

			return pstat.executeUpdate();

		} catch (Exception e) {
			System.out.println("PlanDAO.addPlace");
			e.printStackTrace();
		}

		return 0;
	} // addPlace

	// 설
	public int add(OpiDTO dto, String pno) {

		try {

			String sql = "insert into tblOpinion (oseq, oid, ocontent, ocheck, msseq) values (seqOpinion.nextVal, ?, ?, ?, ?)";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, dto.getOid());
			pstat.setString(2, dto.getOcontent());
			pstat.setString(3, dto.getOcheck());
			pstat.setString(4, pno);

			return pstat.executeUpdate();

		} catch (Exception e) {
			System.out.println("PlanDAO.add");
			e.printStackTrace();
		}

		return 0;
	}

	// 설
	public ArrayList<OpiDTO> list(String pno) {

		try {

			String sql = "select * from tblOpinion where msseq = ? order by oseq desc";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, pno); // 회원일정번호

			rs = pstat.executeQuery();

			ArrayList<OpiDTO> list1 = new ArrayList<OpiDTO>();

			while (rs.next()) {

				OpiDTO dto = new OpiDTO();

				dto.setOseq(rs.getString("oseq"));
				dto.setOid(rs.getString("oid"));
				dto.setOcontent(rs.getString("ocontent"));
				dto.setOcheck(rs.getString("ocheck"));
				dto.setMsseq(rs.getString("msseq"));

				list1.add(dto);

			}

			return list1;

		} catch (Exception e) {
			System.out.println("PlanDAO.list");
			e.printStackTrace();
		}

		return null;
	}

	// 설
	public int check(String no, String stat, String pno) {

		String sql;

		try {

			if (stat.equals("y")) {
				sql = "update tblOpinion set ocheck = 'y' where oseq = (select oseq from (select o.*, rank() over (order by oseq asc) as rank from tblOpinion o where msseq = ?) where rank = ?)";
			} else {
				sql = "update tblOpinion set ocheck = 'n' where oseq = (select oseq from (select o.*, rank() over (order by oseq asc) as rank from tblOpinion o where msseq = ?) where rank = ?)";
			}

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, pno);
			pstat.setString(2, no);

			return pstat.executeUpdate();

		} catch (Exception e) {
			System.out.println("PlanDAO.check");
			e.printStackTrace();
		}

		return 0;
	}

	// 설
	public String getBoss(String pno) {

		try {

			String sql = "select id from vwAuth where msseq = ?";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, pno); // 회원일정번호

			rs = pstat.executeQuery();

			if (rs.next()) {

				String boss = rs.getString("id");

				return boss;
			}

		} catch (Exception e) {
			System.out.println("PlanDAO.getBoss");
			e.printStackTrace();
		}

		return null;
	} // getBoss

	// 검색어 가지고 장소정보 검색하기 (리스트)
	public ArrayList<PlaceDTO> searchPlace(String word) {

		try {

			String sql = "select * from tblPlace where plname like '%'||?||'%'";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, word);

			rs = pstat.executeQuery();

			ArrayList<PlaceDTO> list = new ArrayList<PlaceDTO>();

			while (rs.next()) {

				PlaceDTO dto = new PlaceDTO();

				dto.setPlseq(rs.getString("plseq"));
				dto.setPlname(rs.getString("plname"));
				dto.setLocseq(rs.getString("locseq"));
				dto.setPllat(rs.getString("pllat"));
				dto.setPllng(rs.getString("pllng"));
				dto.setPtheme(rs.getString("ptheme"));

				list.add(dto);

			}

			return list;

		} catch (Exception e) {
			System.out.println("PlanDAO.searchPlace");
			e.printStackTrace();
		}

		return null;
	} // searchPlace

	// 장소명 가지고, 장소 정보 가져오기 (리스트X)
	public PlaceDTO placeInfo(PlaceDTO dto) {

		try {

			String sql = "select * from tblPlace where plname=?";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, dto.getPlname());

			rs = pstat.executeQuery();

			if (rs.next()) {
				PlaceDTO result = new PlaceDTO();

				dto.setLocseq(rs.getString("locseq"));
				dto.setPlseq(rs.getString("plseq"));
				dto.setPllat(rs.getString("pllat"));
				dto.setPllng(rs.getString("pllng"));
				dto.setPtheme(rs.getString("ptheme"));

				return dto;

			}

		} catch (Exception e) {
			System.out.println("PlanDAO.placeInfo");
			e.printStackTrace();
		}

		return null;
	} // placeInfo

	public ArrayList<PlaceDTO> searchPlaceTheme(String local, String theme) {
		try {

			String sql = "select p.plseq as plseq, p.plname as plname, p.locseq as locseq, p.pllat as pllat, p.pllng as pllng, p.ptheme as ptheme from tblPlace p inner join tblLocal l on p.locseq = l.locseq where locname=? and ptheme=?";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, local);
			pstat.setString(2, theme);

			rs = pstat.executeQuery();

			ArrayList<PlaceDTO> list = new ArrayList<PlaceDTO>();

			while (rs.next()) {

				PlaceDTO dto = new PlaceDTO();

				dto.setPlseq(rs.getString("plseq"));
				dto.setPlname(rs.getString("plname"));
				dto.setLocseq(rs.getString("locseq"));
				dto.setPllat(rs.getString("pllat"));
				dto.setPllng(rs.getString("pllng"));
				dto.setPtheme(rs.getString("ptheme"));

				list.add(dto);

			}

			return list;

		} catch (Exception e) {
			System.out.println("PlanDAO.searchPlace");
			e.printStackTrace();
		}

		return null;
	} // searchPlaceTheme

	// 일정 추천
	public ArrayList<PlanDTO> list(HashMap<String, String> map) {

		try {

			String sql = "";
			String where = "";

//			if (map.get(""))

			// mbti와 인원 체크
			// where p.pmcount > c.co and ms.msauth = 1 and ( m.mbti = 'ISFP' or m.mbti =
			// 'INTP' or m.mbti = 'ENTP'

			if (map.get("mbti1").equals("상관없음")) {
				where = "where p.pmcount > c.co and ms.msauth = 1";
			} else if (map.get("mbti2") == "") {
				where = String.format("where p.pmcount > c.co and ms.msauth = 1 and m.mbti = '%s'", map.get("mbti1"));
			} else if (map.get("mbti3") == "") {
				where = String.format("where p.pmcount > c.co and ms.msauth = 1 and (m.mbti = '%s' or m.mbti = '%s')",
						map.get("mbti1"), map.get("mbti2"));
			} else {
				where = String.format(
						"where p.pmcount > c.co and ms.msauth = 1 and (m.mbti = '%s' or m.mbti = '%s' or m.mbti = '%s')",
						map.get("mbti1"), map.get("mbti2"), map.get("mbti3"));
			}

			// 장소 체크
			where += String.format("and locname='%s'", map.get("local"));

			// 날짜 체크
			// and p.pstart >= '2022-03-01' and p.pend <= '2022-12-31'
			where += String.format("and p.pstart >= '%s' and p.pend <= '%s'", map.get("start"), map.get("end"));

			// 테마 체크
			// and p.ptheme = '산속휴양'

			if (map.get("theme1").equals("상관없음")) {
			} else if (map.get("theme2") == "") {
				where += String.format("and p.ptheme = '%s'", map.get("theme1"));
			} else if (map.get("theme3") == "") {
				where += String.format("and (p.ptheme = '%s' or p.ptheme = '%s')", map.get("theme1"),
						map.get("theme2"));
			} else {
				where += String.format("and (p.ptheme = '%s' or p.ptheme = '%s' or p.ptheme = '%s')", map.get("theme1"),
						map.get("theme2"), map.get("theme3"));
			}

			sql = String.format(
					"select rownum, p.pstart - sysdate as datecheck, p.pseq as pseq, p.pname as pname, p.pstart as pstart, p.pend as pend, p.pshare as pshare, p.pmcount as pmcount, p.ptheme as ptheme, c.co as co, s.scount as scount, s.slike as slike, m.mbti as mbti, un.locname as local from tblMSchedule ms inner join tblPlan p on p.pseq = ms.pseq inner join tblMember m on ms.mseq = m.mseq inner join (select * from(select pseq,count(pseq) as co from tblMSchedule where (msauth = 1 or msauth = 2) group by pseq)) c on c.pseq = p.pseq inner join tblShare s on s.pseq = p.pseq inner join (select locname, p.pseq as pseq from (select * from tblLocal l inner join tblTrain tr on l.locseq = tr.trend inner join tblTransfer t on tr.trseq = t.trseq union all select * from tblLocal l inner join tblFlight f on l.locseq = f.fend inner join tblTransfer t on f.fseq = t.fseq union all select * from tblLocal l inner join tblBus b on l.locseq = b.bend inner join tblTransfer t on b.busseq = t.busseq) u inner join tblPlan p on u.pseq = p.pseq) un on un.pseq = p.pseq %s",
					where);

			System.out.println(sql);

			pstat = conn.prepareStatement(sql);

			rs = pstat.executeQuery();

			ArrayList<PlanDTO> list = new ArrayList<PlanDTO>();

			while (rs.next()) {

				PlanDTO dto = new PlanDTO();

				dto.setPseq(rs.getString("pseq"));
				dto.setDatecheck(rs.getDouble("datecheck"));
				dto.setPname(rs.getString("pname"));
				dto.setPstart(rs.getString("pstart").substring(0, 10));
				dto.setPend(rs.getString("pend").substring(0, 10));
				dto.setPshare(rs.getString("pshare"));
				dto.setPmcount(rs.getInt("pmcount"));
				dto.setPtheme(rs.getString("ptheme"));
				dto.setPncount(rs.getInt("co"));
				dto.setScount(rs.getString("scount"));
				dto.setSlike(rs.getString("slike"));
				dto.setRownum(rs.getString("rownum"));
				dto.setMbti(rs.getString("mbti"));

				list.add(dto);

			}

			return list;

		} catch (Exception e) {
			System.out.println("PlanDAO.list");
			e.printStackTrace();
		}

		return null;
	}

	public int join(PlanDTO dto) {

		try {

			String sql = "insert into tblMSchedule values (seqMSchedule.nextVal, (select mseq from tblMember where id = ?), ?, 2)";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, dto.getId());
			pstat.setString(2, dto.getPseq());

			System.out.println(dto.getId());

			return pstat.executeUpdate();

		} catch (Exception e) {
			System.out.println("PlanDAO.join");
			e.printStackTrace();
		}

		return 0;
	}

	public int zim(PlanDTO dto) {

		try {

			String sql = "insert into tblLike values (seqLike.nextVal, (select mseq from tblMember where id = ?), (select sseq from tblPlan p inner join tblShare s on p.pseq = s.pseq where p.pseq = ?))";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, dto.getId());
			pstat.setString(2, dto.getPseq());
			System.out.println(dto.getId());

			return pstat.executeUpdate();

		} catch (Exception e) {
			System.out.println("PlanDAO.join");
			e.printStackTrace();
		}

		return 0;
	}

	public int setPlan(PlanDTO pdto) {

		try {

			// 시작일, 종료일, 일정명, 공유 여부, 모집여부, 인원수, 테마
			String sql = "insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, ?, ?, ?, ?, ?, ?, ?)";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, pdto.getPstart());
			pstat.setString(2, pdto.getPend());
			pstat.setString(3, pdto.getPname());
			pstat.setString(4, pdto.getPshare());
			pstat.setString(5, pdto.getPconnect());
			pstat.setInt(6, pdto.getPmcount());
			pstat.setString(7, pdto.getPtheme());

			return pstat.executeUpdate();

		} catch (Exception e) {
			System.out.println("PlanDAO.setPlan");
			e.printStackTrace();
		}

		return 0;
	}

	public int setMBTI(String id, String mbti) {

		try {

			String sql = "update tblMember set mbti=? where id=?";

			pstat = conn.prepareStatement(sql);

			pstat.setString(1, mbti);
			pstat.setString(2, id);

			return pstat.executeUpdate();

		} catch (Exception e) {
			System.out.println("PlanDAO.setMBTI");
			e.printStackTrace();
		}

		return 0;
	}

}
