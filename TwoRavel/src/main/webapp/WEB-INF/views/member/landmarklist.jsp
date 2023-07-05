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
p, span{
   font-family: 'GongGothicMedium';
}
</style>
<body>
  <%@ include file = "/WEB-INF/inc/header.jsp"%>
  <!--================ Header Menu Area start =================-->
 
  <!--================Blog Area =================-->
  <section class="blog_area section-margin-large">
      <div class="container">
          <div class="row">
              <div class="col-lg-8 mb-5 mb-lg-0">
                  <div class="blog_left_sidebar">
                        
                       <!-- 게시글 시작 -->
                       <c:forEach items="${alist}" var="dto" varStatus="status">
                      <article class="blog_item">     
                        <div class="blog_item_img" >
                        <!-- 이미지 각각 가져오기 lmfile 로 DB에 저장됨 -->
                          <img class="card-img rounded-0" src="/tworavel/asset/img/landmark/${dto.lmfile}" alt="랜드마크 사진" >
                        </div>
                        
                        <div class="blog_details">
                            <a class="d-inline-block" href="/tworavel/member/landmark.do?lmname=${dto.lmname }&lmseq=${dto.lmseq}">
                                <h2>${dto.lmname }</h2>
                            </a>
                            <p>${dto.lmcontent }</p>
                            <ul class="blog-info-link">
                              <li><i class="fa-solid fa-eye"></i><span>${dto.lmcount}</span></li>
                              <li><i class="fa-regular fa-thumbs-up"></i><span style="color:tomato;">${dto.lmlike }</span></li>
                              <li><i class="far fa-comment"></i><span>${oLCount.get(status.index) }</span></li>
                            </ul>
                        </div>
                      </article>
                      </c:forEach>
                      <!-- 게시글 끝 -->    
                                   
                      <!-- 페이징 시작 -->
                      <!-- <nav class="blog-pagination justify-content-center d-flex">
                          <ul class="pagination">
                              <li class="page-item">
                                  이전 페이지 이동 화살표
                                  <a href="#" class="page-link" aria-label="Previous" style="padding: 15px;">
                                      <span aria-hidden="true">
                                          <span class="lnr lnr-chevron-left"></span>
                                      </span>
                                  </a>
                              </li> -->
                              <!-- 페이징 번호 시작 -->
                              <!-- 게시물 당 3 ~ 5 내용물 정해서 그만큼 나누기 홀리 쉣  -->
                              <!-- <li class="page-item active">
                                  <a href="#" class="page-link">1</a>
                              </li>
                              <li class="page-item">
                                  <a href="#" class="page-link">2</a>
                              </li> -->
                              <!-- 페이징 번호 끝 -->
                              
                              <!-- 다음 페이지 이동 화살표 -->
                              <!-- <li class="page-item">
                                  <a href="#" class="page-link" aria-label="Next" style="padding: 15px;">
                                      <span aria-hidden="true">
                                          <span class="lnr lnr-chevron-right"></span>
                                      </span>
                                  </a>
                              </li>
                          </ul>
                      </nav> -->
                      <!-- 페이징 끝 -->
                  </div>
              </div>
              
              <div class="col-lg-4">
                  <div class="blog_right_sidebar">
                      <aside class="single_sidebar_widget search_widget">
                            <div class="form-group">
                              <div class="input-group mb-3">
                                <input type="text" class="form-control" placeholder="랜드마크명을 검색하세요" name="landmark" id="landmark">
                                <div class="input-group-append">
                                  <button class="btn" type="button"><i class="ti-search"></i></button>
                                </div>
                              </div>
                            </div>
                            <!-- 랜드마크명으로만 검색 -->
                            <button class="button rounded-0 primary-bg text-white w-100" type="submit" id="searchbtn" name="searchbtn">검색하기</button>
                      </aside>

                      <aside class="single_sidebar_widget post_category_widget">
                        <h4 class="widget_title">지역</h4>
                        <ul class="list cat-list">

                           <c:forEach items="${loclist}" var="dto" varStatus="status">
                            <li class="local">
                                    <a class="locname">
                                    ${dto.locname}
                                    <input type="hidden" class="locseq" value="${dto.locseq}" />
                                    </a>
                                    <span>(${locresult.get(status.index) })</span>
                            </li>
                            </c:forEach>
                            
                        </ul>
                      </aside>
                  </div>
              </div>
          </div>
      </div>
  </section>
  <!--================Blog Area =================-->

  <!-- ================ start footer Area ================= -->
  <%@ include file = "/WEB-INF/inc/footer.jsp"%>

