<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "/WEB-INF/inc/asset.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>날씨 지도 테스트</title>
<style>
#one{
   width: 300px;
   border:1px solid tomato;
}
#two{
   width: 100%;
   border:1px solid tomato;
}

table{
   width: 100%;
   border:1px solid tomato;
}
</style>
</head>
<body>
	<main>
		<div id="one">
			<select id="regId">
				<option value="11B00000">서울,인천,경기도</option>
				<option value="11D10000">강원도 영서</option>
				<option value="11D20000">강원도 영동</option>
				<option value="11C20000">대전,세종,충청남도</option>
				<option value="11C10000">충청북도</option>
				<option value="11F10000">광주,전라남도</option>
				<option value="11H10000">대구,경상북도</option>
				<option value="11H20000">부산,울산,경상남도</option>
				<option value="11G00000">제주도</option>
			</select>
			
			<select id="regIdT">
				<option value="11G00201">제주</option>
				<option value="11G00401">서귀포</option>
			</select>
			
		</div>
		<div id="two">
			<input type="text" name="tmFc" id="tmFc" placeholder="YYYYMMDDH24:MI" />
			<input type="button" name="btn" id="btn" value="검색" />
		</div>

		<table id="weather">
			<thead>
				<tr>
					<th>3일 후 오전 강수량</th>
					<th>3일 후 오후 강수량</th>
					<th>3일 후 오전 날씨</th>
					<th>3일 후 오후 날씨</th>
					<th>4일 후 오전 강수량</th>
					<th>4일 후 오후 강수량</th>
					<th>4일 후 오전 날씨</th>
					<th>4일 후 오후 날씨</th>
					<th>5일 후 오전 강수량</th>
					<th>5일 후 오후 강수량</th>
					<th>5일 후 오전 날씨</th>
					<th>5일 후 오후 날씨</th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
		
		<table id="temperature">
			<thead>
				<tr>
					<th>3일 후 최저 온도</th>
					<th>3일 후 최고 온도</th>
					<th>4일 후 최저 온도</th>
					<th>4일 후 최고 온도</th>
					<th>5일 후 최저 온도</th>
					<th>5일 후 최고 온도</th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
	</main>

	<script>
	
	 $('#btn').click(() => {
		 //날씨
         $.ajax({
            type:'GET',
            url:'/tworavel/plan/ws.do',
            data:'regId='+ $("#regId option:selected").val() + '&tmFc=' + $('#tmFc').val(),
            dataType:'json',
            success: function(result) {
               //alert(result.total);
               
               
               $('#weather tbody').html('');
               
               
               $(result.response.body.items.item).each((index,item)=>{
                  
                  console.log(item);
                  let temp ='';
                  
                  temp += '<tr>';
                  temp += `<td>\${item.rnSt3Am}</td>`; // 3일 후 오전 강수량
                  temp += `<td>\${item.rnSt3Pm}</td>`; // 3일 후 오전 강수량
                  temp += `<td>\${item.rnSt4Am}</td>`; // 4일 후 오전 강수량
                  temp += `<td>\${item.rnSt4Pm}</td>`; // 4일 후 오전 강수량
                  temp += `<td>\${item.rnSt5Am}</td>`; // 5일 후 오전 강수량
                  temp += `<td>\${item.rnSt5Pm}</td>`; // 5일 후 오전 강수량
                  temp += `<td>\${item.wf3Am}</td>`; // 3일 후 오전 날씨
                  temp += `<td>\${item.wf3Pm}</td>`; // 3일 후 오후 날씨
                  temp += `<td>\${item.wf4Am}</td>`; // 4일 후 오전 날씨
                  temp += `<td>\${item.wf4Pm}</td>`; // 4일 후 오후 날씨
                  temp += `<td>\${item.wf5Am}</td>`; // 5일 후 오전 날씨
                  temp += `<td>\${item.wf5Pm}</td>`; // 5일 후 오후 날씨
                  temp += '</tr>';
                  $('#weather tbody').append(temp);
                  
               });
               
            },
            error: function(a,b,c) {
               console.log(a,b,c);
            }
         });    
        
		 // 기온
         $.ajax({
             type:'GET',
             url:'/tworavel/plan/wt.do',
             data:'regId='+ $("#regIdT option:selected").val() + '&tmFc=' + $('#tmFc').val(),
             dataType:'json',
             success: function(result) {
                //alert(result.total);
                
                
                $('#temperature tbody').html('');
                
                
                $(result.response.body.items.item).each((index,item)=>{
                   
                   console.log(item);
                   let temp ='';
                   
                   temp += '<tr>';
                   temp += `<td>\${item.taMin3}</td>`; // 3일 후 최저 기온
                   temp += `<td>\${item.taMax3}</td>`; // 3일 후 최고 기온
                   temp += `<td>\${item.taMin4}</td>`; // 4일 후 최저 기온
                   temp += `<td>\${item.taMax4}</td>`; // 4일 후 최고 기온
                   temp += `<td>\${item.taMin5}</td>`; // 5일 후 최저 기온
                   temp += `<td>\${item.taMax5}</td>`; // 5일 후 최고 기온
                   temp += '</tr>';
                   $('#temperature tbody').append(temp);
                   
                });
                
             },
             error: function(a,b,c) {
                console.log(a,b,c);
             }
          });

   });
	</script>
</body>
</html>