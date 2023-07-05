package com.test.tworavel.reviewboard;

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

import com.test.tworavel.member.LandMarkDTO;

@WebServlet("/reviewboard/searchreview.do")
public class SearchReview extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		resp.setCharacterEncoding("UTF-8");

		resp.setContentType("application/json");

		req.setCharacterEncoding("UTF-8");

		String word = req.getParameter("word");
		System.out.println(word);
		
		ReviewDAO dao = new ReviewDAO();

		ArrayList<ReviewDTO> rList = new ArrayList<ReviewDTO>();

		rList = dao.searchReview(word);

		//ArrayList<String> memberId = new ArrayList<String>();

		for (ReviewDTO dto : rList) {

			dto.getMsseq();

			//String id = dao.getMemberId(dto.getMsseq());

			dto.setId(dao.getMemberId(dto.getMsseq()));

			//memberId.add(id);

		}
		//req.setAttribute("memberId", memberId);

		//ArrayList<String> countList = new ArrayList<String>();

		for (ReviewDTO dto : rList) {

			dto.getRseq();

			dto.setRccount(dao.getCommentCount(dto.getRseq()));

			//countList.add(oLCount);

		}
		//req.setAttribute("cCount", countList);
		
		JSONArray arr = new JSONArray();

		for (ReviewDTO dto : rList) {

			//DTO 한개를 JSONObject 한개로 옮겨담아야한다.
			JSONObject obj = new JSONObject();

			obj.put("rseq",dto.getRseq());
			obj.put("rcontent",dto.getRcontent());
			obj.put("rcount",dto.getRcount());
			obj.put("rctitle",dto.getRctitle());
			obj.put("msseq",dto.getMsseq());
			obj.put("id",dto.getId());
			obj.put("cCount",dto.getRccount());

			//이후에 JSONObject를 JSONArray에 담아준다.

			arr.add(obj);

		}

		//다시 돌려주기
		PrintWriter writer = resp.getWriter();
//		writer.print("<html>");
//		writer.print("<head>");
//		writer.print("<meta charset='UTF-8'>");
		writer.print(arr);
//		writer.print("</head>");
//		writer.print("</html>");
		writer.close();

	}
}