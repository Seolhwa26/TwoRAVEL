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
<body>
	<%@ include file="/WEB-INF/inc/header.jsp"%>
	<!--================ Header Menu Area start =================-->

	<!--================ section Start =================-->
	<section class="section-margin generic-margin">
	<div class="section-intro text-center pb-90px">
       <div class="stitle">
          <img src="/tworavel/asset/img/home/section-icon.png">
       </div>
    </div>
	<div class="formContainer" style="margin:0 auto; width: 800px; border-radius: 10px; border: 1px solid #6059F6; padding: 20px;">
		<form method="POST" action="/tworavel/reviewboard/raddok.do"
			enctype="multipart/form-data">
			<div class="mb-3">
			<label for="exampleFormControlInput1" class="form-label">제목</label>
				<input type="text" class="form-control"
					id="rctitle" name="rctitle" placeholder="제목을 입력하세요" required>
					
			</div>
			<div class="mb-3">
				<textarea class="form-control"
					rows="3" style="resize: none; height: 300px;" name="rcontent" id="rcontent" required placeholder="내용을 입력하세요"></textarea>
			</div>
			<div class="mb-3">
				<label for="formFileSm" class="form-label">사진 추가</label>
				<input class="form-control form-control-sm" id="rfile" name="rfile" type="file">
			</div>
			<div class="btns">
					<button type="button" class="btn btn-primary"
						onclick="location.href='/tworavel/reviewboard/review.do';" style="background-color:#6059F6; border: #6059F6;">돌아가기</button>
					<button type="submit" class="btn btn-primary" style="background-color:#6059F6; border: #6059F6;">
						<i class="fa-solid fa-pen-nib"></i> 작성하기
					</button>
				</div>
				
		</form>
	</div>
	</section>
	<!--================ section End =================-->




	<!-- ================ start footer Area ================= -->
	<%@ include file="/WEB-INF/inc/footer.jsp"%>

</body>
</html>