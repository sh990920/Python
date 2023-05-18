-- 제약 조건
-- 테이블을 만들 때는 테이블의 구조에 필요한 제약조건을 설정해야 함
-- 앞에서 배운 기본키(primary key)와 외래키(foreign key)가 대표적인 제약조건

-- 제약조건의 기본 개념
-- 제약조건(constraint)은 데이터의 무결성을 지키기 위해 제한하는 조건
-- 데이터의 무결성 : 데이터에 결함이 없다는 의미
-- -- 예) 네이버의 회원 아이디가 중복되면 네이버의 모든 서비스 이용에 혼란이 일어남
-- -- 위의 예시와 같은 결함이 없는 것을 데이터의 무결성 이라고 표현
-- -- 예시 상황에서는 데이터의 무결성을 위해서 회원 테이블의 아이디를 기본키로 지정할 수 있음
-- -- 기본키로 설정하면 중복된 아이디를 실수로 입력하려 해도 입력이 불가능

-- 제약조건의 종류
-- -- primary key : 기본키
-- -- foregin key : 외래키
-- -- unique
-- -- check
-- -- default정의
-- -- null값 허용

-- 기본키(primary key)
-- 테이블의 많은 데이터 중에 데이터를 구분할 수 있는 식별자
-- 예) 회원 아이디, 학생의 학번, 직원의 사번...
-- 기본키의 값은 중복될 수 없으며 null값이 입력될 수 없음

-- 대부분의 테이블은 기본키를 가져야함
-- 테이블당 기본키는 한개만 가질 수 있음
-- -- 아이디, 주민등록번호, 이메일 처럼 기본키로 설정할 수 있는 열이 여러개인 경우에는
-- -- 테이블의 특성을 가장 잘 반영하는 열을 선택하는 것이 좋음

-- create table 에서 기본키 제약 조건 설정
use naver_db;

drop table if exists buy, member;

create table member(
	mem_id char(8) not null primary key,
	mem_name varchar(10) not null,
	height tinyint unsigned null
);

describe member;

-- create table의 마지막 행에 primary key를 추가할 수도 있음
drop table member;

create table member(
	mem_id char(8) not null,
	mem_name varchar(10) not null,
	height tinyint unsigned not null,
	primary key (mem_id)
);

-- alter table 에서 기본키 제약조건 설정
-- 이미 만들어진 테이블을 alter table을 통해 수정하여 기본키를 설정하는 방법
drop table member;

create table member(
	mem_id char(8) not null,
	mem_name varchar(10) not null,
	height tinyint unsigned not null
);
describe member;
alter table member -- member 테이블을 수정
	add constraint -- 제약조건을 추가
	primary key (mem_id); -- mem_id 에 기본키 제약조건을 설정

-- 외래키 제약 조건
-- 외래키(foreign key) : 두 테이블 사이의 관계를 연결해주고, 그 결과 데이터의 무결성을 보장
-- 외래키가 설정된 열은 다른 테이블의 기본키와 연결됨
-- -- member 테이블과 buy 테이블이 기본키-외래키 관계
-- -- 이 경우 기본키가 있는 member 테이블을 기준 테이블이라고 하며, 외래키가 있는 buy 테이블을 참조 테이블 이라고 함
-- -- 구매 테이블의 FK는 반드시 회원 테이블의 PK로 존재함
-- -- -- 예) 네이버 쇼핑에서 제품을 구매한 기록이 있는 사람은 네이버 쇼핑의 회원이어야 함
-- -- -- 외래키를 사용하면 구매한 기록은 있지만 구매한 사람이 누구인지 알 수 없는 상황은 발생하지 않음
-- -- -- 따라서 구매 테이블의 모든 데이터는 누가 구매했는지 확실하게 알 수 있는 무결한 데이터가 됨
	
-- create table 에서 외래키 제약 조건
-- 기본 형식 : foreign key(열_이름) references 기준_테이블(열_이룸)
-- 구매 테이블의 열(mem_id)이 참조(references)하는 기준 테이블(member)의 열(mem_id)
-- 기준 테이블의 열이 primary key 또는 unique가 아니라면 외래키 관계는 설정되지 않음
drop table if exists buy;

create table buy(
	num int auto_increment not null primary key,
	mem_id char(8) not null,
	prod_name char(6) not null,
	foreign key(mem_id) references member(mem_id)
);
describe buy;

-- alter table에서 외래키 제약조건 설정
drop table if exists buy;

create table buy(
	num int auto_increment not null primary key,
	mem_id char(8) not null,
	prod_name char(6) not null
);

alter table buy  -- buy 테이블을 수정
	add constraint -- 제약 조건을 추가
	foreign key(mem_id) -- 외래키 제약조건을 buy 테이블의 mem_id에 설정
	references member(mem_id); -- 참조할 기준 테이블은 member 테이블의 mem_id열

-- 데이터가 입력된 뒤에 기준 테이블의 열이 변경될 경우
insert into member values("BLK", "블랙핑크", 163);
insert into buy values(null, "BLk", "지갑");
insert into buy values(null, "BLk", "맥북");

-- 내부 조인을 사용해서 물품 정보 및 사용자 정보를 확인
select m.mem_id, m.mem_name, b.prod_name
from buy b
	inner join member m 
	on b.mem_id = m.mem_id;

-- BLK의 아이디를 PINK로 변경
update member set mem_id = "PINK" where mem_id = "BLK";
-- 기본키 외래키로 맺어진 후에는 기준 테이블의 열 이름이 변경되지 않음
-- 열 이름이 변경되면 참조 테이블의 데이터에 문제가 발생하기 때문
-- -- 지금은 회원 테이블의 BLK가 물건을 구매한 기록이 구매 테이블에 존재하기 떄문에 변경이 불가한 것
-- -- 만약 BLK가 물건을 구매한 적이 없다면(구매 테이블에 데이터가 없다면) 회원 테이블의 BLK는 변경 가능








































