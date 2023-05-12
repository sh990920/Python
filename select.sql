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
















