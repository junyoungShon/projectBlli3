<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>블리 - 충동구매보다 빠른 합리적 쇼핑!</title>
<link href="${initParam.root}img/favicon/favicon.ico" rel="shortcut icon" type="image/x-icon" />
<meta name="Keywords" content="" />
<meta name="Description" content="" />
<!-- css -->
<link rel="stylesheet" type="text/css" href="./css/reset.css" />
<link rel="stylesheet" type="text/css" href="./css/css.css" />
<link href="${initParam.root}css/bootstrap.css" rel="stylesheet">
<link href="${initParam.root}css/ct-paper.css" rel="stylesheet"/>
<!--     Fonts and icons     -->
<link href="${initParam.root}css/font-awesome.min.css" rel="stylesheet" />
<!-- jquery -->
<script src="//code.jquery.com/jquery-1.12.0.min.js"></script>
<script src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
<script src="${initParam.root}js/jquery-ui-1.10.4.custom.min.js" type="text/javascript"></script>
<script src="${initParam.root}js/bootstrap.min.js"></script>
<!--  Plugins -->
<script src="${initParam.root}js/ct-paper-checkbox.js"></script>
<script src="${initParam.root}js/ct-paper-radio.js"></script>
<script src="${initParam.root}js/bootstrap-select.js"></script>
<script src="${initParam.root}js/bootstrap-datepicker.js"></script>
<script src="${initParam.root}js/ct-paper.js"></script> 
<style type="text/css">
	.alertDiv{
		margin-top: -15px;
	    font-size: 11px;
	    margin-bottom: 10px;
	}
</style>
	<sec:authorize access="hasRole('ROLE_RESTRICTED')">
		<script type="text/javascript">
			location.replace('${initParam.root}loginPage.do');
		</script>
	</sec:authorize>
<script type="text/javascript">
	//이메일 유효성 변수
	var emailValidity = false;
	//회원 이름 유효성 변수
	var memberNameValidity = false;
	//회원 비밀번호 유효성 변수
	var passwordValidity = false;
	//회원 비밀번호 확인 유효성 변수
	var repasswordValidity = false;
	
	$(document).ready(function(){
		
		$.ajax({
			type:"get",
			url:"footerStatics.do",
			success:function(data){
				$('.footerProductStatics').text(data.productStatics);
				$('.footerPostingStatics').text(data.postingStatics);
			}
		});
		
		//입력 값 초기화
		$(':input[name="memberId"]').val('');
		$(':input[name="memberName"]').val('');
		$(':input[name="memberPassword"]').val('');
		$(':input[name="memberRePassword"]').val('');
		
		$(':input[name="memberId"]').keyup(function(){
			//유저의 입력값
			var userMail = $(this).val();
			
			//이메일 정규식
			var regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i; 
			if(userMail==""){
				$('#memberIdInsertMSG').text('이메일을 입력해주세요');
			}else if(!regExp.test(userMail)){
				$('#memberIdInsertMSG').text('유효한 이메일을 입력해주세요');
			}else{
				$('#memberIdInsertMSG').text('유효한 이메일입니다 ');
				$.ajax({
	            	type:"get",
	            	url:"findMemberByEmailId.do?memberId="+userMail,
	            	success:function(result){
	            		if(result==true){
	            			$('#memberIdInsertMSG').text('이미 등록한 이메일 주소 입니다.');
	            		}else{
	            			$('#memberIdInsertMSG').text('유효한 이메일입니다 ');
	            			emailValidity = true;
	            		}
	            	}
	            });
			}
			if(userMail.length>=29){
				$('#memberIdInsertMSG').text('이메일 주소는 30글자 이하로 입력해주세요 ^^');
				$(this).val(userMail.substring(0,29));
			}
		});
		$(':input[name="memberName"]').keyup(function(){
			//유저의 입력값
			var userName = $(this).val();
			if(userName==""){
				$('#memberNameInsertMSG').text('성함 혹은 별칭을 입력해주세요');
			}
			if(userName.length>=10){
				$('#memberNameInsertMSG').text('성함 혹은 별칭은 9글자 이하로 입력해주세요');
				$(this).val(userName.substring(0,9));
			}else if(userName.length>0){
				$('#memberNameInsertMSG').text('유효한 이름입니다!');
				memberNameValidity = true;
			}
			
		});
		$(':input[name="memberPassword"]').keyup(function(){
			//유저의 입력값
			var userPassword = $(this).val();
			if(userPassword==""){
				$('#memberPasswordInsertMSG').text('비밀번호를 입력 해주세요');
			}
			if(userPassword.length>=12){
				$('#memberPasswordInsertMSG').text('비밀번호는 6글자 이상, 12글자 이하로 입력해주세요');
				$(this).val(userPassword.substring(0,12));
			}else if(userPassword.length>6){
				$('#memberPasswordInsertMSG').text('유효한 비밀번호입니다!');
				passwordValidity = true;
			}
		});
		$(':input[name="memberRePassword"]').keyup(function(){
			var userRePassword = $(this).val();
			if(userRePassword==""){
				$('#memberRePasswordInsertMSG').text('비밀번호를 확인 해주세요');
			}
			if(userRePassword.length>=12){
				$('#memberRePasswordInsertMSG').text('비밀번호는 6글자 이상, 12글자 이하로 입력해주세요');
				$(this).val(userRePassword.substring(0,12));
			}else if(userRePassword.length>6){
				if($(':input[name="memberPassword"]').val()==userRePassword){
					$('#memberRePasswordInsertMSG').text('비밀번호가 확인되었습니다.');
					repasswordValidity = true;
				}else{
					$('#memberRePasswordInsertMSG').text('비밀번호가 서로 일치하지 않습니다.');
				}
			}
		});
		
	});
		function submitMemberInfo(){
			if(!emailValidity){
				alert('이메일을 확인해주세요!');
				$(':input[name="memberId"]').focus();
				return false;	
			}
			if(!memberNameValidity){
				alert('입력하신 이름을 확인해주세요');
				$(':input[name="memberName"]').focus();
				return false;	
			}
			if(!passwordValidity){
				alert('입력하신 비밀번호를 확인해주세요');
				$(':input[name="memberPassword"]').focus();
				return false;	
			}
			if(!repasswordValidity){
				alert('확인하신 비밀번호가 올바르지않습니다.');
				$(':input[name="memberRePassword"]').focus();
				return false;	
			}
			document.getElementById("memberJoinForm").submit();
		}
