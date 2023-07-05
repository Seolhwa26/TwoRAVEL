<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file = "/WEB-INF/inc/asset.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>TwoRavel</title>
  <style>
  
  .btn1, .btn2 {
  	font-family: 'GongGothicMedium';
  	width: 150px;
  	height: 70px;
  	border-radius: 20px;
  	margin: 20px;
  	font-size: 25px;
  	color: white;
  	border: 0;
  	background-color: #7676FF;
  }
 
  .r1, .r2, .r3, .r4, .r5 {
  	margin: 0 auto;
  }
  
  .btn2 {
  	width: 120px;
  	height: 60px;
  	margin: 20px;
  	float: right;
  	font-size: 20px;
  	background-color: #B9B9FF;
  }
  
  .btn2:hover {
  	background-color: #7676FF;
  }
  </style>
</head>
<body>
  <%@ include file = "/WEB-INF/inc/header.jsp"%>
  <!--================ Header Menu Area start =================-->
 


 <!--================ Banner Start =================-->
<section class="hero-banner magic-ball">


	<div class="section-intro text-center pb-90px">
			
       <div class="stitle">
          <img src="/tworavel/asset/img/home/section-icon.png">
          <h2>함께 여행하고 싶은 MBTI를 골라주세요</h2>
          <p>최대 3개까지 선택 가능합니다.</p>
       </div>
    </div>
       
     <div id="out" style="width: 780px; margin: 0 auto;">
     	<div class="r1">
     		<input type="button" class="btn1" id="bt1" name="ISTJ" value="ISTJ">
     		<input type="button" class="btn1" id="bt2" name="ISTP" value="ISTP">
     		<input type="button" class="btn1" id="bt3" name="ISFJ" value="ISFJ">
     		<input type="button" class="btn1" id="bt4" name="ISFP" value="ISFP">
     	</div>
     	<div class="r2">
     		<input type="button" class="btn1" id="bt5" name="INTJ" value="INTJ">
     		<input type="button" class="btn1" id="bt6" name="INTP" value="INTP">
     		<input type="button" class="btn1" id="bt7" name="INFJ" value="INFJ">
     		<input type="button" class="btn1" id="bt8" name="INFP" value="INFP">
     	</div>
     	<div class="r3">
     		<input type="button" class="btn1" id="bt9" name="ESTJ" value="ESTJ">
     		<input type="button" class="btn1" id="bt10" name="ESTP" value="ESTP">
     		<input type="button" class="btn1" id="bt11" name="ESFJ" value="ESFJ">
     		<input type="button" class="btn1" id="bt12" name="ESFP" value="ESFP">
     	</div>
     		<div class="r4">
     		<input type="button" class="btn1" id="bt13" name="ENTJ" value="ENTJ">
     		<input type="button" class="btn1" id="bt14" name="ENTP" value="ENTP">
     		<input type="button" class="btn1" id="bt15" name="ENFJ" value="ENFJ">
     		<input type="button" class="btn1" id="bt16" name="ENFP" value="ENFP">
     	</div>
     	<div class="r5">
     		<input type="button" class="btn1" id="bt17" name="null" value="상관없음">
     	</div>
     	<hr>
     	<div>
			<form method="GET" action="/tworavel/plan/recommend5.do">
			
				<a href="#!"><input type="submit" id="btnnext" class="btn2" value="다음으로"></a>
				
				<input type="hidden" name="local" value="${local}">
				<input type="hidden" name="start" value="${start}">
				<input type="hidden" name="end" value="${end}">
				<input type="hidden" name="theme1" value="${theme1}">
				<input type="hidden" name="theme2" value="${theme2}">
				<input type="hidden" name="theme3" value="${theme3}">
				<input type="hidden" name="mbti" value="${mbti}">
				<input type="hidden" name="mbti1" value="">
				<input type="hidden" name="mbti2" value="">
				<input type="hidden" name="mbti3" value="">
				
			
			</form>
			<input type="button" class="btn2" value="이전으로" onclick="location.href='/tworavel/plan/recommend3.do';">
     	</div>
	</div>
	
  </section>
   <!--================ Banner End =================-->

  <!--================ section Start =================-->
  <section class="section-margin generic-margin">
    <div class="container">

    </div>
  </section>
  <!--================ section End =================-->



  <!-- ================ start footer Area ================= -->
  <%@ include file = "/WEB-INF/inc/footer.jsp"%>

<script>
	$('.btn1').click(()=>{
		
		if ($(event.target).css("background-color") === 'rgb(118, 118, 255)') {
			$('#bt17').css('background-color', '#7676FF');
			$(event.target).css('background-color', '#FFC000'); 
		} else {
			$('#bt17').css('background-color', '#7676FF');
			$(event.target).css('background-color', '#7676FF');
		} 
		
	});

	$('#bt17').click(()=>{
		$('.btn1').css('background-color', '#7676FF');
		$('#bt17').css('background-color', '#FFC000');
	});
	
	var mbtivalue = '';
	var mbti = '';
	
	$('#btnnext').click(()=>{
		var cnt = 0; 
		for (var i=1; i<=17; i++) {
			
			if ($('#bt' + i).css('background-color') == 'rgb(255, 192, 0)' ) {
				
				cnt++;
				$('input[name=mbti' + cnt + ']').val($('#bt' + i).val());
				
			}
		}
		
		if (cnt > 3 || cnt == 0) {
			alert("원하는 mbti를 3개 이하 또는 상관없음을 클릭해주세요.");
			event.preventDefault();
			return false;
		}
		
		
		
		
	});
	
</script>
</body>
</html>