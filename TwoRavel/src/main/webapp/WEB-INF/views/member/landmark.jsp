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
</head>
<style>
p, span {
	font-family: 'GongGothicMedium';
}
</style>
<body>
	<%@ include file="/WEB-INF/inc/header.jsp"%>
	<!--================ Header Menu Area start =================-->

	<!--================Blog Area =================-->
	<section class="blog_area single-post-area section-margin">
		<div class="container">
			<div class="row">
				<div class="col-lg-8 posts-list" style="margin: 0 200px 0 200px;">
					<div class="single-post">
						<div class="feature-img">
							<!-- 랜드마크 사진 lmfile -->
							<img class="img-fluid"
								src="/tworavel/asset/img/landmark/${lmfile}" style="width: 736.01px; height:490.35px; object-fit: cover;" alt="랜드마크사진">
						</div>
						<div class="blog_details">
							<h2>${lmname}</h2>
							<ul class="blog-info-link mt-3 mb-4" id="lmInfo">
								<%-- <li>${lmseq } , ${mseq } , ${lmname }</li> --%>
								<li><i class="fa-solid fa-eye"></i><span>${lmcount}</span></li>
								<li><i class="fa-regular fa-thumbs-up" id="like"
									onclick="location.href='/tworavel/member/landmarklike.do?lmname=${lmname}&lmseq=${lmseq }'"></i><span
									style="color: tomato;">${lmlike }</span></li>
								<li><i class="far fa-comment"></i><span>${oLCount }</span></li>
							</ul>
							<p>${lmcontent }</p>
						</div>
					</div>

					<div class="comments-area">
						<div class="comment-list">
							<c:forEach items="${olList}" var="dto">
								<div class="single-comment justify-content-between d-flex"
									style="margin: 30px; border: 1px solid #6059F6; border-radius: 10px; padding: 15px;">
									<div class="user justify-content-between d-flex">
										<div class="desc">
											<p class="comment">${dto.olcontent}</p>

											<div class="d-flex justify-content-between">
												<div class="d-flex align-items-center">
													<h5>
														${dto.id}
														<c:if test="${dto.id == auth }">
															<span
																style="cursor: pointer; margin-left: 5px; font-size: 1.6rem; color: gold;"
																onclick="location.href='/tworavel/member/lmdeleteok.do?olseq=${dto.olseq}&lmname=${lmname}&lmseq=${lmseq }';">&times;</span>
														</c:if>
													</h5>
												</div>
											</div>
										</div>
									</div>
								</div>
							</c:forEach>

						</div>
					</div>

					<c:if test="${not empty auth}">
						<!-- 한 줄 평가 작성 칸 -->

						<div class="comment-form"
							style="border: 1px solid #6059F6; border-radius: 10px; padding: 15px;">
							<h4>한 줄 평가 작성</h4>
							<form class="form-contact comment_form"
								action="/tworavel/member/lmaddok.do" method="GET"
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
											<textarea class="form-control w-100" name="olcontent"
												id="olcontent" cols="30" rows="9"
												placeholder="한 줄 평가를 남겨주세요!" style="resize: none;"></textarea>
										</div>
									</div>
								</div>
								<div class="form-group" style="margin-top: 30px;">
									<button type="submit" class="button button-contactForm"
										id="writebtn">작성하기</button>
								</div>
								<input type="hidden" id="mseq" name="mseq" value="${mseq }" />
								<input type="hidden" id="lmseq" name="lmseq" value="${lmseq }" />
								<input type="hidden" id="lmname" name="lmname"
									value="${lmname }" />
							</form>
						</div>
					</c:if>
				</div>
			</div>
		</div>
	</section>
	<!--================Blog Area =================-->

	<!-- ================ start footer Area ================= -->
	<%@ include file="/WEB-INF/inc/footer.jsp"%>
	<script>

</script>
</body>
</html>