</body>
<script>

$('#searchbtn').click(() => {
    
    $.ajax({
       
       type: 'GET',
       url: '/tworavel/member/landmarksearch.do',
       
       data: 'landmark=' + $('#landmark').val(),
       
       dataType: 'json',
       
       success: function(result) {

          $('.blog_left_sidebar').html('');
           
           
           
           result.forEach((item, index) => {

              
              //json 객체
               let temp = '';

               temp += '<article class="blog_item">';
               temp += '<div class="blog_item_img" >';
               temp += `<img class="card-img rounded-0" src="/tworavel/asset/img/landmark/\${item.lmfile}" alt="랜드마크 사진">`;
               temp += '</div>';
               temp += '<div class="blog_details">';
               temp += `<a class="d-inline-block" href="/tworavel/member/landmark.do?lmname=\${item.lmname }&lmseq=\${item.lmseq}">`;
               temp += `<h2>\${item.lmname }</h2>`;
               temp += '</a>';
               temp += `<p>\${item.lmcontent }</p>`;
               temp += '<ul class="blog-info-link">';
               temp += `<li><i class="fa-solid fa-eye"></i><span>\${item.lmcount}</span></li>`;
               temp += `<li><i class="fa-regular fa-thumbs-up"></i><span style="color:tomato;">\${item.lmlike }</span></li>`;
               temp += `<li><i class="far fa-comment"></i><span>\${item.olcnt }</span></li>`; 
               temp += '</ul>';
               temp += '</div>';
               temp += '</article>';
               
               $('.blog_left_sidebar').append(temp);

           }); //forEach

       }, //success
 
       error: function(a,b,c) {
          console.log(a,b,c);
       }
    })
    });
  
/*  $('.locname').click(() => {
   alert($(event.target).children('.locseq').val());
})  */

$('.locname').click(() => {
    
    $.ajax({
       
       type: 'GET',
       url: '/tworavel/member/landmarklocal.do',
       
       data: 'locseq=' + $(event.target).children('.locseq').val(),
       
       dataType: 'json',
       
       success: function(result) {

          $('.blog_left_sidebar').html('');
           
           
           
           result.forEach((item, index) => {

              
              //json 객체
               let temp = '';

               temp += '<article class="blog_item">';
               temp += '<div class="blog_item_img" >';
               temp += `<img class="card-img rounded-0" src="/tworavel/asset/img/landmark/\${item.lmfile}" alt="랜드마크 사진">`;
               temp += '</div>';
               temp += '<div class="blog_details">';
               temp += `<a class="d-inline-block" href="/tworavel/member/landmark.do?lmname=\${item.lmname }&lmseq=\${item.lmseq}">`;
               temp += `<h2>\${item.lmname }</h2>`;
               temp += '</a>';
               temp += `<p>\${item.lmcontent }</p>`;
               temp += '<ul class="blog-info-link">';
               temp += `<li><i class="fa-solid fa-eye"></i><span>\${item.lmcount}</span></li>`;
               temp += `<li><i class="fa-regular fa-thumbs-up"></i><span style="color:tomato;">\${item.lmlike }</span></li>`;
               temp += `<li><i class="far fa-comment"></i><span>\${item.olcnt }</span></li>`; 
               temp += '</ul>';
               temp += '</div>';
               temp += '</article>';
               
               $('.blog_left_sidebar').append(temp);

           }); //forEach

       }, //success
 
       error: function(a,b,c) {
          console.log(a,b,c);
       }
    })
    });

</script>
</html>