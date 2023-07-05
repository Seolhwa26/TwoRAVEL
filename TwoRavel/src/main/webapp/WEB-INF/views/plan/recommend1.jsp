<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>TwoRAVEL</title>
<%@ include file="/WEB-INF/inc/asset.jsp"%>
<style>
.sec_cal, .sec_cal {
	width: 360px;
	margin: 0 auto;
	font-family: "NotoSansR";
	display: inline-block;
	margin-right: 25px;
}

.sec_cal .cal_nav {
	display: flex;
	justify-content: center;
	align-items: center;
	font-weight: 700;
	font-size: 48px;
	line-height: 78px;
	border-top-left-radius: 10px;
	border-top-right-radius: 10px;
}

.sec_cal .cal_nav .year-month {
	width: 300px;
	text-align: center;
	line-height: 1;
}

.sec_cal .cal_nav .nav {
	display: flex;
	border: 1px solid #333333;
	border-radius: 5px;
}

.sec_cal .cal_nav .go-prev, .sec_cal .cal_nav .go-next {
	display: block;
	width: 50px;
	height: 78px;
	font-size: 0;
	display: flex;
	justify-content: center;
	align-items: center;
}

.sec_cal .cal_nav .go-prev::before, .sec_cal .cal_nav .go-next::before {
	content: "";
	display: block;
	width: 20px;
	height: 20px;
	border: 3px solid #000;
	border-width: 3px 3px 0 0;
	transition: border 0.1s;
}

.sec_cal .cal_nav .go-prev:hover::before, .sec_cal .cal_nav .go-next:hover::before
	{
	border-color: #ed2a61;
}

.sec_cal .cal_nav .go-prev::before {
	transform: rotate(-135deg);
}

.sec_cal .cal_nav .go-next::before {
	transform: rotate(45deg);
}

.sec_cal .cal_wrap {
	padding-top: 40px;
	position: relative;
	margin: 0 auto;
	border-bottom-left-radius: 10px;
	border-bottom-right-radius: 10px;
}

.sec_cal .cal_wrap .days {
	display: flex;
	margin-bottom: 20px;
	padding-bottom: 20px;
	border-bottom: 1px solid #ddd;
}

.sec_cal .cal_wrap::after {
	top: 368px;
}

.sec_cal .cal_wrap .day {
	display: flex;
	align-items: center;
	justify-content: center;
	width: calc(100%/ 7);
	text-align: left;
	color: #999;
	font-size: 12px;
	text-align: center;
	border-radius: 5px
}

/* .current.today { */
/*    background: rgb(242, 242, 242); */
/* } */
.sec_cal .cal_wrap .dates {
	display: flex;
	flex-flow: wrap;
	height: 290px;
}

.sec_cal .cal_wrap .day:nth-child(7n -1) {
	color: #3c6ffa;
}

.sec_cal .cal_wrap .day:nth-child(7n) {
	color: #ed2a61;
}

.sec_cal .cal_wrap .day.disable {
	color: #ddd;
}

.calc {
	width: 100%;
	text-align: center;
}

.sec_cal2, .sec_cal2 {
	width: 360px;
	margin: 0 auto;
	font-family: "NotoSansR";
	display: inline-block;
	border-radius: 10px;
	/*    background-color: #F8F8FF; */
	margin-left: 25px;
}

.sec_cal2 .cal_nav2 {
	display: flex;
	justify-content: center;
	align-items: center;
	font-weight: 700;
	font-size: 48px;
	line-height: 78px;
	border-top-left-radius: 10px;
	border-top-right-radius: 10px;
}

.sec_cal2 .cal_nav2 .year-month2 {
	width: 300px;
	text-align: center;
	line-height: 1;
}

.sec_cal2 .cal_nav2 .nav2 {
	display: flex;
	border: 1px solid #333333;
	border-radius: 5px;
}

.sec_cal2 .cal_nav2 .go-prev2, .sec_cal2 .cal_nav2 .go-next2 {
	display: block;
	width: 50px;
	height: 78px;
	font-size: 0;
	display: flex;
	justify-content: center;
	align-items: center;
}

.sec_cal2 .cal_nav2 .go-prev2::before, .sec_cal2 .cal_nav2 .go-next2::before
	{
	content: "";
	display: block;
	width: 20px;
	height: 20px;
	border: 3px solid #000;
	border-width: 3px 3px 0 0;
	transition: border 0.1s;
}

.sec_cal2 .cal_nav2 .go-prev2:hover::before, .sec_cal2 .cal_nav2 .go-next2:hover::before
	{
	border-color: #ed2a61;
}