</script>

</head>
<body>
	<!-- 회원가입페이지에 비회원 접근 시 회원가입 폼 출력 -->
	<sec:authorize access="isAnonymous()">
	<div class="wrapper">
        <div class="register-background"> 
            <div class="filter-black"></div>
                <div class="container">
                    <div class="row">
                        <div class="col-md-4 col-md-offset-4 col-sm-6 col-sm-offset-3 col-xs-10 col-xs-offset-1 ">
                            <div class="register-card">
                                <h3 class="title">Welcome</h3>
                                <form class="register-form" method="post" name="memberJoin" id="memberJoinForm" action="joinMemberByEmail.do">
                                    <label>이메일 아이디</label>
                                    <input type="text" class="form-control" name="memberId" placeholder="Email 주소" >
                                    <div class="alertDiv" id="memberIdInsertMSG"></div>
                                    <label>이름</label>
                                    <input type="text" class="form-control" name="memberName" placeholder="이름">
									<div class="alertDiv" id="memberNameInsertMSG"></div>
                                    <label>비밀번호</label>
                                    <input type="password" class="form-control" name="memberPassword" placeholder="비밀번호(6자 이상)">
                                    <div class="alertDiv" id="memberPasswordInsertMSG"></div>
                                    <label>비밀번호 확인</label>
                                    <input type="password" class="form-control" name="memberRePassword" placeholder="비밀번호 확인">
                                    <div class="alertDiv" id="memberRePasswordInsertMSG"></div>
                                    <a class="btn btn-danger btn-block" onclick="submitMemberInfo()" style="margin-top:30px;">등록</a>
                                </form>
                                <div class="forgot">
                                    <a href="#" class="btn btn-simple btn-danger">비밀번호를 잊으셨나요?</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>     
            <div class="footer register-footer text-center">
            	<font color="white">가입과 동시에 쿠키 사용 및 약관에 동의하는 것으로 합니다.</font><br/>
				<a href="${initParam.root}loginPage.do" class="yellow"> 로그인 </a> / <span class="yellow"> 약관 보기 </span>
            </div>
        </div>
    </div>      
	</sec:authorize>
	
	<!-- 회원가입페이지에 ROLE_USER접근 시 alert과 메인페이지 이동 -->
	<sec:authorize access="hasAnyRole('ROLE_USER','ROLE_ADMIN')">
		<script type="text/javascript">
			location.replace('${initParam.root}member_proceedingToMain.do');
		</script>
	</sec:authorize>
	
	<!-- 회원가입페이지에 ROLE_RESTRICTED 접근 시 아이정보 입력 페이지 이동 -->
	<sec:authorize access="hasRole('ROLE_RESTRICTED')">
		<script type="text/javascript">
			location.replace('${initParam.root}memberJoin_insertBabyInfo.do');
		</script>
	</sec:authorize>
			<div class="login_bottom">
			<div class="fl login_bottom_ft">
				블리는 <span class="footerProductStatics"></span>개의 상품을 소개하고, 관련된 <span class="footerPostingStatics"></span>개의 블로그를 분석하고 소개합니다.
			</div>
			<div class="fr">
				<div class="login_bottom_right">
				<a href="${initParam.root}adminIndex.do"><img src="./img/bottom_app1.png" alt="안드로이드 다운로드받기"></a>
				<a href="#"><img src="./img/bottom_app2.png" alt="애플 다운로드받기"></a>
				</div>
			</div>
		</div>
</body>
</html>
