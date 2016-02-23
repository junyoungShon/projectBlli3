package kr.co.blli.model.posting;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import kr.co.blli.model.vo.BlliMemberScrapeVO;
import kr.co.blli.model.vo.BlliPostingVO;
import kr.co.blli.model.vo.BlliSmallProductVO;

public interface PostingService {

	abstract ArrayList<BlliPostingVO> searchPosting(String pageNo, String searchWord);

	abstract void recordResidenceTime(BlliPostingVO blliPostingVO);

	abstract int totalPageOfPosting(String searchWord);

	abstract ArrayList<BlliPostingVO> searchPostingListInProductDetail(String searchWord);

	abstract ArrayList<BlliPostingVO> searchPostingListInProductDetail(String smallProductId, String memberId, String pageNo);

	abstract String selectTotalPostingtNum();


	abstract List<BlliPostingVO> searchPostingBySmallProductList(
			List<BlliSmallProductVO> blliSmallProductVOList, String memberId,
			String string);

	BlliPostingVO searchPostingByUserScrape(
			BlliPostingVO blliPostingVO, String memberId);

	abstract ArrayList<BlliPostingVO> getPostingSlideListInfo(String smallProductId);

}
