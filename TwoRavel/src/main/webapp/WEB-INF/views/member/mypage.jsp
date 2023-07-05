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
  
   #page1 {
      width: 1200px;
      border-radius: 50px;
      font-size: 20px;
      color: white;
      border: 3px solid #F2F2F2;
      background-color: #FAFAFA;
      font-family: 'GongGothicMedium';
      text-align: center;
      display: inline-block;
      margin: 0 auto;
      margin-top: 100px;
      padding: 20px 0;
   }
   
   
   #b1 {
      width: 1190px;
      height: 60px;
      margin: 0 auto;
      margin-top: 30px;
      padding-top: 5px;    
   }
   
   #b1 > div {
      width: 190px;
      height: 50px;
      display: inline-block;
      font-size: 1.5rem; 
      padding-top: 5px;
    margin: 0 5px;
    color: #7777FF;
   }
   
   #b1 > div:nth-child(1) {
      width: 270px;
   }
   
   #b1 > div:nth-child(4) {
      width: 155px;
   }
   
   #b1 > div:nth-child(5) {
      width: 155px;
   }
   
   #b1 > div:nth-child(6) {
      width: 120px;
   }
   
  #b2 {
      width: 1190px;
      height: 70px;
      border: 2px solid #FAFAFA;
      border-radius: 10px;
      background-color: #E7E6E6;
      margin: 0 auto;
      margin-bottom: 20px;
      padding-top: 8px;
   }
   
   #b2 > div {
      border: 2px solid #FAFAFA;
      border-radius: 15px;
      width: 190px;
      height: 50px;
      display: inline-block;
      color: #595959;
      background-color: white;
      font-size: 1.5rem; 
      padding-top: 5px;
      margin: 0 5px;
   }
   
   #b2 > div:nth-child(1) {
      width: 270px;
   }
   
   #b2 > div:nth-child(4) {
      width: 155px;
   }
   
   #b2 > div:nth-child(5) {
      width: 155px;
   }
   
   #b2 > div:nth-child(6) {
      width: 120px;
   }
   
   .JJim {
        width: 300px;
        height: 70px;
        color: #595959;
        background-color: #FAFAFA;
        border: 2px solid #D0CECE;
        border-radius: 10px;
        margin: 20px 0;   
       padding: 20px auto;
   }
      
   .box {
        width: 500px;
        height: 150px;
        text-align: center;
        color: #595959;
        background-color: #F2F2F2;
        border: 0;
        outline: none;
        border-radius: 20px;
        margin: 20px 0;
     }
        
   .text {
      font-family: 'GongGothicMedium';
      font-style: normal;
      font-size: 50px;
   }
   
   p{
      font-family: 'GongGothicMedium';
      color: black;
   }
   
   .plan{
      border: 2px solid #D0CECE; 
      width: 1190px; 
      height: 185px; 
      border-radius: 20px; 
      margin: 30px 0; 
      background-color: #FAFAFA;
   }
   
   .plan:hover {
      background-color: #FFF2CC; 
   }
   
   .plan:hover > .del{
         display: block;
   }
   
   .seq{
      float: left; 
      width: 10%;
      height: 185px; 
      font-weight: bold; 
      font-size: 5rem;
      margin-left: 30px;
      margin-top: 20px;
   }
   
   .detail{
      float: left; 
      width: 540px;
   }
   
   .cnt{
      float: left; 
      width: 180px;
      height: 100px;
      font-size: 1.5rem;
   }
   
   .jnl{ 
      width: 160px;
      height: 185px;
      float: left; 
   }
  
  .btn01 {
     width: 160px;
     height: 70px;
     font-family: 'GongGothicMedium';
     font-size: 1.3rem;
     color: white;
     background-color: #B5B0FF;
     border: 2px solid #D0CECE; 
     border-radius: 20px;
     margin: 10px auto;
  }
  
  .btn01:hover {
     background-color: #6059F6;
  }
  
  .del{
      float: left; 
      width: 100px;
      font-size: 4rem;
      font-weight: bold;
      margin: 40px 5px;
      padding-left: 25px;
      display: none;
      color: gray;
   }
   
   .del:hover {
         color: black;
        cursor: pointer;
     }
     
  </style>
</head>
<body>
  <%@ include file = "/WEB-INF/inc/header.jsp"%>
  <!--================ Header Menu Area start =================-->
  
   <!--================ Banner Start =================-->
