package kr.co.blli.aop;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import javax.annotation.Resource;

import kr.co.blli.model.posting.PostingDAO;
import kr.co.blli.model.vo.BlliMemberScrapeVO;
import kr.co.blli.model.vo.BlliPostingDisLikeVO;
import kr.co.blli.model.vo.BlliPostingLikeVO;
import kr.co.blli.model.vo.BlliPostingVO;

import org.apache.log4j.Logger;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;

@Component
@Aspect
public class BlliAop {
	@Resource
	private PostingDAO postingDAO;
	@Around("within(kr.co.blli.*.*.*)")
	public Object checkScheduler(ProceedingJoinPoint point) throws Throwable{
		Logger logger = Logger.getLogger(getClass());
		Object retValue= null;
		try{
			retValue= point.proceed();
		}catch(Exception e){
			Calendar cal = Calendar.getInstance();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd hh:mm:ss");
			String datetime = sdf.format(cal.getTime());
			logger.error("발생한 에러:"+e.getMessage());
			logger.error("발생 메서드:"+point.getSignature().getName());
			logger.error("발생 일자 : "+datetime);
		}
		return retValue;
	}
	@Around("execution(public * kr.co.blli.model.posting.PostingService.searchPosting*(..))")
	public Object postingStatusChecker(ProceedingJoinPoint point) throws Throwable{
		Object retValue = point.proceed();
		Logger logger = Logger.getLogger(getClass());
		String memberId = (String) point.getArgs()[1];
		if(retValue instanceof List){
			//포스팅을 가져올 때 해당 회원이 포스팅을 스크램,좋아요,싫어요 했는지 여부를 파악해준다.
			BlliMemberScrapeVO blliMemberScrapVO = new BlliMemberScrapeVO();
			blliMemberScrapVO.setMemberId(memberId);
			BlliPostingLikeVO blliPostingLikeVO = new BlliPostingLikeVO();
			blliPostingLikeVO.setMemberId(memberId);
			BlliPostingDisLikeVO blliPostingDisLikeVO = new BlliPostingDisLikeVO();
			blliPostingDisLikeVO.setMemberId(memberId);
			for(int i=0;i<((List) retValue).size();i++){
				String smallProductId = ((List<BlliPostingVO>) retValue).get(i).getSmallProductId();
				String postingUrl = ((List<BlliPostingVO>) retValue).get(i).getPostingUrl();
				blliMemberScrapVO.setPostingUrl(postingUrl);
				blliMemberScrapVO.setSmallProductId(smallProductId);
				blliPostingLikeVO.setPostingUrl(postingUrl);
				blliPostingLikeVO.setSmallProductId(smallProductId);
				blliPostingDisLikeVO.setPostingUrl(postingUrl);
				blliPostingDisLikeVO.setSmallProductId(smallProductId);
				//스크랩 여부 판단.
				if(postingDAO.selectThisPostingScrape(blliMemberScrapVO)!=0)
					((BlliPostingVO) ((List) retValue).get(i)).setIsScrapped(1);
				else
					((BlliPostingVO) ((List) retValue).get(i)).setIsScrapped(0);
				//좋아요 여부판단
				if(postingDAO.selectThisPostingLike(blliPostingLikeVO)!=0)
					((BlliPostingVO) ((List) retValue).get(i)).setIsLike(1);
				else
					((BlliPostingVO) ((List) retValue).get(i)).setIsLike(0);
				//싫어요 여부판단
				if(postingDAO.selectThisPostingDisLike(blliPostingDisLikeVO)!=0)
					((BlliPostingVO) ((List) retValue).get(i)).setIsDisLike(1);
				else
					((BlliPostingVO) ((List) retValue).get(i)).setIsDisLike(0);
				System.out.println(((List) retValue).get(i));
			}
		}else{
			String postingUrl = ((BlliPostingVO)retValue).getPostingUrl();
			String smallProductId = ((BlliPostingVO)retValue).getSmallProductId();
			BlliMemberScrapeVO scrapeVO = new BlliMemberScrapeVO();
			scrapeVO.setMemberId(memberId);
			scrapeVO.setPostingUrl(postingUrl);
			scrapeVO.setSmallProductId(smallProductId);
			((BlliPostingVO)retValue).setIsScrapped(postingDAO.selectThisPostingScrape(scrapeVO));
			BlliPostingLikeVO postingLikeVO = new BlliPostingLikeVO();
			postingLikeVO.setMemberId(memberId);
			postingLikeVO.setPostingUrl(postingUrl);
			postingLikeVO.setSmallProductId(smallProductId);
			((BlliPostingVO)retValue).setIsLike(postingDAO.selectThisPostingLike(postingLikeVO));
			BlliPostingDisLikeVO postingDisLikeVO = new BlliPostingDisLikeVO();
			postingDisLikeVO.setMemberId(memberId);
			postingDisLikeVO.setPostingUrl(postingUrl);
			postingDisLikeVO.setSmallProductId(smallProductId);
			((BlliPostingVO)retValue).setIsDisLike(postingDAO.selectThisPostingDisLike(postingDisLikeVO));
			((BlliPostingVO)retValue).setPostingScrapeCount(postingDAO.getPostingScrapeCount(scrapeVO));
			((BlliPostingVO)retValue).setPostingLikeCount(postingDAO.getPostingLikeCount(scrapeVO));
			((BlliPostingVO)retValue).setPostingDislikeCount(postingDAO.getPostingDislikeCount(scrapeVO));
		}
		return retValue;
	}
}