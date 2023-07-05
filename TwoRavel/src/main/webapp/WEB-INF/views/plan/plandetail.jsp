<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file = "/WEB-INF/inc/asset.jsp"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>TwoRavel</title>
  <style>
    
    .txt {
       font-family: 'GongGothicMedium';
       border: 2px solid #F2F2F9;
       margin: 20px 0;
        padding: 20px;
        width: 450px;
        height: 50px;
        outline: none;
        border: 0;
        border-radius: 10px;
    }
    
    input[type="radio"] {
       margin: 5px;
       margin-left: 10px;
    }
    
    .border1 {
       width: 1110px;
       margin: 0 auto;
    }
    
    .border2 {
       border: 1px solid #F2F2F9;
       border-radius: 50px;
       background-color: #F8F8FF;
       text-align: center;
       width: 900px;
       padding: 40px 0;
       margin: 0 auto;
    }
    
    #gender {
       text-align: left;
       margin: 0 215px;
    }
    
    form > h1 {
       font-size: 35px; 
    }
    
    span {
       display: block;
    }
    
    .day {
       margin-bottom: 0px;
        background-color: #FEF1CB;
        color: #444;
    }
    
    /* 지현 추가 css */
    #plantitle{
    	margin-top: 10px;
    	outline: none;
    	width: 80%;
    	text-align: center;
    	font-size: 1.7rem;
    	font-weight: bold;
    	color: #444;
    	border: 0px;
    }
    
    #themebox {
    	width: 700px;
    	height: 45px;
    	text-align: center;
    	margin:10px auto;
    	font-family: 'GongGothicMedium';
    }
    
    .nice-select {
    	font-size: 1.1rem;
    	margin: 0 auto;
    	font-family: 'GongGothicMedium';
    }
    
   
  </style>
