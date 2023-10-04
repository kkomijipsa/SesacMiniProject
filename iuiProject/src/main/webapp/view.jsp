<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="iuiProject.*,java.sql.*,java.util.*"%>
<jsp:useBean id="album" type="iuiProject.AlbumDTO" scope="session"/>
<jsp:useBean id="albumService" type="iuiProject.AlbumDAO" scope="session"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>IUI 앨범뷰</title>
<!-- 부트스트랩 CSS 링크 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
<% List<AlbumDTO> albums = albumService.getAllAlbums(); %>
	<div class="container">
		<h3 align="center" style="margin-top: 10px;">아이유 앨범 갤러리</h3>
		<div class="row">
			<!-- 앨범 재킷 카드 -->
			<% for(AlbumDTO a : albums){%>
			<div class="col-md-3">
				<div class="card">
					<img src="image/<%=a.getAlbumCover()%>" class="card-img-top"
						alt="앨범 재킷">
					<div class="card-body">
						<h5 class="card-title"><%=a.getAlbumName()%></h5>
						<button type="button" class="btn btn-primary" 
						 onclick="albumview('albumView.jsp?albumId=<%=a.getAlbumId()%>')">앨범 정보</button>
						
					</div>
				</div>
			</div>
			<%}%>
			
		</div>
	</div>
	
	<script>
	function albumview(i) {
		console.log('함수가 albumId와 함께 호출되었습니다:', i);
	    // AJAX 요청 생성
	    const xhr = new XMLHttpRequest();
	 //   const target = 'albumView.jsp?albumId=' + i;
	    const target = i;
	    console.log(target);
	    
	    // 요청을 보낼 페이지 URL 설정
	    xhr.open('GET', target, true);

	    // 요청이 완료되면 실행될 함수 정의
	    xhr.onload = function () {
	        if (xhr.status === 200) {
	            // 응답으로 받은 HTML을 section 요소에 삽입
	            document.querySelector('section').innerHTML = xhr.responseText;
	            // 이전 페이지로 돌아가기 기능 활성화
	            /* window.history.pushState({ page: "album", albumId: i }, null, target); */
	        } else {
	            alert('페이지 로드 중 오류가 발생했습니다.');
	        }
	    };
	    
	    // 요청 보내기
	    xhr.send();
	}
	
		// 이전 페이지로 돌아가는 이벤트 핸들러
		window.onpopstate = function(event) {
			if (event.state && event.state.page === "album") {
				test(event.state.albumId);
			} else {
				// 이전 페이지가 없거나 album 페이지가 아닌 경우 메인 페이지로 이동
				if (member == null) {
					window.location.href = 'main.jsp';
				} else
					window.location.href = 'home.jsp';
			}
		};
		
		 function updateAlbumAndShowAlbumView(albumId) {
		        // updateAlbum 함수 호출
		        updateAlbum(albumId, function() {
		            // updateAlbum이 완료되면 albumView 함수 호출
		            albumview('albumView.jsp?albumId=' + albumId);
		        });
		    }
		 
		 function submitCommentAndShowAlbumView(albumId) {
			 // submitComment 함수 호출
		        submitComment(albumId, function() {
		            // submitComment이 완료되면 albumView 함수 호출
		            albumview('albumView.jsp?albumId=' + albumId);
		        });
		    }
		 
		  function updateAlbum(i,callback) {
	            var newAlbumName = document.getElementById("new_albumName").value;
	            var newAlbumType = document.getElementById("new_albumType").value; 
	            var newReleaseDate = document.getElementById("new_releaseDate").value;
	            var newNumberSongs = document.getElementById("new_numberSongs").value;
	            var newAlbumIntro = document.getElementById("new_albumIntro").value;
	            var newAlbumId = i;

	            // AJAX를 사용하여 albumModAction.jsp로 데이터 전송
	            var xhr = new XMLHttpRequest();
	            xhr.open("POST", "albumModAction.jsp", true);
	            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
	            xhr.onreadystatechange = function() {
	                if (xhr.readyState == 4 && xhr.status == 200) {
	                    // 성공적으로 응답을 받았을 때의 동작
	                    alert("앨범이 성공적으로 수정되었습니다.");
	                    if (callback && typeof callback === 'function') {
	                        callback();
	                    }
	                }
	            };

	            // 전송할 데이터를 URL-encoded 형식으로 만듭니다.
	            var data = "newAlbumName=" + encodeURIComponent(newAlbumName) +
	                       "&newAlbumType=" + encodeURIComponent(newAlbumType) +
	                       "&newReleaseDate=" + encodeURIComponent(newReleaseDate) +
	                       "&newNumberSongs=" + encodeURIComponent(newNumberSongs) +
	                       "&newAlbumIntro=" + encodeURIComponent(newAlbumIntro)+
	                       "&newAlbumId=" + encodeURIComponent(i);

	            xhr.send(data);
	        }
		
		  
		  function submitComment(i,callback) {
			  console.log('submitComment 함수 호출');
	            var albumId = document.getElementById("albumId").value;
	            var memberNo = document.getElementById("memberNo").value; 
	            var comment = document.getElementById("comment").value;

	            // AJAX를 사용하여 albumModAction.jsp로 데이터 전송
	            var xhr = new XMLHttpRequest();
	            xhr.open("POST", "commentSubmitAction.jsp", true);
	            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
	            xhr.onreadystatechange = function() {
	                if (xhr.readyState == 4) {
	                    // 성공적으로 응답을 받았을 때의 동작
	                    if (xhr.status == 200) {
	                    	console.log('submitComment 성공');
	                        if (callback && typeof callback === 'function') {
	                            callback();
	                        }
	                    } else {
	                        // 에러 처리
	                        alert('댓글 작성 중 오류가 발생했습니다.');
	                    }
	                }
	            };


	            // 전송할 데이터를 URL-encoded 형식으로 만듭니다.
	            var data = "albumId=" + encodeURIComponent(albumId) +
	                       "&memberNo=" + encodeURIComponent(memberNo) +
	                       "&comment=" + encodeURIComponent(comment);
	            xhr.send(data);
	        }  
		
		
	</script>
	<!-- 부트스트랩 JavaScript 및 j Query 스크립트 링크 -->
	<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
	<script	src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>