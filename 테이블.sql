-- 테이블
-- 표 형태로 구성된 2차원 구조로, 형과 열로 구성됨
-- 행은 로우(row)나 레코드(record)라고 부르며
-- 열은 컬럼(column) 또는 필드(field)라고 부름
-- 엑셀과 유사한 형태

-- 테이블 만들기
create database naver_db;
use naver_db;
create table member(
	mem_id char(8) 			not null primary key,
	mem_name varchar(10)	not null,
	mem_number tinyint 		not null,
	addr char(2) 			not null,
	phone1 char(3),
	phone2 char(8),
	height tinyint 			unsigned,
	debut_date date
);

create table buy(
	num int 				not null primary key auto_increment,
	mem_id char(8) 			not null,
	prod_name char(6) 		not null,
	group_name char(4),
	price int 				unsigned not null,
	amount smallint 		unsigned not null,
	foreign key (mem_id) references member (mem_id)
);

-- null : 기본값, null값을 허용함
-- not null : null값을 허용하지 않는다, 반드시 값을 넣어야함

insert into member values("TWC", "트와이스", 9, "서울", "02", "11111111", 167, "2015-10-19");
insert into member values("BLK", "블랙핑크", 4, "경남", "055", "22222222", 163, "2016-8-8");
insert into member values("WMN", "여자친구", 6, "경기", "031", "33333333", 166, "2015-1-15");
select * from member;

-- buy 테이블
-- auto_increment 열은 반드시 primary key 또는 unique 로 지정해야함
insert into buy values(null, "BLK", "지갑", null, 30, 2);
insert into buy values(null, "BLK", "맥북프로", "디지털", 1000, 1);
-- 'APN'은 아직 회원에 존재하지 않아서 오류가 발생한다.
insert into buy values(null, "APN", "아이폰", "디지털", 200, 1);
select * from buy;
















