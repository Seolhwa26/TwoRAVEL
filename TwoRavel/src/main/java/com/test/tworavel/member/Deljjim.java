package com.test.tworavel.member;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/member/deljjim.do")
public class Deljjim extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		HttpSession session = req.getSession();
		// 찜 목록 삭제
		String sseq = req.getParameter("sseq");
		System.out.println("sseq = " + sseq);
		String mseq = (String) session.getAttribute("mseq");

		MPlanDAO dao3 = new MPlanDAO();

		int result = dao3.deljjim(sseq, mseq);
		System.out.println(result);
		if (result == 1) {

			req.setCharacterEncoding("UTF-8");
			resp.setContentType("text/html; charset=UTF-8");

			PrintWriter writer = resp.getWriter();
			writer.print("<script>");
			writer.print("alert('찜 목록에서 삭제 되었습니다.');");
			writer.print("window.location.href = '/tworavel/member/mypage.do';");
			writer.print("</script>");
			writer.close();

		} else {
			PrintWriter writer = resp.getWriter();
			writer.print("<script>");
			writer.print("alert('failed');");
			writer.print("history.back();");
			writer.print("</script>");
			writer.close();
		}

	}

}