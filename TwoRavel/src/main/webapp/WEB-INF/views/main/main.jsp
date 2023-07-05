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
  
  p {
      font-family: 'GongGothicMedium';
  }
  
  h2 {
     font-size: 1.5rem;
  }
  
  h2 + div {
     margin-top: 0px;
  }
  
  .plall {
   width: 1000px;
   margin: 0 auto;
}

.inplbox {
   border: 1px solid #F2F2F9;
   display: flex;
   width: 430px;
   height:190px;
   margin: 20px auto;
   padding: 30px 10px;
   background-color: #F8F8FF;
   border-radius: 30px;
}

.plbox {
   display: flex;
}
  
.inplbox > div {
   width: 280px;
   height: 130px;
   padding-left: 10px;
}

.plall > div:nth-child(2) {
   width: 1000px;
   height: 250px;
   float: left;
   display: flex;
   margin: 0 10px;
   padding: 0;
}

i {
   color: #E90000;
   font-size: 1.4rem;
}

  </style>
</head>
<body class="bg-shape">

  <%@ include file = "/WEB-INF/inc/header.jsp"%>
  <!--================ Header , 배너 부분 =================-->


  <!--================ 맨 처음 사이트 설명 페이지 Start  =================-->
  <section class="hero-banner magic-ball">
    <div class="container">

      <div class="row align-items-center text-center text-md-left">
        <div class="col-md-6 col-lg-5 mb-5 mb-md-0">
          <h1><span style="color: gold;">MBTI</span>로 떠나는 여행!</h1>
          <p>혼자 떠나는 여행에 지치셨나요?<br>잘맞는 MBTI 유형의 사람들과 떠나고 싶으신가요?<br>친구와 함께 여행을 계획하고 있으신가요?<br /><span style="font-style: italic;">TwoRAVEL</span>과 함께 멋진 여행을 계획해보세요!</p>
           <c:if test="${empty auth}">
                  <a class="button" href="/tworavel/member/login.do">일정 작성</a>
               </c:if>
               <c:if test="${not empty auth}">
                  <a class="button" href="/tworavel/plan/planstart.do">일정 작성</a>
               </c:if>
            <a class="button" href="/tworavel/reviewboard/review.do" style ="margin:30px;">여행 후기</a>
        </div>
       
        <div class="col-md-6 col-lg-7 col-xl-6 offset-xl-1">
          <img class="img-fluid" src="/tworavel/asset/img/home/hero-img.png" alt="">
        </div>
      </div>
    </div>
  </section>
  <!--================ 맨 처음 사이트 설명 페이지 End =================-->


  <!--================ 랜드마크 추천 Start =================-->
  <%@ include file = "/WEB-INF/views/main/mlandmark.jsp"%>
  <!--================랜드마크 추천 End =================-->


  <!--================ 장소+후기 추천 Start =================-->
   <section class="bg-gray section-padding magic-ball magic-ball-about">
      <div class="container">
         <div class="section-intro text-center pb-90px">
            <img class="section-intro-img"
               src="/tworavel/asset/img/home/section-icon.png" alt="">
            <h2>이곳은 어때요?</h2>
            <p><span style="font-style: italic;">TwoRAVEL</span> 회원들이 다녀온 장소!</p>
         </div>

                  <div class="prall">
         
            <div class="prbox">
               <div class="inprbox">
                  <img src="/tworavel/asset/img/placeimg.png" style="width: 100px; height: 100px; margin-top: 30px; margin-right: 20px;">
                  <div>
                        <h2 style="font-size: 2rem"><span>강릉 풀빌라 케이</span>&nbsp<span style="color: #A3A2A2; font-size: 1.4rem">강원도</span></h2>
                     <div style="font-size: 1.4rem">
                        위치:&nbsp<span>강원도 강릉시 사천면 진리해변길</span><br>
                        테마:&nbsp<span>바다여행</span>
                     </div>
                  </div>
               </div>
               <div style="text-align: center; margin-top: 20px;">
                 <a class="button" href="/tworavel/reviewboard/reviewdetail.do?rseq=72&id=test&cCount=2">후기 보러가기</a>
               </div>
            </div>

            <div class="prbox">
               <div class="inprbox">
                  <img src="/tworavel/asset/img/placeimg.png" style="width: 100px; height: 100px;">
                  <div>
                        <h2 style="font-size: 2rem"><span>제주 올레길</span>&nbsp<span style="color: #A3A2A2; font-size: 1.4rem">제주도</span></h2>
                     <div style="font-size: 1.4rem">
                        위치:&nbsp<span>제주특별자치도 서귀포시 중정로 22 </span><br>
                        테마:&nbsp<span>활동적인</span>
                     </div>
                  </div>
               </div>
               <div style="text-align: center; margin-top: 20px;">
                 <a class="button" href="/tworavel/reviewboard/reviewdetail.do?rseq=69&id=io030&cCount=1">후기 보러가기</a>
               </div>
            </div>

         </div>
         
         <div class="prall">
         
            <div class="prbox">
               <div class="inprbox">
                  <img src="/tworavel/asset/img/placeimg.png" style="width: 100px; height: 100px;">
                  <div>
                        <h2 style="font-size: 2rem"><span>보령 머드축제</span>&nbsp<span style="color: #A3A2A2; font-size: 1.4rem">충청남도</span></h2>
                     <div style="font-size: 1.4rem">
                        위치:&nbsp<span>대천해수욕장 머드광장</span><br>
                        테마:&nbsp<span>이색체험</span>
                     </div>
                  </div>
               </div>
               <div style="text-align: center; margin-top: 20px;">
                 <a class="button" href="/tworavel/reviewboard/reviewdetail.do?rseq=1&id=qlwn7&cCount=6">후기 보러가기</a>
               </div>
            </div>

            <div class="prbox">
               <div class="inprbox">
                  <img src="/tworavel/asset/img/placeimg.png" style="width: 100px; height: 100px;">
                  <div>
                        <h2 style="font-size: 2rem"><span>수원 화성</span>&nbsp<span style="color: #A3A2A2; font-size: 1.4rem">경기도</span></h2>
                     <div style="font-size: 1.4rem">
                        위치:&nbsp<span>경기도 수원시 팔달구 장안동 1-2</span><br>
                        테마:&nbsp<span>감성힐링</span>
                     </div>
                  </div>
               </div>
               <div style="text-align: center; margin-top: 20px;">
                 <a class="button" href="/tworavel/reviewboard/reviewdetail.do?rseq=9&id=trwj24&cCount=2">후기 보러가기</a>
               </div>
            </div>

         </div>
      </div>
   </section>
   <!--================장소 추천 End =================-->
   
   
  <!--================ BEST 일정 Start =================-->
   <section class="section-margin pb-xl-5">
      <div class="container">
         <div class="section-intro text-center pb-90px">
            <img class="section-intro-img"
               src="/tworavel/asset/img/home/section-icon.png" alt="">
            <h2>BEST 일정</h2>
            <p>
               <span style="font-style: italic;">TwoRAVEL</span> 회원들이 선정한 최고의 일정!
            </p>
         </div>

         <div class="plall">

            <c:forEach items="${list}" var="dto">

               <c:if test="${dto.rank == 2}">
               <div>
               </c:if>
               <div class="inplbox"
                  onclick="location.href='/tworavel/shareboard/share.do?sseq=${dto.sseq}'">
                  <c:if test="${dto.rank == 1}">
                     <img src="/tworavel/asset/img/g.png"
                        style="width: 110px; height: 110px; margin-top: 10px;">
                  </c:if>
                  <c:if test="${dto.rank == 2}">
                     <img src="/tworavel/asset/img/s.png"
                        style="width: 110px; height: 110px; margin-top: 10px;">
                  </c:if>
                  <c:if test="${dto.rank == 3}">
                     <img src="/tworavel/asset/img/d.png"
                        style="width: 110px; height: 110px; margin-top: 10px;">
                  </c:if>
                  <div>
                     <h2>
                        <span style="font-size: 1.8rem;">${dto.pname}</span>&nbsp<br><span
                           style="color: #A3A2A2; font-size: 1.3rem; margin-top: 20px;">${dto.locname}</span>
                     </h2>
                     <div style="font-size: 1rem; font-family: 'GongGothicMedium';">
                        작성자:&nbsp<span>${dto.mname}</span><br> <i class="fa-solid fa-heart"></i> ${dto.slike} /
                        테마:&nbsp<span>${dto.ptheme}</span>
                     </div>
                  </div>

               </div>
               <c:if test="${dto.rank == 3}">
               </div>
               </c:if>
            </c:forEach>

            

         </div>
      </div>
   </section>
   
   <!--================ section Start =================-->
  <section class="section-margin generic-margin">
    <div class="container">
       
    </div>
  </section>
  <!--================ section End =================-->
   
   
   <!--================ BEST 일정 End =================-->
   <%@ include file = "/WEB-INF/inc/footer.jsp"%>
</body>
<style>

</style>
</html>