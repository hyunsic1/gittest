<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/api/common/include/headerBase.jsp"%>
<%@ include file="/WEB-INF/views/common/include/taglib.jsp" %>
<body>
<div class="canvas">
	<div class="container webView_containerBtn">
		<div class="review_wrap">
<%--			<div class="search_box type3">--%>
<%--				<div class="search_txt">--%>
<%--					<input type="text"  name="" value=""  placeholder="상품명을 입력해주세요" class="search_txt_input">--%>
<%--					<a href="javascript:;" class="btn_search"><img src="https://minfo.lotteshopping.com/mobmweb/resources/layout/images/src/icon_search03.png" alt="검색" /></a>--%>
<%--				</div>--%>
<%--				<a href="javascript:;" class="btn_close"><img src="https://minfo.lotteshopping.com/mobmweb/resources/layout/images/shpMap/btn_close.png" alt="닫기" /></a>--%>
<%--			</div>--%>

			<!-- s: 검색결과 없을 시 show
				.filter_area, .review_cont 삭제 -->
<%--			<div class="nodata" style="display:">--%>
<%--				<p class="desc">"검색결과가 없습니다"</p>--%>
<%--			</div>--%>
			<!-- e: 검색결과 없을 시 -->

			<!-- s: 필터영역 -->
			<ul class="filter_area">
				<li>
					<a href="javascript:;" class="option"><em class="sortText">최신순</em>(<em class="listCnt"></em>)</a>
					<div class="layer_filter">
						<ul class="filter_list">
							<li>
								<button type="button" class="btn_filter" data-order="rgstDtm">최신순</button>
							</li>
							<li>
								<button type="button" class="btn_filter" data-order="rcmCnt">추천순</button>
							</li>
							<li>
								<button type="button" class="btn_filter" data-order="prdcEvlScor1">별점 높은 순</button>
							</li>
							<li>
								<button type="button" class="btn_filter" data-order="prdcEvlScor2">별점 낮은 순</button>
							</li>
						</ul>
					</div>
				</li>
    			<li class="check_list">
					<input type="checkbox" id="filter0101" onclick="getConditionRevwList()" >
					<label for="filter0101">포토리뷰</label>
					<input type="checkbox" id="filter0102" onclick="getConditionRevwList()">
					<label for="filter0102">나의지점만 보기</label>
				</li>
    		</ul>
			<!-- e: 필터영역 -->
			<div class="review_cont">
				<ul class="review_list"></ul>
			</div>
		</div>
    </div>
    <!-- //Container -->
</div>
<input type="hidden" name="page" value="1" />
<input type="hidden" name="order" value="rgstDtm" />
<input type="hidden" name="hasNextYn" value="Y" />
<script>
const reveiwGrade = {
	init : function(){
		if ($('.review_item .img_area').length) {this.reviewSlide.init();} // 리뷰 슬라이드
		if ($('.review_item .info .btn_more').length) {this.reviewMore.init();} // 리뷰 내용 더보기
		if ($('.filter_area .option').length) {this.filter.init()}	// 필터 버튼
	},
	reviewSlide : {
		init : function(){
			const _this = this;
			let $target = $('.review_item .img_area');
			
			$target.each(function(){
				let $this = $(this);
				
				if( $this.find('li').length > 1 && $this.parents('.type_mypage').length < 1 ){
					_this.evtHandler($this);
				}
			});
		},
		evtHandler : function($this){
			/* tab slider */
			var reviewSlide = new Swiper($this, {
				pagination: '.swiper-pagination',
				slidesPerView: 'auto',
				autoHeight: true,
				loop: true,
				paginationClickable: true,
				spaceBetween: 20,
				observer: true, // displsy:none 대응,  
				observeParents: true,
				pagination: {
					el: '.swiper-pagination',
					type: 'bullets',
				},
			});
		}
	},
	reviewMore : {
		init : function(){
			const _this = this;
			let $btn = $('.review_item .info .btn_more');
			
			$btn.on('click', function(){
				let $this = $(this),
					$target = $this.parents('.more_desc').siblings('.desc');
				
				_this.evtHandler($this, $target);
			})
		},
		evtHandler : function($this, $target){
			const _this = this;

			if( $this.hasClass('on') ){
				_this.descClose($this, $target);
			} else {
				_this.descOpen($this, $target);
			};
		},
		descOpen : function($this, $target){
			$this.text('접기').addClass('on');
			$target.addClass('on');
		},
		descClose : function($this, $target){
			$this.text('더보기').removeClass('on');
			$target.removeClass('on');
		}
	},
	filter : {
		init : function(){
			let _this = this,
					$btn = $('.filter_area .option'),
					$target = $btn.siblings('.layer_filter');

			$btn.on('click', function(){
				if( $(this).hasClass('on') ){
					$(this).removeClass('on');
					$target.hide();
				} else {
					$(this).addClass('on');
					$target.show();
				}
			});

			$target.on('click', 'button', function(){
				var order = $(this).data("order");
				var label = $(this).text();
				$(".sortText").text(label);
				$("[name='order']").val(order);
				getConditionRevwList();
				$('.filter_area .option').removeClass("on");
				$target.hide();
			})
		},
		show : function($target){
			$target.show();
		},
		hide : function($target){
			$target.hide();
		}
	}
}

