<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/inc/asset.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="ie=edge">
<title>TwoRavel</title>
<style>
p, span{
	font-family: 'GongGothicMedium';
}
h2,h6{
	font-family: 'GongGothicMedium';
}

</style>
</head>
<body>
	<%@ include file="/WEB-INF/inc/header.jsp"%>
	<!--================ Header Menu Area start =================-->

	<!--================ section Start =================-->
	<section class="section-margin generic-margin">

		<div class="section-intro text-center pb-90px">
			<div class="stitle">
				<img src="/tworavel/asset/img/home/section-icon.png">
				<h2>${rctitle } </h2>
				<h6>${writeId }</h6>

			</div>

			<div class="single-post">
				<div class="feature-img">
					<!-- 리뷰 사진 lmfile -->
					<c:if test="${not empty rfile}">
						<img class="img-fluid" src="/tworavel/asset/files/${rfile }" style="width: 736.01px; height:490.35px; object-fit: cover;"
							alt="리뷰사진">
					</c:if>
				</div>
				<div class="blog_details">

					<ul class="blog-info-link mt-3 mb-4" id="rInfo">
						<li><i class="fa-solid fa-eye"></i><span>${rcount }</span></li>
						<li><i class="far fa-comment"></i><span>${cCount }</span></li>
					</ul>
					<p>${rcontent }</p>
				</div>
			</div>

			<div class="comments-area">
				<div class="comment-list">
					<c:forEach items="${comment}" var="dto">
						<div class="single-comment justify-content-between d-flex"
							style="margin: 30px; border: 1px solid #6059F6; border-radius: 10px; padding: 15px;">
							<div class="user justify-content-between d-flex">
								<div class="desc">
									<p class="comment">${dto.rccontent }</p>

									<div class="d-flex justify-content-between">
										<div class="d-flex align-items-center">
											<h5>${dto.id }
											<c:if test="${dto.id == auth }">
											<span style="cursor:pointer; margin-left: 5px; font-size: 1.6rem; color: gold;" onclick = "location.href='/tworavel/reviewboard/rcdelok.do?rcseq=${dto.rcseq}&rseq=${rseq}&id=${writeId }&cCount=${cCount }';">&times;</span>
											</c:if>
											</h5>
										</div>
									</div>
								</div>
							</div>
						</div>
					</c:forEach>
					<c:if test="${not empty auth and writeId == auth}">
						<div class="btns">
							<button class="btn btn-primary" type="button"
								style="background-color: #6059F6; border: #6059F6;"
								onclick="location.href='/tworavel/reviewboard/redit.do?rseq=${rseq}&id=${writeId }&cCount=${cCount }';">
								<i class="fa-solid fa-pen-to-square"></i> 수정하기
							</button>
							<button class="btn btn-primary" type="button"
								style="background-color: #6059F6; border: #6059F6;"
								onclick="location.href='/tworavel/reviewboard/rdeleteok.do?rseq=${rseq}';">
								<i class="fa-solid fa-trash-can"></i> 삭제하기
							</button>
						</div>
					</c:if>
				</div>
			</div>

			<c:if test="${not empty auth}">
				<!-- 한 줄 평가 작성 칸 -->

				<div class="comment-form"
					style="border: 1px solid #6059F6; border-radius: 10px; padding: 15px;">
					<h4>댓글 작성</h4>
					<form class="form-contact comment_form"
						action="/tworavel/reviewboard/rccaddok.do" method="GET"
						id="commentForm">
						<div class="row">
							<div class="col-sm-6">
								<div class="form-group">
									<input class="form-control" name="name" id="name" type="text"
										placeholder="Name" readonly value="${auth }"
										style="color: #5E57F3; font-weight: bold;">
								</div>
							</div>
							<div class="col-12">
								<div class="form-group">
									<textarea class="form-control w-100" name="rccontent"
										id="rccontent" cols="30" rows="9" placeholder="댓글을 작성하세요!"
										style="resize: none;"></textarea>
								</div>
							</div>
						</div>
						<div class="form-group" style="margin-top: 30px;">
							<button type="submit" class="button button-contactForm"
								id="writebtn">작성하기</button>
						</div>
						<input type="hidden" id="mseq" name="mseq" value="${mseq }" /> <input
							type="hidden" id="rseq" name="rseq" value="${rseq }" /> <input
							type="hidden" id="writeId" name="writeId" value="${writeId }" />
						<input type="hidden" id="cCount" name="cCount" value="${cCount }" />
					</form>
				</div>
			</c:if>
		</div>

	</section>
	<!--================ section End =================-->

	<!-- ================ start footer Area ================= -->
	<%@ include file="/WEB-INF/inc/footer.jsp"%>

</body>
</html>