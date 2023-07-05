package com.test.tworavel.member;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

@WebServlet("/member/landmarklocal.do")
public class LandMarkLocal extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		resp.setCharacterEncoding("UTF-8");
		
		resp.setContentType("application/json");
		
		req.setCharacterEncoding("UTF-8");
		
		String locseq = req.getParameter("locseq");
		
		MemberDAO dao = new MemberDAO();
		
		ArrayList<LandMarkDTO> lmList = new ArrayList<LandMarkDTO>();

		lmList = dao.searchLandMarkLocal(locseq);
		

		for (LandMarkDTO dto : lmList) {

			dto.setOlcnt(dao.getOLCount(dto.getLmseq()));

		}

		
		JSONArray arr = new JSONArray();
		
		for (LandMarkDTO dto : lmList) {
	        
	        //DTO 한개를 JSONObject 한개로 옮겨담아야한다.
	        JSONObject obj = new JSONObject();
	        
	        obj.put("lmseq", dto.getLmseq());
	        obj.put("lmname", dto.getLmname());
	        obj.put("lmaddress", dto.getLmaddress());
	        obj.put("lmcontent", dto.getLmcontent());
	        obj.put("lmcount", dto.getLmcount());
	        obj.put("lmlike", dto.getLmlike());
	        obj.put("lmfile", dto.getLmfile());
	        obj.put("locseq", dto.getLocseq());
			obj.put("olcnt", dto.getOlcnt());
	        
	        //이후에 JSONObject를 JSONArray에 담아준다.
	        
	        arr.add(obj);
	        
	     }
		
		
	     
	     //다시 돌려주기
	     PrintWriter writer = resp.getWriter();
	     
	     writer.print(arr);
	     
	     writer.close();
		 
		}

	}