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
	
	#login1 {
		padding: 50px;
		width: 100vh;
	}
	
	#login2 {
		padding: 20px;
		width: 600px !important;
	}
	
	#btn1 {
		margin: 10px auto !important;
		text-align: center;
		padding: 10px !important;
	}
	

</style>


</head>

<body>   
  <%@ include file = "/WEB-INF/inc/header.jsp"%>
 

  <!--================ section Start =================-->
  <section class="section-margin generic-margin">
    <div class="container">
       <div id="login1">
       <div id="login2">
         <h1 style="font-size: 28px; text-align: center; padding-top: 30px; color: #FFC000; font-weight: 90;">일정 저장이 완료되었습니다!</h1>
          <form id="log" method="POST" action="/tworavel/member/loginok.do" style="padding: 0px;">
             <div>
            <h1 style="font-size: 25px; text-align: center; padding-top: 10px; color: #595959; font-weight: bold;"><span style="font-style: italic;">T<span style="color: gold;">wo</span>RAVEL</span> 과 함께 멋진 여행을 떠나보세요!</h1>
             </div>
          </form>
          <div id="btn1">
           <a class="button" href="/tworavel/main/main.do">메인으로 돌아가기</a>
           <a class="button" href="/tworavel/member/mypage.do" style ="margin:30px;">마이페이지</a>
       </div>
          </div>
       </div>
    </div>
  </section>
  <!--================ section End =================-->


 

  <!-- ================ start footer Area ================= -->
  <%@ include file = "/WEB-INF/inc/footer.jsp"%>

</body>
</html>