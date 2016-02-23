<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript">
		
	//이메일 유효성 변수
	var emailValidity = false;
	//쌍둥이 선택 시 몇번째 칸 아이인지 저장하는 변수
	var selectBabyNum ;
	//최근 업로드된 사진번호 저장 변수
	var updateBabyPhotoNum;
	
	function setUpdateBabyPhotoNum(updateBabyPhotoNum){
		this.updateBabyPhotoNum = updateBabyPhotoNum;
	}
	function insertEmailInfo(){
		if(emailValidity){
			$('#emailConfirmed').modal('hide');
		}else{
			alert('이메일을 확인해주세요');
		}
	}
	$(document).ready(function(){
		//초기에 기본 성별 설정
		for(var i=0;i<3;i++){
			$(':input[name="BlliBabyVO['+i+'].babySex"]').eq(0).radio('check');
		}
		//이메일을 체크해서 이메일정보가 없을 경우 모달을 띄운다.
		if(true){
			var regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i; 
			if(!regExp.test('${sessionScope.blliMemberVO.memberEmail}')){
				$('#emailConfirmed').modal({
					  keyboard: false,
					  backdrop :'static'
				});
			}else{
				emailValidity=true;
			}
		}
		$.ajax({
			type:"get",
			url:"footerStatics.do",
			success:function(data){
				$('.footerProductStatics').text(data.productStatics);
				$('.footerPostingStatics').text(data.postingStatics);
			}
		});
		$.datepicker.regional['ko'] = {
				  closeText: '닫기',
				  prevText: '이전',
				  nextText: '다음',
				  currentText: '오늘',
				  monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
				  monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'],
				  dayNames: ['일','월','화','수','목','금','토'],
				  dayNamesShort: ['일','월','화','수','목','금','토'],
				  dayNamesMin: ['일','월','화','수','목','금','토'],
				  weekHeader: 'Wk',
				  dateFormat: 'yy-mm-dd',
				  firstDay: 0,
				  isRTL: false,
				  showMonthAfterYear: true,
				  yearSuffix: ''};
				 $.datepicker.setDefaults($.datepicker.regional['ko']);

		//사진 업로드 시 실시간 미리보기 및 용량 체크
		$('.babyPhoto').change(function(){
			var fileName = $(this).val(); 
			//파일을 추가한 input 박스의 값
			fileName = fileName.slice(fileName.indexOf('.') + 1).toLowerCase(); 
			//파일 확장자를 잘라내고, 비교를 위해 소문자로 만듭니다.
			if(fileName != "jpg" && fileName != "png" &&  fileName != "gif" &&  fileName != "bmp")
			{ //확장자를 확인합니다.
				alert('프로필 사진은 이미지 파일(jpg, png, gif, bmp)만 등록 가능합니다.');
				$('#babyPhoto'+updateBabyPhotoNum).attr("src","${initParam.root}img/baby_foto.jpg");
				$('#babyPhoto'+updateBabyPhotoNum).css("width","100px");
				$('#babyPhoto'+updateBabyPhotoNum).css("height","100px");
				return false;
			}else{
				var data = new FormData();
				$.each($('#babyPhotoInput'+updateBabyPhotoNum)[0].files, function(i, file) {          
		   			data.append('file-' + i, file);
		        });
		        $.ajax({
			        url: 'fileCapacityCheck.do',
			        type: "post",
			        dataType: "text",
			        data: data,
			        // cache: false,
			        processData: false,
			        contentType: false,
			        success: function(data, textStatus, jqXHR) {
				        var input = this;
				        if(data=="true"){
				        	
				        }else{
				        	var fileName = $(this).val("");
					        alert('프로필 사진은 2mb 이하로 올려주세요 ^^');
					        $('#babyPhoto'+updateBabyPhotoNum).attr("src","${initParam.root}img/baby_foto.jpg");
							$('#babyPhoto'+updateBabyPhotoNum).css("width","100px");
							$('#babyPhoto'+updateBabyPhotoNum).css("height","100px");

					        return false;
					    }
		            }, 
		            error: function(jqXHR, textStatus, errorThrown) {}
		        });
		        if(fileName!=""){
				var input = this;
				 if (input.files && input.files[0]) {
	                    var reader = new FileReader(); //파일을 읽기 위한 FileReader객체 생성
	                    reader.onload = function (e) {
	                    //파일 읽어들이기를 성공했을때 호출되는 이벤트 핸들러
	                        //$('#babyPhoto0').css({"background":"url("+e.target.result+")"});
	                    	$('#babyPhoto'+updateBabyPhotoNum).attr("src",e.target.result);
	                    	$('#babyPhoto'+updateBabyPhotoNum).css("width","100px");
	                    	$('#babyPhoto'+updateBabyPhotoNum).css("height","100px");
	                    }                   
	                    reader.readAsDataURL(input.files[0]);
	             }
			}
			}
		});
		/* $('#sandbox-container input').Datepicker({
		    format: "yyyy-mm-dd",
		    weekStart: 1,
		    startDate: "2016-02-19",
		    endDate: "2016-03-22",
		    maxViewMode: 0,
		    todayBtn: "linked",
		    keyboardNavigation: false,
		    autoclose: true,
		}); */
		$('.babyName').keyup(function(){
			var userWritingBabyName = $(this).val();
			$(this).val(userWritingBabyName.substring(0,5));
			if($(this).length>5){
				alert('아이이름은 5글자 이하로 작성해주세요 ^^');
				$(this).val(userWritingBabyName.substring(0,5));
			}
		});
		//쌍둥이 이름 글자 제한
		$('.twinsName').keyup(function(){
			var userWritingBabyName = $(this).val();
			$(this).val(userWritingBabyName.substring(0,5));
			if($(this).length>5){
				alert('아이이름은 5글자 이하로 작성해주세요 ^^');
				$(this).val(userWritingBabyName.substring(0,5));
			}
		});
		//쌍둥이 선택 취소 혹은 완료 시 입력창 초기화
		$('#addTwins').on('hidden.bs.modal', function (e) {
			$('.twinsName').val('');
		})
		
		
		$(':input[name="memberEmail"]').keyup(function(){
			//유저의 입력값
			var userMail = $(this).val();
			//이메일 정규식
			if(userMail==""){
				$('#memberEmailInsertMSG').text('이메일을 입력해주세요');
			}else if(!regExp.test(userMail)){
				$('#memberEmailInsertMSG').text('유효한 이메일을 입력해주세요');
			}else{
				$('#memberEmailInsertMSG').text('유효한 이메일입니다 ');
				$.ajax({
		        	type:"get",
		        	url:"findMemberByEmailId.do?memberId="+userMail,
		        	success:function(result){
		        		if(result==true){
		        			$('#memberEmailInsertMSG').text('이미 등록한 이메일 주소 입니다.');
		        		}else{
		        			$('#memberEmailInsertMSG').text('유효한 이메일입니다 ');
		        			emailValidity = true;
		        		}
		        	}
		        });
			}
			if(userMail.length>=29){
				$('#memberEmailInsertMSG').text('이메일 주소는 30글자 이하로 입력해주세요 ^^');
				$(this).val(userMail.substring(0,29));
			}
		});
		//쌍둥이 이름 수정 시 발동되는 메서드
		$('.babyName').click(function(){
			if($(this).attr("readonly")){
				$('#addTwins').modal('show');
			}
		});
		$('.BlliBaby1Gender').click(function(){
			if($(this).children(':input[name="BlliBabyVO[0].babySex"]').val()=='쌍둥이'){
				selectBabyNum = 0;
				$('#addTwins').modal();
			}
		})
		$('.BlliBaby2Gender').click(function(){
			if($(this).children(':input[name="BlliBabyVO[1].babySex"]').val()=='쌍둥이'){
				selectBabyNum = 1;
				$('#addTwins').modal();
			}
		})
		$('.BlliBaby3Gender').click(function(){
			if($(this).children(':input[name="BlliBabyVO[2].babySex"]').val()=='쌍둥이'){
				selectBabyNum = 2;
				$('#addTwins').modal();
			}
		})
		//date-picker 키보드 이용 불능으로 만들기
		$('#datepicker1').on('keypress', function(e) {
					    e.preventDefault();
					    return false;
					});
					$('#datepicker2').on('keypress', function(e) {
					    e.preventDefault();
					});
					$('#datepicker3').on('keypress', function(e) {
					    e.preventDefault();
					});
	$('.babyBirthday').change(function(){
		var inputDate = $(this).val();
		var regExp = /^([0-9]{4})-([0-9]{2})-([0-9]{2})/g;
		
		if(inputDate.length!=10){
			$(this).val('');
		}else if(regExp.test(inputDate)){
		}else{
			$(this).val('');
		}
		
	});
		});
	function addInfoBg2(){
		$('.info_bg2').css('display','block');
		$('.info_bg2_before').css('display','none');
		return false;
	}
	function addInfoBg3(){
		if($('.info_bg2').css("display")=="none"){
			alert('2번째 아이 입력창부터 활성화 해주세요');
			return false;
		}else{
			$('.info_bg3').css('display','block');
			$('.info_bg3_before').css('display','none');
			return false;
		}
	}
	function cancelInfoBg2(){
		if($('.info_bg3').css("display")=="block"){
			alert('3번째 아이 입력창부터 비활성화 해주세요');
			return false;
		}
		$('.info_bg2').css('display','none');
		$('.info_bg2_before').css('display','block');
	}
	function cancelInfoBg3(){
		$('.info_bg3').css('display','none');
		$('.info_bg3_before').css('display','block');
	}
	
	function insertBabyInfo(){
		//첫번째 아이만 등록하는 경우
		if($('.info_bg2').css('display')=='none'){
			checkBabyInfo(1);			
		}else if($('.info_bg2').css('display')=='block'){
			//두번째 아이까지 등록하는 경우
			if($('.info_bg3').css('display')=='none'){
				checkBabyInfo(2);	
			}else{
				//세번째 아이까지 등록하는 경우
				checkBabyInfo(3);	
			}
		}
	}
	
	function sendChildValue(){
		var twinsName="";
		var duplicateTwins = false;
		for(var i=0;i<$('.twinsName').size();i++){
			if(i==0){
				if($($('.twinsName').get(1)).val()!=""){
					twinsName = $($('.twinsName').get(0)).val();
				}
			}else{
				if($($('.twinsName').get(i)).val()!=""){
					if($($('.twinsName').get(i)).val()==$($('.twinsName').get(i-1)).val()){
						duplicateTwins = true;
					}else{
						twinsName += "&"+ $($('.twinsName').get(i)).val();
					}
				}
			}
			if(i==2){
				if($($('.twinsName').get(0)).val()==$($('.twinsName').get(2)).val()){
					duplicateTwins = true;
				}
			}
		}
		if(duplicateTwins&&twinsName!=""){
			alert('이름이 중복됩니다.');
			$('.twinsName').val('');
			twinsName = "";
			return false;
		}
		if(twinsName!=""){
			$(':input[name="BlliBabyVO['+selectBabyNum+'].babyName"]').val(twinsName);
			$(':input[name="BlliBabyVO['+selectBabyNum+'].babyName"]').attr("readonly",true);
		}else{
			cancelTwinInsert();
		}
		$('#addTwins').modal('hide');
	}
	
	function cancelTwinInsert(){
		$(':input[name="BlliBabyVO['+selectBabyNum+'].babyName"]').attr("readonly",false);
		$(':input[name="BlliBabyVO['+selectBabyNum+'].babySex"]').eq(2).radio('uncheck');
		$(':input[name="BlliBabyVO['+selectBabyNum+'].babySex"]').eq(0).radio('check');
		$(':input[name="BlliBabyVO['+selectBabyNum+'].babyName"]').val("");
		$('#addTwins').modal('hide');
	}
	
	
	
	function checkBabyInfo(targetAmount){
		var flag = false;
		//이메일 유효성 검증 실패
		if(!emailValidity){
			alert('이메일을 확인해주세요');
			$(':input[name="memberEmail"]').focus();
			return false;
		}
		flag = checkFirstBabyInfo(targetAmount);
		$(':input[name="targetAmount"]').val(targetAmount);
		submitBabyInfo(flag);
		
		function checkFirstBabyInfo(targetAmount){
			for(var i=0;i<targetAmount;i++){
				if($(':input[name="BlliBabyVO['+i+'].babyName"]').val()==""){
					alert((i+1)+'번째 아이의 이름을 입력해주세요!');
					$(':input[name="firstBabyName"]').focus();
					return false;
				}else if($(':input[name="BlliBabyVO['+i+'].babyBirthday"]').val()==""){
					alert((i+1)+'번째 아이의 생일을 입력해주세요!');
					$(':input[name="firstBabyBirthday"]').focus();
					return false;
				}
				if(targetAmount>=2){
					for(var j=targetAmount-1;j>0;j--){
						if($(':input[name="BlliBabyVO['+i+'].babyName"]').val()==$(':input[name="BlliBabyVO['+j+'].babyName"]').val()){
							if(i==j){
								
							}else{
								alert('아이의 이름이 중복됩니다. 확인 부탁드려요!');
								$(':input[name="BlliBabyVO['+j+'].babyName"]').val('');
								$(':input[name="BlliBabyVO['+j+'].babyName"]').focus();
								return false;
							}
						};
					}
				}
			}
			return true;
		}
	}
	function submitBabyInfo(flag){
		if(flag){
			document.getElementById("babyInfoForm").submit();
		}
	}
	$(function() {
		$( "#datepicker1" ).datepicker({ minDate: -1095, maxDate: "+10M", changeMonth: true,
		changeYear: true , dateFormat: "yy-mm-dd" });
		  });
		$(function() {
		    $( "#datepicker2" ).datepicker({ minDate: -1095, maxDate: "+10M", changeMonth: true,
		        changeYear: true , dateFormat: "yy-mm-dd" });
		  });
		$(function() {
		    $( "#datepicker3" ).datepicker({ minDate: -1095, maxDate: "10M", changeMonth: true,
		        changeYear: true , dateFormat: "yy-mm-dd" });
		  });