</head>
<body>
  <%@ include file = "/WEB-INF/inc/header.jsp"%>
  <!--================ Header Menu Area start =================-->
 


 <!--================ Banner Start =================-->
   <section class="hero-banner magic-ball">
      <div class="container">
         <div class="section-intro text-center pb-90px">
            <img class="section-intro-img"
               src="/tworavel/asset/img/home/section-icon.png" alt=""><br>
             <form method="POST" action="/tworavel/plan/plandetailok.do">
            <input type="text" placeholder="이곳에 여행이름을 입력해주세요." value="" id="plantitle" name="pname" required autofocus>
   
         </div>
         <div class="border1">
            <div class="border2">
            	
            	<input type="hidden" name="local" value="${local}">
            	<input type="hidden" name="sdate" value="${sdate}">
            	<input type="hidden" name="edate" value="${edate}">
            	<input type="hidden" name="mcount" value="${mcount}">
                  <input type="text" class="txt" name="dest" id="dest" value="여행가는 곳: ${local}" style="border: 2px solid #F2F2F9;" required>  <!-- 여행가는 곳: 제주도 JEJU -->
                  <input type="text" class="txt" name="date" id="date" value="여행날짜: ${sdate} ~ ${edate}" style="border: 2px solid #F2F2F9;" required> <!-- 여행날짜: 2022.12.17 ~ 2022.12.30 -->
                  <input type="text" class="txt" name="pcount" id="pcount" value="함께 여행하는 인원수: ${mcount}명" style="border: 2px solid #F2F2F9;" required> <!-- 함께 여행하는 인원수: 5명 -->
                  <input type="text" class="txt" name="mname" id="mname" value="총 ${diffDays}일 간 의 여행" style="border: 2px solid #F2F2F9; text-align: center;" required> <!-- 여행일정 -->


                  <div id="themebox">
                  <div style="display:flex; margin: 10px auto; padding: 5px; padding-bottom: 20px; width: 450px; height: 60px; text-align:center; background-color: white; border: 2px solid #F2F2F9;">
                 	 <span style="padding: 5px; margin-top: 6px; text-align:center;">여행의 테마를 알려주세요! </span>
                              <select name="theme" id="theme" required>
                                 <option value="" selected>💡 테마선택</option>
                                 <option value="활동적인">활동적인</option>
                                 <option value="낭만적인">낭만적인</option>
                                 <option value="이색체험">이색체험</option>
                                 <option value="감성힐링">감성힐링</option>
                                 <option value="가성비">가성비</option>
                                 <option value="쇼핑여행">쇼핑여행</option>
                                 <option value="시간여행">시간여행</option>
                                 <option value="문화예술">문화예술</option>
                                 <option value="이국적인">이국적인</option>
                                 <option value="생태체험">생태체험</option>
                                 <option value="친환경">친환경</option>
                                 <option value="골목여행">골목여행</option>
                                 <option value="호캉스">호캉스</option>
                                 <option value="전통시장">전통시장</option>
                                 <option value="맛집여행">맛집여행</option>
                                 <option value="SNS명소">SNS명소</option>
                                 <option value="산속휴양">산속휴양</option>
                                 <option value="전망좋은">전망좋은</option>
                                 <option value="먹방투어">먹방투어</option>
                                 <option value="가족여행">가족여행</option>
                                 <option value="산업관광">산업관광</option>
                                 <option value="한옥여행">한옥여행</option>
                                 <option value="안심여행">안심여행</option>
                                 <option value="바다여행">바다여행</option>
                                 <option value="등산여행">등산여행</option>
                              </select> 
                  </div>
                  </div>
                  <br>
                  
                  <div id="planbox">
                  <c:forEach begin="1" end="${daylength}" var="dcnt">
                     <input type="text" class="txt day" name="day${dcnt}" id="day${dcnt}" value="DAY0${dcnt}" style="text-align: center; border: 2px solid #F2F2F9;" disabled>
                     <div style="width: 450px; height: 180px; font-family: 'GongGothicMedium'; background-color: white; margin: 0 auto; border: 2px solid #F2F2F9; border-radius: 10px; font-size: 0.9rem; border-top: 0; padding: 10px;" required>

                     <c:forEach items="${map}" var="map">
                     <c:if test="${map.value eq dcnt}">
                     <c:set var = "names" value = "${map.key}"/>
                     <c:set var = "length" value = "${fn:length(names)}"/>
  					 <c:set var = "string" value = "${fn:substring(names,0,length-1)}" />	
                     
                     	<span style="font-size:1.1rem; padding: 5px 0; margin: 5px;">${string}</span>
                     	
                     </c:if>
                     </c:forEach> 
                     
                     </div>
                  </c:forEach>
                  </div> 
                  
                  <!-- 
                  <input type="text" class="txt day" name="day1" id="day1" value="이용하는 교통편" style="border: 2px solid #F2F2F9;" disabled>
                  <textarea style="width: 450px; height: 180px; font-family: 'GongGothicMedium'; resize: none; outline: none; border: 2px solid #F2F2F9; border-radius: 10px; font-size: 0.9rem; border-top: 0;" required></textarea>
                    -->
                     
                  <div id="mbtibox" style="font-family: 'GongGothicMedium'; width: 450px; height: 50px; background-color: white; border: 2px solid #F2F2F9; margin: 20px auto; margin-top: 10px; padding-left: 20px;">
                  당신의 MBTI는?   
                  <input type="text" class="txt" name="mbti" id="mbti" style=" width: 260px; height: 40px; margin: 0; margin-left: 40px; border: 2px solid #F2F2F9;" value="${mbti}" required>
                  </div>
                  
                  <div id="mbtibox" style="font-family: 'GongGothicMedium'; width: 450px; height: 50px; background-color: white; border: 2px solid #F2F2F9; margin: 20px auto; padding: 10px 20px; text-align: left;">
                  다른 사람들과 여행 일정을 공유 하시겠습니까?
                  <input type="checkbox" name="cb1" id="cb1" style="border: 2px solid #F2F2F9; zoom: 2; padding: 10px; float: right;">
                  </div>
                  
                  <div id="mbtibox" style="font-family: 'GongGothicMedium'; width: 450px; height: 50px; background-color: white; border: 2px solid #F2F2F9; margin: 20px auto; margin-bottom: 40px; padding: 10px 20px; text-align: left;">
                  다른 사람들과 함께 여행을 떠나시겠습니까?
                  <input type="checkbox" name="cb2" id="cb2" style="border: 2px solid #F2F2F9; zoom: 2; padding-left: 50px; float: right;">
                  </div>
               <input type="submit" class="button" id="ok" value="저장하기" style="width: 170px; border: 0; display: block; margin: 20px auto;">
               </form>

            </div>
         </div>
      </div>

   </section>
   <!--================ Banner End =================-->

  

  <!--================ section Start =================-->
   <section class="section-margin pb-xl-5">
      <div class="container">
         

      </div>
   </section>
 <!--================ section End =================-->



  <!-- ================ start footer Area ================= -->
  <%@ include file = "/WEB-INF/inc/footer.jsp"%>


<script>




</script>

</body>
</html>