.sec_cal2 .cal_nav2 .go-prev2::before {
	transform: rotate(-135deg);
}

.sec_cal2 .cal_nav2 .go-next2::before {
	transform: rotate(45deg);
}

.sec_cal2 .cal_wrap2 {
	padding-top: 40px;
	position: relative;
	margin: 0 auto;
	border-bottom-left-radius: 10px;
	border-bottom-right-radius: 10px;
}

.sec_cal2 .cal_wrap2 .days2 {
	display: flex;
	margin-bottom: 20px;
	padding-bottom: 20px;
	border-bottom: 1px solid #ddd;
}

.sec_cal2 .cal_wrap2::after {
	top: 368px;
}

.sec_cal2 .cal_wrap2 .day2 {
	display: flex;
	align-items: center;
	justify-content: center;
	width: calc(100%/ 7);
	text-align: left;
	color: #999;
	font-size: 12px;
	text-align: center;
	border-radius: 5px
}

/* .current2.today2 { */
/*    background: rgb(242, 242, 242); */
/* } */
.sec_cal2 .cal_wrap2 .dates2 {
	display: flex;
	flex-flow: wrap;
	height: 290px;
}

.sec_cal2 .cal_wrap2 .day2:nth-child(7n -1) {
	color: #3c6ffa;
}

.sec_cal2 .cal_wrap2 .day2:nth-child(7n) {
	color: #ed2a61;
}

.sec_cal2 .cal_wrap2 .day2.disable2 {
	color: #ddd;
}

.btn2 {
	width: 120px;
	height: 60px;
	border-radius: 20px;
	margin: 20px 0 20px 20px;
	float: right;
	color: white;
	border: 0;
	background-color: #B9B9FF;
	font-family: 'GongGothicMedium';
	padding: 0;
}

.btn2:hover {
	background-color: #7676FF;
}

.startend {
	display: flex;
	max-width: 100%;
}

.start {
	width: 150px;
	margin-left: 100px;
	text-align: center;
}

.end {
	width: 150px;
	margin-left: 100px;
	text-align: center;
}

.start, .end {
	font-family: 'GongGothicMedium';
	font-size: 25px;
	background-color: #F8F8FF;
	border-top-right-radius: 10px;
	border-top-left-radius: 10px;
}

#btnnext {
	text-align: center;
}

.cal_nav, .cal_wrap {
	background-color: #F8F8FF;
}

