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
    
    .inp {
       margin: 20px 0;
       padding: 20px;
       width: 450px;
       height: 50px;
       outline: none;
       border: 0;
    }
    
    input[type="radio"] {
       margin: 5px;
       margin-left: 10px;
    }
    
    .border1 {
       width: 1110px;
       margin: 0 auto;
    }
    
    .border2 {
       border: 1px solid #F2F2F9;
       border-radius: 50px;
       background-color: #F8F8FF;
       text-align: center;
       width: 900px;
       padding: 40px 0;
       margin: 0 auto;
    }
    
    #gender {
       text-align: left;
       margin: 0 215px;
    }
    
    form > h1 {
       font-size: 35px; 
    }
    
    span {
       display: block;
    }
  </style>
</head>
<body>
  <%@ include file = "/WEB-INF/inc/header.jsp"%>
  <!--================ Header Menu Area start =================-->
 


 <!--================ Banner Start =================-->
<section class="hero-banner magic-ball">
    <div class="container">
     
        <div class="border1">
      <div class="border2">
          <form method="POST" action="/tworavel/member/joinok.do">
          <h1>회원가입</h1>
          <input type="text" class="inp" name="id" id="id" placeholder="아이디 입력" required>
          <input type="button"  id="btnid" value="중복확인" style="width: 80px;">
          <span id="result"></span>
          <input type="password" class="inp" name="pw" id="pw" placeholder="비밀번호 입력" required>
          <input type="password" class="inp" name="pw2" id="pw2" placeholder="비밀번호 확인" required>
          <input type="text" class="inp" name="mname" id="mname" placeholder="이름" required>
          <div id="gender">
          <label><input type="radio" id="m" name="gender" value="m" checked> 남자</label>
          <label><input type="radio" id="f" name="gender" value="f"> 여자</label>
          </div>
          <input type="text" class="inp" name="mtel" id="mtel" placeholder="연락처" required>
          <input type="text" class="inp" name="mptel" id="mptel" placeholder="보호자 연락처">
          <input type="text" class="inp" name="jumin" id="jumin" placeholder="주민번호" required>
          <input type="text" class="inp" name="maddress" id="maddress" placeholder="주소" required>
          <input type="text" class="inp" name="email" id="email" placeholder="이메일" required>
          <input type="text" class="inp" name="mbti" id="mbti" placeholder="mbti">
          <input type="submit" class="button" id="ok" value="회원 가입 하기" style=" width: 185px; border: 0; display: block; margin: 20px auto;">
          </form>
           
        </div>
       </div>
       </div>
      
  </section>
   <!--================ Banner End =================-->

  

  <!--================ section Start =================-->
   <section class="section-margin pb-xl-5">
      <div class="container">
         

      </div>
   </section>
 <!--================ section End =================-->



  <!-- ================ start footer Area ================= -->
  <%@ include file = "/WEB-INF/inc/footer.jsp"%>


<script>

   $('#ok').click(()=>{

      if(($('#id').val().length) < 4 || ($('#id').val().length) > 12) {
          alert('아이디를 4~12자 사이로 입력해주세요.');
          event.preventDefault();
           $('#id').focus();
           return;
      }
   
      
      if ('0' <= ($('#id').val().charAt(0)) && ($('#id').val().charAt(0)) <= '9') {
            alert('아이디를 숫자로 시작할 수 없습니다.');
            event.preventDefault();
            $('#id').select(); 
            return;
      }
   
        for (var i=0; i<$('#id').val().length; i++) {
             let c = $('#id').val().charAt(i);
             if ((c < 'A' || c > 'Z') && (c < 'a' || c > 'z') && (c < '0' || c > '9') && c != '_') {
                   alert('아이디를 영어/숫자/_ 조합 으로만 입력하세요.');
                   event.preventDefault();
                   $('#id').focus();
                   return;
                }
           }
       
   });
   
    $('#btnid').click(()=>{
   
      var id = $('#id').val();
      
      $.ajax({
         type: 'GET',
            url: '/tworavel/member/idcheck.do',
            data: 'id=' + $('#id').val(),
            dataType: 'json',
            success: function(result) {
      
               if (id.length == 0) {
                  $('#result').text('아이디를 입력해주세요.').css('color', 'tomato');
               }
               else if(result.use == 1) {
                  $('#result').text('이미 사용중인 아이디입니다.').css('color', 'tomato');
               } else {
                  $('#result').text('사용 가능한 아이디입니다.').css('color', 'cornflowerblue');
               }
               
            },
            error: function(a,b,c) {
               console.log(a,b,c);
            }
      });
   });

</script>

</body>
</html>