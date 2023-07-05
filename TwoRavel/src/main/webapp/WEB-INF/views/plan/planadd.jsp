<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<%@ include file="/WEB-INF/inc/asset.jsp"%>
<style>

@font-face {
    font-family: 'GongGothicMedium';
    src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_20-10@1.0/GongGothicMedium.woff') format('woff');
    font-weight: normal;
    font-style: normal;
}


@font-face {
    font-family: 'Tenada';
    src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_2210-2@1.0/Tenada.woff2') format('woff2');
    font-weight: normal;
    font-style: normal;
}

#logintxt, #hfont li>a {
   font-size: 1.05rem;
   font-family: 'Tenada';
}



.datelist {
   width: 100%;
   height: 100vh;
   margin: 10px auto;
   overflow: scroll;
}

.map_wrap, .map_wrap * {
   margin: 0;
   padding: 0;
	font-family: 'GongGothicMedium';
   font-size: 12px;
}

.map_wrap a, .map_wrap a:hover, .map_wrap a:active {
   color: #000;
   text-decoration: none;
}

.map_wrap {
   position: relative;
   width: 100%;
}

#menu_wrap {
   position: absolute;
   top: 0;
   left: 0;
   bottom: 0;
   width: 250px;
   margin: 10px 0 30px 10px;
   padding: 5px;
   overflow-y: auto;
   background: rgba(255, 255, 255, 0.7);
   z-index: 1;
   font-size: 12px;
   border-radius: 10px;
}

.bg_white {
   background: #fff;
}

#menu_wrap hr {
   display: block;
   height: 1px;
   border: 0;
   border-top: 2px solid #5f5f5f;
   margin: 3px 0;
}

#menu_wrap .option {
   text-align: center;
}

#menu_wrap .option p {
   margin: 10px 0;
}

#menu_wrap .option button {
   margin-left: 5px;
}

#placesList li {
   list-style: none;
}

#placesList .item {
   position: relative;
   border-bottom: 1px solid #888;
   overflow: hidden;
   cursor: pointer;
   min-height: 65px;
}

#placesList .item span {
   display: block;
   margin-top: 4px;
}

#placesList .item h5, #placesList .item .info {
   text-overflow: ellipsis;
   overflow: hidden;
   white-space: nowrap;
}

#placesList .item .info {
   padding: 10px 0 10px 55px;
}

#placesList .info .gray {
   color: #8a8a8a;
}

#placesList .info .jibun {
   padding-left: 26px;
   background:
      url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/places_jibun.png)
      no-repeat;
}

#placesList .info .tel {
   color: #009900;
}

#placesList .item .markerbg {
   float: left;
   position: absolute;
   width: 36px;
   height: 37px;
   margin: 10px 0 0 10px;
   background:
      url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png)
      no-repeat;
}

#placesList .item .marker_1 {
   background-position: 0 -10px;
}

#placesList .item .marker_2 {
   background-position: 0 -56px;
}

#placesList .item .marker_3 {
   background-position: 0 -102px;
}

#placesList .item .marker_4 {
   background-position: 0 -148px;
}

#placesList .item .marker_5 {
   background-position: 0 -194px;
}

#placesList .item .marker_6 {
   background-position: 0 -240px;
}

#placesList .item .marker_7 {
   background-position: 0 -286px;
}

#placesList .item .marker_8 {
   background-position: 0 -332px;
}

#placesList .item .marker_9 {
   background-position: 0 -378px;
}

#placesList .item .marker_10 {
   background-position: 0 -423px;
}

#placesList .item .marker_11 {
   background-position: 0 -470px;
}

#placesList .item .marker_12 {
   background-position: 0 -516px;
}

#placesList .item .marker_13 {
   background-position: 0 -562px;
}

#placesList .item .marker_14 {
   background-position: 0 -608px;
}

#placesList .item .marker_15 {
   background-position: 0 -654px;
}

#pagination {
   margin: 10px auto;
   text-align: center;
}

#pagination a {
   display: inline-block;
   margin-right: 10px;
}

#pagination .on {
   font-weight: bold;
   cursor: default;
   color: #777;
}

.offcanvas-title {
	font-size: 1.5rem;
}


.searchbtn:hover {
   background-color: #4741C9;
}

.spotaddbox {
   width: 500px;
   height: 500px;
   margin: 30px auto;
   background-color: white;
   border-radius: 15px;
   padding: 5px;
   text-align: center;
}


.searchbox {
   margin: 10px auto;
}


.nice-select span {
   padding: 5px;
   text-align: center;
   font-size: 12px;
}

.offcanvas {
   width: 500px;
}



                               
                              
.searchtxt {
	background-color: white;
	width: 330px; 
	height: 45px; 
	margin: 0 5px; 
	padding-left: 10px; 
	border: 0; 
	outline: none;
}

.spotlisttxt {
   width: 350px;
   padding: 7px;
   border: 2px solid gray;
   background-color: #E7E6E6;
   border-radius: 18px;
   color: #555;
   margin: 20px auto;
   cursor: pointer;
}

.spotlisttxt:hover {
   background-color: #FFF2CC;
}

.spotlisttxt h2 {
   font-size: 1.2rem;
   color: #555;
}

.spotlisttxt span {
   font-size: .9rem;
   color: #555;
}


 .stxtbox {
    width: 400px;
    margin: 13.5px auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
 }
 
.saddtitle {
   border: 0px;
   border-radius: 15px;
   padding: 7px;
   font-weight: bold;
   background-color: #E7E6E6;
   text-align: center;
   width: 120px;
   height: 50px;
   font-size: 1.2rem;
   outline: none;
}

.saddtxt {
   border: 0px;
   border-radius: 15px;
   padding: 7px;
   color: #444;
   background-color: #E7E6E6;
   text-align: center;
   width: 280px;
   height: 50px;
   font-size: 1.1rem;
   margin-left: 20px;
}
 
 
/* 장소 등록 select박스 */
 .addtheme {
   width: 250px;
   font-size: 1.3rem;   /* 안먹음 */
}

.scontent {
	text-align: center;
	padding: 20px;
	background-color: #F2F2F2;
}

.subselect {
	font-size: 1.3rem;
	color: #555;
}

input[type=date] {
	color: #555;
	font-size: 1rem;
	margin: 10px;
}

.datesel {
   border: 0px;
   padding: 2px;
   border-radius: 15px;
   text-align: center;
   outline: none;
}

.main_menu {
	background-color: #7676FF;
}

#logintxt, #hfont {
	color: #FFFFFF;
    font-family: 'Tenada';
   }

.nav-item {
    font-family: 'Tenada';
}

input[type=number] {
	margin-top: 0;
	width: 90px;
	height: 40px;
	padding: 5px;
	background-color: white;
	outline: none;
	text-align: center;
	border: 2px solid gray;
	border-radius: 15px;
	font-size: 1rem;
}

#keyword {
	text-align: center;
	padding: 5px;
	border: 2px solid gray;
	border-radius: 15px;

}

.searchbtn {

	border: 2px solid white;
	font-size:.7rem;
	border-radius: 15px;
	background-color: #7676FF;
	color: white;
}

.menubtn {
	background-color: #6059F6;
	font-size: 1rem;
	border: 0;
	width: 100px;
	height: 40px;
	border-radius: 15px;
	margin: 5px;
}

.menubtn:hover {
	background-color: #4741C9;
}

.addlistbtn {
	background-color: #7676FF;
   color: white;
   font-size: 1rem;
   border: 0;
   padding: 0 20px;
   height: 40px;
   border-radius: 5px;
   margin: 5px;
}

.addlistbtn:hover {
   background-color: #6059F6;
}

.spotbox {
   width: 500px;
   margin: 30px auto;
   background-color: white;
   border-radius: 70px;
   padding: 10px;
}


.searchbox {
	margin-top: 20px;
}

#plan {
   position: fixed;
   left: 92%;
   bottom: 30px;
}

.offcanvas, .offcanvas-lg, .offcanvas-md, .offcanvas-sm, .offcanvas-xl,
   .offcanvas-xxl { 
   --bs-offcanvas-width: 600px;
   --bs-offcanvas-height: 100vh;
}

.nice-select {
   margin-left: 20px;
   width: 100px;
   height: 45px;
   color: gray;
   padding-left: 10px;
}

/* select scroll 안될때 */
.nice-select .list {
   height: 180px;
   overflow: scroll;
}

.txt {
   text-align: left;
   display: inline-block;
   color: #7F7F7F;
}

.box1 {
   width: 450px;
   height: 110px;
   border: 2px solid #BFBFBF;
   border-radius: 20px;
   background-color: #E7E6E6;
   margin: 15px 20px;
   display: flex;
   padding: 10px;
   cursor: pointer;
}

.box1:hover {
   background-color: #FFF2CC;
}

#sort {
   width: 490px;
   margin: 0 auto;
}

#sr, #spotsearchbtn {
   background-color: #B9B9FF;
   color: #fff;
   width: 100px;
   height: 100px;
   border-radius: 10px;
   text-transform: capitalize;
   -webkit-transition: all 0.3s ease 0s;
   -moz-transition: all 0.3s ease 0s;
   -o-transition: all 0.3s ease 0s;
   transition: all 0.3s ease 0s;
   font-size: 18px;
   border: 0; 
}

#sr:hover {
   background-color: #FFF2CC;
   color: #fff;
}

#spotsearchbtn:hover {
   background-color: #FFF2CC;
   color: #fff;
}

#abtn {
   margin: 0;
   position: absolute;
   left: -30px;
   top: 0px;
}

.txtop {
   width: 500px;
   padding: 20px;
   margin: 20px auto;
   background-color: white;
   border: 1px solid #E7E6E6;
   border-radius: 20px;
   color: #595959;
}

.cb1:checked + div {
   background-color: #FBE5D6;
}


/* 새로 추가 */

