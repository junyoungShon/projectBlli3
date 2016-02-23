<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style type="text/css">
	.alertDiv{
		margin-top: -15px;
	    font-size: 11px;
	    margin-bottom: 10px;
	}
</style>

<script type="text/javascript">
	//이메일 유효성 변수
	var emailValidity = true;
	//회원 이름 유효성 변수
	var memberNameValidity = true;
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
		$(':input[name="memberPassword"]').val('');
		$(':input[name="memberRePassword"]').val('');
		
		
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
			document.getElementById("memberInfoForm").submit();
		}
</script>

</head>
        <div class="register-background" style="background-image: url('${initParam.root}img/modifyBg.jpg"> 
            <div class="filter-black"></div>
                <div class="container">
                    <div class="row">
                        <div class="col-md-4 col-md-offset-4 col-sm-6 col-sm-offset-3 col-xs-10 col-xs-offset-1 ">
                            <div class="register-card">
                                <h3 class="title">회원 정보 수정</h3>
                                <form class="register-form" method="post" name="memberInfo" id="memberInfoForm"action="updateMemberInfoByEmail.do">
                                	<input type="hidden" name="memberId" value="${requestScope.blliMemberVO.memberId}"  readonly="readonly">
                                    <input type="hidden" name="memberEmail" placeholder="이메일 주소를 입력해주세요" value="${requestScope.blliMemberVO.memberEmail}">
                                    <div class="alertDiv" id="memberIdInsertMSG"></div>
                                    <label>이름</label>
                                    <input type="text" class="form-control" name="memberName" placeholder="${requestScope.blliMemberVO.memberName}" value="${requestScope.blliMemberVO.memberName}">
									<div class="alertDiv" id="memberNameInsertMSG"></div>
                                    <label>새로운 비밀번호</label>
                                    <input type="password" class="form-control" name="memberPassword" placeholder="비밀번호(6자 이상)">
                                    <div class="alertDiv" id="memberPasswordInsertMSG"></div>
                                    <label>비밀번호 확인</label>
                                    <input type="password" class="form-control" name="memberRePassword" placeholder="비밀번호 확인">
                                    <div class="alertDiv" id="memberRePasswordInsertMSG"></div>
                                    <a class="btn btn-danger btn-block" onclick="submitMemberInfo()" style="margin-top:30px;">수정</a>
                                </form>
                                <div class="forgot">
                                    <a href="#" class="btn btn-simple btn-danger">비밀번호를 잊으셨나요?</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>     
        </div>
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