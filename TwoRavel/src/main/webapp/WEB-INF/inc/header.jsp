<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
@font-face {
   font-family: 'Tenada';
   src:
      url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_2210-2@1.0/Tenada.woff2')
      format('woff2');
   font-weight: normal;
   font-style: normal;
}

#logintxt, #hfont li>a {
   font-size: 1.05rem;
   font-family: 'Tenada';
}
</style>
<!--================ Header Menu Area start =================-->
<header class="header_area">
   <div class="main_menu">
      <nav class="navbar navbar-expand-lg navbar-light">
         <div class="container box_1620">
            <a class="navbar-brand logo_h" href="/tworavel/main/main.do"><img
               src="/tworavel/asset/img/flogo.png" alt="" style="width: 190px;"></a>
            <button class="navbar-toggler" type="button" data-toggle="collapse"
               data-target="#navbarSupportedContent"
               aria-controls="navbarSupportedContent" aria-expanded="false"
               aria-label="Toggle navigation">
               <span class="icon-bar"></span> <span class="icon-bar"></span> <span
                  class="icon-bar"></span>
            </button>


            <div class="collapse navbar-collapse offset"
               id="navbarSupportedContent">
               <ul class="nav navbar-nav menu_nav justify-content-end" id="hfont">
                  <!-- 회원가입, 로그인, 랜드마크, 여행 일정 작성, 일정 공유게시판, 후기 게시판(로그인),자유게시판(로그인), 관리자 페이지(로그인), 마이페이지(로그인)  -->
                  <c:if test="${empty auth}">
                  <li class="nav-item"><a class="nav-link" href="/tworavel/member/login.do">여행 일정 작성</a></li>
                  </c:if>
                  
                  <c:if test="${not empty auth}">
                  <li class="nav-item"><a class="nav-link" href="/tworavel/plan/planstart.do">여행 일정 작성</a></li>
                  </c:if>
                  
                  <li class="nav-item"><a class="nav-link" href="/tworavel/member/landmarklist.do">랜드마크</a></li>
                  <li class="nav-item submenu dropdown"><a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">게시판</a>
                     <ul class="dropdown-menu">
                        <li class="nav-item"><a class="nav-link" href="/tworavel/shareboard/share.do">일정 공유 게시판</a></li>
                        <li class="nav-item"><a class="nav-link" href="/tworavel/reviewboard/review.do">후기 게시판</a></li>
                        <c:if test="${not empty auth and pw.length() != 4}">
                        <li class="nav-item"><a class="nav-link" href="/tworavel/freeboard/freeboard.do">자유 게시판</a></li>
                        </c:if>
                     </ul>
                  </li>

                  <!-- 로그인 권한 if 조건 추가  -->
                  <c:if test="${not empty auth and pw.length() != 4}">
                  <li class="nav-item"><a class="nav-link" href="/tworavel/member/mypage.do">마이 페이지</a></li>
                  </c:if>

                  <!-- 로그인 권한 if 조건 추가  -->
                  <c:if test="${not empty auth and pw.length() == 4}">
                     <li class="nav-item submenu dropdown"><a href="#"
                        class="nav-link dropdown-toggle" data-toggle="dropdown"
                        role="button" aria-haspopup="true" aria-expanded="false">관리자</a>
                        <ul class="dropdown-menu">
                           <li class="nav-item"><a class="nav-link"
                              href="/tworavel/member/admintotal.do">통계</a></li>
                           <li class="nav-item"><a class="nav-link"
                              href="/tworavel/member/adminmember.do">회원관리</a></li>
                        </ul></li>
                  </c:if>

                  <c:if test="${empty auth}">
                     <li class="nav-item"><a class="nav-link"
                        href="/tworavel/member/join.do">회원가입</a></li>
                  </c:if>
               </ul>

               <div class="nav-right text-center text-lg-right py-4 py-lg-0">
                  <!-- 로그인 권한 if 조건 추가  -->
                  <c:if test="${empty auth}">
                     <a class="button" href="/tworavel/member/login.do" id="logintxt">Login</a>
                  </c:if>

                  <c:if test="${not empty auth}">
                     <a class="button" href="/tworavel/member/logoutok.do"
                        id="logintxt">Logout</a>
                  </c:if>
                  <!-- <a class="button" href="/tworavel/member/logoutok.do">로그아웃</a> -->
               </div>
            </div>
         </div>
      </nav>
   </div>
</header>