.day {
	font-size: 1.2rem;
	width: 100%;
	border-radius: 10px;
	border: 0px;
	color: white;
	background-color: #7676FF;
	height: 50px;
}

.datedetail {
	border: 0px solid darkgray;
	background-color: #FFFFFF;
	width: 400px; 
	height: 50px; 
	margin: 20px auto;
	margin-bottom: 0;
	text-align: center;
	padding: 0;
	border-radius: 30px;
}

.datedetailbox{
	border: 1px solid #E3E3E3;
	background-color: #EFEFEF;
	width: 100%; 
	height: 500px; 
	margin: 10px auto;
	text-align: center;
	padding: 6px;
	font-size: 1rem;
	border-radius: 10px;
	overflow: scroll;
}

#selday {
   width: 120px;
   height: 45px;
   background-color: gold;
   color: #444;
   border: 0;
   border-radius: 15px;
   font-size: 1.1rem;
   text-align: center;
   padding: 5px;
   padding-top: 7px;
   margin-top: 60px;
   margin-left: -30px;
}


.datedlists {
	width: 90%px;
	margin: 20px auto;
	text-align: center;
	font-size: 1.1rem;
}

.datedlist {
	background-color: #E7E6E6;
	font-size: 1.1rem;
	text-align: center;
	color: #444;
	border: 0px solid gray;
	border-radius: 10px;
	width: 250px;
	height: 40px;
}

.datedlist:hover {
	background-color: #FCEFCA;
}

.addpricebtn {
	margin-left: 5px;
	width: 50px;
	height: 30px;
	border: 1px solid gray;
	color: gray;
	border-radius: 10px;	
}

.offcanvas-body {
	height: 100vh;
}

.roadstxt1, .roadstxt2 {
	width: 170px;
	height: 35px;
	font-size: 1rem;
	color: #444;
	border-radius: 15px;
	border: 2px solid gray;
	margin: 5px;
	outline: none;
	text-align: center;
}

.markerbtn {
	width: 80px;
	height: 30px;
	background-color: #D1CFF4;
	color: #555;
	border-radius: 10px;
	border: 0px solid gray;
	margin: 5px auto;
	margin-left: 20px;
}

/* 더보기 메뉴 css */
.moreviewbar {
    
/*    position: relative; */
/*    left:579px; */
/*    top:55px; */
   width: 550px; 
   height: 250px; 
   background-color: #F2F2F2; 

}

.moreviewbtn:hover {
   background-color: #4741C9;
}

.moreviewbtn {
	margin-top: 10px;
   border: 2px solid white;
   font-size:.7rem;
   border-radius: 15px;
   background-color: #7676FF;
   color: white;
}


/* 교통부분 css */
.transferbtn {
   width: 80px; 
   height: 35px; 
   font-size: 1rem; 
   border: 0px; 
   border-radius: 15px;
   background-color: #7676FF;
   color: white;
   margin: 5px;
}

.transferbtn:hover {
   background-color: #4741C9;
}

.transbox {
   width: 450px;
   height: 115px;
   border: 2px solid #BFBFBF;
   border-radius: 20px;
   background-color: #E7E6E6;
   margin: 15px 20px;
   display: flex;
   padding: 10px;
}

.transbox:hover {
   background-color: #FFF2CC;
}

.non-click {
  background-color: #E7E6E6;
}

.click {
  background-color: #FFF2CC;
}

#nextbtn {
	border-radius: 30px;
	border: 0px;
	width: 150px;
	height: 50px;
    font-family: 'Tenada';
    
}


#nextbtn:hover {
	bakcground-color: #F0CA00;
}

#abtn {
   margin: 0;
   position: absolute;
   left: -30px;
   top: 0px;
}

#accomList{
   width: 490px;
   margin: 0 auto;
}

</style>
</head>
<body>
<header class="header_area">
	<div class="main_menu">
		<nav class="navbar navbar-expand-lg navbar-light">
			<div class="container box_1620">
				<a class="navbar-brand logo_h" href="/tworavel/main/main.do">
					<img src="/tworavel/asset/img/flogo.png" alt="" style="width: 190px;">
				</a>
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
						<li class="nav-item"><a class="nav-link" href="/tworavel/plan/planstart.do">여행 일정 작성</a></li>
						<li class="nav-item"><a class="nav-link" href="/tworavel/member/join.do">랜드마크</a></li>
						<li class="nav-item submenu dropdown"><a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">게시판</a>
							<ul class="dropdown-menu">
								<li class="nav-item"><a class="nav-link" href="/tworavel/shareboard/share.do">일정 공유 게시판</a></li>
								<li class="nav-item"><a class="nav-link" href="/tworavel/reviewboard/review.do">후기 게시판</a></li>
								<c:if test="${not empty auth}">
								<li class="nav-item"><a class="nav-link" href="/tworavel/freeboard/freeboard.do">자유 게시판</a></li>
								</c:if>
							</ul>
						</li>

						<!-- 로그인 권한 if 조건 추가  -->
						<c:if test="${not empty auth and pw.length() != 4}">
						<li class="nav-item"><a class="nav-link" href="/tworavel/member/join.do">마이 페이지</a></li>
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
						<div class="nav-right text-center text-lg-right py-4 py-lg-0">
							<form method="GET" action="/tworavel/plan/plandetail.do" id="senddata">
							
								<a href="#!"><input type="submit" id="nextbtn" style="background-color: gold; color: #555;" value="다음으로"></a>
								
								<input type="hidden" name="local" value="${local}">
								<input type="hidden" name="sdate" value="">
								<input type="hidden" name="edate" value="">
								<input type="hidden" name="mcount" value="">
							
							</form>
				     	</div>
					</div>
			</div>
		</nav>
	</div>
