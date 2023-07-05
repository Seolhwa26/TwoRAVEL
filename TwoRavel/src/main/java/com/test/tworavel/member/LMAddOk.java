package com.test.tworavel.member;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

@WebServlet("/member/lmaddok.do")
public class LMAddOk extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		HttpSession session = req.getSession();
		
	
		req.setCharacterEncoding("UTF-8");
		
		String lmseq = req.getParameter("lmseq");
		
		String mseq = req.getParameter("mseq");
		
		String olcontent = req.getParameter("olcontent");
		
		String lmname = req.getParameter("lmname");
		
		System.out.println("한 줄 평 추가:" + lmname);
		
		LandMarkDTO dto = new LandMarkDTO();
		
		dto.setLmseq(lmseq);
		dto.setMseq(mseq);
		dto.setOlcontent(olcontent);
		
		MemberDAO dao = new MemberDAO();
		
		//한 줄 평가 추가
		int result = dao.addOneLine(dto);
		

		resp.setCharacterEncoding("UTF-8");
		PrintWriter writer = resp.getWriter();
		writer.print("<html>");
		writer.print("<head>");
		writer.print("<meta charset='UTF-8'>");
		writer.print("<script>");
		
		if (result == 1) {

			writer.print("location.href='/tworavel/member/landmark.do?lmname=" + lmname + "&lmseq=" + lmseq + "';");
			
		} else {
			writer.print("alert('failed');");
			writer.print("history.back();");
		}
		
		writer.print("</script>");
		writer.print("</head>");
		writer.print("</html>");
		writer.close();			
		
	}
}
