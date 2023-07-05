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

  <!--================ section Start =================-->
  <section class="section-margin generic-margin">
    <div class="section-intro text-center pb-90px">
         
       <div class="stitle">
          <img src="/tworavel/asset/img/home/section-icon.png">
          <h2>여행기</h2>
       </div>
    </div>
    <div class="main-container" style="width:800px; margin: 0 auto;">
    <div class="btns">
            <c:if test="${not empty auth}">
            <button type="button" class="btn btn-primary" style="background-color:#6059F6; border: #6059F6; margin-bottom: 10px;" onclick="location.href='/tworavel/reviewboard/radd.do';">
						<i class="fa-solid fa-pen-nib" style=" float:left;"></i> <span>작성하기</span>
					</button>
            </c:if>
            <aside class="single_sidebar_widget search_widget" style="width: 300px; float:right;">
                            <div class="form-group" >
                              <div class="input-group mb-3">
                                <input type="text" class="form-control" placeholder="검색" name="search" id="search">
                                <div class="input-group-append">
                                  <button class="btn" type="button" name="searchBtn" id="searchBtn"><i class="ti-search"></i></button>
                                </div>
                              </div>
                            </div>
                      </aside>
    </div>
    <table class="table table-bordered table-hover" style="background-color:#6059F6;">
  <thead style="background-color:#6059F6;">
    <tr>
       <td style="width:50px;">번호</td>
       <td>제목</td>
       <td style="width:120px; text-align: center;">작성자</td>
       <td style="width:80px; text-align: center;">조회수</td>
    </tr>
  </thead>
   <tbody>
      <c:forEach items="${rList }" var="dto" varStatus="status">
      <tr>
      <td style="text-align: center;">${dto.rseq }</td>
      <td onClick="location.href='/tworavel/reviewboard/reviewdetail.do?rseq=${dto.rseq}&id=${memberId.get(status.index)}&cCount=${cCount.get(status.index) }';">
      ${dto.rctitle }
      <c:if test="${cCount.get(status.index) != 0 }">
      (${cCount.get(status.index) })
      </c:if>
      
      </td>
      <td style="text-align: center;">${memberId.get(status.index)} </td>
      <td style="text-align: center;">${dto.rcount }</td>
      </tr>
      </c:forEach>
   </tbody>
   </table>
   </div>
    
  </section>
  
  <!-- ================ start footer Area ================= -->
  <%@ include file = "/WEB-INF/inc/footer.jsp"%>

</body>
<script>
$('#searchBtn').click(() => {
    
    $.ajax({
       
       type: 'GET',
       url: '/tworavel/reviewboard/searchreview.do',
       
       data: 'word=' + $('#search').val(),
       
       dataType: 'json',
       
       success: function(result) {

          $('table tbody').html('');
           
           
           
           result.forEach((item, index) => {
    
               let temp = '';

               temp += '<tr>';
               temp += '<td style="text-align: center;">' + item.rseq + '</td>';
               temp += '<td onClick="location.href=\'/tworavel/reviewboard/reviewdetail.do?rseq=' +item.rseq + '&id='+ item.id + '&cCount=' + item.cCount + '\' ;">' + item.rctitle;
               temp += '<c:if test="${' + item.rccount + '!=' + 0 + '}">';
               temp += '(' + item.cCount+ ')'; 
               temp += '</c:if>'; 
               temp += '</td>';
               temp += '<td style="text-align: center;">' + item.id + '</td>';
               temp += '<td style="text-align: center;">' + item.rcount + '</td>';
               temp += '</tr>';
    
               $('table tbody').append(temp);

           }); //forEach

       }, //success
 
       error: function(a,b,c) {
          console.log(a,b,c);
       }
    })
    });
</script>
</html>