</header>


   <main>
      <!-- 지도 시작  -->
      <div class="map_wrap" style="width: 100%; height: 100vh;">
         <div id="map"
            style="width: 100%; height: 100%; position: relative; overflow: hidden;">
            <!-- 오른쪽 장소 숙박 교통 시작 -->
            <div style="position: absolute; z-index: 100; margin-left: 92%; margin-top: 120px;">
               <button id="placebtn" class="btn btn-primary menubtn" type="button"
                  data-bs-toggle="offcanvas" data-bs-target="#offcanvasPlace"
                  aria-controls="offcanvasPlace">장소 추가</button>

               <button class="btn btn-primary menubtn" type="button"
                  data-bs-toggle="offcanvas" data-bs-target="#offcanvasAccom"
                  aria-controls="offcanvasAccom" id="accombtn">숙박
                  추가</button>

               <button class="btn btn-primary menubtn" type="button"
                  data-bs-toggle="offcanvas" data-bs-target="#offcanvasTransfer"
                  aria-controls="offcanvasTransfer">교통 추가</button>

				<button id="plan" class="btn btn-primary menubtn" type="button"
                  data-bs-toggle="offcanvas" data-bs-target="#offcanvasOpinion"
                  aria-controls="offcanvasOpinion">일정 의견</button>
				  
				  <!-- 0105 -->
				<button class="markerbtn" onclick="hideMarkers()">마커 감추기</button>
    			<button class="markerbtn" onclick="showMarkers()">마커 보이기</button>


					<!-- 장소 사이드 바 시작  -->
               <div class="offcanvas offcanvas-end scontent" data-bs-scroll="true" data-bs-backdrop="false" tabindex="-1"
                  id="offcanvasPlace" aria-labelledby="offcanvasPlaceLabel">
                  <div class="offcanvas-header"
                     style="margin-bottom: 30px; margin-top: 15px;">
                     <div></div>
                     <h3 style="font-size: 2rem;" align="center">장소 추가</h3>
                     <button type="button" class="btn-close"
                        data-bs-dismiss="offcanvas" aria-label="Close"
                        style="font-size: 1.2rem; background-color: white;"></button>
                  </div>
                  <div class="offcanvas-body">
                     <input type="button" value="장소 등록" class="addlistbtn" id="registspot"> 
                     <input type="button" value="장소 찾기" class="addlistbtn" id="addspot">
                     <input type="button" value="일정 추가" id="addday" class="addlistbtn"">

                     <div class="spotsearch">
                     
                           <div class="searchbox">
                              <select name="theme" id="theme" size="10">
                                 <option value="none" selected>💡 테마선택</option>
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
                              <input type="text" placeholder="장소 검색" class="searchtxt" size="20" name="word" id="word"> 
                              <button type="button" id="spotsearchbtn" style="width: 45px; height: 45px;">
	                           <img src="/tworavel/asset/img/search.png" style="width: 35px; height: 35px; border: 0;">
	                          </button>
                              
                           </div>
                           
                           
							
                        <form id="form1">
                           <div class="spotbox">
                           
                           </div>
                        </form>
                           
                           <form id="form2">
                           
                           <div class="spotaddbox" style="display: none;">
                              <div class="stxtbox" style="margin-top: 90px;">
                                 <input type="text" class="saddtitle"value="장소명" readonly>
                                 <input type="text" class="saddtxt" id="plname" name="plname" placeholder="장소명을 입력하세요.">
                              </div>
                              <div class="stxtbox">
                                 <input type="text" class="saddtitle" value="주소" readonly>
                                 <textarea class="saddtxt" id="saddress" placeholder="주소를 입력하세요." style="resize: none; height: 160px;"></textarea>
                                 <input type="hidden" name="lat">
                                 <input type="hidden" name="lng">
                              </div>
                              <div class="stxtbox">
                                 <input type="text" class="saddtitle" value="테마" readonly>
                                 <select name="theme" id="theme1" class="addtheme">
                                    <option value="none" selected>💡 테마선택</option>
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
                           <input type="button" id="spotaddbtn" class="searchbtn" value="등록하기" style="background-color: #7676FF; color: #FFFFFF; padding: 10px; font-size: 1.2rem; border: 0px; width: 100px;">
                           
                           <input type="hidden" name="local" value="${local}">
                           </div>
                        </form>
                     </div>

                  </div>
               </div>

               <!-- 장소 사이드 바 끝  -->

 <!-- 숙박 사이드 바 시작  -->
               
               <div class="offcanvas offcanvas-end scontent" tabindex="-1" id="offcanvasAccom" aria-labelledby="offcanvasAccomLabel">
                  <div class="offcanvas-header" style="margin-bottom: 30px; margin-top: 15px;">
                     <div></div>
                     <h3 style="font-size: 2rem;" align="center">숙박 추가</h3>
                     <button type="button" class="btn-close"
                        data-bs-dismiss="offcanvas" aria-label="Close"
                        style="font-size: 1.2rem; background-color: white;"></button>
                  </div>
                  <div class="offcanvas-body">
                     <input type="button" value="일정 추가" id="accomaddday" class="addlistbtn ad">

                     <form style="width: 500px; height: 50px; margin: 20px auto;">
                             
                           <input type="text" id="accomWord" name ="accomWord" placeholder="가고 싶은 장소를 검색해 보세요."
                              style="background-color: white; width: 330px; height: 45px; margin: 0 5px; padding-left: 10px; border: 0; outline: none;">
      
                           <button type="button" id="searchAccom" style="width: 45px; height: 45px;">
                           <img src="/tworavel/asset/img/search.png" style="width: 35px; height: 35px; border: 0;">
                           </button>
                        </form>
                     
                     <div style="background-color: white; padding: 10px; border-radius: 100px;">

                        <div id="accomList">
                        
                     <c:forEach items="${alist}" var="dto">
                           <div class="box1" onclick="createMarkerAddrA('${dto.aaddress}'); accomAddDayReay('${dto.aname}');">
                              <img src="/tworavel/asset/img/bed.png"
                                 style="width: 90px; height: 90px; margin-right: 20px;">
                              <div class="txt">
                                 <span style="font-size: 17px;">${dto.aname}</span><br>
                                 <span style="font-size: 15px;">${dto.aaddress}</span><br><br>
                                  <span style="font-size: 14px;">가격:${dto.aprice}원</span>
                              </div>
                           </div>
                     </c:forEach>
                        
                        </div>
                        
                     </div>
                  </div>
               </div>
               
               
               <!-- 숙박 사이드 바 끝  -->

               <!-- 교통 사이드 바 시작  -->
               <div class="offcanvas offcanvas-end scontent" tabindex="-1"
                  id="offcanvasTransfer" aria-labelledby="offcanvasTransferLabel">
                  <div class="offcanvas-header" style="margin-bottom: 30px; margin-top: 15px;">
                      <div></div>
                     <h3 style="font-size: 2rem;" align="center">교통 추가</h3>
                     <button type="button" class="btn-close"
                        data-bs-dismiss="offcanvas" aria-label="Close" style="font-size: 1.2rem; background-color: white;"></button>
                  </div>
                  <div class="offcanvas-body">
                  
                     <input type="button" value="일정 추가" class="addlistbtn" id="addListTransfer">
                   
                      <div style="padding: 5px; margin: 5px 0 10px 0;">
                     
                        <input type="button" value="KTX" class="transferbtn" id="searchTrain">
                        <input type="button" value="버스" class="transferbtn" id="searchBus">
                        <input type="button" value="항공" class="transferbtn" id="searchFlight">

                     </div>
                   
               <div style="background-color: white; padding: 10px; border-radius: 10px;">
                        <div class="transfer_main">
                           교통수단을 선택해주세요.
                        </div>
                        <div id="sort">
                     

                           <c:forEach items="${trlist}" var="trdto">
                           <div class="transbox showTrain non-click" style="display: none;" onclick="addTransfer(); selecTransfer();">
                              <img src="/tworavel/asset/img/train.png"
                                 style="width: 90px; height: 90px; margin-right: 20px; border-radius: 5px;">
                              <div class="txt">
                                 <div class="transfer_names" style="font-size: 17px; color: black;">${trdto.trnum}</div>
                                 <div style="font-size: 15px;">출발지: ${trdto.splace}</div>
                                 <div style="font-size: 15px;">도착지: ${trdto.eplace}</div>
                                 <div style="font-size: 14px;">소요시간: ${trdto.trtime}시간</div>
                              </div>
                           </div>
                           </c:forEach>
                           
                           
                           <c:forEach items="${buslist}" var="busdto">
                           <div class="transbox showBus non-click" style="display: none;" onclick="addTransfer(); selecTransfer();">
                              <div><img src="/tworavel/asset/img/bus.png"
                                 style="width: 90px; height: 90px; margin-right: 20px; margin-bottom: 10px; border-radius: 5px;">
                                 </div>
                              <div class="txt">
                                 <div class="transfer_names"style="font-size: 17px; color: black;">${busdto.bnum}</div>
                                 <div style="font-size: 15px;">출발지: ${busdto.splace}</div>
                                 <div style="font-size: 15px;">도착지: ${busdto.eplace}</div>
                                 <div style="font-size: 14px;">소요시간: ${busdto.btime}시간</div>
                              </div>
                           </div>
                           </c:forEach>
                           
                           
                           <c:forEach items="${fllist}" var="fldto">
                           <div class="transbox showFlight non-click" style="display: none;" onclick="addTransfer(); selecTransfer();">
                              <img src="/tworavel/asset/img/flight.png"
                                 style="width: 90px; height: 90px; margin-right: 20px; border-radius: 5px;">
                              <div class="txt">
                                 <div class="transfer_names" style="font-size: 17px; color: black;">${fldto.fnum}</div>
                                 <div style="font-size: 15px;">출발지: ${fldto.splace}</div>
                                 <div style="font-size: 15px;">도착지: ${fldto.eplace}</div>
                                 <div style="font-size: 14px;">소요시간: ${fldto.ftime}시간</div>
                              </div>
                           </div>
                           </c:forEach>
                           
                  </div>
               </div>

                  </div>
               </div>
               
               <!-- 출발일 아래보면 var date1  -->
               <!-- 교통 사이드 바 끝  -->




            </div>
            <!-- 오른쪽 장소 숙박 교통 끝 -->

            <!-- 왼쪽 일정 시작 -->
            <div 
               style="position: absolute; z-index: 100; margin-left: 54px; margin-top: 120px;">

               <button class="btn btn-primary menubtn" id="abtn" type="button"
                  data-bs-toggle="offcanvas" data-bs-target="#offcanvasExample"
                  aria-controls="offcanvasExample">일정 추가</button>
                  
                 <div id="selday">선택날짜</div>
                 

               <!-- 일정 사이드바 시작 -->
               <div class="offcanvas offcanvas-start scontent" data-bs-scroll="true" data-bs-backdrop="false" tabindex="-1"
                  id="offcanvasExample" aria-labelledby="offcanvasExampleLabel">
                  <div class="offcanvas-header" style="margin-bottom: 30px; margin-top: 15px;">
                      <div></div>
                     <h3 style="font-size: 2rem;" align="center">${local}</h3>
                     <button type="button" class="btn-close"
                        data-bs-dismiss="offcanvas" aria-label="Close" style="font-size: 1.2rem; background-color: white;"></button>
                  </div>
                  <div class="offcanvas-body">
                  <div>
                     <div style="background-color: white; padding: 10px; border-radius: 5px; width: 500px; margin: 30px auto; margin-bottom: 10px;">

                        
                        <input type="date" id="sdate" class="datesel"> ~<input type="date" id="edate" class="datesel">
                        <span style="font-size: 1rem;"><input type="number" placeholder="인원수" id="mcountbox" maxlength="2" style="border: 0; margin-left: 5px;"> &nbsp명</span>
                       
                        
                     </div>
                     
                     <div class="scontent">
                        <input type="button" value="적용하기" class="searchbtn" style="width: 100px; height: 35px; font-size: 1.1rem; border: 0px;" onclick="createDate(); updateSdate(); updateEdate(); updateMcount();">
                     </div>
                  </div>
