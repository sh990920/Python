-- 뷰(view)
-- 데이터베이스 개체 중 하나
-- 데이터베이스 개체 중에서도 테이블과 밀접한 연관이 있음
-- 한 번 생성된 뷰는 일반 테이블과 거의 동일한 개체로 취급할 수 있음

-- 하지만 뷰는 테이블처럼 데이터를 가지고 있지는 않고, 뷰의 실체는 select문 임
-- -- 뷰에 접근하면 select문이 실행되고 그 결과가 화면에 츌력되는 방식
-- -- 윈도우에 바로가기 아이콘 과 유사

-- 뷰의 종류
-- 단순 뷰 : 하나의 테이블과 연관된 뷰
-- 복합 뷰 : 두개 이상의 테이블과 연관된 뷰

-- 뷰의 개념
use market_db;
select mem_id, mem_name, addr from member;
-- select문으로 meme_id, mem_name, addr을 조회하면 3개의 컬럼을 가진 테이블과 유사한 형태가 조회됨
-- select문의 실행 결과를 하나의 테이블처럼 사용하는 것이 뷰의 개념
-- -- 따라서 뷰의 실체는 select문
-- 일반적으로 뷰의 이름만 보고도 뷰인지 알아볼 수 있도록 이름 앞에 v_를 붙이는 것이 일반적

-- 뷰의 형식
create view 뷰_이름
as
	select문;

-- 뷰에 접근하는 방식
-- 테이블과 동일하게 select 문으로 접근할 수 있음
-- 필요하다면 조건식도 테이블과 동일하게 사용할 수 있음
select 열_이름 from 뷰_이름
[where 조건];

-- 회원 테이블의 아이디, 이름, 주소에 접근하는 뷰 생성
create view v_member
as
	select mem_id, mem_name, addr from member;

-- 뷰 사용하기
select * from v_member;

-- 필요한 열만 보거나 조건식을 넣을 수도 있음
select mem_name, addr from v_member where addr in("서울", "경기");
-- 뷰는 테이블에 접근한 것과 동일한 결과를 얻을 수 있음

-- 뷰의 작동
-- 1. 조회 또는 변경
-- 2. 뷰에서 테이블로 쿼리 실행
-- 3. 뷰에서 쿼리 데이터 받음
-- 4. 사용자에게 결과 전달

-- 뷰를 사용하는 이유
-- 1. 보안(security)에 도움
-- -- 앞의 예제에서 만든 v_member 뷰에서는 사용자의 아이디, 이름, 주소 외의 다른 정보는 들어있지 않음
-- -- 만약 인터넷 마켓 회원의 데이터를 확인하는 작업을 하는데 아르바이트생을 고용할 계획이라면
-- -- 아르바이트생이 회원 테이블에 접근하도록 한다면 중요한 개인 정보들이 노출될 가능성이 있다.
-- -- 하지만 회원 테이블에 접근하지 못하면 일을 진행할 수 없다.
-- -- 이런 경우 작업에 필요한 데이터만 확인할 수 있는 뷰를 생성해서
-- -- 아르바이트생의 회원테이블에 접근 권한을 제한하고 뷰의 접근 권한을 준다면 문제를 해결할 수 있다.

-- 데이터베이스에서 보안은 중요한 주제이며 사용자마다 테이블에 접근하는 권한에 차별을 둬서 처리하는 경우가 일반적

-- 2. 복잡한 sql을 단순화 할 수 있음
select b.mem_id, m.mem_name, b.prod_name, m.addr, concat(m.phone1, m.phone2) '연락처'
from buy b
	inner join member m 
	on b.mem_id = m.mem_id;
-- 만약 위 쿼리를 자주 사용해야 한다면 매번 쿼리를 입력하기 힘듬
-- 이때, 이 sql을 뷰로 생성해두고 사용자들이 뷰에 접근하도록 한다면 복잡한 sql을 입력할 필요가 없어짐
create view v_memberBuy
as
	select b.mem_id, m.mem_name, b.prod_name, m.addr, concat(m.phone1, m.phone2) '연락처'
	from buy b
		inner join member m
		on b.mem_id = m.mem_id;

-- v_memberBuy를 테이블 처럼 접근할 수 있고 where 절도 사용할 수 있음
select * from v_memberBuy;
select * from v_memberBuy where mem_name = "블랙핑크";
	
-- 뷰의 실제 작동
-- -- 뷰의 실제 생성, 수정, 삭제
-- -- 뷰를 생성하면서 뷰에서 사용될 열 이름을 테이블과 다르게 지정할 수 있다(별칭을 사용해서)
-- -- 별칭은 열 이름 뒤에 작은 따옴표 또는 큰 따옴표로 묶어주고, as를 붙여 코드를 명확하게 보여줌
-- -- 단, 뷰를 조회할 때 열 이름에 공백이 있으면 백틱(``)으로 묶어줘야 함

