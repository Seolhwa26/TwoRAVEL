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
</head>
<style>

.sharelist {
	width: 900px;
	font-family: 'GongGothicMedium';
	margin:0 auto; 
}

p, span{
   font-family: 'GongGothicMedium';
}

.btn1{
   width: 120px;
   height: 60px;
   border-radius: 20px;
   margin: 20px;
   font-size: 20px;
   color: white;
   border: 0;
   background-color: #7676FF;
   font-family: 'GongGothicMedium';
   display:block;
}

.btn1:hover {
	background-color: 534ADB;
}

.plan{
	border: 1px solid black; 
	width: 100%; 
	height: 200px; 
	border-radius: 20px; 
	margin-bottom: 30px;
}

.plan:hover{
	background-color: FFF2CC;
}

.seq{
	float: left; 
	width: 20%;
	font-weight: bold; 
	font-size: 8rem;
	text-align: center;
	margin-top: 5px;
}

.detail{
	float: left; 
	width: 40%;
	margin-top: 25px;
}

.cnt{
	float: left; 
	width: 15%;
	width: 20%;
	margin-top: 25px;
}
.jnl{
	float: left; 
	width: 10%;
	margin-top: 10px;
}

.title{
	font-size: 1.5rem;
	color: black;
}
</style>
<body>
  <%@ include file = "/WEB-INF/inc/header.jsp"%>
  <!--================ Header Menu Area start =================-->

   <!--================ section Start =================-->
   <section class="section-margin generic-margin">
      <div class="container">
         <div class="section-intro text-center pb-90px">

            <div class="stitle">
               <img src="/tworavel/asset/img/home/section-icon.png">
               <h2>추천 여행 일정</h2>
            </div>
         </div>
      <div class="sharelist">

				<c:forEach items="${list}" var="dto">
					<div class="plan">
						<div class="seq">${dto.rownum}</div>
						<div class="detail">
							<div class=title>${dto.pname}</div>
							<p>
								<span>${dto.pstart} </span> ~ <span>${dto.pend}</span>
							</p>
							<p>
								<span>${dto.ptheme}</span>
							</p>
							<p>
								<span>${dto.pmcount}</span>명(<span>${dto.pncount}</span> / <span>${dto.pmcount}</span>)
								/<span>
									<c:if test="${dto.pmcount<=dto.pncount}">인원모집완료</c:if>
									<c:if test="${dto.pmcount>dto.pncount}">인원모집중</c:if>
								</span>
							</p>

						</div>

						<div class="cnt">
							<i class="fa-solid fa-heart" style="color: red">&nbsp</i><span>${dto.slike}</span>
							/ <i class="fa-solid fa-eye">&nbsp</i><span>${dto.scount}</span>
							<p style="margin-left: 20px; margin-top: 20px;">글쓴이 MBTI</p>
							<p style="margin-left: 22px;font-size:2rem; color: gold;">${dto.mbti}</p>
						</div>
						<div class="jnl">
						
							<c:if test="${dto.datecheck>0}">
							<form name="planjoin" method="GET" action="/tworavel/plan/recommendok.do?">
							
							<input type="submit" id="join" class="btn1" value="참여하기">
							
							<input type="hidden" name="seq" value="${dto.pseq}">
							
							</form>
							</c:if>
							
							
							<form name="planzim" method="GET" action="/tworavel/plan/zimok.do?">
							
							<input type="submit" id="like" class="btn1" value="찜하기">
							<input type="hidden" name="seq" value="${dto.pseq}">
							
							</form>
							
						</div>
					</div>

				</c:forEach>



			</div>
      
      
      </div>
   </section>
   <!--================ section End =================-->
  
  <!-- ================ start footer Area ================= -->
  <%@ include file = "/WEB-INF/inc/footer.jsp"%>

</body>
</html>