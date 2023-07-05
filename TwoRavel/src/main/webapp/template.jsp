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
 


 <!--================ Banner Start =================-->
<section class="hero-banner magic-ball">
    <div class="container">
      <div class="row align-items-center text-center text-md-left">
        <div class="col-md-6 col-lg-5 mb-5 mb-md-0">
          <h1>내용</h1>
          <p>설명 내용</p>
           <a class="button" href="/tworavel/plan/planstart.do">버튼</a>
            <a class="button" href="/tworavel/reviewboard/review.do" style ="margin:30px;">버튼</a>
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
  <section class="section-margin generic-margin">
    <div class="container">
			<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Voluptate suscipit magnam illo quos fuga quis minima impedit harum. Quam aut expedita architecto quod cupiditate laudantium recusandae tempore fugiat perferendis eaque.</p>

    </div>
  </section>
  <!--================ section End =================-->


  <!--================ section Start =================-->
	<section class="bg-gray section-padding magic-ball magic-ball-about">
		<div class="container">
			<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Voluptate suscipit magnam illo quos fuga quis minima impedit harum. Quam aut expedita architecto quod cupiditate laudantium recusandae tempore fugiat perferendis eaque.</p>
			</div>
	</section>
	<!--================ section End =================-->

  <!--================ section Start =================-->
	<section class="section-margin pb-xl-5">
		<div class="container">
			<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Voluptate suscipit magnam illo quos fuga quis minima impedit harum. Quam aut expedita architecto quod cupiditate laudantium recusandae tempore fugiat perferendis eaque.</p>

		</div>
	</section>
 <!--================ section End =================-->



  <!-- ================ start footer Area ================= -->
  <%@ include file = "/WEB-INF/inc/footer.jsp"%>

</body>
</html>