</script>

<body>

		 <div class="register-background" style="background-image: url('${initParam.root}img/modifyBg.jpg"> 
            	<div class="filter-black"></div>
                	<div class="container">
                    	<div class="row" style="margin-top: 6%;">
			                <form class="register-form" action="updateBabyInfo.do" method="post" id="babyInfoForm" method="post" name="babyInfoInsertForm" enctype="multipart/form-data">
                    		<c:forEach end="2" var="blliBabyList" varStatus="i" items="${requestScope.blliMemberVO.blliBabyVOList}">
                    			<c:choose>
                    				<c:when test="${blliBabyList!=null}">
                    					<div class="col-md-4 info_bg${i.index+1}" style="height: 450px; display: block">
			                            	<div class="register-card" style="margin-bottom:20px">
			                                	<h3 class="title">${i.index+1} 번째 아이 정보입력</h3>
												<div class="email_bg" style="top: 15%; display : none;">
													이메일 주소 <input type="text" name="memberEmail" placeholder="Email 주소" value="${sessionScope.blliMemberVO.memberEmail}">
												</div>
					                        	<div style="height: 108px">
			        			                	<div class="fl">
					                        		<label>
			        			                		<input type="file" class="babyPhoto" name="BlliBabyVO[${i.index}].babyPhoto" id="babyPhotoInput${i.index}" 
			        			                		style="display: none;" accept="image/*" onchange="setUpdateBabyPhotoNum(${i.index})">
				                			            <c:if test="${blliBabyList.babyPhoto ne 'default'}">
				                			           	 <img src="${initParam.root}babyphoto/${blliBabyList.babyPhoto}" alt="Thumbnail Image" 
				                			            class="img-thumbnail img-responsive" id="babyPhoto${i.index}" style="height: 100px;width: 100px;">
														</c:if>
														<c:if test="${blliBabyList.babyPhoto eq 'default'}">
				                			           	 <img src="${initParam.root}img/baby_foto.jpg" alt="Thumbnail Image" 
				                			            class="img-thumbnail img-responsive" id="babyPhoto${i.index}" style="height: 100px;width: 100px;">
														</c:if>
			                        				</label>
			                        				</div>
			                        				<div class="fl" style="margin-left: 20px">
			                        					
				                         				<label class="radio checked BlliBaby${i.index+1}Gender">
				                            			<span class="icons">
				                            				<span class="first-icon fa fa-circle-o fa-base"></span>
				                            				<span class="second-icon fa fa-dot-circle-o fa-base"></span>
				                            			</span>
				                            			<input name="BlliBabyVO[${i.index}].babySex" type="radio" value="남자" data-toggle="radio">
				                            			<i></i>남자
				                          				</label>
				                          				<label class="radio BlliBaby${i.index+1}Gender">
							                            <span class="icons">
								                            <span class="first-icon fa fa-circle-o fa-base"></span>
								                            <span class="second-icon fa fa-dot-circle-o fa-base"></span>
							                            </span>
							                            <input name="BlliBabyVO[${i.index}].babySex" type="radio" value="여자" data-toggle="radio">
							                            <i></i>여자
							                         	</label>
							                          	<label class="radio BlliBaby${i.index+1}Gender">
							                            <span class="icons">
							                          		<span class="first-icon fa fa-circle-o fa-base"></span>
								                            <span class="second-icon fa fa-dot-circle-o fa-base"></span>
								                        </span>
							                            <input name="BlliBabyVO[${i.index}].babySex" type="radio" value="쌍둥이" data-toggle="radio">
							                            <i></i>쌍둥이
							                         	</label>
			                           				</div>
			                      		  		</div> 
					                      		<div style="text-align: left ;height: 150px;">
					                      			<label>아이 이름</label>
					                                <input type="text" class="form-control babyName" name="BlliBabyVO[${i.index}].babyName" placeholder="이름" value="${blliBabyList.babyName}">
					                                <div class="alertDiv" id="memberIdInsertMSG"></div>
					                                <label>아이 생일</label>
					                                <input type="text" class="form-control babyBirthday" style="background: white; cursor: pointer;"
					                                id="datepicker${i.index+1}" name="BlliBabyVO[${i.index}].babyBirthday" readonly="readonly" value="${blliBabyList.babyBirthday}">
					                                <div class="alertDiv" id="memberIdInsertMSG"></div>
					                      		</div>
			                        		</div>
			                            </div>
										<c:set value="${i.index}" var="babyNum"/>
                    				</c:when>
                    			</c:choose>
                    		</c:forEach>
			                            <c:forEach begin="${babyNum+1}" end="${2-babyNum}" step="1" varStatus="i">
			                            <div class="col-md-4 info_bg${i.index+1}" style="height: 450px;">
			                            	<div class="register-card" style="margin-bottom:20px">
							                <span class="fr" style="margin-top: -20px;margin-right: -15px;">
				                            <a href="#" onclick="cancelInfoBg2()">
				                            	<i class="fa fa-times"></i>
				                            	</a>
				                            </span>
			                                	<h3 class="title">${i.index+1} 번째 아이 정보입력</h3>
			                               		<form class="register-form" action="insertBabyInfo.do" method="post" id="babyInfoForm" method="post" name="babyInfoInsertForm" enctype="multipart/form-data">
												<div class="email_bg" style="top: 15%; display : none;">
												</div>
					                        	<div style="height: 108px">
			        			                	<div class="fl">
					                        		<label>
			        			                		<input type="file" class="babyPhoto" name="BlliBabyVO[${i.index}].babyPhoto" id="babyPhotoInput0" 
			        			                		style="display: none;" accept="image/*" onchange="setUpdateBabyPhotoNum(${i.index})">
				                			            <img src="${initParam.root}babyphooto/${babyList.babyPhoto}" alt="Thumbnail Image" 
				                			            class="img-thumbnail img-responsive" id="babyPhoto${i.index}" style="height: 100px;width: 100px;">
			                        				</label>
			                        				</div>
			                        				<div class="fl" style="margin-left: 20px">
			                        					
				                         				<label class="radio checked BlliBaby${i.index+1}Gender">
				                            			<span class="icons">
				                            				<span class="first-icon fa fa-circle-o fa-base"></span>
				                            				<span class="second-icon fa fa-dot-circle-o fa-base"></span>
				                            			</span>
				                            			<input name="BlliBabyVO[${i.index}].babySex" type="radio" value="남자" data-toggle="radio">
				                            			<i></i>남자
				                          				</label>
				                          				<label class="radio BlliBaby${i.index+1}Gender">
							                            <span class="icons">
								                            <span class="first-icon fa fa-circle-o fa-base"></span>
								                            <span class="second-icon fa fa-dot-circle-o fa-base"></span>
							                            </span>
							                            <input name="BlliBabyVO[${i.index}].babySex" type="radio" value="여자" data-toggle="radio">
							                            <i></i>여자
							                         	</label>
							                          	<label class="radio BlliBaby${i.index+1}Gender">
							                            <span class="icons">
							                          		<span class="first-icon fa fa-circle-o fa-base"></span>
								                            <span class="second-icon fa fa-dot-circle-o fa-base"></span>
								                        </span>
							                            <input name="BlliBabyVO[${i.index}].babySex" type="radio" value="쌍둥이" data-toggle="radio">
							                            <i></i>쌍둥이
							                         	</label>
			                           				</div>
			                      		  		</div> 
					                      		<div style="text-align: left ;height: 150px;">
					                      			<label>아이 이름</label>
					                                <input type="text" class="form-control babyName" name="BlliBabyVO[${i.index}].babyName" placeholder="이름" value="${babyList.babyName}">
					                                <div class="alertDiv" id="memberIdInsertMSG"></div>
					                                <label>아이 생일</label>
					                                <input type="text" class="form-control babyBirthday" style="background: white; cursor: pointer;"
					                                id="datepicker${i.index+1}" name="BlliBabyVO[${i.index}].babyBirthday" readonly="readonly" value="${babyList.babyBirthday}">
					                                <div class="alertDiv" id="memberIdInsertMSG"></div>
					                      		</div>
			                        		</div>
			                            </div>
                    					<div class="col-md-4 info_bg${i.index+1}_before" style="height: 450px;" >
			                            <div class="register-card" style="margin-bottom:20px height:400px; width:350px;background-color: rgba(255,255,255,0.5);">
			                            	<a class="btn btn-fill btn-warning" onclick="addInfoBg${i.index+1}()" style="margin-top: 50%;margin-left: 40%; width: 66px;">
			                            	<i class="fa fa-plus fa-3x" style="margin-left: -13px;margin-top: 2px"></i>
			                            	</a>
			                       		 </div>
                            			</div>
			                            </c:forEach>
                        	
                        
                            
                        		<div class="col-md-4 col-md-offset-4 col-sm-6 col-sm-offset-3 col-xs-10 col-xs-offset-1">
                                <a class="btn btn-fill btn-success btn-block" onclick="insertBabyInfo()" style="margin-top:30px;">등록</a>
                                <div class="forgot">
                                </div>
                                </div>
                  			</div>
                </div>     
              
            <div class="footer register-footer text-center" style="margin-top: 50px">
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

	<div class="modal fade" id="addTwins" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">쌍둥이들 정보를 입력해주세요!</h4>
				</div>
				<div class="modal-body">
					
					<div style="text-align: left; height: 250px;">
						<label>첫째 이름</label> <input type="text"
							class="form-control twinsName" placeholder="이름"
							style="margin-bottom: 20px">
							 <label>둘째 이름</label> <input
							type="text" class="form-control twinsName" placeholder="이름"
							style="margin-bottom: 20px"> 
							<label>셋째 이름</label> 
							<input
							type="text" class="form-control twinsName" placeholder="이름"
							style="margin-bottom: 20px">
					</div>
					<%-- <a href="#" onclick="sendChildValue()"><img src="${initParam.root}img/info_bt1.png" style="padding-top: 20px; width: 200px; height:40px; margin-left: 85px;"></a> --%>
				</div>
				<div class="modal-footer">
					<div class="left-side">
						<button type="button" class="btn btn-default btn-simple"
							onclick="cancelTwinInsert()">입력 취소</button>
					</div>
					<div class="divider"></div>
					<div class="right-side">
						<a type="button" class="btn btn-danger btn-simple" onclick="sendChildValue()">입력 완료</a>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<input type="text" name="targetAmount" style="display: none">
	<input type="text" name="memberId" style="display: none" value="${sessionScope.blliMemberVO.memberId}">
  </form>