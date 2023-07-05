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
			String where = "";
			
			sql = "select rownum, p.pstart - sysdate as datecheck, p.pseq as pseq, p.pname as pname, p.pstart as pstart, p.pend as pend, p.pshare as pshare, p.pmcount as pmcount, p.ptheme as ptheme, c.co as co, s.scount as scount, s.slike as slike, m.mbti as mbti, un.locname as local from tblMSchedule ms inner join tblPlan p on p.pseq = ms.pseq inner join tblMember m on ms.mseq = m.mseq inner join (select * from(select pseq,count(pseq) as co from tblMSchedule where (msauth = 1 or msauth = 2) group by pseq)) c on c.pseq = p.pseq inner join tblShare s on s.pseq = p.pseq inner join (select locname, p.pseq as pseq from (select * from tblLocal l inner join tblTrain tr on l.locseq = tr.trend inner join tblTransfer t on tr.trseq = t.trseq union all select * from tblLocal l inner join tblFlight f on l.locseq = f.fend inner join tblTransfer t on f.fseq = t.fseq union all select * from tblLocal l inner join tblBus b on l.locseq = b.bend inner join tblTransfer t on b.busseq = t.busseq) u inner join tblPlan p on u.pseq = p.pseq) un on un.pseq = p.pseq ";
			
			where = "where ms.msauth = 1";
			
			
			sql = sql + where;
			
			
			pstat = conn.prepareStatement(sql);
			
			rs = pstat.executeQuery();
			
			ArrayList<ShareDTO> list = new ArrayList<ShareDTO>();
			
			while (rs.next()) {
				
				ShareDTO dto = new ShareDTO();
				
				dto.setPseq(rs.getString("pseq"));
				dto.setPname(rs.getString("pname"));
				dto.setDatecheck(rs.getDouble("datecheck"));
				dto.setPstart(rs.getString("pstart").substring(0,10));
				dto.setPend(rs.getString("pend").substring(0,10));
				dto.setPshare(rs.getString("pshare"));
				dto.setPmcount(rs.getInt("pmcount"));
				dto.setPtheme(rs.getString("ptheme"));
				dto.setPncount(rs.getInt("co"));
				dto.setScount(rs.getString("scount"));
				dto.setSlike(rs.getString("slike"));
				dto.setRownum(rs.getString("rownum"));
				dto.setMbti(rs.getString("mbti"));
				dto.setLocal(rs.getString("local"));
				
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
