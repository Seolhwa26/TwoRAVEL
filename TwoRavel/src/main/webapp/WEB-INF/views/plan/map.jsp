<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "/WEB-INF/inc/asset.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
<title>Insert title here</title>

<script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=wr4cicggx8"></script>

<style>


</style>
</head>
<body>
	<main>
			<!-- 지도 전체 시작  -->
			<div id="map" style="width: 100%; height: 880px; position: relative;">
			
			<!-- 오른쪽 장소 숙박 교통 시작 -->
			<div style=" position:absolute; z-index:100; margin-left: 93%; margin-top: 50px;">
				<button class="btn btn-primary" type="button"
				data-bs-toggle="offcanvas" data-bs-target="#offcanvasPlace"
				aria-controls="offcanvasPlace" style="margin-bottom: 30px;">장소 추가</button>
				
				<button class="btn btn-primary" type="button"
				data-bs-toggle="offcanvas" data-bs-target="#offcanvasAccom"
				aria-controls="offcanvasAccom" style="margin-bottom: 30px;">숙박 추가</button>
				
				<button class="btn btn-primary" type="button"
				data-bs-toggle="offcanvas" data-bs-target="#offcanvasTransfer"
				aria-controls="offcanvasTransfer">교통 추가</button>
				
			<!-- 장소 사이드 바 시작  -->
			<div class="offcanvas offcanvas-end" tabindex="-1"
				id="offcanvasPlace" aria-labelledby="offcanvasPlaceLabel">
				<div class="offcanvas-header">
					<h5 class="offcanvas-title" id="offcanvasPlaceLabel">장소 추가</h5>
					<button type="button" class="btn-close" data-bs-dismiss="offcanvas"
						aria-label="Close"></button>
				</div>
				<div class="offcanvas-body">
				<input type="button" value="장소 등록" />
				<input type="button" value="장소 추가" />
					<div class="container" style="border:5px solid gray; width: 300px; margin-top: 50px; border-radius: 50px;">
						
						<div style="border: 3px solid black; width: 230px; height: 150px; margin:20px 20px 20px 20px; border-radius:10px;">
							
						</div>
						
						<div style="border: 3px solid black; width: 230px; height: 150px; margin:20px 20px 20px 20px; border-radius:10px;">
						
						</div>
						
						<div style="border: 3px solid black; width: 230px; height: 150px; margin:20px 20px 20px 20px; border-radius:10px;">
						
						</div>
					
					</div>		
				</div>
			</div> <!-- 장소 사이드 바 끝  -->
			
			<!-- 숙박 사이드 바 시작  -->
			<div class="offcanvas offcanvas-end" tabindex="-1"
				id="offcanvasAccom" aria-labelledby="offcanvasAccomLabel">
				<div class="offcanvas-header">
					<h5 class="offcanvas-title" id="offcanvasAccomLabel">장소 추가</h5>
					<button type="button" class="btn-close" data-bs-dismiss="offcanvas"
						aria-label="Close"></button>
				</div>
				<div class="offcanvas-body">
				<input type="button" value="장소 추가" />
				
				</div>
			</div> <!-- 숙박 사이드 바 끝  -->
			
			<!-- 교통 사이드 바 시작  -->
			<div class="offcanvas offcanvas-end" tabindex="-1"
				id="offcanvasTransfer" aria-labelledby="offcanvasTransferLabel">
				<div class="offcanvas-header">
					<h5 class="offcanvas-title" id="offcanvasTransferLabel">장소 추가</h5>
					<button type="button" class="btn-close" data-bs-dismiss="offcanvas"
						aria-label="Close"></button>
				</div>
				<div class="offcanvas-body">
				<input type="button" value="교통 추가" />
				
				</div>
			</div> <!-- 교통 사이드 바 끝  -->
				
				
				
				
			</div> <!-- 오른쪽 장소 숙박 교통 끝 -->
	
			<!-- 왼쪽 일정 시작 -->
			<div style="position: absolute; z-index: 100; margin-left: 30px; margin-top: 50px;">

				<button class="btn btn-primary" type="button"
					data-bs-toggle="offcanvas" data-bs-target="#offcanvasExample"
					aria-controls="offcanvasExample">일정 추가</button>
				
				<!-- 일정 사이드바 시작 -->
				<div class="offcanvas offcanvas-start" tabindex="-1" id="offcanvasExample" aria-labelledby="offcanvasExampleLabel">
					<div class="offcanvas-header">
						<h5 class="offcanvas-title" id="offcanvasExampleLabel">일정 추가</h5>
						<button type="button" class="btn-close"
							data-bs-dismiss="offcanvas" aria-label="Close"></button>
					</div>
					<div class="offcanvas-body">
						여행 시작일<input type="date" />
						<br />
						여행 종료일<input type="date" />
					</div>
				</div> <!-- 일정 사이드바 끝 -->

			</div> <!-- 왼쪽 일정 끝 -->

			</div> <!-- 지도 전체 끝  -->
			
		
	</main>
	<script>
	var mapOptions = {
		    center: new naver.maps.LatLng(33.4996213, 126.5311884),
		    zoom: 10
		};

		var map = new naver.maps.Map('map', mapOptions);
		
		var marker = new naver.maps.Marker({
		    map: map
		});

		naver.maps.Event.addListener(map, 'click', function(e) {
		    marker.setPosition(e.latlng);
		});
	
	</script>
</body>
</html>