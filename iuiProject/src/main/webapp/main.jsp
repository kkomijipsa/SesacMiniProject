<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="iuiProject.*,java.sql.*,java.util.*"%>
<jsp:useBean id="album" class="iuiProject.AlbumDTO" scope="session"/>
<jsp:useBean id="albumService" class="iuiProject.AlbumDAO" scope="session"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" type="text/css" href="styles.css">
<title>IUI.main</title>
</head>
<% List<AlbumDTO> albums = albumService.getAllAlbums(); %>
<% Map<String, List<AlbumDTO>> years= albumService.loadAlbumByYear(albums); %>
<body>
	<header>
		<div class="login-button" onclick="toggleLoginPopup()">로그인</div>
		<div class="register-button" onclick="toggleRegisterPopup()">회원가입</div>
	</header>
	
	<!-- 로그인 팝업 -->
    <div id="login-popup" class="popup">
        <div class="popup-content">
            <span class="close-button" onclick="toggleLoginPopup()">&times;</span>
            <h2>로그인</h2>
            <br>
            <form class="login-form" action="loginAction.jsp" method="GET">
                <label for="id">아이디:</label>
                <input type="text" id="id" name="id" placeholder="아이디" required>
                <label for="password">비밀번호:</label>
                <input type="password" id="pw" name="pw"  placeholder="비밀번호" required>
				<br>
                <button type="submit">로그인</button>
            </form>
        </div>
    </div>
    
    <aside>
		<div class="logo">
			<a href="main.jsp" > 
			<img src="image/logo2.webp" alt="iui 홈페이지">
			</a>
		</div>

		<div class="dropdown">
    		<a href="#">아이유의 음원 목록</a>
    		<div class="dropdown-content">
				<% for(AlbumDTO a : albums){ %>
				<a href="#" onclick="albumview('albumView.jsp?albumId=<%=a.getAlbumId()%>')"><%=a.getAlbumName()%></a>
				<%}%>
				
			</div>
    	</div>
    	
		<% for(String year : years.keySet()) { %>
		<div class="dropdown">
			<a href="#"><%=year%>년</a>
			<div class="dropdown-content">
				<a href="#" onclick="loadAlbumsByYear('<%=year%>')"><%=year%>년
					앨범</a>
				<%
				}
				%>
			</div>
		</div>

	</aside>
	
	<section>
	<jsp:include page="view.jsp" />
	</section>

    <!-- JavaScript 스크립트 -->
    <script>
    function toggleLoginPopup() {
        var loginPopup = document.getElementById('login-popup');
        var registerPopup = document.getElementById('register-popup');
        var usernameInput = document.getElementById('id'); // 아이디 입력 필드
        var passwordInput = document.getElementById('pw'); // 비밀번호 입력 필드
        usernameInput.value = '';
        passwordInput.value = '';

        if (loginPopup.style.display === 'block') {
            loginPopup.style.display = 'none';
            // 팝업이 닫힐 때 입력 필드 초기화
            usernameInput.value = '';
            passwordInput.value = '';
        } else {
            loginPopup.style.display = 'block';
            // 회원가입 팝업 닫기
            registerPopup.style.display = 'none';
        }
    }
    
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

    function toggleRegisterPopup() {
    	  window.location.href = 'register.jsp';
    }
    
    
	</script>
</body>
</html>