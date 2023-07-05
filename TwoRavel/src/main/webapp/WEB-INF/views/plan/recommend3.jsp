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
.box {
	width: 480px;
	height: 120px;
	text-align: center;
	color: #595959;
	background-color: #F2F2F2;
	border: 0;
	outline: none;
	border-radius: 20px;
	margin: 20px 0;
}

.btn2 {
	width: 120px;
	height: 60px;
	border-radius: 20px;
	margin: 20px;
	font-size: 20px;
	color: white;
	border: 0;
	background-color: #7676FF;
	font-family: 'GongGothicMedium';
}

.btn2 {
	margin: 20px;
	float: right;
	background-color: #B9B9FF;
}

.btn2:hover {
	background-color: #7676FF;
}

.text {
	font-family: 'GongGothicMedium';
	font-style: normal;
	font-size: 50px;
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/inc/header.jsp"%>
	<!--================ Header Menu Area start =================-->


	<!--================ section Start =================-->
	<section class="section-margin generic-margin">

		<div id = out style="width: 840px; margin: 0 auto;">
			<div class="section-intro text-center pb-90px">
				<img src="/tworavel/asset/img/home/section-icon.png">
				<h2>당신의 MBTI를 알려주세요</h2>
				<div class="text">
					<input type="text" id="box" class="box" required>
				</div>
			</div>
			<div>
			
			<form method="GET" name="th" action="/tworavel/plan/recommend4.do">
			
				<a href="#!"><input type="submit" id="btnnext" class="btn2" value="다음으로"></a>
				
				<input type="hidden" name="local" value="${local}">
				<input type="hidden" name="start" value="${start}">
				<input type="hidden" name="end" value="${end}">
				<input type="hidden" name="theme1" value="${theme1}">
				<input type="hidden" name="theme2" value="${theme2}">
				<input type="hidden" name="theme3" value="${theme3}">
				<input type="hidden" name="mbti" value="">
				
				
			</form>
			
			<input type="button" class="btn2" value="이전으로" onclick="location.href='/tworavel/plan/recommend2.do';">
			
			</div>
		</div>

			
			
			

	</section>
	<!--================ Banner End =================-->

	<!--================ section Start =================-->
	<section class="section-margin generic-margin">
		<div class="container"></div>
	</section>
	<!--================ section End =================-->



	<!-- ================ start footer Area ================= -->
	<%@ include file="/WEB-INF/inc/footer.jsp"%>


   <script>
   
   $('#btnnext').click(()=>{
      
      var mbti = $('.box').val().toUpperCase();
      //alert($('.box').val());
      document.th.mbti.value = mbti;
      
		if (mbti != 'INFP' && mbti != 'INFJ' && mbti != 'INTP' && mbti != 'INTJ'
			&& mbti != 'ISFP' && mbti != 'ISFJ'	&& mbti != 'ISTP' && mbti != 'ISTJ'
			&& mbti != 'ENFP' && mbti != 'ENFJ'	&& mbti != 'ENTP' && mbti != 'ENTJ'
			&& mbti != 'ESFP' && mbti != 'ESFJ'	&& mbti != 'ESTP' && mbti != 'ESTJ') {
			alert("올바른 MBTI값을 입력하십시오.");
			event.preventDefault();
			return false;
		}
      
         
      });
   
   </script>


</body>
</html>