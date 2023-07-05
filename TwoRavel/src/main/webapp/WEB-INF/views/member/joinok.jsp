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
<body>   
  <%@ include file = "/WEB-INF/inc/header.jsp"%>
  <!--================ Header Menu Area start =================-->
 


 

  <!--================ section Start =================-->
  <section class="section-margin generic-margin">
    <div class="container">
       <div id="login1">
       <div id="login2">
         <h1 style="font-size: 15px; text-align: center; padding-top: 30px; color: gold; font-weight: bold;"><span style="font-style: italic;">TwoRAVEL</span> 의 회원이 되신 것을 축하드립니다!</h1>
          <form id="log" method="POST" action="/tworavel/member/loginok.do" style="padding: 0px;">
             <div>
            <h1 style="font-size: 25px; text-align: center; padding-top: 10px; color: #595959; font-weight: bold;"><span style="font-style: italic;">TwoRAVEL</span> 의 기능을<br>마음껏 사용해보세요!</h1>
             </div>
          </form>
          <div id="btn1">
           <a class="button" href="/tworavel/main/main.do">메인으로 돌아가기</a>
           <a class="button" href="/tworavel/member/login.do" style ="margin:30px;">로그인</a>
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