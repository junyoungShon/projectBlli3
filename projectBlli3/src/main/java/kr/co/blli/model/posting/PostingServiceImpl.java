package kr.co.blli.model.posting;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import kr.co.blli.model.vo.BlliMemberScrapeVO;
import kr.co.blli.model.vo.BlliMemberVO;
import kr.co.blli.model.vo.BlliPostingDisLikeVO;
import kr.co.blli.model.vo.BlliPostingLikeVO;
import kr.co.blli.model.vo.BlliPostingVO;
import kr.co.blli.model.vo.BlliSmallProductVO;

import org.springframework.stereotype.Service;

@Service
public class PostingServiceImpl implements PostingService {
	
	@Resource
	private PostingDAO postingDAO;
	
	/**
	 * 
	 * @Method Name : searchSmallProduct
	 * @Method 설명 : 검색어(소제품)에 해당하는 포스팅을 찾아주는 메서드
	 * @작성일 : 2016. 1. 16.
	 * @작성자 : hyunseok
	 * @param searchWord
	 * @return
	 */
	@Override
	public ArrayList<BlliPostingVO> searchPosting(String pageNo, String searchWord) {
		HashMap<String, String> map = new HashMap<String, String>();
		if(pageNo == null || pageNo == ""){
			pageNo = "1";
		}
		map.put("pageNo", pageNo);
		map.put("searchWord", searchWord);
		ArrayList<BlliPostingVO> postingList = (ArrayList<BlliPostingVO>)postingDAO.searchPosting(map);
		return postingList;
	}
	
	/**
	  * @Method Name : recordResidenceTime
	  * @Method 설명 : 포스팅내에 얼마나 머물렀는지를 초단위로 기록하며, 포스팅의 조회수를 올려준다.
	  * @작성일 : 2016. 1. 22.
	  * @작성자 : junyoung
	  * @param blliPostingVO
	 */
	@Override
	public void recordResidenceTime(BlliPostingVO blliPostingVO) {
		postingDAO.updatePostingViewCountAndResidenceTime(blliPostingVO);
	}

	/**
	 * 
	 * @Method Name : totalPageOfPosting
	 * @Method 설명 : 검색 결과에 해당하는 포스팅의 총 페이지 수를 반환해주는 메서드
	 * @작성일 : 2016. 1. 27.
	 * @작성자 : hyunseok
	 * @param searchWord
	 * @return
	 */
	@Override
	public int totalPageOfPosting(String searchWord) {
		return postingDAO.totalPageOfPosting(searchWord);
	}

	@Override
	public ArrayList<BlliPostingVO> searchPostingListInProductDetail(String searchWord) {
		return (ArrayList<BlliPostingVO>)postingDAO.searchPostingListInProductDetail(searchWord);
	}

	@Override
	public ArrayList<BlliPostingVO> searchPostingListInProductDetail(
			String smallProductId, String memberId, String pageNo) {
		//파라미터로 사용할 맵을 생성하고, 페이지 번호를 넣는다.
		HashMap<String, String> paraMap = new HashMap<String, String>();
		int currentPage = Integer.parseInt(pageNo);
		String startPosting = currentPage+"";
		String endPosting = (currentPage+5)+"";
		if(currentPage!=1){
			startPosting = ((currentPage-1)*5+1)+"";
			endPosting = ((currentPage-1)*5+5)+"";
		}
		System.out.println(smallProductId);
		paraMap.put("startPosting", startPosting);
		paraMap.put("endPosting", endPosting);
		paraMap.put("smallProductId", smallProductId);
		//점수순 노출 , 상태(confirmed) , 포스팅 대상 소제품 등을 기준으로 출력<!극혐주의!> 포스팅 관련 이므로 여기있으면 안되지만 구조상 여기왔다 . 상의해보자
		List<BlliPostingVO> blliPostingVOList = postingDAO.selectPostingBySmallProductId(paraMap);
		
		return (ArrayList<BlliPostingVO>) blliPostingVOList;
	}

	@Override
	public String selectTotalPostingtNum() {
		DecimalFormat df = new DecimalFormat("#,##0");
		String totalPostingNum = df.format(Integer.parseInt(postingDAO.selectTotalPostingtNum()));
		return totalPostingNum;
	}

	@Override
	public BlliPostingVO searchPostingByUserScrape(BlliPostingVO blliPostingVO, String memberId) {
		BlliPostingVO postingVO = postingDAO.getPostingInfo(blliPostingVO);
		postingVO.setSmallProductId(blliPostingVO.getSmallProductId());
		return postingVO;
	}

	/**
	  * @Method Name : selectPostingBySmallProductList
	  * @Method 설명 : <!극혐주의!> 포스팅 관련 이므로 여기있으면 안되지만 구조상 여기왔다 . 상의해보자
	  * @작성일 : 2016. 1. 21.
	  * @작성자 : junyoung
	  * @param blliMidCategoryVOList
	  * @return
	 */
	@Override
	public List<BlliPostingVO> searchPostingBySmallProductList(List<BlliSmallProductVO> blliSmallProductVOList,String memberId,String pageNum) {
		List<BlliPostingVO> blliPostingVOList = new ArrayList<BlliPostingVO>();
		//파라미터로 사용할 맵을 생성하고, 페이지 번호를 넣는다.
		HashMap<String, String> paraMap = new HashMap<String, String>();
		paraMap.put("pageNum", pageNum);
		//점수순 노출 , 상태(confirmed) , 포스팅 대상 소제품 등을 기준으로 출력<!극혐주의!> 포스팅 관련 이므로 여기있으면 안되지만 구조상 여기왔다 . 상의해보자
		for(int i=0;i<blliSmallProductVOList.size();i++){
			System.out.println(blliSmallProductVOList);
			if(blliSmallProductVOList.get(i)!=null){
				paraMap.put("smallProductId", blliSmallProductVOList.get(i).getSmallProductId());
				List<BlliPostingVO> tempList = postingDAO.selectPostingBySmallProductList(paraMap);
				if(tempList!=null){
					for(int j=0;j<tempList.size();j++){
						blliPostingVOList.add(tempList.get(j));
					}
				}
			}
		}
		return blliPostingVOList;
	}
	@Override
	public ArrayList<BlliPostingVO> getPostingSlideListInfo(String smallProductId) {
		return (ArrayList<BlliPostingVO>)postingDAO.getPostingSlideListInfo(smallProductId);
	}

}
