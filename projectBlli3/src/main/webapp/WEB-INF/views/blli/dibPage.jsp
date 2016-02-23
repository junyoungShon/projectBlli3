<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<style>
.detail_list th {
	background-color: #FD9595; 
	border-top: 2px solid red;
}
</style>
<!-- bxSlider Javascript file -->
<script src="${initParam.root}js/jquery.bxslider.min.js"></script>
<!-- bxSlider CSS file -->
<link href="${initParam.root}css/jquery.bxslider.css" rel="stylesheet" />
<script>
$(document).ready(function(){
	$('.slider').bxSlider({
	    mode: 'vertical',
	    slideWidth: 145,
	    minSlides: 3,
	    slideMargin: 10
	});
});
</script>
	<c:forEach items="${requestScope.smallProductList}" var="smallProductInfo" varStatus="index">
	<c:if test="${index.count%2 == 0}">
	<div style="width: 100%; height: 575px; background-color: honeydew;">
	</c:if>
	<c:if test="${index.count%2 != 0}">
	<div style="width: 100%; height: 575px;">
	</c:if>
	<div style="width: 1030px; margin: auto; height: 575px;">
	<div class="slider" style="float: left;">
		<c:forEach items="${smallProductInfo.postingList}" var="postingList">
			<div class="slide">
				<a href=""><img src="${postingList.postingPhotoLink}"></a>
			</div>
		</c:forEach>
	</div>
		<div class="in_fr" style="height:575px; display: inline-block; width: 395px;">
			<div class="result_con" style="width: 330px;">
				<div class="result_ti" style="width: 345px;">
					${smallProductInfo.smallProduct} 
				</div>
				<div>
					<div class="result_foto fl">
						<img src="${smallProductInfo.smallProductMainPhotoLink}" alt="${smallProductInfo.smallProduct}" style="width: 100%; height: 100%; vertical-align: middle;">
						<div class="product_month">
							${smallProductInfo.smallProductWhenToUseMin}~${smallProductInfo.smallProductWhenToUseMax}<br/>
							개월
						</div>
					</div>
				</div>
			</div>
			<div class="fl">
				<div class="product_text" style="height: 150px; width: 340px; overflow-y: hidden;">
					하은맘 프라임 샴푸 의자 이젠 32개월 모야 안고 머리감기는 일 너무 힘들어요~ 무게도 덩치도
					발육이 남다른 모야 ~ 구상도를보면 참 많은 생각을 하시고 제작하신것 같아요
				</div>
				<div class="product_price" style="width: 360px;">
					<div class="fl" style="width: 60px; display: inline-block;">
						<p class="result_gray">최저가</p>
						<p class="result_price">${smallProductInfo.minPrice}원</p>
					</div>
					<div style="width: 30px; display: inline-block;">
						<p class="result_sns" style="font-size: 15px;">${smallProductInfo.dbInsertPostingCount}</p>
						<p class="result_sns_text" style="font-size: 5px;">blog</p>
					</div>
					<div style="width: 30px; display: inline-block;">
						<p class="result_sns" style="font-size: 15px;">${smallProductInfo.smallProductScore}</p>
						<p class="result_sns_text" style="font-size: 5px;">Point</p>
					</div>
					<div class="fr" style="width: 40px; height: 40px; display: inline-block;">
						<div style="margin-top: 3px;" class="smallProductDibBtn" data-tooltip-text="찜해두시면 스크랩페이지에서 다시 보실 수 있어요!">
							<c:if test="${smallProductInfo.isDib==0}">
								<i class="fa fa-heart-o fa-2x" style="color: red"></i>
							</c:if>
							<c:if test="${smallProductInfo.isDib==1}">
								<i class="fa fa-heart fa-2x" style="color: red"></i>
							</c:if>
								<span style="font-size: 15px ;color: gray;" class="dibsCount">${smallProductInfo.smallProductDibsCount}</span>
								<input type="hidden" value="${smallProductInfo.smallProductId}" class="smallProductId">
						</div>
					</div>
					<div class="result_last fr" style="width: 150px; margin-top: 4px;">
						<div style="text-align:center;">
						<!-- 페이스북 공유 -->
								<div id="fb-root"></div>
							    <script src='http://connect.facebook.net/en_US/all.js'></script>
							     <script src="https://developers.kakao.com/sdk/js/kakao.story.min.js"></script>
			<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
			<script src="/js/kakaolink.js"></script>
							    <!-- 공유끝 -->
						<a onclick='postToFeed(); return false;' style="cursor: pointer;"><img src="${initParam.root}img/fbShareBtn.png" alt="페이스북 공유하기"></a>
						<a style="cursor:pointer;" id='kakao-login-btn' 
						onclick="kakaolink_send('블리!', 'http://bllidev.dev/blli/goSmallProductDetailView.do?smallProduct=${smallProductInfo.smallProduct}');" >
						<img src="${initParam.root}img/kakaoShareBtn.png" alt="카스 공유하기"></a>
						
						</div>
						<script> 
						      FB.init({appId: "476938162497817", status: true, cookie: true});
						  	
						      function postToFeed() {
						        var obj = {
						          method: 'feed',
						          redirect_uri:"http://bllidev.dev/blli/goSmallProductDetailView.do?smallProduct=${smallProductInfo.smallProduct}",
						          link: "http://bllidev.dev/blli/goSmallProductDetailView.do?smallProduct=${smallProductInfo.smallProduct}",
						          picture: 'http://bllidev.dev/blli/scrawlImage/smallProduct/${smallProductInfo.smallProductMainPhotoLink}',
						          name: '충동구매보다 빠른 합리적 소비!',
						          caption: '블리가 추천하는 유아용품! 포스팅과 함께 확인하세요',
						          description: '블리가 추천하는 유아용품! 광고없는 !! 포스팅과 함께 확인하세요'
						        };
						 
						        function callback(response) {
									snsShareCountUp();
						        }
						        FB.ui(obj, callback);
						      }
						  	 // 사용할 앱의 JavaScript 키를 설정해 주세요.
						      Kakao.init('7e613c0241d9f07553638f04b7df66ef');
						
						      function kakaolink_send(text, targetURL){
						    	var n = "http://bllidev.dev/blli/goSmallProductDetailView.do?smallProduct=".length;
						    	var koreanWord = targetURL.substring(n,targetURL.length);
						    	var url = targetURL.substring(0,n)+encodeURIComponent(koreanWord);
						    	alert("koreanWord:"+koreanWord);
						    	alert("url:"+url);
						      	Kakao.Auth.login({
						      		success: function(authObj) {
						      			 Kakao.API.request( {
						      				 url : '/v1/api/story/linkinfo',
						      				 data : {
						      				   url : url
						      				 }
						      			   }).then(function(res) {
						      				 // 이전 API 호출이 성공한 경우 다음 API를 호출합니다.
						      				 return Kakao.API.request( {
						      				   url : '/v1/api/story/post/link',
						      				   data : {
						      					 link_info : res
						      				   }
						      				 });
						      			   }).then(function(res) {
						      				 return Kakao.API.request( {
						      				   url : '/v1/api/story/mystory',
						      				   data : { id : res.id }
						      				 });
						      			   }).then(function(res) {
						      				 snsShareCountUp();
						      			   }, function (err) {
						      				 alert(JSON.stringify(err));
						      			   });
						      		}
						      	});
						      }
						     function snsShareCountUp(){
						    	 alert('${smallProductInfo.smallProduct}');
						    	 $.ajax({
										type:"get",
										url:"snsShareCountUp.do?smallProductId=${smallProductInfo.smallProductId}",
										success:function(){
											
									}
								}); 
						     }
					</script>
					</div>
				</div>
			</div>
		</div>
		
		<div class="in_fr" style="clear:both; display: inline-block; width: 450px; height: 575px;">
				<div class="detail_list fl" style="width: 410px; height: 247.5px;">
					<div class="result_ti">
						쇼핑몰 리스트 
					</div>
					<div style="overflow-y:auto; height: 207.5px;">
						<table>
							<colgroup>
								<col width="20%">
								<col width="20%">
								<col width="20%">
								<col width="20%">
								<col width="20%">
							</colgroup>
							<tr>
								<th>
									쇼핑몰
								</th>
								<th>
									판매가
								</th>
								<th>
									배송비
								</th>
								<th>
									부가정보
								</th>
								<th>
									사러가기
								</th>
							</tr>
							<c:forEach items="${smallProductInfo.blliSmallProductBuyLinkVOList}" var="sellerInfo">
								<tr>
									<td>
										${sellerInfo.seller}
									</td>
									<td>
										${sellerInfo.buyLinkPrice}원
									</td>
									<td>
										${sellerInfo.buyLinkDeliveryCost}
									</td>
									<td>
										<c:if test="${sellerInfo.buyLinkOption == null}">
											없음
										</c:if>
										<c:if test="${sellerInfo.buyLinkOption != null}">
											${sellerInfo.buyLinkOption}
										</c:if>
									</td>
									<td>
										<a href="#" onclick="goBuyMidPage()"><img src="${initParam.root}img/bt_buy.png" alt="사러가기"></a>
										<form action="goBuyMidPage.do" method="post" id="smallProductLinkInfo">
											<input type="hidden" name="buyLink" value="${sellerInfo.buyLink}"> 
											<input type="hidden" name="smallProductId" value="${sellerInfo.smallProductId}"> 
											<input type="hidden" name="memberId" value="${sessionScope.blliMemberVO.memberId}"> 
											<input type="hidden" name="seller" value="${sellerInfo.seller}"> 
										</form>
									</td>
								</tr>
							</c:forEach>
						</table>
					</div>
				</div>
				
				<div class="detail_list fr" style="width: 410px; height: 247.5px;">
					<div class="result_ti">
						동일 제품점수별로 보기
					</div>
					<div style="overflow-y:auto; height: 207.5px;">
						<table id="otherProductInfo">
							<colgroup>
								<col width="10%">
								<col width="50%">
								<col width="20%">
								<col width="20%">
							</colgroup>
							<tr>
								<th>
									순위
								</th>
								<th>
									제품명
								</th>
								<th>
									점수
								</th>
								<th>
									보러가기
								</th>
							</tr>
							<c:forEach items="${smallProductInfo.otherSmallProductList}" var="productList" varStatus="rank">
								<tr>
									<td>
										${rank.count}
									</td>
									<td>
										${productList.smallProduct}
									</td>
									<td>
										${productList.smallProductScore}
									</td>
									<td>
										<a href="${initParam.root}goSmallProductDetailView.do?smallProduct=${productList.smallProduct}"><img src="${initParam.root}img/bt_see.png" alt="보러가기"></a>
									</td>
								</tr>
							</c:forEach>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
	</c:forEach>
