<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="/WEB-INF/inc/asset.jsp" %>
<style>

</style>
</head>
<body>
   <main>
       <!--================ 랜드마크 추천 Start =================-->
  <section class="section-margin generic-margin">
    <div class="container">
      <div class="section-intro text-center pb-90px">
        <img class="section-intro-img" src="/tworavel/asset/img/home/section-icon.png" alt="">
          <h2><span class="h2txt">T<span style="color: gold;">wo</span>RAVEL&nbsp</span>이 추천하는 랜드마크</h2>
        <p>여행지 고민하지 마세요! </p>
      </div>

      <div class="row">
      
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
        
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=주상절리'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/주상절리.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;"> <!-- 랜드마크 사진  -->
            </div>
            <div class="service-card-body" style="margin-top: 100px;">
              <h3>대포해안주상절리</h3>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=각원사'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/각원사.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px;">
              <h3>각원사</h3>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=롯데월드타워'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/롯데월드타워.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>롯데월드타워</h3>
            </div>
          </div>
        </div>
        
        
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=경복궁'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/경복궁.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>경복궁</h3>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=창덕궁'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/창덕궁.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>창덕궁</h3>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=광안대교'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/광안대교.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>광안대교</h3>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=감천 문화마을'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/감천문화마을.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>감천문화마을</h3>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=경포해변'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/경포해변.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>경포해변</h3>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=광화문'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/광화문.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>광화문</h3>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=낙산사'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/낙산사.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>낙산사</h3>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=명동성당'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/명동성당.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>명동성당</h3>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=봉은사'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/봉은사.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>봉은사</h3>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=북촌 한옥마을'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/북촌한옥마을.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>북촌 한옥마을</h3>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=불국사'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/불국사.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>불국사</h3>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=N 서울타워'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/서울타워.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>서울타워</h3>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=섭지코지'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/섭지코지.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>섭지코지</h3>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=성산일출봉'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/성산일출봉.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>성산일출봉</h3>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=수원화성'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/수원화성.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>수원화성</h3>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=안동 하회마을'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/안동하회마을.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>안동 하회마을</h3>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=전주 한옥마을'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/전주한옥마을.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>전주 한옥마을</h3>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=정림사지'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/정림사지.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>정림사지</h3>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=진주성'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/진주성.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>진주성</h3>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=천마총'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/천마총.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>천마총</h3>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=청계천'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/청계천.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>청계천</h3>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=태종대'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/태종대.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>태종대</h3>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=한국민속촌'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/한국민속촌.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>한국민속촌</h3>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=한라산'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/한라산.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>한라산</h3>
            </div>
          </div>
        </div>
                
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=해동 용궁사'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/해동용궁사.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>해동용궁사</h3>
            </div>
          </div>
        </div>
           
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=해인사'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/해인사.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>해인사</h3>
            </div>
          </div>
        </div>
                  
        <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 rnd">
          <div class="service-card text-center" onclick="location.href='/tworavel/member/landmark.do?lmname=호미곶'">
            <div class="service-card-img">
              <img class="img-fluid" src="/tworavel/asset/img/landmark/호미곶.jpg" alt="랜드마크 사진" style="width: 300px; height:250px; object-fit: cover;">
            </div>
            <div class="service-card-body" style="margin-top: 100px; ">
              <h3>호미곶</h3>
            </div>
          </div>
        </div>
        
        
      </div>
    </div>
  </section>
   </main>
   
   <script>

      $(document).ready(function() {
          $(".rnd").hide();

          var elements = $('.rnd');          
          var elementCount = elements.length;          
          var elementsToShow = 3;       
          var alreadyChoosen = ",";
          var i = 0;
          
          while (i < elementsToShow) {
             
              var rand = Math.floor(Math.random() * elementCount);
              
              if (alreadyChoosen.indexOf("," + rand + ",") < 0) {
                 
                  alreadyChoosen += rand + ",";
                  
                  elements.eq(rand).show();
                  
                  ++i;
              }
          }
      });
   </script>
</body>
</html>