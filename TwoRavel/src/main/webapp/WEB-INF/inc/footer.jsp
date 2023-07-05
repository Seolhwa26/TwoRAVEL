<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
td { padding: 0px 30px 10px 0px; }
td:nth-child(1) {
   color: white;
   padding: 0px 50px 10px 0px;
}

p { 
   font-size: .9rem;
   color : #777;
}

table {
    font-family: 'GongGothicMedium';
}

table td {
	color: white;
}

</style>
<%@ include file="/WEB-INF/inc/asset.jsp"%>

<!-- ================ start footer Area ================= -->
<footer class="footer-area">
   <div class="container">
      <div class="row">
         <div class="team_sub" style="width: 800px; padding-right: 50px;">
            <div class="single-footer-widget">
               <h6>About Team</h6>
               
               <table>
                  <tr>
                     <td>상호명</td>
                     <td colspan="6">TwoRAVEL</td>
                  </tr>
                  <tr>
                     <td>대표</td>
                     <td>김설화</td>
                     <td>김지현</td>
                     <td>손영우</td>
                     <td>송영주</td>
                     <td>임동균</td>
                     <td>최유찬</td>
                  </tr>
                  <tr>
                     <td>고객센터</td>
                     <td colspan="6">TwoRAVEL@ssangyoung.com</td>
                  </tr>
               </table>
               <br>
               <p>
               TwoRAVEL은 친구와 혹은 원하는 MBTI를 추천받아 새로운 사람들과 함께 여행을 계획할 수 있는 사이트입니다. 
               TwoRAVEL과 함께 그동안 꿈꿔왔던 여행을 떠나보세요! <br>
               TwoRAVEL 서비스의 모든 콘텐츠는 저작자에게 저작권이 있으므로 무단 업로드 및 사용 시 법적 책임이 발생할 수 있습니다.
               </p>
            </div>
         </div>

         <div class="col-lg-3  col-md-6 col-sm-6">
            <div class="single-footer-widget mail-chimp">
               <h6 class="mb-20">InstaFeed</h6>
               <ul class="instafeed d-flex flex-wrap">
                  <li><img src="/tworavel/asset/img/instagram/i1.jpg" alt=""></li>
                  <li><img src="/tworavel/asset/img/instagram/i2.jpg" alt=""></li>
                  <li><img src="/tworavel/asset/img/instagram/i3.jpg" alt=""></li>
                  <li><img src="/tworavel/asset/img/instagram/i4.jpg" alt=""></li>
                  <li><img src="/tworavel/asset/img/instagram/i5.jpg" alt=""></li>
                  <li><img src="/tworavel/asset/img/instagram/i6.jpg" alt=""></li>
               </ul>
            </div>
         </div>
      </div>

      <div class="footer-bottom">
         <div class="row align-items-center">
            <p
               class="col-lg-8 col-sm-12 footer-text m-0 text-center text-lg-left">
               <!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
               Copyright &copy;
               <script>document.write(new Date().getFullYear());</script>
               All rights reserved | This site is made with <i class="fa fa-heart"
                  aria-hidden="true"></i> by TwoRavel
               <!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
            </p>
         </div>
      </div>
   </div>
</footer>
<!-- ================ End footer Area ================= -->



