$(document).ready(function(){
	// 리뷰작성페이지 초기 실행
	reveiwGrade.init();
	getConditionRevwList();

	setInterval(function() {
		location.href = "toapp:::AppFunction:::ScrollHeightChange:::" + $(".container").outerHeight(true);
	}, 500)
});

// 네이티브 정책 변경으로 수정
function scrollHeightCheck() {
	if(!scrollHeightCheck.flag) {
		scrollHeightCheck.flag = true;
		var hasNextYn = $("[name='hasNextYn']").val();
		if(hasNextYn == "Y") {
			getRevwList();
		} else {
			scrollHeightCheck.flag = false;
		}
	}
}// e:scrollHeightCheck

function getConditionRevwList() {
	$("[name='page']").val(1);
	$("[name='hasNextYn']").val("Y");
	getRevwList();
}

function getRevwList() {
	if(!getRevwList.flag) {
		getRevwList.flag = true;
		var page = $("[name='page']").val();
		$.ajax("/api/revw/shopReviewList", {
			type: 'POST',
			data: {
				page : page,
				mbrNo : "${loginFlag}" == "true" ? "${header.mbrNo}" : "",
				cstrShopNo : "${param.cstrShopNo}",
				revwTp : $("#filter0101:checked").length ? "C16402" : "",
				cstrCd : $("#filter0102:checked").length ? "${param.cstrCd}" : "",
				order : $("[name='order']").val()
			}
		})
		.done(function(data) {
			if(page == 1) {
				$(".review_list").remove("script").html(data);
			} else {
				$(".review_list").remove("script").append(data);
			}

			reveiwGrade.reviewSlide.init();
			getRevwList.flag = false;
			scrollHeightCheck.flag = false;
		})
		.error(function(xhr) {
			alert('통신 중 문제가 발생하였습니다');
			getRevwList.flag = false;
			scrollHeightCheck.flag = false;
		});
	}
}// e:getRevwList

// 공유하기
function onShare(prdcEvlNo, cntsNm, imgUrlApp) {
	var url = "lottecoupon://gate?page=a0209&url=${mowDomain}/api/revw/reviewDetail?prdcEvlNo=" + prdcEvlNo;
	imgUrlApp = imgUrlApp || "${imgDomain}/mobmweb/resources/layout/images/common/dummy_gry.jpg";
	var webUrl = "${mowDomain}/reviewGate?prdcEvlNo=" + prdcEvlNo;
	var kakaoWebUrl = "reviewGate?prdcEvlNo=" + prdcEvlNo;
	var scheme = "lottecoupon://gate?page=a0198&url=" + encodeURIComponent(url) + "&cntsNm=" + encodeURIComponent(cntsNm) + "&imgUrlApp=" + imgUrlApp + "&webUrl=" + encodeURIComponent(webUrl) + "&kakaoWebUrl=" + kakaoWebUrl;
	location.href = scheme;
}
// e:공유하기
</script>
<c:choose>
	<c:when test="${loginFlag}">
<script>

	// 추천하기
	function procRevwRcm(obj, prdcEvlNo, rcmYn) {
		if(!procRevwRcm.flag) {
			procRevwRcm.flag = true;
			$.ajax("/api/revw/procRevwRcm", {
				type: 'POST',
				data: {
					prdcEvlNo : prdcEvlNo,
					mbrNo : "${header.mbrNo}",
					rcmYn : rcmYn
				}
			})
			.done(function(data) {
				if(data.resultCode == "0000") {
					$(obj).toggleClass("on");
					var rcmCnt = $(obj).find(".rcmCnt").text();
					rcmYn == "Y" ? rcmCnt-- : rcmCnt++;
					$(obj).find(".rcmCnt").text(rcmCnt);

					$(obj).removeAttr("onclick");
					$(obj).unbind("click").click(function() {
						procRevwRcm(obj, prdcEvlNo, rcmYn == "Y" ? "N" : "Y");
					})
				} else {
					alert('통신 중 문제가 발생하였습니다');
				}
				procRevwRcm.flag = false;
			})
			.error(function(xhr) {
				alert('통신 중 문제가 발생하였습니다');
				procRevwRcm.flag = false;
			});
		}
	}
	// e:추천하기

	// 신고하기
	function openSttmPop(obj, prdcEvlNo) {
		var url = encodeURIComponent("${mowDomain}/api/revw/reviewSttm?mbrNo=${header.mbrNo}&prdcEvlNo=" + prdcEvlNo + "&refreshYn=Y");
		location.href = "lottecoupon://gate?page=a0214&url=" + url;
	}
	// e:신고하기
</script>
	</c:when>
	<c:otherwise>
<script>
	function procRevwRcm(prdcEvlNo, rcmYn) {
		alert("로그인이 필요한 서비스입니다.");
		location.href = "toapp:::AppFunction:::Login:::Y";
	}

	function openSttmPop() {
		alert("로그인이 필요한 서비스입니다.");
		location.href = "toapp:::AppFunction:::Login:::Y";
	}
</script>
	</c:otherwise>
</c:choose>
</body>
</html>