.cal_nav2, .cal_wrap2 {
	background-color: #F8F8FF;
	border-radius: 10px;
}
</style>
</head>
<body>
	<main>

		<%@ include file="/WEB-INF/inc/header.jsp"%>
		<!--================ Banner Start =================-->
		<section class="hero-banner magic-ball">

			<div class="stitle">
				<img src="/tworavel/asset/img/home/section-icon.png">
				<h2>어디로 떠나시나요?</h2>
			</div>

			<div class="calc">

				<div class="sec_cal">

					<div class="start">출발일</div>
					<div class="cal_nav">
						<a href="javascript:;" class="nav-btn go-prev">prev</a>
						<div class="year-month"></div>
						<a href="javascript:;" class="nav-btn go-next">next</a>
					</div>
					<div class="cal_wrap">
						<div class="days">
							<div class="day">MON</div>
							<div class="day">TUE</div>
							<div class="day">WED</div>
							<div class="day">THU</div>
							<div class="day">FRI</div>
							<div class="day">SAT</div>
							<div class="day">SUN</div>
						</div>
						<div class="dates"></div>
					</div>
				</div>

				<div class="sec_cal2">
					<div class="end">도착일</div>
					<div class="cal_nav2">

						<a href="javascript:;" class="nav-btn2 go-prev2">prev</a>
						<div class="year-month2"></div>
						<a href="javascript:;" class="nav-btn2 go-next2">next</a>
					</div>
					<div class="cal_wrap2">
						<div class="days2">
							<div class="day2">MON</div>
							<div class="day2">TUE</div>
							<div class="day2">WED</div>
							<div class="day2">THU</div>
							<div class="day2">FRI</div>
							<div class="day2">SAT</div>
							<div class="day2">SUN</div>
						</div>
						<div class="dates2"></div>
					</div>

					<form method="GET" name="se" action="/tworavel/plan/recommend2.do">
						<a href="#!" id="btnnext"><input type="submit" class="btn2"value="다음으로"></a> 
						<input type="hidden" name="local" value="${local}">
						<input type="hidden" name="start" value="">
						<input type="hidden" name="end" value="">
					</form>

					<a href="/tworavel/plan/planstart.do"><input type="submit"class="btn2" value="이전으로"></a>


				</div>


			</div>


		</section>



		<%@ include file="/WEB-INF/inc/footer.jsp"%>


	</main>
	<script>
				$('.sec_cal').ready(function() {
					calendarInit();
				});

				$('.sec_cal2').ready(function() {
					calendarInit2();
				});
				/*
				    달력 렌더링 할 때 필요한 정보 목록 

				    현재 월(초기값 : 현재 시간)
				    금월 마지막일 날짜와 요일
				    전월 마지막일 날짜와 요일
				 */

				function calendarInit() {

					// 날짜 정보 가져오기
					var date = new Date(); // 현재 날짜(로컬 기준) 가져오기
					var utc = date.getTime()
							+ (date.getTimezoneOffset() * 60 * 1000); // uct 표준시 도출
					var kstGap = 9 * 60 * 60 * 1000; // 한국 kst 기준시간 더하기
					var today = new Date(utc + kstGap); // 한국 시간으로 date 객체 만들기(오늘)

					var thisMonth = new Date(today.getFullYear(), today
							.getMonth(), today.getDate());
					// 달력에서 표기하는 날짜 객체

					var currentYear = thisMonth.getFullYear(); // 달력에서 표기하는 연
					var currentMonth = thisMonth.getMonth(); // 달력에서 표기하는 월
					var currentDate = thisMonth.getDate(); // 달력에서 표기하는 일

					// kst 기준 현재시간
					// console.log(thisMonth);

					// 캘린더 렌더링
					renderCalender(thisMonth);

					function renderCalender(thisMonth) {

						// 렌더링을 위한 데이터 정리
						currentYear = thisMonth.getFullYear();
						currentMonth = thisMonth.getMonth();
						currentDate = thisMonth.getDate();

						// 이전 달의 마지막 날 날짜와 요일 구하기
						var startDay = new Date(currentYear, currentMonth, 0);
						var prevDate = startDay.getDate();
						var prevDay = startDay.getDay();

						// 이번 달의 마지막날 날짜와 요일 구하기
						var endDay = new Date(currentYear, currentMonth + 1, 0);
						var nextDate = endDay.getDate();
						var nextDay = endDay.getDay();

						// console.log(prevDate, prevDay, nextDate, nextDay);

						// 현재 월 표기
						$('.year-month').text(
								currentYear + '.' + (currentMonth + 1));

						// 렌더링 html 요소 생성
						calendar = document.querySelector('.dates')
						calendar.innerHTML = '';

						// 지난달
						for (var i = prevDate - prevDay + 1; i <= prevDate; i++) {
							calendar.innerHTML = calendar.innerHTML
									+ '<div class="day prev disable color ">'  + i
									+ '</div>'
						}
						// 이번달
						for (var i = 1; i <= nextDate; i++) {
							calendar.innerHTML = calendar.innerHTML
									+ '<div class="day current color '
									+ 'num'
									+ i
									+ '" onclick="selDate();" style="cursor: pointer;" >'
									+ i + '</div>'
						}
						// 다음달
						for (var i = 1; i <= (7 - nextDay == 7 ? 0
								: 7 - nextDay); i++) {
							calendar.innerHTML = calendar.innerHTML
									+ '<div class="day next disable color ">' + i
									+ '</div>'
						}

						// 오늘 날짜 표기
						if (today.getMonth() == currentMonth) {
							todayDate = today.getDate();
							var currentMonthDate = document
									.querySelectorAll('.dates .current');
							currentMonthDate[todayDate - 1].classList
									.add('today');
						}
					}

					// 이전달로 이동
					$('.go-prev').on('click', function() {
						thisMonth = new Date(currentYear, currentMonth - 1, 1);
						renderCalender(thisMonth);
					});

					// 다음달로 이동
					$('.go-next').on('click', function() {
						thisMonth = new Date(currentYear, currentMonth + 1, 1);
						renderCalender(thisMonth);
					});

					//일자 선택 클릭
					/* $('.num2').on('click', function() {


					   alert($('.num2').text());

					}); */

				}

				var startdate = '';
				var enddate = '';

				function selDate() {

					//alert(event.target.textContent);
					//alert(event.target.parentElement.parentElement.parentElement.children[1].children[1].textContent + '.' + event.target.textContent);
					startdate = event.target.parentElement.parentElement.parentElement.children[1].children[1].textContent
							+ '.' + event.target.textContent;
					startdate = startdate.replaceAll('.', '-');

					console.log(startdate);
					$(".color").css("background-color", "transparent");
					$(event.target).css("background-color", "#eee");
					//alert($(event.target).text());#/tworavel/plan/recommend2'#/tworavel/plan/recommend2.do?startdate= &enddate= '

					//$('#btnnext').attr('href', '/tworavel/plan/recommend2.do?startdate=' + startdate + '&enddate=' + enddate);

					//alert('selDate() : ' + startdate + ":" + enddate);

					document.se.start.value = startdate;
				}

				function selDate2() {

					//alert(event.target.textContent);
					//alert(event.target.parentElement.parentElement.parentElement.children[1].children[1].textContent + '.' + event.target.textContent);
					enddate = event.target.parentElement.parentElement.parentElement.children[1].children[1].textContent
							+ '.' + event.target.textContent;
					enddate = enddate.replaceAll('.', '-');
					console.log(enddate);
					$(".color2").css("background-color", "transparent");
					$(event.target).css("background-color", "#eee");
					//alert($(event.target).text());

					//$('#btnnext').attr('href', '/tworavel/plan/recommend2.do?startdate=' + startdate + '&enddate=' + enddate);

					//alert('selDate2() : ' + startdate + ":" + enddate);
					document.se.end.value = enddate;
				}

				function calendarInit2() {

					// 날짜 정보 가져오기
					var date = new Date(); // 현재 날짜(로컬 기준) 가져오기
					var utc = date.getTime()
							+ (date.getTimezoneOffset() * 60 * 1000); // uct 표준시 도출
					var kstGap = 9 * 60 * 60 * 1000; // 한국 kst 기준시간 더하기
					var today = new Date(utc + kstGap); // 한국 시간으로 date 객체 만들기(오늘)

					var thisMonth = new Date(today.getFullYear(), today
							.getMonth(), today.getDate());
					// 달력에서 표기하는 날짜 객체

					var currentYear = thisMonth.getFullYear(); // 달력에서 표기하는 연
					var currentMonth = thisMonth.getMonth(); // 달력에서 표기하는 월
					var currentDate = thisMonth.getDate(); // 달력에서 표기하는 일

					// kst 기준 현재시간
					// console.log(thisMonth);

					// 캘린더 렌더링
					renderCalender2(thisMonth);

					function renderCalender2(thisMonth) {

						// 렌더링을 위한 데이터 정리
						currentYear = thisMonth.getFullYear();
						currentMonth = thisMonth.getMonth();
						currentDate = thisMonth.getDate();

						// 이전 달의 마지막 날 날짜와 요일 구하기
						var startDay = new Date(currentYear, currentMonth, 0);
						var prevDate = startDay.getDate();
						var prevDay = startDay.getDay();

						// 이번 달의 마지막날 날짜와 요일 구하기
						var endDay = new Date(currentYear, currentMonth + 1, 0);
						var nextDate = endDay.getDate();
						var nextDay = endDay.getDay();

						// console.log(prevDate, prevDay, nextDate, nextDay);

						// 현재 월 표기
						$('.year-month2').text(
								currentYear + '.' + (currentMonth + 1));

						// 렌더링 html 요소 생성
						calendar = document.querySelector('.dates2')
						calendar.innerHTML = '';

						// 지난달
						for (var i = prevDate - prevDay + 1; i <= prevDate; i++) {
							calendar.innerHTML = calendar.innerHTML
									+ '<div class="day2 prev2 disable2 color2 ">' + i
									+ '</div>'
						}
						// 이번달
						for (var i = 1; i <= nextDate; i++) {
							calendar.innerHTML = calendar.innerHTML
									+ '<div class="day2 current2 color2 '
									+ 'num'
									+ i
									+ '" onclick="selDate2();"  style="cursor: pointer;" >'
									+ i + '</div>'

						}
						// 다음달
						for (var i = 1; i <= (7 - nextDay == 7 ? 0
								: 7 - nextDay); i++) {
							calendar.innerHTML = calendar.innerHTML
									+ '<div class="day2 next2 disable2 color2">' + i
									+ '</div>'
						}

						// 오늘 날짜 표기
						if (today.getMonth() == currentMonth) {
							todayDate = today.getDate();
							var currentMonthDate = document
									.querySelectorAll('.dates2 .current2');
							currentMonthDate[todayDate - 1].classList
									.add('today2');
						}
					}

					// 이전달로 이동
					$('.go-prev2').on('click', function() {
						thisMonth = new Date(currentYear, currentMonth - 1, 1);
						renderCalender2(thisMonth);
					});

					// 다음달로 이동
					$('.go-next2').on('click', function() {
						thisMonth = new Date(currentYear, currentMonth + 1, 1);
						renderCalender2(thisMonth);
					});

				}
			</script>
</body>
</html>