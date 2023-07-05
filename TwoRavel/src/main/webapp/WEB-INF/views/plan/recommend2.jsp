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
.btn1, .btn2 {
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

p{
	font-family: 'GongGothicMedium';
}

.r1, .r2, .r3, .r4, .r5, .r6 {
	margin: 0px;
}

.r7 {
	margin: 100px;
}


.btn2 {
	margin: 20px;
	float: right;
	background-color: #B9B9FF;
}

.btn2:hover {
   background-color: #7676FF;
}



</style>
</head>
<body>
	<%@ include file="/WEB-INF/inc/header.jsp"%>
	<!--================ Header Menu Area start =================-->



	<!--================ Banner Start =================-->
	<section class="hero-banner magic-ball">


		<div class="section-intro text-center pb-90px">

			<div class="stitle">
				<img src="/tworavel/asset/img/home/section-icon.png">
				<h2>어떤 여행을 원하시나요?</h2>
				<p>최대 3개까지 선택 가능합니다</p>
			</div>
		</div>

		<div id="out" style="width: 840px; margin: 0 auto;">
		
			<div class="r1">
				<input type="button" class="btn1" id="bt1" name="" value="활동적인"> 
				<input type="button" class="btn1" id="bt2" name="" value="낭만적인"> 
				<input type="button" class="btn1" id="bt3" name="" value="이색체험"> 
				<input type="button" class="btn1" id="bt4" name="" value="감성힐링">
				<input type="button" class="btn1" id="bt5" name="" value="가성비"> 
			</div>
			
			<div id="r2">
				<input type="button" class="btn1" id="bt6" name="" value="쇼핑여행"> 
				<input type="button" class="btn1" id="bt7" name="" value="시간여행"> 
				<input type="button" class="btn1" id="bt8" name="" value="문화예술">
				<input type="button" class="btn1" id="bt9" name="" value="이국적인"> 
				<input type="button" class="btn1" id="bt10" name="" value="생태체험"> 
			</div>
			
			<div id="r3">
				<input type="button" class="btn1" id="bt11" name="" value="친환경"> 
				<input type="button" class="btn1" id="bt12" name="" value="골목여행">
				<input type="button" class="btn1" id="bt13" name="" value="호캉스"> 
				<input type="button" class="btn1" id="bt14" name="" value="전통시장"> 
				<input type="button" class="btn1" id="bt15" name="" value="맛집여행"> 
			</div>
			
			<div id="r4">
				<input type="button" class="btn1" id="bt16" name="" value="SNS명소">
				<input type="button" class="btn1" id="bt17" name="" value="산속휴양"> 
				<input type="button" class="btn1" id="bt18" name="" value="전망좋은"> 
				<input type="button" class="btn1" id="bt19" name="" value="먹방투어"> 
				<input type="button" class="btn1" id="bt20" name="" value="가족여행">
			</div>
			
			<div id="r5">
				<input type="button" class="btn1" id="bt21" name="" value="산업관광"> 
				<input type="button" class="btn1" id="bt22" name="" value="한옥여행"> 
				<input type="button" class="btn1" id="bt23" name="" value="안심여행"> 
				<input type="button" class="btn1" id="bt24" name="" value="바다여행">
				<input type="button" class="btn1" id="bt25" name="" value="등산여행">
			</div>
			
			<div id="r6">
				<input type="button" class="btn1" id="bt26" id="no" value="상관없음">
			</div>
			
			<hr>
			<div>
			
			<form method="GET" name="th" action="/tworavel/plan/recommend3.do">
			
				<a href="#!"><input type="submit" id="btnnext" class="btn2" value="다음으로"></a>
				
				
				<input type="hidden" name="local" value="${local}">
				<input type="hidden" name="start" value="${start}">
				<input type="hidden" name="end" value="${end}">
				<input type="hidden" name="theme1" value="">
				<input type="hidden" name="theme2" value="">
				<input type="hidden" name="theme3" value="">
				
			
			</form>
			<input type="button" class="btn2" value="이전으로" onclick="location.href='/tworavel/plan/recommend1.do';">
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
	 
	 
	$('.btn1').click(()=>{
		
		if ($(event.target).css("background-color") === 'rgb(118, 118, 255)') {
			$('#bt26').css('background-color', '#7676FF');
			$(event.target).css('background-color', '#FFC000'); 
		} else {
			$('#bt26').css('background-color', '#7676FF');
			$(event.target).css('background-color', '#7676FF');
		} 
		
	});

	$('#bt26').click(()=>{
		$('.btn1').css('background-color', '#7676FF');
		$('#bt26').css('background-color', '#FFC000');
	});
	
	var theme = '';
	
	
	$('#btnnext').click(()=>{
		var cnt = 0; 
		theme = '';

		for (var i=1; i<=26; i++) {
			
			console.log($('#bt' + i).css('background-color')	);
			
			
			
			console.log(($('#bt' + i).css('background-color') == 'rgb(255, 192, 0)' ));
			
			if ($('#bt' + i).css('background-color') == 'rgb(255, 192, 0)' ) {

				cnt++;
				console.log(cnt);
				//<input type="hidden" name="theme1" value="">
				$('input[name=theme' + cnt + ']').val($('#bt' + i).val());
				

			}
			

		}
		
		if (cnt > 3 || cnt == 0) {
			alert("원하는 테마를 3개 이하 또는 상관없음을 클릭해주세요.");
			event.preventDefault();
			return false;
		}
		
		
		
		
	});
	
	
	</script>

</body>
</html>