use market_db;
create view v_viewtest1
as
	select b.mem_id 'Member ID', m.mem_name as "Member Name", b.prod_name "Product Name"
	, concat(m.phone1, m.phone2) as "Office Phone"
	from buy b
		inner join member m 
		on m.mem_id = b.mem_id;

select distinct `member ID`, `member Name` from v_viewtest1;

-- 뷰의 수정은 alter view 구문 사용
alter view v_viewtest1
as 
	select b.mem_id '회원 아이디', m.mem_name as '회원 이름', b.prod_name "제품 이름"
	, concat(m.phone1, m.phone2) as "연락처"
	from buy b
		inner join member m 
		on m.mem_id = b.mem_id;
	
select distinct `회원 아이디`, `회원 이름` from v_viewtest1;
-- 열 이름에 한글을 사용하면 한글 운영 체제 외에는 인식이 안될 수도 있으므로 권장하지는 않음

-- 뷰의 삭제
drop view v_viewtest1;
describe v_viewtest1;

-- 뷰의 정보 확인
use market_db;

-- create or replace view : 뷰를 생성할 때 create view 는 기존의 뷰가 있으면 오류를 발생하지만
-- create or replace view는 기존에 뷰가 있어도 덮어쓰는 효과를 내기 때문에 오류가 발생하지 않음
-- drop view와 create view를 연속해서 사용한 효과를 가짐
create or replace view v_viewtest2
as
	select mem_id, mem_name, addr from member;

desc v_viewtest2;
describe v_viewtest2;
describe member;
-- describe로 뷰의 정보를 확인할 수 있음
-- 주의할 점은 primary key등의 정보는 확인되지 않음

-- 뷰의 소스코드 확인
show create view v_viewtest2;

-- 뷰를 통한 데이터의 수정 삭제
select * from v_member;
update v_member set addr = '부산' where mem_id = 'BLK';
select * from v_member;
select * from member;

insert into v_member(mem_id, mem_name, addr) values("BTS", "방탄소년단", '경기');
-- v_member 뷰가 참조하는 member 테이블의 열 중에 mem_number 열은 not null 열이라서
-- 반드시 값이 입력되어야 하지만
-- 현재의 v_member에서는 mem_number 열을 참조하고 있지 않으므로 값을 입력할 방법이 없음

-- 만약 v_member 뷰를 통해서 member테이블에 값을 입력하고 싶다면 v_member에 mem_number를 포함하도록
-- 뷰를 재정의 하거나 member에서 mem_number 열의 속성을 null로 바꾸거나 기본값을 지정해야함

create view v_height167
as
	select * from member where height >= 167;
select * from v_height167;
-- height가 167이상인 회원만 조회되었음

-- v_height167뷰에서 height가 167 미만인 데이터를 삭제하기
delete from v_height167 where height < 167;
select * from v_height167;
select * from member;
-- v_height167 뷰애는 167미만인 데이터가 없기 때문에 삭제될 데이터가 없음

-- 뷰를 통한 데이터 등록
-- -- v_height167 뷰에 height가 167 미만인 데이터 입력하기
insert into v_height167 values("TRA", "티아라", 6, '서울', null, null, 159, '2005-01-01');

select * from v_height167;
select * from member;
-- 데이터 입력은 되었지만 v_height167 뷰는 height가 167 이상인 데이터만 조회하므로
-- 마지막으로 입력한 티아라는 보이지 않음
-- height가 167이상인 부에는 height가 159인 데이터를 입력하는 것은 바람직하지 않음
-- 논리적으로 바람직하려면 height가 167이상인 뷰에 height가 167이상인 데이터만 입력되는 것이 알맞음
-- -- 위와 같은 경우 with check option을 통해 뷰에 설정된 값의 범위를 벗어나는 값은 입력되지 않도록 할 수 있음
-- -- -- with check option : 설정한 범위의 데이터만 입력되도록 제한
alter view v_height167
as 
	select * from member where height >= 167
		with check option;

insert into v_height167 values("TOB", "텔레토비", 4, "영국", null, null, 140, '1995-01-01');
-- height가 167미만인 데이터는 입력되지않고 167이상의 데이터만 입력됨

-- 뷰가 참조하는 테이블 삭제
drop table if exists buy, member;
-- 현재 여러 개의 뷰가 두 테이블과 관련이 있음에도 테이블이 삭제됨

select * from v_height167;
-- 참조하는 테이블이 없기 때문에 조회할 수 없다는 메시지가 출력됨
-- 테이블은 관련된 뷰가 있더라도 쉽게 삭제됨

-- 뷰가 조회되지 않으면 check table로 뷰의 삭제를 확인할 수 있음
check table v_height167;

-- 복합 뷰
-- 두개 이상의 테이블로 만든 뷰
-- 주로 두 테이블을 join한 결과를 뷰로 만들 때 사용
-- 복합 뷰는 읽기 전용임
-- 복합뷰를 통해 테이블에 데이터를 입력/수정/삭제할 수 없음
create view v_complex
as 
	select b.mem_id, m.mem_name, b.prod_name, m.addr
	from buy b
		inner join member m
		on b.mem_id = m.mem_id;





