-- 데이터 조회
-- SELECT

-- SELECT문의 기본 형식
select (열 이름)
from (테이블 이름)
where (조건식)
group by (열 이름)
having (조건식)
order by (열 이름)
limit 숫자;

-- SELECT ~ FROM ~~
select * from member;
-- select : 테이블에서 데이터를 가져올 때 사용하는 예약어
-- * : asterisk. 일반적으로 "모든 것"을 의미함, 위 예시에서는 열 이름이 들어갈 자리에 사용되어 "모든 열"을 뜻
-- from : 데이터를 가져올 테이블 지정
-- member : 조회할 테이블 이름
-- > member 테이블에서 모든 열의 내용을 가져와라

-- 원칙적으로는 데이터베이스.테이블 의 형식으로 표현해야 함

-- 사용할 데이터베이스 지정
-- use.(데이터베이스 이름);
use market_db;

-- 원칙적으로는 데이터베이스.테이블 의 형식으로 표현해야함
select * from market_db.member;

-- 필요한 열만 가져오기
select mem_name from member;

-- 여러 열을 가져오고 싶으면 콤마로 연결
-- 기존 테이블의 열 순서는 관계없이 보고싶은 순서대로 열을 나열
select addr, debut_date, mem_name from member;

-- 열 이름에 별칭 지정
-- 열 이름 다음에 지정하고 싶은 별칭 입력
-- 별칭에 공백이 포함되어 있다면 따옴표로 묶음
select addr 주소, debut_date "데뷔 일자", mem_name from member;

-- select ~ from ~ where ~
-- 특정 조건만 조회하기
-- 부하 문제 때문에 실무에서는 보통 where를 함께 사용하거나 limit를 사용함
select (열 이름) from (테이블 이름) where 조건식;

select * from member where mem_name = "블랙핑크";
select * from member where mem_number >= 6;
select * from member;

-- 관계 연산자, 논리 연산자
-- 숫자로 표현된 데이터라면 범위를 지정할 수 있음
select mem_id, mem_name, height from member where height <= 162;

-- 논리 연산자를 이용해서 여러 조건을 만족하도록 할 수도 있다.
select mem_name, height, mem_number from member where height >= 165 and mem_number > 6;

select mem_name, height, mem_number from member where height >= 165 or mem_number > 6;


-- 특정 범위에 있는 값을 구하는 경우
select mem_name, height from member where 163 <= height and height <= 165;
-- 열 이름 between a and b 로 범위를 구할수 있다.
select mem_name, height from member where height between 163 and 165;

-- in 
select mem_name, addr from member where addr = "경기" or addr="전남" or addr = "경남";

select mem_name, addr from member where addr in ("경기", "전남", "경남");

-- 문자열 일부 검색
select * from member where mem_name like "%이%크%";

-- 글자 수 매치
select * from member where mem_name like"__핑크";

# -------------------- 05/12 --------------------
select * from buy;

-- 1. buy table 에서 amount 가 4 이상인 모든 열 조회하기
select * from buy where amount >= 4;

-- 2. buy table 에서 prod_name이 지갑 또는 청바지에 해당하는 모든 열 데이터 조회하기
select * from buy where prod_name in ("지갑", "청바지");


-- order by
-- 정렬(결과가 출력되는 순서를 조절)
select mem_id, mem_name, debut_date from member;
select mem_id, mem_name, debut_date from member order by debut_date;

-- 정렬옵션
-- ASC : 오름차순
-- DESC : 내림차순
-- 생략하면 ASC

-- 평균키가 164 이상인 회원들 키의 내림차순
select * from member where height >= 164 order by height DESC;

-- 정렬기준을 여러 열로 지정하기
select * from member where height >= 164 order by height DESC, debut_date ASC;

-- limit(출력 개수 제한)
select * from member limit 3;

-- 데뷔일자가 가장 빠른 3건만 조회
select * from member order by debut_date DESC limit 3;

-- 데이터의 중복 제거
select addr from member;

select addr from member order by addr asc;

select distinct addr from member order by addr asc;


-- group by
-- 그룹화

-- 각 회원이 구매한 물품의 총 개수를 알고 싶은 경우
select mem_id, amount from buy order by mem_id;

select mem_id, sum(amount) from buy group by mem_id;
select mem_id "회원 아이디", sum(amount) "총 구매 개수" from buy group by mem_id;

-- 각 회원이 구매한 금액의 총합을 알고 싶은 경우
select mem_id "회원 아이디", sum(price * amount) "총합" from buy group by mem_id;

-- 한 거래당 구매하는 물품 수 평균
select mem_id "회원 아이디", avg(amount) "평균 구매 개수" from buy group by mem_id;

-- 전체 회원의 구매하는 물품 수 평균
select avg(amount) from buy;

-- 전체 회원 수를 알고 싶은 경우
select count(*) from member;

-- 연락처가 있는 회원 수만 알고 싶은 경우
select count(phone1) "연락처가 있는 회원 수" from member;

-- having
select mem_id "회원 아이디", sum(price * amount) "총 구매 금액" from buy group by mem_id;

-- 위 데이터에서 총 구매액이 1000이상인 회원에게만 사은품을 증정하려고 한다면
select mem_id "회원 아이디", sum(price * amount) "총 구매 금액" where sum(price * amount) >= 1000 group by mem_id;
-- 집계 함수는 where 에서 사용할 수 없다.

select mem_id "회원 아이디", sum(price * amount) "총 구매 금액" from buy group by mem_id having sum(price * amount) >= 1000;

-- 위 데이터에서 총 금액이 큰 사용자부터 나타내려 한다면
select mem_id "회원 아이디", sum(price * amount) "총 구매 금액" from buy group by mem_id having sum(price * amount) >= 1000 order by sum(price * amount) DESC;

-- 연습문제
-- 1. member 테이블에서 회원들을 height의 오름차순으로 조회
select * from member order by height;
-- 2. member 테이블의 phone1을 중복없이 조회하기
select distinct phone1 from member where phone1;