<section class="hero-banner magic-ball">
    <div class="container">
      <div class="row align-items-center text-center text-md-left">
        <div class="col-md-6 col-lg-5 mb-5 mb-md-0" style="margin-top: -170px;">
          <h1 style="font-size: 4rem; text-align: left;">마이페이지</h1>
          <p style="font-size: 2rem; padding-left: 50px; text-align: left;">'${name}'님 반갑습니다!</p>
        </div>
        <div class="col-md-6 col-lg-7 col-xl-6 offset-xl-1">
           <!-- 첨부 이미지 추가 -->
          <img class="img-fluid" src="/tworavel/asset/img/home/hero-img.png" alt="">
        </div>
      </div>
    </div>
  </section>
   <!--================ Banner End =================-->

  <!--================ section Start =================-->
  <section class="section-margin generic-margin" style=" width: 1200px; margin-top: 10px; margin: 0 auto;">
   
    <div class="box1" style="width: 1200px;">
       
       <div id="page1">
         <h1 style="font-size: 25px; text-align: center; padding-top: 10px;">일정 정보 확인</h1>
          
          <div id="b1">
             <div>일정명</div>
             <div>시작일</div>
             <div>종료일</div>
             <div>목적지</div>
             <div>테마</div>
             <div>참여인원</div>
          </div>
          
          <c:forEach items="${list}" var="dto">
          <div id="b2">
             <c:if test="${dto.msauth == 1}">
             <div><i class="fa-solid fa-user-pen"></i> ${dto.pname}</div>
             </c:if>
             <c:if test="${dto.msauth == 2}">
             <div>${dto.pname}</div>
             </c:if>
             <div>${dto.pstart}</div>
             <div>${dto.pend}</div>
             <div>${dto.locname}</div>
             <div>${dto.ptheme}</div>
             <div>(${dto.co}/${dto.pmcount})</div>
          </div>
          </c:forEach>
          
       </div>
     </div>

      <hr style="height: 20px; color: black; margin-top: 100px">

      <div class="JJim" style="margin: 0 auto; margin-top: 50px;">
         <h1 style="font-size: 2rem; text-align: center; padding-top: 15px; color: #595959;">내가 찜한 여행일정</h1>
      </div>

       <c:forEach items="${list2}" var="dto2">
      <div class="plan">

         <div class="seq">${dto2.sseq}</div>

         <div class="detail" style="margin: 20;">
            <p style="font-size: 2rem; margin-bottom: 0; color: #212529;"> ${dto2.pname} <span style="font-size: 1.5rem; color: #7F7F7F;"> ${dto2.locname}</span>
            </p>
            <p style="font-size: 1.5rem; margin-bottom: 0; color: #7F7F7F;">${dto2.pstart}
               ~ ${dto2.pend}</p>
            <p style="font-size: 1.5rem; margin-bottom: 0; color: #212529;;">${dto2.ptheme}</p>
            <c:if test="${dto2.pconnect == 'y'}">
            <p style="font-size: 1rem; margin-bottom: 0; color: #7F7F7F;">
               ${dto2.pmcount}명(${dto2.co} / ${dto2.pmcount}) / 인원모집중</p>
            </c:if>
            <c:if test="${dto2.pconnect == 'n'}">
            <p style="font-size: 1rem; margin-bottom: 0; color: #7F7F7F;">
               ${dto2.pmcount}명(${dto2.co} / ${dto2.pmcount}) / 인원모집완료</p>
            </c:if>
         </div>

         <div class="cnt" style="margin-top: 20px;">
            <i class="fa-solid fa-heart" style="color: red;"></i> ${dto2.slike} / <i
               class="fa-solid fa-eye"></i> ${dto2.scount}
         </div>

         <div class="jnl">
            <input type="button" class="btn01" value="일정 참여하기"> 
            <input type="button" class="btn01" value="일정 가져가기">
         </div>
         
         <div class="del" id="${dto2.sseq}">X</div>
         
      </div>
      </c:forEach>
      
      

      <input type="button" class="button" value="회원 탈퇴" onclick="location.href='/member/unjoin.do';" style="font-size: 1.5rem; border: 0; margin-top: 20px; float: right;">
  
  </section>
  <!--================ section End =================-->
  
  <!--================ section Start =================-->
  <section class="section-margin generic-margin">
    <div class="container">
  
    </div>  
  </section>
  <!--================ section End =================--> 
   
  <!-- ================ start footer Area ================= -->
  <%@ include file = "/WEB-INF/inc/footer.jsp"%>
  
  <script>
  
  $('.del').click(function() {
     
     location.href="/tworavel/member/deljjim.do?sseq=" + event.target.id + "&no=" + ${no};
     
  });
  
  </script>
</body>
</html>