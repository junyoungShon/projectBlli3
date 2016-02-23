package kr.co.blli.model.scheduler;

import java.io.IOException;
import java.net.SocketTimeoutException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Random;

import javax.annotation.Resource;

import kr.co.blli.model.posting.PostingDAO;
import kr.co.blli.model.product.ProductDAO;
import kr.co.blli.model.vo.BlliPostingVO;
import kr.co.blli.model.vo.BlliSmallProductVO;

import org.apache.log4j.Logger;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

//@Component
@Service
public class PostingScheduler {
	
	@Resource
	private ProductDAO productDAO;
	
	@Resource
	private PostingDAO postingDAO;
	
	/**
	 * 
	 * @Method Name : insertPosting
	 * @Method 설명 : 매일 오전 4시에 소제품 리스트 목록을 불러와 해당 소제품 관련 블로그 포스팅을 insert or update하는 메서드
	 * @작성일 : 2016. 1. 16.
	 * @작성자 : hyunseok
	 * @return
	 * @throws IOException
	 */
	@Scheduled(cron = "00 00 04 * * *")
	public void insertPosting() throws IOException {
		Random random = new Random();
		int r = random.nextInt(3000);
		try {
			System.setProperty("random", Integer.toString(r));
			Thread.sleep(r);
			if(Integer.parseInt(System.getProperty("random")) == r){
				long start = System.currentTimeMillis(); // 시작시간 
				Logger logger = Logger.getLogger(getClass());
				String methodName = new Throwable().getStackTrace()[0].getMethodName();
				logger.error("start : "+methodName);
				logger.error("요청자 : scheduler");
				Calendar cal = Calendar.getInstance();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd hh:mm:ss");
				String datetime = sdf.format(cal.getTime());
				logger.error("발생 일자 : "+datetime);
				
				String key = "6694c8294c8d04cdfe78262583a13052"; //네이버 검색API 이용하기 위해 발급받은 key값
				//소제품 리스트를 불러와 변수에 할당
				ArrayList<BlliSmallProductVO> smallProductList = (ArrayList<BlliSmallProductVO>)productDAO.getSmallProduct(); 
				String postingUrl = ""; //포스팅 주소
				String smallProduct = ""; //검색할 소제품
				String frameSourceUrl = ""; //프레임 소스 주소
				String postingTitle = ""; //포스팅 제목
				String postingContent = ""; //포스팅 본문
				int postingMediaCount = 0; //포스팅에 등록된 이미지 개수
				String postingPhotoLink = ""; //대표 사진 링크
				String postingAuthor = ""; //포스팅 작성자 닉네임
				String postingReplyCount = ""; //댓글 수
				ArrayList<String> regex = new BlliPostingVO().regex; //html에서 제거되야 할 태그와 특수문자들 리스트
				ArrayList<String> denyWord = new BlliPostingVO().denyWord;
				boolean denyFlag = false;
				int countOfPosting = 0;
				int insertPostingCount = 0;
				int updatePostingCount = 0;
				int notUpdatePostingCount = 0;
				int denyPostingCount = 0;
				int delayConnectionCount = 0;
				int deletePostingCount = 0;
				int updatePostingStatusToTemptdead = 0;
				int updateSmallProductStatusToConfirmedByAdmin = 0;
				int updatePostingStatusToConfirmed = 0;
				int preCountOfPosting = 0;
				int preInsertPostingCount = 0;
				int preUpdatePostingCount = 0;
				int preNotUpdatePostingCount = 0;
				int preDenyPostingCount = 0;
				int preDelayConnectionCount = 0;
				int preDeletePostingCount = 0;
				int preUpdatePostingStatusToTemptdead = 0;
				int preUpdateSmallProductStatusToConfirmedByAdmin = 0;
				int preUpdatePostingStatusToConfirmed = 0;
				int exceptionCount = 0;
				int allExceptionCount = 0;
				LinkedHashMap<String, String> detailException = new LinkedHashMap<String, String>();
				BlliPostingVO postingVO = null;
				long end = 0;
				Document doc = null;
				
				label:
				for(int i=0;i<smallProductList.size();i++){ //소제품들 한개씩 뽑아서 포스팅 검색
					double maxPosting = 50; //검색할 포스팅 최대 개수
					
					int postingRank = 0; //검색 순위
					smallProduct = smallProductList.get(i).getSmallProduct().replaceAll("&", "%26");
					int totalPosting = 0;
					
					doc = Jsoup.connect("http://openapi.naver.com/search?key="+key+"&query="+
									smallProduct+"&display=100&start=1&target=blog&sort=sim").timeout(0).get();
					if(doc.select("message").text().contains("Query limit exceeded")){
						key = "0a044dc7c63b8f3b9394e1a5e49db7ab";
						doc = Jsoup.connect("http://openapi.naver.com/search?key="+key+"&query="+
								smallProduct+"&display=100&start=1&target=blog&sort=sim").timeout(0).get();
						if(doc.select("message").text().contains("Query limit exceeded")){
							key = "2a636a785d0e03f7048319f8adb3d912";
							doc = Jsoup.connect("http://openapi.naver.com/search?key="+key+"&query="+
									smallProduct+"&display=100&start=1&target=blog&sort=sim").timeout(0).get();
						}
					}
					if(doc.select("message").text().contains("Query limit exceeded")){
						break label;
					}
					//소제품 관련 총 포스팅 개수
					String totalPostingText = doc.select("total").text().trim();
					if(totalPostingText.equals("")){
						totalPostingText = "0";
					}
					totalPosting = Integer.parseInt(totalPostingText);
					if(Math.ceil(totalPosting*0.3) < maxPosting){ //총 포스팅 개수의 30%가 50개 미만일 경우 
																	 //포스팅 최대 개수를 총 포스팅의 30%로 설정
						maxPosting = Math.ceil(totalPosting*0.3);
					}
					String smallProductId = smallProductList.get(i).getSmallProductId();
					Elements postingList = doc.select("item"); //포스팅 간략 정보
					int count = 0;
					boolean flag = true;
					while(flag){
						try{
							for(int k=count;k<postingList.size();k++){
								if(exceptionCount > 3){
									count = k+1;
									exceptionCount = 0;
								}else{
									count = k;
								}
								preCountOfPosting = countOfPosting;
								preInsertPostingCount = insertPostingCount;
								preUpdatePostingCount = updatePostingCount;
								preNotUpdatePostingCount = notUpdatePostingCount;
								preDenyPostingCount = denyPostingCount;
								preDelayConnectionCount = delayConnectionCount;
								preDeletePostingCount = deletePostingCount;
								preUpdatePostingStatusToTemptdead = updatePostingStatusToTemptdead;
								preUpdateSmallProductStatusToConfirmedByAdmin = updateSmallProductStatusToConfirmedByAdmin;
								preUpdatePostingStatusToConfirmed = updatePostingStatusToConfirmed;
								Element postingInfo = postingList.get(k);
								postingVO = new BlliPostingVO();
								if(postingRank > maxPosting){
									break;
								}
								postingRank++;
								
								postingTitle = postingInfo.select("title").text();
								for(int j=0;j<regex.size();j++){ //태그 및 특수문자 제거
									postingTitle = postingTitle.replaceAll(regex.get(j), "");
								}
								String bloggerLink = postingInfo.select("bloggerlink").text();
								postingUrl = bloggerLink;
								//네이버 블로그 포스팅이 아닐 경우 
								//countOfPosting을 한개 늘려주고 while문 처음으로 이동(네이버 블로그가 아닐 경우 DB에 저장X)
								if(!bloggerLink.contains("http://blog.naver.com")){ 
									denyPostingCount++;
									continue;
								}
								postingVO.setPostingTitle(postingTitle); //postingTitle을 vo에 저장
								postingVO.setPostingUrl(bloggerLink+"/");
								postingVO.setSmallProductId(smallProductId); //소제품ID를 vo에 저장
								String postingStatus = postingDAO.getPostingStatus(postingVO);
								
								if(postingStatus == null){ //insert
									try{
										//openAPI를 통해 얻은 포스팅URL 연결
										doc = Jsoup.connect(postingInfo.select("link").html()).timeout(1000).get(); 
										//frameSourceURL 불러와 설정
										frameSourceUrl = "http://blog.naver.com" + doc.select("#mainFrame").attr("src"); 
										doc = Jsoup.connect(frameSourceUrl).timeout(1000).get();
									}catch(SocketTimeoutException exception){
										delayConnectionCount++;
										continue;
									}
									if(doc.select("#post-area script").html().contains("삭제되었거나 존재하지 않는 게시물입니다")){
										denyPostingCount++;
										continue;
									}
									if(doc.select("#post-area script").html().contains("비공개 포스트 입니다")){
										denyPostingCount++;
										continue;
									}
									
									Elements metaInfo = doc.select("meta");
									for(Element el : metaInfo){
										String property = el.attr("property"); //meta정보
										if(property.contains("url")){ 
											postingUrl = el.attr("content"); 
											postingVO.setPostingUrl(postingUrl); //postingURL을 vo에 저장
										}else if(property.contains("image")){
											postingPhotoLink = el.attr("content");
											postingVO.setPostingPhotoLink(postingPhotoLink); //postingPhotoLink를 vo에 저장
										}else if(property.contains("author")){
											postingAuthor = el.attr("content");
											//포스팅 작성자를 vo에 저장
											postingVO.setPostingAuthor(postingAuthor.substring(postingAuthor.lastIndexOf("|")+2)); 
										}
									}
									//본문에 등록된 이미지가 없을 시 포스팅 개수 한개 줄이고 while문 처음으로 이동
									//(이미지가 없을 시 네이버 기본 이미지가 들어가 있음)
									if(postingPhotoLink.equals("http://blogimgs.naver.net/nblog/mylog/post/og_default_image2.png")){
										denyPostingCount++;
										continue;
									}
									
									Elements imgInfo = doc.select("#postViewArea img");
									ArrayList<String> mediaList = new ArrayList<String>();
									if(imgInfo.size() != 0){ //스마트에디터가 아닐 경우
										//이미지 개수
										for(Element el : imgInfo){
											String src = el.attr("src");
											if(src.contains("postfiles") || src.contains("blogfiles")){
												for(int j=0;j<mediaList.size();j++){
													if(!mediaList.contains(src)){
														mediaList.add(src);
														postingMediaCount++;
													}
												}
												if(mediaList.size() == 0){
													mediaList.add(src);
													postingMediaCount++;
												}
											}
										}
										//영상 개수
										Elements playerInfo = doc.select("#postViewArea iframe");
										for(Element el : playerInfo){
											String mediaName = el.attr("name");
											if(mediaName.equals("mplayer")){
												postingMediaCount++;
											}
										}
									}else{ //스마트에디터일 경우
										//이미지 개수
										imgInfo = doc.select("#printPost1 tbody a");
										for(Element el : imgInfo){
											String imgType = el.attr("data-linktype");
											if(imgType.equals("img")){
												String src = el.select("img").attr("src");
												for(int j=0;j<mediaList.size();j++){
													if(!mediaList.contains(src)){
														mediaList.add(src);
														postingMediaCount++;
													}
												}
												if(mediaList.size() == 0){
													mediaList.add(src);
													postingMediaCount++;
												}
											}
										}
										//영상 개수
										Elements playerInfo = doc.select("#printPost1 tbody div");
										for(Element el : playerInfo){
											if(el.attr("class").equals("se_mediaArea")){
												postingMediaCount++;
											}
										}
									}
									if(postingMediaCount == 0){ //이미지와 영상의 개수가 0개일때 제거
										denyPostingCount++;
										continue;
									}
									postingVO.setPostingMediaCount(postingMediaCount); //이미지와 영상의 개수를 vo에 저장
									
									if(doc.select("#postViewArea").size() != 0){ //스마트에디터가 아닐 경우
										postingContent = doc.select("#postViewArea").html();
										for(int j=0;j<regex.size();j++){ //태그 및 특수문자 제거
											postingContent = postingContent.replaceAll(regex.get(j), "");
										}
										postingContent = postingContent.replaceAll("( )+", " ").trim(); //공란을 한칸으로 변경 및 앞 뒤 공란 제거
									}else{ //스마트에디터일 경우
										postingContent = ""; //본문 초기화
										Elements contentTag = doc.select("#printPost1 tbody p");
										for(Element el : contentTag){
											if(el.attr("class").equals("se_textarea")){ //본문 내용 누적
												postingContent += el.html();
											}
										}
										for(int j=0;j<regex.size();j++){ //태그 및 특수문자 제거
											postingContent = postingContent.replaceAll(regex.get(j), "");
										}
										postingContent = postingContent.replaceAll("( )+", " ").trim(); //공란을 한칸으로 변경 및 앞 뒤 공란 제거
									}
									
									if(postingContent.length() == 0){ //본문 내용이 없으면 제거
										denyPostingCount++;
										continue;
									}
									for(int j=0;j<denyWord.size();j++){
										if(postingContent.contains(denyWord.get(j))){
											denyPostingCount++;
											denyFlag = true;
											break;
										}
									}
									if(denyFlag){
										denyFlag = false;
										continue;
									}
									
									postingVO.setPostingContent(postingContent); //본문을 vo에 저장
									
									if(postingContent.length() > 200){ //본문 길이 검사 후 본문 요약 vo에 저장
										postingVO.setPostingSummary(postingContent.substring(0,180) + "...");
									}else{
										postingVO.setPostingSummary(postingContent);
									}
									
									postingMediaCount = 0; //이미지 갯수 초기화
									postingVO.setSmallProduct(smallProduct.replaceAll("%26", "&")); //소제품을 vo에 저장
									postingVO.setPostingRank(postingRank); //포스팅 검색시 배열 순서(검색 순위)를 vo에 저장
									
									Elements reply = doc.select(".postre .pcol2");
									for(Element el : reply){
										if(el.attr("class").contains("pcol2 _cmtList _param")){
											postingReplyCount = el.text().substring(el.text().lastIndexOf(" ")+1);
											if(postingReplyCount.equals("쓰기")){
												postingReplyCount = "0";
											}
											postingVO.setPostingReplyCount(Integer.parseInt(postingReplyCount)); //댓글 수를 vo에 저장
										}
									}
									
									Elements postingDate = doc.select(".post-top tbody tr .date");
									if(postingDate.size() == 0){ //스마트에디터일 경우
										postingVO.setPostingDate(doc.select(".se_publishDate").text().
												substring(0, doc.select(".se_publishDate").text().lastIndexOf(".")));
									}else{ //스마트에디터가 아닐 경우
										if(postingDate.attr("class").equals("date fil5 pcol2 _postAddDate")){
											//포스팅 작성일을 vo에 저장
											postingVO.setPostingDate(postingDate.text().substring(0, postingDate.text().lastIndexOf("."))); 
										}
									}
									
									postingDAO.insertPosting(postingVO);
									insertPostingCount++;
									countOfPosting++;
									logger.warn(countOfPosting+" - "+smallProduct+" - "+postingUrl+" - insert");
								}else if(postingStatus.equals("confirmed")){ //update
									try{
										//openAPI를 통해 얻은 포스팅URL 연결
										doc = Jsoup.connect(postingInfo.select("link").html()).timeout(1000).get(); 
										//frameSourceURL 불러와 설정
										frameSourceUrl = "http://blog.naver.com" + doc.select("#mainFrame").attr("src"); 
										doc = Jsoup.connect(frameSourceUrl).timeout(1000).get();
									}catch(SocketTimeoutException exception){
										delayConnectionCount++;
										continue;
									}
									if(doc.select("#post-area script").html().contains("삭제되었거나 존재하지 않는 게시물입니다") || doc.select("#post-area script").html().contains("비공개 포스트 입니다")){
										postingDAO.deletePosting(postingVO); // 포스팅 삭제
										deletePostingCount++;
										postingDAO.insertPermanentDeadPosting(postingVO); // dead테이블에 삽입
										productDAO.subtractDbInsertPostingCount(smallProductId); // 해당 제품의 포스팅 개수 한개 감소
										countOfPosting++;
										logger.warn(countOfPosting+" - "+smallProduct+" - "+postingUrl+" - confirmed -> delete");
										continue;
									}
									postingVO.setPostingRank(postingRank); //포스팅 검색시 배열 순서(검색 순위)를 vo에 저장
									postingDAO.updatePosting(postingVO); // 포스팅 업데이트
									updatePostingCount++;
									countOfPosting++;
									logger.warn(countOfPosting+" - "+smallProduct+" - "+postingUrl+" - update");
								}else if(postingStatus.equals("temptdead")){
									postingDAO.updatePostingStatusToConfirmed(postingVO);
									productDAO.addDbInsertPostingCount(smallProductId);
									updatePostingStatusToConfirmed++;
									countOfPosting++;
									logger.warn(countOfPosting+" - "+smallProduct+" - "+postingUrl+" - temptdead -> confirmed");
								}else{ //아무 작업도 하지 않음
									notUpdatePostingCount++;
									countOfPosting++;
									logger.warn(countOfPosting+" - "+smallProduct+" - "+postingUrl+" - "+postingStatus);
								}
							} //for
							flag = false;
						}catch(Exception exception){
							exception.printStackTrace();
							if(preCountOfPosting != countOfPosting){
								countOfPosting--;
							}
							if(preInsertPostingCount != insertPostingCount){
								insertPostingCount--;
							}
							if(preUpdatePostingCount != updatePostingCount){
								updatePostingCount--;
							}
							if(preNotUpdatePostingCount != notUpdatePostingCount){
								notUpdatePostingCount--;
							}
							if(preDenyPostingCount != denyPostingCount){
								denyPostingCount--;
							}
							if(preDelayConnectionCount != delayConnectionCount){
								delayConnectionCount--;
							}
							if(preDeletePostingCount != deletePostingCount){
								deletePostingCount--;
							}
							if(preUpdatePostingStatusToTemptdead != updatePostingStatusToTemptdead){
								updatePostingStatusToTemptdead--;
							}
							if(preUpdateSmallProductStatusToConfirmedByAdmin != updateSmallProductStatusToConfirmedByAdmin){
								updateSmallProductStatusToConfirmedByAdmin--;
							}
							if(preUpdatePostingStatusToConfirmed != updatePostingStatusToConfirmed){
								updatePostingStatusToConfirmed--;
							}
							exceptionCount++;
							if(!detailException.containsKey(postingVO.getPostingUrl())){
								allExceptionCount++;
								detailException.put(postingVO.getPostingUrl(), exception.getMessage());
							}
						}
					}
					productDAO.updateSearchTime(smallProductId);
					postingVO.setSmallProductId(smallProductId);
					postingVO.setPostingRank((int)maxPosting);
					int updateResult = postingDAO.updatePostingStatusToTemptdead(postingVO);
					updatePostingStatusToTemptdead += updateResult;
					postingDAO.resetPostingUpdateColumn(smallProductId);
					HashMap<String, Object> map = new HashMap<String, Object>();
					map.put("smallProductId", smallProductId);
					map.put("subtractCount", updateResult);
					productDAO.subtractDbInsertPostingCountByTemptdead(map); // 해당 제품의 포스팅 개수를 포스팅 status가 temptdead로 변경된 숫자만큼 감소
					updateSmallProductStatusToConfirmedByAdmin += productDAO.updateSmallProductStatusToConfirmedByAdmin(smallProductId);
					end = System.currentTimeMillis();  //종료시간
					//종료-시작=실행시간		
					if((end-start)/1000.0 > 60*60){ //3시간을 초과하면 실행 중지
						break label;
					}
				} //for
				logger.error("총 소제품 개수 : "+smallProductList.size());
				logger.error("총 포스팅 개수 : "+countOfPosting);
				logger.error("insert한 포스팅 개수 : "+insertPostingCount);
				logger.error("update한 포스팅 개수 : "+updatePostingCount);
				logger.error("insert하지 않은 조건에 맞지 않는 포스팅 개수 : "+denyPostingCount);
				logger.error("update하지 않은 포스팅 개수 : "+notUpdatePostingCount);
				logger.error("시간지연되어 insert or update하지 않은 포스팅 개수 : "+delayConnectionCount);
				logger.error("삭제된 포스팅 개수 : "+deletePostingCount); // 추가
				logger.error("confirmed -> temptDead로 변경된 포스팅 개수 : "+updatePostingStatusToTemptdead); // 추가
				logger.error("confirmed -> confirmedByAdmin으로 변경된 소제품 개수 : "+updateSmallProductStatusToConfirmedByAdmin); // 추가
				logger.error("temptDead -> confirmed로 변경된 포스팅 개수 : "+updatePostingStatusToConfirmed); // 추가
				logger.error("Exception 발생 횟수 : "+allExceptionCount);
				Iterator<String> postingUrlList = detailException.keySet().iterator();
				while(postingUrlList.hasNext()){
					postingUrl = postingUrlList.next();
					logger.error("Exception이 발생한 postingUrl : "+postingUrl);
					logger.error("Exception 내용 : "+detailException.get(postingUrl));
				}
				end = System.currentTimeMillis();  //종료시간
				//종료-시작=실행시간		
				if((end-start)/1000 > 60*60){
					int hour = (int)Math.floor((((end-start)/1000.0)/60.0)/60);
					int minute = (int)Math.floor(((end-start)/1000.0)/60-hour*60);
					int second = (int)Math.ceil((end-start)/1000.0-minute*60);
					logger.error("실행 시간  : "+hour+"시간 "+minute+"분 "+second+"초");
				}else if((end-start)/1000 > 60){
					int minute = (int)Math.floor(((end-start)/1000.0)/60.0);
					int second = (int)Math.ceil((end-start)/1000.0-minute*60);
					logger.error("실행 시간  : "+minute+"분 "+second+"초");
				}else{
					logger.error("실행 시간  : "+(int)Math.ceil((end-start)/1000.0)+"초");
				}
				logger.error("end : "+methodName);
			} 
		}catch (InterruptedException e) {
			e.printStackTrace();
		}
	}
}
