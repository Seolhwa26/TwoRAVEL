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

	@font-face {
	    font-family: 'GongGothicMedium';
	    src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_20-10@1.0/GongGothicMedium.woff') format('woff');
	    font-weight: normal;
	    font-style: normal;
	}

	#id, #pw, .loginbutton {
	    font-family: 'GongGothicMedium';	
	}

</style>
  
  
</head>
<body>
  <%@ include file = "/WEB-INF/inc/header.jsp"%>
  <!--================ Header Menu Area start =================-->
 


 

  <!--================ section Start =================-->
  <section class="section-margin generic-margin">
    <div class="container">
       <div id="login1">
       <div id="login2">
         <h1 style="font-size: 25px; text-align: center; padding-top: 30px;">아이디/비밀번호 로그인</h1>
          <form id="log" method="POST" action="/tworavel/member/loginok.do">
             <div id="in">
             <input type="text" name="id" id="id" placeholder="아이디 입력" required><br>
             <input type="password" name="pw" id="pw" placeholder="비밀번호 입력" required>
             </div>
             <div id="ok">
            <input type="submit" class="loginbutton" value="로그인">
            </div>
          </form>
          <div id="btnlo">
           <a class="button" href="/tworavel/plan/planstart.do">아이디/비밀번호 찾기</a>
           <a class="button" href="/tworavel/member/join.do" style ="margin:30px;">회원가입</a>
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