<!-- 		         <div class="datedetailbox" id="datedetail" style="display: none;"> -->
            
                     <!-- 데이트 추가  -->
	               <div class="datelist">
	       

		            </div> 
                     <!-- 데이트 추가 -->
                     
				</div>
				
				                   <!-- 더보기 메뉴 --> 
                   <!--  //////////////유찬 추가//////////////// --> 
 
                  <div class="moreviewbar" id="bar" style="display: none; height: 300px; background-color: #F9F9F9; border-radius: 10px;">
                     <div style="display:flex;">
                  <div style="border: 1px solid black; 
                     width: 275px; height: 225px; margin: 0 auto; margin: 35px; background-color: #FFFFFF;
                        border-radius: 10px;">
                     <div style="height: 30px; margin-top: 10px;">
                        <span style="font-size: 1rem;">[MEMO]</span>
                     </div>
                     <div id="memodetail">
                  		<textarea placeholder="메모 내용을 입력하세요." style=" color: #555; resize: none; padding: 5px; width: 95%; height: 170px; overflow: auto; border: 0px; outline: none; font-size: .9rem;"></textarea>                    
                     </div>
                  </div>
                  <div style="border: 1px solid black; 
                     width: 275px; height: 225px; margin: 0 auto; margin: 35px; background-color: #FFFFFF;
                        border-radius: 10px;">
                     <div style="height: 30px; margin-top: 10px;">
                        <span style="font-size: 1rem; ">[가계부]</span>
                     </div>
                     <div class="accountlist" style="height:170px; text-align: center;">
                  			<input type="text" id="totalprice" placeholder="총 여행 경비를 보여드려요." style=" color: #555; padding: 5px; border: 0px; outline: none; font-size: .9rem; text-align: center;" value="" readonly>               
                  			<input type="button" id="gonbbang" value="N빵하기" class="searchbtn" style="width: 70px; height: 30px; padding: 5px; margin-top: 15px;">    
                  			<input type="button" id="accountreset" value="초기화" class="searchbtn" style="width: 70px; height: 30px; padding: 5px; margin-top: 15px;">    
                  			<hr style="margin: 10px;">
                  			<span style="font-size: .9rem">1인당:&nbsp; <input type="text" id="nbbang" value="" style=" color: #555; padding: 5px; border: 0px; outline: none; font-size: .8rem; width: 100px; text-align: right; margin-right: 5px;" readonly> &nbsp;원</span>
                     </div>
                  </div>
                                 
                     </div>
                  </div>
                  <div>
                  <input type="button" class="moreviewbtn" value="더보기" style="width: 80px; height: 35px; font-size: 1rem; border: 0px; margin-right: 10px;">                     
                  </div>

				

               </div>
                 
               <!-- 일정 사이드바 끝 -->

            
            <!-- 왼쪽 일정 끝 -->
            
            <!-- 일정 의견 사이드 바 시작 23/01/04 설 -->
               <div class="offcanvas offcanvas-end scontent" tabindex="-1"
                  id="offcanvasOpinion" aria-labelledby="offcanvasOpinionLabel">
                  <div class="offcanvas-header"
                     style="margin-bottom: 30px; margin-top: 15px;">
                     <div></div>
                     <h3 style="font-size: 2rem;" align="center">일정 의견</h3>
                     <button type="button" class="btn-close"
                        data-bs-dismiss="offcanvas" aria-label="Close"
                        style="font-size: 1.2rem; background-color: white;"></button>
                  </div>
                  <div class="offcanvas-body">
              
                     <c:if test="${auth != boss}">
                     <form method="GET" action="/tworavel/plan/addokop.do" style="width: 500px; height: 150px; background-color: white; border-radius: 40px; margin: 30px auto; position: relative; left: 0; top: 0;">
                     <textarea name="opinion" style="width: 450px; height: 120px; margin: 15px auto; resize: none; outline: none; border: 0; font-size: 0.9rem;"></textarea>
                     <input type="submit" value="의견 작성하기" id="addOp" class="addlistbtn" style="position: absolute; right: 0px; bottom: -70px;">
                     <input type="hidden" name="local" value="${local}">
                     <input type="hidden" name="pno" value="${pno}">
                     </form>
                     <br><br><br>
                     <hr style="background-color: black; height: 2px; margin-bottom: 20px;">
                     </c:if>
                     
                      <div class="spotbox1">
                           
                      </div>
                      
                        
                     
                  </div>
   
               </div>
               <!-- 일정 의견 사이드 바 끝  --> 
            
            


         </div>



      </div>
      <!-- 지도 끝  -->

      <script type="text/javascript"
         src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d7a1498356f3b5b5426e3e4fd10cf077&libraries=services"></script>
      <!-- <script src="map.js"></script> -->

   </main>

   <script>
   
   //============= 생성되는 장소를 담을 배열 + 갯수//
   let spotcount = 0;

   let accomcount = 0;

   let transcount = 0;
   
	
   function updateEdate() {
	   $('input[name=edate]').val($('#edate').val());
   }
   
   function updateSdate() {
	   $('input[name=sdate]').val($('#sdate').val());	   
   }
   
   function updateMcount() {
	   $('input[name=mcount]').val($('#mcountbox').val());
   }
   
   
   //2023.01.04 유찬 교통 추ㅏ

   $('#searchTrain').click(function() {
      
      $('.showTrain').show();
      $('.showBus').hide();
      $('.showFlight').hide();
      $('.transfer_main').hide();
      
      $('#searchTrain').css('background-color', '#4741C9');
      $('#searchBus').css('background-color', '#7676FF');
      $('#searchFlight').css('background-color', '#7676FF');
      
   });
 
   $('#searchBus').click(function() {
      
      $('.showTrain').hide();
      $('.showBus').show();
      $('.showFlight').hide();
      $('.transfer_main').hide();
      
      $('#searchTrain').css('background-color', '#7676FF');
      $('#searchBus').css('background-color', '#4741C9');
      $('#searchFlight').css('background-color', '#7676FF');
      
   });
   
   $('#searchFlight').click(function() {
      
      $('.showTrain').hide();
      $('.showBus').hide();
      $('.showFlight').show();
      $('.transfer_main').hide();
      
      $('#searchTrain').css('background-color', '#7676FF');
      $('#searchBus').css('background-color', '#7676FF');
      $('#searchFlight').css('background-color', '#4741C9');
      
   });   // 유찬 ----------------------------------------------------
   
   
   
   
   
   $('.moreviewbtn').click(function() {
	     
	      var view = document.getElementById("bar");
	      
	      if(view.style.display == "none") {
	         $('.moreviewbar').show();
	      }
	      else {
	         $('.moreviewbar').hide();
	      }
	      
	   });

	   //2023.01.04추가
	   
	   //DAY 목록 토글
	   var toggle = false;
	   
	   function showDList(i) {
	    	
		   //Day뭔지 텍스트로 가져옴
		   //alert($(event.target.children).text());
		
		   
		if (toggle){
			
			toggle = false;
			$('#date' + i).css('height', '50px');
			$('#datedetail' + i).hide();
			$('#roadbox' + i).hide();
			$('#roadboxbtn' + i).hide();
			
		} else {
			
			toggle = true;
		    $('#date' + i).css('height', '600px');
		    $('#datedetail' + i).show();
		    $('#roadbox' + i).show();
		    $('#roadboxbtn' + i).show();
		    
		    
		    $('#selday').text('');
		    $('#selday').text($(event.target).text()); 
		}
		
	   };

   
   

      //일정에 맞춰서 day 생성
   function createDate() {
       
	   $('.datelist').text('');
    	
	  
      
      const date1 = new Date($('#sdate').val());
      const date2 = new Date($('#edate').val());
      
      const diffDate = date2.getTime() - date1.getTime();
      
      const allDate = (diffDate / (1000 * 60 * 60 * 24))+1;
      
      //alert(allDate);
      
      for (var i=1; i<=allDate; i++) {
         
         temp = '';
         
  

         temp += '<div class="datedetail" id="date' + i + '">';
         temp += '<button class="day" id="day' + i + '" onclick="showDList(' + i + ')">Day0' + i + '</button>';
         
	     temp += '<div class="roadsbox" id="roadbox'+ i +'" style="width: 90%; margin: 10px auto; display: margin-bottom: 5px; flex; justify-content: space-between; display: none;">';
	     temp += '<div class="roadsbox" id="roadboxbtn'+ i +'" style="width: 100%; margin: 5px auto; margin-bottom: 5px; display: flex; justify-content: flex-end;">';
	     temp += '<input type="button" value="길찾기" id="roadsbtn' + i + '" class="searchbtn" style="margin-right: 10px; width: 80px; height: 35px; font-size: 1rem; border: 0px;" onclick="findRoad(' + i + ')">'
	     temp += '<input type="button" value="취소" id="cancelbtn' + i + '" class="searchbtn" style="width: 80px; height: 35px; font-size: 1rem; border: 0px;" onclick="clearRoadSearch(' + i + ')">'
	     temp += '</div>';
	     temp += '<input type="text" value="" class="roadstxt1" id="saddr' + i + '" placeholder="출발지" readonly>'
	     temp += '<input type="text" value="" class="roadstxt2" id="eaddr' + i + '" placeholder="도착지" readonly>'
         temp += '<hr style="margin: 10px;">';
	     temp += '</div>';
         temp += '</div>';
                  
         $('.datelist').append(temp);
         $('#senddata').append('<input type="hidden" name="day" value="' + i + '">');
    	
      }
      
      //alert(Math.abs(diffDate / (1000 * 60 * 60 * 24)));

   };
   
   
   //0105 길찾기 버튼 & 취소 버튼
   
	//길찾기
   function findRoad(index) {
	   
	   let saddr = $('#saddr' + index).val();
	   let eaddr = $('#eaddr' + index).val();
	   
	   window.open("https://map.kakao.com/?sName="+saddr+"&eName="+eaddr);    
	   
   };
   
   //취소
   function clearRoadSearch(index) {
	 
	   $('#saddr' + index).val('');
	   $('#eaddr' + index).val('');
	   
	   
   };
   
   

	//길찾기, 취소 버튼 끝 0105
   
   //===========
    
    function getAddr(id, lat, lng) {
        
        //console.log(id, lat, lng);
        
        let geocoder = new kakao.maps.services.Geocoder();

        let coord = new kakao.maps.LatLng(lat, lng);
        
        let callback = function(result, status) {
        
           
           if (status === kakao.maps.services.Status.OK) {
              
              //console.log(result[0].address.address_name);

              $('#' + id).text(result[0].address.address_name);
                 
           }
              
        }
        
        geocoder.coord2Address(lng, lat, callback)
     }
    
    let temp = '';
    
    let no;
    //설
    $('#plan').click(function() {
       no = 0;
       
        $('.spotbox1').html('');
        
       <c:forEach items="${list1}" var="dto">
       temp = '';
       
       <c:if test="${dto.ocheck == 'y' and auth == boss}">
       temp += '<input type="checkbox" id="' + no +'" class="cb1" name="cb" style="float: right; margin-right: 40px; margin-top: 15px;" checked>'; 
       </c:if>
       <c:if test="${dto.ocheck == 'n' and auth == boss}">
       temp += '<input type="checkbox" id="' + no +'" class="cb1" name="cb" style="float: right; margin-right: 40px; margin-top: 15px;">'; 
        </c:if>
        
       <c:if test="${dto.ocheck == 'y' and auth != boss}">
       temp += '<input type="checkbox" id="' + no +'" class="cb1" name="cb" style="float: right; margin-right: 40px; margin-top: 15px;" disabled checked>'; 
       </c:if>
       <c:if test="${dto.ocheck == 'n' and auth != boss}">
       temp += '<input type="checkbox" id="' + no +'" class="cb1" name="cb" style="float: right; margin-right: 40px; margin-top: 15px;" disabled>'; 
        </c:if>
       
       temp += '<div class="txtop">';
        temp += '<span style="font-size: 1rem;">${dto.oid}</span><br>';
        temp += '<span style="display: block; text-align: left; margin-top: 10px;">${dto.ocontent}</span>';
       temp += '</div>';
             
       $('.spotbox1').append(temp);
       no++;

        </c:forEach> 

        
    });
      
  //설
     $(document).on("click", 'input[name=cb]', function() {
        //alert(event.target.id);   
        if ($(event.target).is(':checked')) {
           location.href="/tworavel/plan/check.do?stat=y&id=" + event.target.id+"&local=${local}&pno=${pno}&cnt1=" + no;
           
        } else {
           location.href="/tworavel/plan/check.do?stat=n&id=" + event.target.id+"&local=${local}&pno=${pno}&cnt1=" + no;
        }
     });
    
    
    
    let plindex = 0;
    $('#placebtn').click(function() {   
       
	   $('.spotaddbox').hide();
	   $('.spotbox').show();
	   $('.spotbox').html('');
       
       <c:forEach items="${list}" var="dto" varStatus="status">
       
       temp = '';
       
       temp += '<div class="spotlisttxt" onclick="createMarker(${dto.pllat}, ${dto.pllng}); addPlanReady();">';
       temp += '<h2 class="plnames">${dto.plname}</h2>';
       temp += '<span class="pthemes">테마: ${dto.ptheme}</span><br>';
       temp += '<div id="spotaddress${status.index}">';
       temp += '</div>';
       temp += '</div>';
       temp += '<input type="hidden" name="pllat" id="pllat${status.index}" value="${dto.pllat}">'
       temp += '<input type="hidden" name="pllng" id="pllng${status.index}" value="${dto.pllng}">'
		
       plindex++;
       
       $('.spotbox').append(temp);
       
       getAddr("spotaddress${status.index}", ${dto.pllat}, ${dto.pllng});

       
       </c:forEach>

    });
    
    
    $('#addspot').click(function() {  
    	
       $('.spotaddbox').hide();
       $('.searchbox').show();
       $('.spotbox').show();
       $('.spotbox').html('');
       
       <c:forEach items="${list}" var="dto" varStatus="status">
       
       temp = '';
       
       temp += '<div class="spotlisttxt" onclick="createMarker(${dto.pllat}, ${dto.pllng}); addPlanReady();">';
       temp += '<h2 class="plnames">${dto.plname}</h2>';
       temp += '<span class="pthemes">테마: ${dto.ptheme}</span><br>';
       temp += '<div id="spotaddress${status.index}">';
       temp += '</div>';
       temp += '</div>';
       temp += '<input type="hidden" name="pllat" id="pllat${status.index}" value="${dto.pllat}">'
       temp += '<input type="hidden" name="pllng" id="pllng${status.index}" value="${dto.pllng}">'

       
       $('.spotbox').append(temp);
       
       getAddr("spotaddress${status.index}", ${dto.pllat}, ${dto.pllng});

       
       </c:forEach>

    });
    
    
    $('#registspot').click(function() {
       
       $(".spotaddbox").show();
       $('.spotbox').hide();
       $('.searchbox').hide();
       
    });
    
       
    
    //=======================ajax
    
    	
   $('#spotaddbtn').click(() => {
	   
	   const clocal = '${local}';
	   const plname = $('#plname').val();
	  
	  $.ajax({
		  
		  type: 'GET',
		  url: '/tworavel/plan/placeadd.do',
		  
		  data: {
			  	
			  	local: clocal,
				plname: $('#plname').val(),
				lat: $('input[name=lat]').val(),
		  		lng: $('input[name=lng]').val(),
		  		theme: $('#theme1').val()

		  },
		  
		  dataType: 'json',
		  
		  success: function(result) {
			  
			  
			  
			  if(result.addResult == 1){
					
			       $('.spotaddbox').hide();
			       $('.searchbox').show();
			       $('.spotbox').show();
				  
			       let temp = '';
			       
			       temp += '<div class="spotlisttxt" onclick="createMarker(' + $("input[name=lat]").val() + ', ' + $("input[name=lng]").val() + '); addPlanReady();">';
			       temp += '<h2 class="plnames">' + $("#plname").val() + '</h2>';
			       temp += '<span class="pthemes">테마: ' + $("#theme1").val() + '</span><br>';
			       temp += '<div id="spotaddress' + plindex + '">';
			       temp += '</div>';
			       temp += '</div>';
			       temp += '<input type="hidden" name="pllat" id="pllat' + plindex + '" value="' + $("input[name=lat]").val() + '">'
			       temp += '<input type="hidden" name="pllng" id="pllng' + plindex + '" value="' + $("input[name=lng]").val() + '">'

			       
			       $('.spotbox').append(temp);
				  
			       plindex++;
			       
			       //입력 폼 리셋
			       $('#plname').val('');
			       $('#saddress').val('');
			       $('#theme1').val('');
			       
			       getAddr("spotaddress${status.index}", $('input[name=lat]').val(), $('input[name=lng]').val());
				  
			       alert('등록에 성공했습니다!');
				  
			  } else {
				  alert('failed');
			  }
			  
		  },
		  
		  error: function(a,b,c) {
			  console.log(a,b,c);
		  }
		  
	  });
	  	   
   });  //장소 등록 한 경우 ajax
   
   
   //<<<<<<<<< 장소 검색 ajax>>>>>>>>>
	
   $('#spotsearchbtn').click(() => {

	   
	   $.ajax({
		   
		   type: 'GET',
		   url: '/tworavel/plan/placesearch.do',
		   
		   data: {
			   
			   word: $('#word').val(),
			   local: '${local}',
			   theme: $('#theme').val()
			   
		   },
		   
		   dataType: 'json',
		   
		   success: function(result) {
 
			   $('.spotbox').html('');
				
			   
			   
			   result.forEach((item, index) => {

				   
				   //json 객체
			       let temp = '';

			       temp += '<div class="spotlisttxt" onclick="createMarker(' + item.pllat + ', ' + item.pllng + '); addPlanReady();">';
			       temp += '<h2 class="plnames">' + item.plname + '</h2>';
			       temp += '<span class="pthemes"> 테마:' + item.ptheme + '</span><br>';
			       temp += '<div id="spotaddress' + index +'">';
			       temp += '</div>';
			       temp += '</div>';
			       temp += '<input type="hidden" name="pllat" id="pllat$'+ index + '" value="' + item.pllat + '">'
			       temp += '<input type="hidden" name="pllng" id="pllng$' + index + '" value="' + item.pllng + '">'

			       
			       $('.spotbox').append(temp);

			       getAddr("spotaddress" + index, item.pllat, item.pllng);
				   
			       
			   }); //forEach
			  
			   
			   
		   }, //success
		   
		   error: function(a,b,c) {
			   console.log(a,b,c);
		   }
		   
		   
	   });
	   
	   
   }); //장소 검색 ajax
   
   //<<<<<< < 장소 검색 ajax end>>>>>>>>
   
   //<<<<<<<<< 숙박 검색 ajax >>>>>>>>>>
   
   $('#searchAccom').click(() => {

      
      $.ajax({
         
         type: 'GET',
         url: '/tworavel/plan/accomsearch.do',
         
         data: {
            
            word: $('#accomWord').val(),
            local: '${local}',         
         },
         
         dataType: 'json',
         
         success: function(result) {
 
            $('#accomList').html('');
            
            
            
            result.forEach((item, index) => {

               
               //json 객체
                let temp = '';
               /* console.log();
               console.log("I said, \'" +item.aaddress+ "`\'"); */
               
                temp += '<div class="box1" onclick="createMarkerAddrA(\''+item.aaddress+'\'); accomAddDayReay(\''+ item.aname+'\');">';
                /* temp += `<div class="box1" onclick=`createMarkerAddrA(`\${item.aaddress}`); accomAddDayReay(`\${item.aname}`);`>`; */
                temp += '<img src="/tworavel/asset/img/bed.png" style="width: 90px; height: 90px; margin-right: 20px;">';
                temp += '<div class="txt">';
                temp += '<span style="font-size: 17px;">'+ item.aname + '</span><br>';
                temp += '<span style="font-size: 15px;">'+ item.aaddress+'</span><br><br>';
                temp += '<span style="font-size: 14px;">가격:'+ item.aprice +'원</span>';
                temp += '</div>'
                temp += '</div>'

                $('#accomList').append(temp);

                //getAddr("spotaddress" + index, item.pllat, item.pllng);
               
                
            }); //forEach
           
            
            
         }, //success
         
         error: function(a,b,c) {
            console.log(a,b,c);
         }
         
         
      });
      
      
   });
   
   //<<<<<<< 숙박 검색 ajax end >>>>>>>>
   
   
       // ============== 유찬 ajax
   let transname = '';
       
   let tcnt = 0;
   let acnt = 0;
    
   function addTransfer() {
      
            //선택한 교통수단의 이름
            //alert($(event.currentTarget).find('.transfer_names').text());
            
            transname = $(event.currentTarget).find('.transfer_names').text();
            
            $('#addListTransfer').bind('click', function() {
                doAddList();  
             });
          
           
          var doAddList = function(){
             $('#addListTransfer').unbind('click');
            
             $.ajax({
                
                type: 'GET',
                url: '/tworavel/plan/transferadd.do',
                data: {
                   
                   day: $('#selday').text(),
                   transname: transname   
  
                   //여기
                },
               
                dataType: 'json',
                
                success: function(result) {
                    
                   let[a, b] = (result.day).split('0');
                   
                   
                   temp = '';
                      
                   
                      temp += '<div class="datedlists" id="datedetail' + tcnt + '">';
                      
                      //ktx, bus, flight 경우에 따라 다르게 나오게
                      if(transname.length == 6) {
                          temp += '<input type="button" value="KTX(' + result.trnum + ')" class="datedlist" id="datedlist"' + tcnt + '">';
                       
                      } else if(transname.length == 4) {
                         temp += '<input type="button" value="버스(' + result.bnum + ')" class="datedlist" id="datedlist"' + cnt + '">';
                         
                      } else if(transname.length == 5) {
                         temp += '<input type="button" value="비행기(' + result.fnum + ')" class="datedlist" id="datedlist"' + cnt + '">';
                         
                      }
                      
                temp += '<input type="button" class="addpricebtn" id="pricebtn' + acnt + '" value="비용" onclick="showPriceBox(' + acnt + ')">';
                    temp += '<span style="cursor:pointer; margin-left: 5px; font-size: 1.6rem; color: gold;" onclick = "transdel(' + b + ','+ acnt + ')">&times;</span>';
                temp += '<div class="spotpricediv" id="spotpriceid' + acnt + '" style="width: 350px; margin: 0 auto; font-size: 1rem; display: none;">';
                temp += '예상 비용: ';
                temp += '<input type="text" class="spotpricebox" id="spotprice' + acnt + '" style="width:100px; font-size:.8rem; margin:10px auto; padding: 5px; border: 1px solid gray; text-align:center;" value="" placeholder="예상비용 입력">';
                temp += '<input type="button" class="searchbtn" id="addpricebtn' + acnt + '"style="width:50px; height: 30px; font-size: 1.1rem; margin:5px auto; margin-left: 10px; border: 1px solid gray;" value="+" onclick="priceAccount(' + acnt + ')">';
                temp += '<input type="button" class="searchbtn" id="activepricebtn' + acnt + '"style="width:50px; height: 30px; font-size: .7rem; margin:5px auto; margin-left: 10px; border: 1px solid gray;" value="수정" onclick="activeAddPrice(' + acnt + ')">';
                temp += '</div>';
                    temp += '</div>';
                     
                               
                     $('#date'+b).append(temp);
                   
                      //transcount++;
                      
                     $('#senddata').append('<input type="hidden" id="transsend' + acnt + '" name="translist" value="' + result.trnum  + b + '">');
                     //$('input[name=transcount]').val(transcount);
                      
                      //$('#offcanvasExample').addClass('show');
                      
                      
                      alert('일정에 등록되었습니다!');

                      
                      
                }, //success
                
                error: function(a,b,c) {
                   console.log(a,b,c);
                }
                
                
             }).done(function() {
                $('#foo').bind('click', function() {
                   doSomething();  
                });    
             });
          }

       tcnt++;
 };
 
            
	 function selecTransfer() {
	     
	     $('.transbox').css('background-color', '#E7E6E6');
	       $(event.currentTarget).css('background-color', '#FFF2CC');
	
	  }
   
   
    // ============== 유찬 ajax 끝
   
    
      //========================== 선택한 일정끼리 선 추가하기
		// 선을 구성하는 좌표 배열입니다. 이 좌표들을 이어서 선을 표시합니다
		var linePath = [];
		var polyline = '';
		
   	function LineCreate(lat, lng){

		linePath.push(new kakao.maps.LatLng(lat, lng));
		

		// 지도에 표시할 선을 생성합니다
		polyline = new kakao.maps.Polyline({
		    path: linePath, // 선을 구성하는 좌표배열 입니다
		    strokeWeight: 5, // 선의 두께 입니다
		    strokeColor: '#7474FA', // 선의 색깔입니다
		    strokeOpacity: 1, // 선의 불투명도 입니다 1에서 0 사이의 값이며 0에 가까울수록 투명합니다
		    strokeStyle: 'solid' // 선의 스타일입니다
		});
		
		// 지도에 선을 표시합니다 
		//polyline.setMap(map);  
		   
   }
	   
	//=========================
		
   //여행 경로 선으로 표시하기

   	function showLine(){
		polyline.setMap(map);  
	}

   
   	function hideLine(){
		
   		linePath = [];

   		polyline.setMap(null);  
		
	}
   
   
   //여행 경로 선으로 표시하기 끝
		

   
   //======= 일정 추가============
	   
	   let cnt = 0;	
	   let plname = '';
	   var ajax_last_num = 0; // 마지막 요청 카운트 저장. 전역변수 

		// ajax 요청 시작 전 ajax 요청이 들어있는 함수의 지역변수 
		var current_ajax_num = ajax_last_num;
	   
		// ajax 중복요청왔을때 계속 ajax success 코드실행을
		// 방지하기 위해 지금 들어온 요청의 카운트 저장 
		
	    function accomAddDayReay(aname) {

   			$('#accomaddday').bind('click', function() {
   				
   					
   				if($('#selday').text() == '' || $('#selday').text() == '선택날짜'){
   					alert('여행할 날을 선택해주세요!');
   				} else {
   					doSomething();  
   				}
   				
   			});
   			
   			
   		
   		 
   		var doSomething = function(){
   			
   			$('#accomaddday').unbind('click');
   		  
			   $.ajax({
				   
				   type: 'GET',
				   url: '/tworavel/plan/dayaddaccom.do',
				   data: {
					   
					   day: $('#selday').text(),
					   aname: aname,
					   local: '${local}'
					   
				   },
				  
				   dataType: 'json',
				   
				   success: function(result) {
		 				
					   let[a, b] = (result.day).split('0');
					   
					   
					   temp = '';
							
					   
					   temp += '<div class="datedlists" id="datedetail' + cnt + '">';
				       temp += '<input type="button" value="' + result.aname + '" class="datedlist" id="datedlist' + cnt + '" onclick="roadSearch(' + b + ',' + cnt + ')">';
				       temp += '<input type="button" class="addpricebtn" id="pricebtn' + cnt + '" value="비용" onclick="showPriceBox(' + cnt + ')">';
				       temp += '<span style="cursor:pointer; margin-left: 5px; font-size: 1.6rem; color: gold;" onclick = "accomdel(' + b + ','+ cnt + ')">&times;</span>';
				       temp += '<div class="spotpricediv" id="spotpriceid' + cnt + '" style="width: 350px; margin: 0 auto; font-size: 1rem; display: none;">';
				       temp += '예상 비용: ';
				       temp += '<input type="text" class="spotpricebox" id="spotprice' + cnt + '" style="width:100px; font-size:.8rem; margin:10px auto; padding: 5px; border: 1px solid gray; text-align:center;" value="" placeholder="예상비용 입력">';
				       temp += '<input type="button" class="searchbtn" id="addpricebtn' + cnt + '"style="width:50px; height: 30px; font-size: 1.1rem; margin:5px auto; margin-left: 10px; border: 1px solid gray;" value="+" onclick="priceAccount(' + cnt + ')">';
				       temp += '<input type="button" class="searchbtn" id="activepricebtn' + cnt + '"style="width:50px; height: 30px; font-size: .7rem; margin:5px auto; margin-left: 10px; border: 1px solid gray;" value="수정" onclick="activeAddPrice(' + cnt + ')">';
				       temp += '</div>';
				       temp += '</div>';
				        
				                  
				         $('#date'+b).append(temp);

				         //accomcount = $('#date'+b).children().length;
						
				        $('#senddata').append('<input type="hidden" id="accomsend' + cnt + '" name="accomlist" value="' + result.aname  + b + '">');				   	
				        //$('#senddata').append('<input type="hidden" name="' + b + 'accomcount" value="' + accomcount + '">');		
				         
				         
				         //$('#offcanvasExample').addClass('show');
				         
				         alert('일정에 등록되었습니다!');
					
				         LineCreate(result.pllat, result.pllng);
				         
				         
				   }, //success
				   
				   error: function(a,b,c) {
					   console.log(a,b,c);
				   }
				   
				   
			   }).done(function() {
   				$('#foo').bind('click', function() {
   					doSomething();  
   				});    
   			});
   		}

	   cnt++;
	};
		

	   	cnt = 0;	
		ajax_last_num = 0; // 마지막 요청 카운트 저장. 전역변수 

			// ajax 요청 시작 전 ajax 요청이 들어있는 함수의 지역변수 
		current_ajax_num = ajax_last_num;
		
	   function addPlanReady() {
	   
	   		//선택한 지역명
	   		plname = $(event.currentTarget).find('.plnames').text();

	   		
	   			$('#addday').bind('click', function() {
	   				
	   					
	   				if($('#selday').text() == '' || $('#selday').text() == '선택날짜'){
	   					alert('여행할 날을 선택해주세요!');
	   				} else {
	   					doSomething();  
	   				}
	   				
	   			});
	   		
	   		 
	   		var doSomething = function(){
	   			$('#addday').unbind('click');
	   		  
				   $.ajax({
					   
					   type: 'GET',
					   url: '/tworavel/plan/dayadd.do',
					   data: {
						   
						   day: $('#selday').text(),
						   plname: plname,
						   local: '${local}'
						   
					   },
					  
					   dataType: 'json',
					   
					   success: function(result) {
			 				
						   let[a, b] = (result.day).split('0');
						   
						   
						   temp = '';
								
						   
						   temp += '<div class="datedlists" id="datedetail' + cnt + '">';
					       temp += '<input type="button" value="' + result.plname + '" class="datedlist" id="datedlist' + cnt + '" onclick="roadSearch(' + b + ',' + cnt + ')">';
					       temp += '<input type="button" class="addpricebtn" id="pricebtn' + cnt + '" value="비용" onclick="showPriceBox(' + cnt + ')">';
					       temp += '<span style="cursor:pointer; margin-left: 5px; font-size: 1.6rem; color: gold;" onclick = "pldel(' + b + ',' + cnt + ')">&times;</span>';
					       temp += '<div class="spotpricediv" id="spotpriceid' + cnt + '" style="width: 350px; margin: 0 auto; font-size: 1rem; display: none;">';
					       temp += '예상 비용: ';
					       temp += '<input type="text" class="spotpricebox" id="spotprice' + cnt + '" style="width:100px; font-size:.8rem; margin:10px auto; padding: 5px; border: 1px solid gray; text-align:center;" value="" placeholder="예상비용 입력">';
					       temp += '<input type="button" class="searchbtn" id="addpricebtn' + cnt + '"style="width:50px; height: 30px; font-size: 1.1rem; margin:5px auto; margin-left: 10px; border: 1px solid gray;" value="+" onclick="priceAccount(' + cnt + ')">';
					       temp += '<input type="button" class="searchbtn" id="activepricebtn' + cnt + '"style="width:50px; height: 30px; font-size: .7rem; margin:5px auto; margin-left: 10px; border: 1px solid gray;" value="수정" onclick="activeAddPrice(' + cnt + ')">';
					       temp += '</div>';
					       temp += '</div>';
					        
					                  
					         $('#date'+b).append(temp);
					         
					         
					         //spotcount = $('#date'+b).children().length;
							
					        $('#senddata').append('<input type="hidden" id="spotsend' + cnt + '" name="spotlist" value="' + result.plname  + b + '">');			
					        
					        //$('#senddata').append('<input type="hidden" name="' + b + 'spotcount" value="' + spotcount + '">');				   	
					        
					        
					         //$('#offcanvasExample').addClass('show');
					         
					         
					         alert('일정에 등록되었습니다!');
						
					         LineCreate(result.pllat, result.pllng);
					         
					         
					   }, //success
					   
					   error: function(a,b,c) {
						   console.log(a,b,c);
					   }
					   
					   
				   }).done(function() {
	   				$('#foo').bind('click', function() {
	   					doSomething();  
	   				});    
	   			});
	   		}

		   cnt++;
   };
   
   

	  
   //=======================0105
   
			toggle = false;

   //금액 입력창 보이게하기(토글)
   function showPriceBox(index){
	   
	   if (toggle){
			
			toggle = false;
			
	   		$('#spotpriceid'+index).hide();
	   
	   } else {
			
			toggle = true;
	   		$('#spotpriceid'+index).show();
		}
   }
   
	   let total = 0;
   //금액 가계부에 추가하기
   function priceAccount(index) {
	   
	   $('#addpricebtn'+index).attr('disabled', true);
	   
	   total += parseInt($('#spotprice' + index).val());
	   
	   $('#totalprice').val(total);
	   
   }
   
   // 금액 수정
   function activeAddPrice(index) {
	   
	   $('#addpricebtn'+index).attr('disabled', false);
	   
	   total -= parseInt($('#spotprice' + index).val()); 
	   
	   $('#totalprice').val(total);
   }
   
   // 가계부 초기화 버튼
   $('#accountreset').click(() => {
		
	   $('.spotpricebox').val("");
	   $('#totalprice').val("");
	   $('#nbbang').val("");
	   
   });
   
   //n빵하기 버튼
   $('#gonbbang').click(() => {
	   
	   let mcount = parseInt($('#mcountbox').val());
	   
	   if($('#mcountbox').val() === "") {
		   alert('인원수를 체크해주세요!');
	   } else {
		   $('#nbbang').val(total/mcount);
	   }
	   
	   
   });
   
   //일정추가 목록에서 삭제하는 기능   
   function accomdel(day, index) {
	   
	   //alert(index);
	   
	   if (confirm('일정에서 삭제하시겠습니까?')) {
		   
		   $('#datedetail' + index).remove();	 
		   
		   $('#accomsend' + index).remove();
		  // $('input[name="' + day + 'accomname' + index + '"]').remove();	
		   //$('input[name="' + day + 'spotcount"').val($('input[name="' + day + 'spotcount"').val()-1);	
		  	
			
	   }	   
   };
   
   function pldel(day, index) {
	   
	   //alert(index);
	   
	   if (confirm('일정에서 삭제하시겠습니까?')) {
		   
		   $('#datedetail' + index).remove();	  
		   
		   $('#spotsend' + index).remove();	
		   

			
	   }	   
   };
   
   
   function transdel(day, index) {
	   
	   //alert(index);
	   
	   if (confirm('일정에서 삭제하시겠습니까?')) {
		   
		   $('#datedetail' + index).remove();	  
		   
		  $('#transsend' + index).remove();	
		   

			
	   }	   
   };
   
   
   //길찾기 검색창 0105
   function roadSearch(day, index) {

	   
	   let plname = $('#datedlist' + index).val();
	   
	   if(($('#saddr' + day).val()) == '') {
   
	   	//alert($('#datedlist' + index).val())
	   	
	   	$('#saddr' + day).val(plname);
		
	   	plname = '';
	   	
	   } else if(($('#eaddr' + day).val()) == '') {
		   
		$('#eaddr' + day).val(plname);
	   }
	   
   }
   

    //========================ajax end
    
    
    function removeMarker() {
        for ( var i = 0; i < markers.length; i++ ) {
            markers[i].setMap(null);
        }   
        markers = [];
    }
    
    // 마커를 담을 배열입니다
    var markers = [];
    let presentPosition;
	
    var addrlat = null;
    var addrlng = null;
    
	
    toggle = false;
    
    // 마커 추가 + 지도 이동
    function createMarker(lat, lng) {
    	
    	
    	if (toggle) {
    		toggle = false;
    		$('.spotlisttxt').css('background-color', '#E7E6E6');
    		$(event.currentTarget).css('background-color', '#FFF2CC');
    	} else {
    		toggle = true;
    		$('.spotlisttxt').css('background-color', '#E7E6E6');
    		$(event.currentTarget).css('background-color', '#FFF2CC');
    		
    	}
    	
       removeMarker();

       var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png', // 마커이미지의 주소입니다    
        imageSize = new kakao.maps.Size(25, 35), // 마커이미지의 크기입니다
        imageOption = {offset: new kakao.maps.Point(27, 69)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
          
       // 마커의 이미지정보를 가지고 있는 마커이미지를 생성합니다
       var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption),
           markerPosition = new kakao.maps.LatLng(lat, lng); // 마커가 표시될 위치입니다
    
       // 마커를 생성합니다
       var marker = new kakao.maps.Marker({
           position: markerPosition, 
           image: markerImage // 마커이미지 설정 
       });
    
       // 마커가 지도 위에 표시되도록 설정합니다
       marker.setMap(map);               
       markers.push(marker);  // 배열에 생성된 마커를 추가합니다
        
       
       // 이동할 위도 경도 위치를 생성합니다 
       var moveLatLon = new kakao.maps.LatLng(lat, lng);
           
       // 지도 중심을 부드럽게 이동시킵니다
       // 만약 이동할 거리가 지도 화면보다 크면 부드러운 효과 없이 이동합니다
       map.panTo(moveLatLon);  
       
          return marker;
       }; //createMarker

       
      //=========================================
       
    	  toggle = false;

       
      //주소로 위도 경도 변환 후 마커
      function createMarkerAddrA(address) {
    	   
      	if (toggle) {
    		toggle = false;
    		$('.box1').css('background-color', '#E7E6E6');
    		$(event.currentTarget).css('background-color', '#FFF2CC');
    	} else {
    		toggle = true;
    		$('.box1').css('background-color', '#E7E6E6');
    		$(event.currentTarget).css('background-color', '#FFF2CC');
    		
    	}
    	  
       let geocoder = new kakao.maps.services.Geocoder();  
    	
       geocoder.addressSearch(address, function(result, status) {

    	    // 정상적으로 검색이 완료됐으면 
    	     if (status === kakao.maps.services.Status.OK) {

    	        addrlat = result[0].y;
    	        addrlng = result[0].x;
				
    	    } 
    	});
       
       
       removeMarker();

       var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png', // 마커이미지의 주소입니다    
        imageSize = new kakao.maps.Size(25, 35), // 마커이미지의 크기입니다
        imageOption = {offset: new kakao.maps.Point(27, 69)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
          
       // 마커의 이미지정보를 가지고 있는 마커이미지를 생성합니다
       var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption),
           markerPosition = new kakao.maps.LatLng(addrlat, addrlng); // 마커가 표시될 위치입니다
    
       // 마커를 생성합니다
       var marker = new kakao.maps.Marker({
           position: markerPosition, 
           image: markerImage // 마커이미지 설정 
       });
    
       // 마커가 지도 위에 표시되도록 설정합니다
       marker.setMap(map);               
       markers.push(marker);  // 배열에 생성된 마커를 추가합니다
        
       
       // 이동할 위도 경도 위치를 생성합니다 
       var moveLatLon = new kakao.maps.LatLng(addrlat, addrlng);
           
       // 지도 중심을 부드럽게 이동시킵니다
       // 만약 이동할 거리가 지도 화면보다 크면 부드러운 효과 없이 이동합니다
       map.panTo(moveLatLon);  
       
          return marker;
       };
       
       //==========================================
    	   
      
   /////////////////지도의 중심을 현재 위치로 변경///////////////////////
   var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
       mapOption = { 
           center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
           level: 5 // 지도의 확대 레벨 
       }; 
    
   var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
    
   // HTML5의 geolocation으로 사용할 수 있는지 확인합니다 
   if (navigator.geolocation) {
       
       // GeoLocation을 이용해서 접속 위치를 얻어옵니다
       navigator.geolocation.getCurrentPosition(function(position) {
           
    	   var lat = ${loclat}//position.coords.latitude, // 위도
               lon = ${loclng}//position.coords.longitude; // 경도
           
           var locPosition = new kakao.maps.LatLng(lat, lon) // geolocation으로 얻어온 좌표
           presentPosition=locPosition;
    
           map.setCenter(locPosition);   
               
         });
       
   } else { // HTML5의 GeoLocation을 사용할 수 없을때 
       
       var locPosition = new kakao.maps.LatLng(37.566826, 126.9786567)
       alert('현재 위치를 찾을 수 없습니다!');
   }
    
   
   marker = null;
   
   //이벤트 >0105 수정
   kakao.maps.event.addListener(map, 'click', function(evt) {
	   
	   removeMarker();
      
      let lat = evt.latLng.getLat();
      let lng = evt.latLng.getLng();
      
      var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png', // 마커이미지의 주소입니다    
       imageSize = new kakao.maps.Size(25, 35), // 마커이미지의 크기입니다
       imageOption = {offset: new kakao.maps.Point(10, 25)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
         
      // 마커의 이미지정보를 가지고 있는 마커이미지를 생성합니다
      var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption)
       
      //1. 마커 표시
      
      if (marker != null) {
    	  marker.setMap(null);
      }
      
      marker = new kakao.maps.Marker({
         position: evt.latLng,
         image: markerImage
      });
      
      marker.setMap(map);
      markers.push(marker);
      
      let geocoder = new kakao.maps.services.Geocoder();

      let coord = new kakao.maps.LatLng(lat, lng);
      
      let callback = function(result, status) {
      
         
         if (status === kakao.maps.services.Status.OK) {
            $('#saddress').val(result[0].address.address_name);
         }
            
      }
      
      geocoder.coord2Address(lng, lat, callback)
      
      
      //2. 입력폼 표시
      $('#lat').text(lat);
      $('#lng').text(lng);
      
      //찍은 곳의 주소 출력하기
      
      
      //3. 전송 > 히든태그 입력
      $('input[name=lat]').val(lat);
      $('input[name=lng]').val(lng);
      
   });

   
   // 배열에 추가된 마커들을 지도에 표시하거나 삭제하는 함수입니다
      function setMarkers(map) {
          for (var i = 0; i < markers.length; i++) {
              markers[i].setMap(map);
          }            
      }

      // "마커 보이기" 버튼을 클릭하면 호출되어 배열에 추가된 마커를 지도에 표시하는 함수입니다
      function showMarkers() {
          setMarkers(map)    
      }

      // "마커 감추기" 버튼을 클릭하면 호출되어 배열에 추가된 마커를 지도에서 삭제하는 함수입니다
      function hideMarkers() {
          setMarkers(null);    
      }
   
   //========0105  마커 끝
   
   /*
   ////////////////////장소 검색/////////////////////////////
   // 장소 검색 객체를 생성합니다
   var ps = new kakao.maps.services.Places();  
    
   // 검색 결과 목록이나 마커를 클릭했을 때 장소명을 표출할 인포윈도우를 생성합니다
   var infowindow = new kakao.maps.InfoWindow({zIndex:1});
    
   const searchForm = document.querySelector('.form');
   searchForm.addEventListener('submit', function(e){
       e.preventDefault();
       // 키워드로 장소를 검색합니다
       searchPlaces();
   })
    
    
   // 키워드 검색을 요청하는 함수입니다
   function searchPlaces() {
    
       var keyword = document.getElementById('keyword').value;
    
       if (!keyword.replace(/^\s+|\s+$/g, '')) {
           alert('키워드를 입력해주세요!');
           return false;
       }
    
       // 장소검색 객체를 통해 키워드로 장소검색을 요청합니다
       ps.keywordSearch( keyword, placesSearchCB); 
   }
    
   // 장소검색이 완료됐을 때 호출되는 콜백함수 입니다
   function placesSearchCB(data, status, pagination) {
       if (status === kakao.maps.services.Status.OK) {
    
           // 정상적으로 검색이 완료됐으면
           // 검색 목록과 마커를 표출합니다
           displayPlaces(data);
    
           // 페이지 번호를 표출합니다
           displayPagination(pagination);
    
       } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
    
           alert('검색 결과가 존재하지 않습니다.');
           return;
    
       } else if (status === kakao.maps.services.Status.ERROR) {
    
           alert('검색 결과 중 오류가 발생했습니다.');
           return;
    
       }
   }
    
   // 검색 결과 목록과 마커를 표출하는 함수입니다
   function displayPlaces(places) {
    
       var listEl = document.getElementById('placesList'), 
       menuEl = document.getElementById('menu_wrap'),
       fragment = document.createDocumentFragment(), 
       bounds = new kakao.maps.LatLngBounds(), 
       listStr = '';
       
       // 검색 결과 목록에 추가된 항목들을 제거합니다
       removeAllChildNods(listEl);
    
       // 지도에 표시되고 있는 마커를 제거합니다
       removeMarker();
       
       for ( var i=0; i<places.length; i++ ) {
    
           const lon = places[i].x;
           const lat = places[i].y;
    
           // 마커를 생성하고 지도에 표시합니다
           var placePosition = new kakao.maps.LatLng(places[i].y, places[i].x),
               marker = addMarker(placePosition, i), 
               itemEl = getListItem(i, places[i]); // 검색 결과 항목 Element를 생성합니다
    
           // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
           // LatLngBounds 객체에 좌표를 추가합니다
           bounds.extend(placePosition);
    
           // 마커와 검색결과 항목에 mouseover 했을때
           // 해당 장소에 인포윈도우에 장소명을 표시합니다
           // mouseout 했을 때는 인포윈도우를 닫습니다
           (function(marker, title) {
               kakao.maps.event.addListener(marker, 'mouseover', function() {
                   displayInfowindow(marker, title);
               });
    
               kakao.maps.event.addListener(marker, 'mouseout', function() {
                   infowindow.close();
               });
    
               itemEl.onmouseover =  function () {
                   displayInfowindow(marker, title);
               };
    
               itemEl.onmouseout =  function () {
                   infowindow.close();
               };
           })(marker, places[i].place_name);
    
           // 마커와 검색 결과를 클릭했을때 좌표를 가져온다
           (function(marker, title) {
               kakao.maps.event.addListener(marker, 'click', function() {1	
                   DetailAddrFromCoords(presentPosition, function(result, status) {
                       if (status === kakao.maps.services.Status.OK) {
                           detailAddr = !!result[0].road_address ? result[0].road_address.address_name : result[0].address.address_name;
                           location.href = "https://map.kakao.com/?sName="+detailAddr+"&eName="+title                                            
                       }   
                   });
               })
    
               itemEl.onclick =  function () {
                   searchDetailAddrFromCoords(presentPosition, function(result, status) {
                       if (status === kakao.maps.services.Status.OK) {
                           detailAddr = !!result[0].road_address ? result[0].road_address.address_name : result[0].address.address_name;
                           location.href = "https://map.kakao.com/?sName="+detailAddr+"&eName="+title                                            
                       }   
                   });
               };
           })(marker, places[i].place_name);
    
           fragment.appendChild(itemEl);
       }
    
       // 검색결과 항목들을 검색결과 목록 Elemnet에 추가합니다
       listEl.appendChild(fragment);
       menuEl.scrollTop = 0;
    
       // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
       map.setBounds(bounds);
   }
    */
   // 검색결과 항목을 Element로 반환하는 함수입니다
   function getListItem(index, places) {
    
       var el = document.createElement('li'),
       itemStr = '<span class="markerbg marker_' + (index+1) + '"></span>' +
                   '<div class="info">' +
                   '   <h5>' + places.place_name + '</h5>';
    
       if (places.road_address_name) {
           itemStr += '    <span>' + places.road_address_name + '</span>' +
                       '   <span class="jibun gray">' +  places.address_name  + '</span>';
       } else {
           itemStr += '    <span>' +  places.address_name  + '</span>'; 
       }
                    
         itemStr += '  <span class="tel">' + places.phone  + '</span>' +
                   '</div>';           
    
       el.innerHTML = itemStr;
       el.className = 'item';
    
       return el;
   }
    
   // 마커를 생성하고 지도 위에 마커를 표시하는 함수입니다
   function addMarker(position, idx, title) {
       var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
           imageSize = new kakao.maps.Size(36, 37),  // 마커 이미지의 크기
           imgOptions =  {
               spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
               spriteOrigin : new kakao.maps.Point(0, (idx*46)+10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
               offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
           },
           markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
               marker = new kakao.maps.Marker({
               position: position, // 마커의 위치
               image: markerImage 
           });
    
       marker.setMap(map); // 지도 위에 마커를 표출합니다
       markers.push(marker);  // 배열에 생성된 마커를 추가합니다
    
       return marker;
   }
    
   // 검색결과 목록 하단에 페이지번호를 표시는 함수입니다
   function displayPagination(pagination) {
       var paginationEl = document.getElementById('pagination'),
           fragment = document.createDocumentFragment(),
           i; 
    
       // 기존에 추가된 페이지번호를 삭제합니다
       while (paginationEl.hasChildNodes()) {
           paginationEl.removeChild (paginationEl.lastChild);
       }
    
       for (i=1; i<=pagination.last; i++) {
           var el = document.createElement('a');
           el.href = "#";
           el.innerHTML = i;
    
           if (i===pagination.current) {
               el.className = 'on';
           } else {
               el.onclick = (function(i) {
                   return function() {
                       pagination.gotoPage(i);
                   }
               })(i);
           }
    
           fragment.appendChild(el);
       }
       paginationEl.appendChild(fragment);
   }
    
   // 검색결과 목록 또는 마커를 클릭했을 때 호출되는 함수입니다
   // 인포윈도우에 장소명을 표시합니다
   function displayInfowindow(marker, title) {
       var content = '<div style="padding:5px;z-index:1;">' + title + '</div>';
    
       infowindow.setContent(content);
       infowindow.open(map, marker);
   }
    
    // 검색결과 목록의 자식 Element를 제거하는 함수입니다
   function removeAllChildNods(el) {   
       while (el.hasChildNodes()) {
           el.removeChild (el.lastChild);
       }
   }
    
   // 좌표 -> 주소
   var geocoder = new kakao.maps.services.Geocoder();
   function searchDetailAddrFromCoords(coords, callback) {
       geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
   }
   
   </script>
</body>
</html>