<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>블리 - 충동구매보다 빠른 합리적 쇼핑!</title>
<link href="${initParam.root}img/favicon/favicon.ico" rel="shortcut icon" type="image/x-icon" />
<meta name="Keywords" content="" />
<meta name="Description" content="" /></head>
<body>
<!-- 본페이지는 로그인 페이지로서 Restricted멤버의 경우 아이 추가 페이지를 출력하며 비인증 회원의 경우 로그인 폼을 출력해줍니다. -->
	
	<!-- 회원가입페이지에 ROLE_USER접근 시 alert과 메인페이지 이동 -->
	<sec:authorize access="hasRole('ROLE_USER')">
		<script type="text/javascript">
			location.replace('${initParam.root}member_proceedingToMain.do');
		</script>
	</sec:authorize>
	<!-- 회원가입페이지에 ROLE_USER접근 시 alert과 메인페이지 이동 -->
	<sec:authorize access="hasRole('ROLE_ADMIN')">
		<script type="text/javascript">
			location.replace('${initParam.root}admin_goAdminIndexPage.do');
		</script>
	</sec:authorize>
	<sec:authorize access="hasRole('ROLE_RESTRICTED')">
		<script type="text/javascript">
			location.replace('${initParam.root}memberjoin_insertBabyInfo.do');
		</script>
	</sec:authorize>
	<!-- 미인증 유저에게는 로그인 폼이 제공된다. -->
	<sec:authorize access="isAnonymous()">
		<script type="text/javascript">
			location.replace('${initParam.root}loginPage.do');
		</script>
	</sec:authorize>


</body>
</html>