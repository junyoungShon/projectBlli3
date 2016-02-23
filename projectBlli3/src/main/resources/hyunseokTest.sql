drop table blli_permanent_dead_posting cascade constraint;
CREATE TABLE blli_permanent_dead_posting (
	posting_url     VARCHAR2(300) NOT NULL,
	posting_title   VARCHAR2(450) NOT NULL,
	constraint pk_permanent_dead_posting primary key(posting_url, posting_title)
);

select * from blli_small_product;

select count(*) from blli_small_product;

select count(*) from blli_small_product where small_product_status = 'dead';

select count(*) from blli_small_product where small_product_status = 'unconfirmed';

select count(*) from blli_small_product group by mid_category;

select * from blli_small_product where mid_category = '캐릭터/패션인형' and small_product_status = 'dead';

select * from blli_small_product where mid_category = '캐릭터/패션인형' and small_product_status = 'unconfirmed';

select count(*) from blli_small_product where mid_category = '캐릭터/패션인형';

select count(*) from blli_small_product where small_product_status = 'confirmedbyadmin';

select * from blli_small_prod_buy_link;

select posting_url, posting_title, posting_content, small_product, small_product_id from(
	select ceil(rownum/5) as page, posting_url, posting_title, posting_content, small_product, small_product_id from(
		select count(*) over (partition by posting_url) as count_posting_url, posting_url, posting_title, 
		posting_content, small_product, small_product_id from blli_posting where posting_status = 'unconfirmed' and small_product like '%' || '위드맘' || '%' order by small_product asc
	) where count_posting_url = 1
) where page = '1'

select small_product_id from blli_small_product where small_product like '%' || '위드맘' || '%' and small_product_status = 'confirmed';

select posting_url, posting_title, posting_content, small_product, small_product_id from(
	select ceil(rownum/5) as page, posting_url, posting_title, posting_content, small_product, small_product_id from(
		select count(*) over (partition by posting_url) as count_posting_url, posting_url, posting_title, 
		posting_content, small_product, small_product_id from blli_posting where posting_status = 'unconfirmed' and small_product_id = '6507320795' order by small_product asc
	) where count_posting_url = 1
) where page = '1'

select * from blli_posting where small_product = '아이배냇 베베레시피 당근 단호박 시금치 20g';

update blli_posting set posting_status = 'unconfirmed' where posting_status = 'confirmed' and posting_photo_link like '%' || 'blogthumb' || '%';

select small_product_id from blli_member_dibs where member_id = 'gonipal@naver.com';

select small_product_id from blli_small_product where small_product_status = 'confirmedbyadmin';

select * from blli_small_product where small_product_status = 'confirmed';

select * from blli_small_product where small_product_id = '6733513412';

select * from blli_small_product where small_product  = '똘똘이 옹알이아기';

update blli_posting set posting_status = 'unconfirmed' where posting_status = 'confirmed';

update blli_small_product set small_product_status = 'unconfirmed' where small_product_status = 'confirmed' or small_product_status = 'confirmedbyadmin';

update blli_small_product set db_insert_posting_count = 0;

update blli_posting set posting_status = 'unconfirmed' where posting_status = 'dead';

select * from blli_mid_category;

