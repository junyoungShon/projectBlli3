package kr.co.blli.model.posting;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import kr.co.blli.model.vo.BlliMemberScrapeVO;
import kr.co.blli.model.vo.BlliPostingDisLikeVO;
import kr.co.blli.model.vo.BlliPostingLikeVO;
import kr.co.blli.model.vo.BlliPostingVO;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class PostingDAOImpl implements PostingDAO{
	@Resource
	private SqlSessionTemplate sqlSessionTemplate;
	@Override
	public int updatePosting(BlliPostingVO postingVO) {
		return sqlSessionTemplate.update("posting.updatePosting", postingVO);
	}
	@Override
	public void insertPosting(BlliPostingVO postingVO) {
		sqlSessionTemplate.insert("posting.insertPosting", postingVO);
	}
	@Override
	public List<BlliPostingVO> searchPosting(HashMap<String, String> map) {
		return sqlSessionTemplate.selectList("posting.searchPosting", map);
	}
	@Override
	public List<String> searchProducts(String postingUrl) {
		return sqlSessionTemplate.selectList("posting.searchProducts", postingUrl);
	}
	@Override
	public String getPostingStatus(String postingUrl) {
		return sqlSessionTemplate.selectOne("posting.getPostingStatus",postingUrl);
	}
	/**
	  * @Method Name : updatePostingViewCountAndResidenceTime
	  * @Method 설명 : 체류시간과 포스팅 조회수를 업데이트 해줍니다.
	  * @작성일 : 2016. 1. 22.
	  * @작성자 : junyoung
	  * @param blliPostingVO
	 */
	@Override
	public void updatePostingViewCountAndResidenceTime(BlliPostingVO blliPostingVO) {
		sqlSessionTemplate.update("posting.updatePostingViewCountAndResidenceTime",blliPostingVO);
	}
	@Override
	public int totalPageOfPosting(String searchWord) {
		return sqlSessionTemplate.selectOne("posting.totalPageOfPosting", searchWord);
	}
	@Override
	public List<BlliPostingVO> searchPostingListInProductDetail(String searchWord) {
		return sqlSessionTemplate.selectList("posting.searchPostingListInProductDetail", searchWord);
	}
	@Override
	public List<BlliPostingVO> selectAllPosting() {
		return sqlSessionTemplate.selectList("posting.selectAllPosting");
	}
	@Override
	public void updatePostingScore(BlliPostingVO blliPostingVO) {
		sqlSessionTemplate.update("posting.updatePostingScore", blliPostingVO);
	}
	@Override
	public String getPostingStatus(BlliPostingVO blliPostingVO) {
		return sqlSessionTemplate.selectOne("posting.getPostingStatus", blliPostingVO);
	}
	@Override
	public int selectThisPostingScrape(BlliMemberScrapeVO blliMemberScrapeVO) {
		return sqlSessionTemplate.selectOne("posting.selectThisPostingScrape", blliMemberScrapeVO);
	}
	@Override
	public int selectThisPostingLike(BlliPostingLikeVO blliPostingLikeVO) {
		return sqlSessionTemplate.selectOne("posting.selectThisPostingLike", blliPostingLikeVO);
	}
	@Override
	public int selectThisPostingDisLike(BlliPostingDisLikeVO blliPostingDisLikeVO) {
		return sqlSessionTemplate.selectOne("posting.selectThisPostingDisLike", blliPostingDisLikeVO);
	}
	@Override
	public List<BlliPostingVO> selectPostingBySmallProductId(HashMap<String, String> paraMap) {
		System.out.println(paraMap);
		return sqlSessionTemplate.selectList("posting.selectPostingBySmallProductId", paraMap);
	}
	@Override
	public String selectTotalPostingtNum() {
		return sqlSessionTemplate.selectOne("posting.selectTotalPostingtNum");
	}
	@Override
	public BlliPostingVO getPostingInfo(BlliPostingVO blliPostingVO) {
		return sqlSessionTemplate.selectOne("posting.getPostingInfo", blliPostingVO);
	}
	@Override
	public int getPostingScrapeCount(BlliMemberScrapeVO scrapeVO) {
		return sqlSessionTemplate.selectOne("posting.getPostingScrapeCount", scrapeVO);
	}
	@Override
	public int getPostingLikeCount(BlliMemberScrapeVO scrapeVO) {
		return sqlSessionTemplate.selectOne("posting.getPostingLikeCount", scrapeVO);
	}
	@Override
	public int getPostingDislikeCount(BlliMemberScrapeVO scrapeVO) {
		return sqlSessionTemplate.selectOne("posting.getPostingDislikeCount", scrapeVO);
	}
	@Override
	public void deletePosting(BlliPostingVO postingVO) {
		sqlSessionTemplate.delete("posting.deletePosting", postingVO);
	}
	@Override
	public void insertPermanentDeadPosting(BlliPostingVO postingVO) {
		sqlSessionTemplate.insert("posting.insertPermanentDeadPosting", postingVO);
	}
	@Override
	public int updatePostingStatusToTemptdead(BlliPostingVO postingVO) {
		return sqlSessionTemplate.update("posting.updatePostingStatusToTemptdead", postingVO);
	}
	@Override
	public void updatePostingStatusToDeadBySmallProduct(String smallProductId) {
		sqlSessionTemplate.update("posting.updatePostingStatusToDeadBySmallProduct", smallProductId);
	}
	@Override
	public void resetPostingUpdateColumn(String smallProductId) {
		sqlSessionTemplate.update("posting.resetPostingUpdateColumn", smallProductId);
	}
	@Override
	public void updatePostingStatusToConfirmed(BlliPostingVO postingVO) {
		sqlSessionTemplate.update("posting.updatePostingStatusToConfirmed", postingVO);
	}
	@Override
	public List<BlliPostingVO> selectPostingBySmallProductList(HashMap<String, String> paraMap) {
		return sqlSessionTemplate.selectList("posting.selectPostingBySmallProductList", paraMap);
	}
	public List<BlliPostingVO> getPostingSlideListInfo(String smallProductId) {
		return sqlSessionTemplate.selectList("posting.getPostingSlideListInfo", smallProductId);
	}
}
