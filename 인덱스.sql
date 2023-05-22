-- 인덱스(index)
-- 데이터를 빠르게 찾을 수 있도록 도와주는 도구
-- 실무에서는 현실적으로 인덱스없이 데이터베이스 운영이 불가

-- 인덱스의 개념
-- 책의 색인 또는 찾아보기와 유사한 개념
-- 예) 책의 내용 중 찾아보고 싶은 내용이 있다면 책의 제일 뒤에 수록되어 있는 색인을 열어보고
-- 원하는 단어를 찾아서 해당 페이지를 빠르게 확인할 수 있음
-- 색인이 없는 책이라면 책을 첫 페이지부터 넘겨가며 확인하는 수 밖에 없음

-- 지금까지 사용한 테이블은 인덱스를 고려하지 않았는데, 이는 색인이 없는 책과 마찬가지로 테이블을 사용한 것임
-- 인덱스가 없었음에도 문제가 되지 않았던 이유는 데이터의 양이 적었기 때문
-- 실무에서 운영하는 테이블에서는 인덱스의 사용 여부에 따라 성능 차이가 날 수 있고,
-- 대용량의 테이블일 경우에는 그 차이가 더욱 커짐
-- -- 인덱스 사용 여부에 따른 결과값의 차이는 없음, 단지 시간이 오래 걸림

-- 인덱스의 문제점
-- 필요 없는 인덱스를 남용하면 데이터베이스의 용량만 늘어나고 속도가 더 느려질 수 있음
-- -- 데이터베이스에 인덱스를 생성해두더라도 mysql이 인덱스를 사용하는 것과 전체 테이블을 검색하는 것 중에
-- -- 더 빠른 방법을 판단해서 사용함
-- -- 사용하지 않는 인덱스를 만들면 쓸데없이 공간낭비만 하게 됨

-- 인덱스의 장점
-- 기존보다 아주 빠른 응답속도를 얻을 수 있음
-- 컴퓨터는 작은 처리량으로 요청한 결과를 빨리 얻을 수 있으니 여유가 생기고 추가로 더 많은 일을 할 수 있게 됨
-- 결과적으로 전체 시스템 성능이 향상됨

-- 인덱스의 단점
-- 인덱스도 공간을 차지하는 데이터이기 때문에 데이터베이스 안에 추가적인 공간이 필요함
-- 처음 인덱스를 만드는 데 시간이 오래 걸릴 수 있음
-- select가 아닌 데이터의 변경 작업이 자주 일어나면 오히려 성능이 나빠질 수 있음

-- 자동으로 생성되는 인덱스
-- 인덱스는 테이블의 컬럼단위에 생성되며, 하나의 열에는 하나의 인덱스만 생성할 수 있음
-- -- 하나의 열에 여러 개의 인덱스를 생성하거나 여러 개의 열을 묶어서 하나의 인덱스를 생성하는 것이 가능은 하지만
-- -- 드문 경우임
-- 테이블에서 기본키를 지정하면 자동으로 클러스터형 인덱스를 생성
-- -- 클러스터형 인덱스 (Clustered Index) : 영어사전처럼 책의 내용이 이미 정렬되어 있는 것
-- 기본키는 테이블에 하나만 지정할 수 있으므로 클러스터형 인덱스는 테이블에 한 개만 만들 수 있음
use market_db;
create table table1(
	col1 int primary key,
	col2 int,
	col3 int
);

-- 테이블의 인덱스 확인
show index from table1;
-- -- Key_name : 'primary'는 '기본키로 설정해서 자동으로 생성된 인덱스'라는 의미(클러스터형 인덱스)
-- -- column_name : 해당 컬럼에 인덱스가 만들어져 있다는 뜻
-- -- non_unlque : 중복이 허용된다 라는 뜻, 0이면 중복이 허용되지 않는다, 1이면 중복이 허용된다.

-- -- 고유 인덱스(Unique Index)
-- -- 인덱스의 값이 중복되지 않는다는 의미이며 반대 의미로는 단순 인덱스(non_Uinque Index)가 있음
-- -- 기본키(Primary key)나 고유키(unique)로 지정하면 값이 중복되지 않으므로 고유 인덱스가 생성됨
-- -- 고유키도 인덱스가 자동으로 생성되며, 고유키로 생성되는 인덱스는 보조 인덱스
-- -- -- 보조 인덱스(Secondary Index) : 책의 색인과 같이 단어를찾고 단어의 주소를찾아야 실제 내용이 있는 형태
create table table2(
	cal1 int primary key,
	cal2 int unique,
	cal3 int unique
);

show index from table2;
-- Key_name에 열 이름이 쓰여진 것은 보조 인덱스
-- 고유키도 중복을 허용하지 않기 때문에 Non_unique가 0
-- 고유키를 여러 개 지정할 수 있듯이 보조 인덱스도 여러개 만들 수 있음

-- 클러스터형 인덱스의 특징
-- 기본키로 지정하면 자동으로 생성됨
-- 테이블에 1개만 생성됨
-- 어떤 열을 기본키로 지정해서 클러스터형 인덱스가 생성되면 그 열을 기준으로 자동 정렬됨
use market_db;
drop table if exists buy, member;
create table member(
	mem_id char(8),
	mem_name varchar(10),
	mem_number int,
	addr char(2)
);
insert into member values ("TWC", "트와이스", 9, "서울");
insert into member values ("BLK", "블랙핑크", 4, "경남");
insert into member values ("WMN", "여자친구", 6, "경기");
insert into member values ("OMY", "오마이걸", 7, "서울");

select * from member;

-- 위의 데이터에 기본키를 설정
alter table member
	add constraint
	primary key (mem_id);

select * from member;
-- 기본키를 설정하면 mem_id를 기준으로 정렬 순서가 바뀜
-- -- mem_id 열을 기본키로 지정하면서 mem_id열에 클러스터형 인덱스가 설정되어 mem_id 열을 기준으로 정렬된 것

-- mem_id의 primary key를 제거하고 mem_name열을 primary key로 지정
alter table member drop primary key; -- 기본키 제거
alter table member
	add constraint
	primary key(mem_name);
select * from member;
-- mem_name열에 클러스터형 인덱스가 생성되었기 때문에 mem_name열을 기준으로 다시 정렬됨

-- 데이터를 추가로 입력하면 기준에 맞춰 자동 정렬
insert into member values ("GRL", "소녀시대", 8, "서울");
select * from member;
-- -- 대용량 데이터가 있는 상태에서 기본키를 변경하면 시간이 오랙 걸릴 수 있음

-- 보조 인덱스의 특징
-- 테이블에 여러 개 설정할 수 있음
-- 보조 인덱스를 만든다고해서 데이터의 순서나 내용이 바뀌지는 않음
drop table member;
create table member(
	mem_id char(8),
	mem_name varchar(10),
	mem_number int,
	addr char(2)
);
insert into member values ("TWC", "트와이스", 9, "서울");
insert into member values ("BLK", "블랙핑크", 4, "경남");
insert into member values ("WMN", "여자친구", 6, "경기");
insert into member values ("OMY", "오마이걸", 7, "서울");
select * from member;

-- mem_id를 고유키로 설정
alter table member
	add constraint
	unique (mem_id);

select * from member;
-- 데이터의 순서에는 변화가 없음
-- -- 보조 인덱스를 생성하더라도 데이터의 순서는 변경되지 않고 별도의 인덱스를 만듦

-- mem_name 열에 추가로 고유키 지정
alter table member
	add constraint
	unique (mem_name);
select * from member;
-- 데이터의 내용과 순서는 그대로이며, mem_id열과 mem_name열에 모두 보조 인덱스가 생성된 상태임

insert into member values ("GRL", "소녀시대", 8, "서울");
select * from member;
-- 새로운 내용이 추가되면 제일 뒤쪽에 추가됨

-- 보조 인덱스는 여러 개 만들 수 있지만, 보조 인덱스를 만들 때 마다 데이터베이스의 공간을 차지하게 되고
-- 전반적으로 시스템에 오히려 나쁜 영향을 미침
-- 그러므로 꼭 필요한 열에만 적절히 보조 인덱스를 생성하는 것이 좋음

-- 인덱스 생성
create [unique] index 인덱스_이름
	on 테이블_이름 (열_이름) [asc|desc];

-- create index로 생성되는 인덱스는 보조 인덱스임
-- unique는 중복이 안되는 고유 인덱스를 생성하는 것. 생략하면 중복을 허용함
-- -- unique 인덱스를 생성하려면 기존에 입력된 값들에 중복이 있으면 안됨
-- -- 인덱스를 생성한 후에 입력되는 데이터와도 중복될 수 없다.
-- asc 또는 desc는 인덱스의 오름차순 또는 내림차순으로 만들어줌
-- -- 기본은 asc로 만들어지며, 굳이 desc로 만드는 경우는 거이 없음

-- 인덱스 제거
drop index 인덱스_이름 on 테이블_이름;
-- 기본키, 고유키로 자동 생성된 인덱스는 drop index로 제거하지 못함
-- -- 자동 생성된 인덱스는 alter table로 기본키나 고유키가 제거되면 함께 제거됨

-- 하나의 테이블에 클러스터형 인덱스와 보조 인덱스가 모두 있는 경우에는
-- 인덱스를 제거할 때 보조 인덱스부터 제거하는 것이 더 좋음
-- -- 클러스터형 인덱스가 제거되면 내부적으로 데이터가 재구성되기 때문

-- 인덱스가 많이 생성되어 있는 테이블은 사용하지 않는 인덱스를 제거해주는 것이 성능 향상에 도움이 됨
use market_db;
select * from member;

show index from member;
-- 현재 member 테이블에는 mem_id 열에 클러스터형 인덱스 1개가 설정되어 있음

-- 인덱스 크기 확인
show table status like 'member'; -- member라는 글자가 들어간 테이블의 정보 라는 의미
-- data_lenght는 클러스터형 인덱스의 크기를 byte 단위로 표기한 것
-- 1페이지는 기본적으로 16kb인데 1kb는 1024byte이므로 16 * 1024 = 16384
-- -- member 테이블의 인덱스는 1페이지가 할당되어 있음
-- index_lenght는 보조 인덱스의 크기인데 member 테이블에는 현재 보조 인덱스가 없기 때문에 표기되지 않음

-- addr 열에 중복을 허용하는 단순 보조 인덱스 생성
create index idx_member_addr
	on member (addr);

show index from member;
-- Non_unique가 1로 설정되어 중복된 데이터를 허용함

-- 전체 인덱스의 크기를 다시 확인
show table status like 'member';
-- 보조 인덱스 idx_member_addr을 생성했음에도 index_lenght가 여전히 0이다.
-- -- 생성한 인덱스를 실제로 적용시키려면 analyze table문을 먼저 실행해야 한다.

analyze table member;
show table status like 'member';

-- mem_number에 중복을 허용하지 않는 고유 보조 인덱스 생성
create unique index idx_member_mem_number
	on member (mem_number);

-- mem_name에 고유 보조 인덱스 생성
create unique index idx_member_mem_name
	on member (mem_name);


show index from member;

insert into member values ("MOO", "마마무", 2, "태국", "001", "12341234", 155, "2020.10.10");
-- mem_name에 고유 보조 인덱스를 생성했기 때문에 mem_name에 중복된 값을 입력할 수 없음
-- -- 실제 서비스에서 심각한 문제가 발생할 수 있기 때문에 고유 보조 인덱스는 업무상 절때로 중복되지 않는 열에만 생성

-- 인덱스의 활용 실습
analyze table member; -- 지금까지 만든 인덱스르 모두 적용
show index from member;

select * from member;
-- 인덱스가 생성된 열 이름이 sql문에 있지 않으면 인덱스를 사용하지 않음

select mem_id, mem_name, addr from member;
-- 열 이름이 select 다음에 나와도 인덱스를 사용하지 않음

select mem_id, mem_name, addr
from member
where mem_name = "에이핑크";
-- where절에 열 이름이 들어 있어야 인덱스를 사용함

select mem_name, mem_number from member where mem_number >= 7;

create index idx_member_mem_number
	on member (mem_number);
analyze table member;

select mem_name, mem_number from member where mem_number >= 7;
-- 숫자의 범위로 조회하는 것도 인덱스를 사용함

-- 인덱스를 사용하지 않는 경우
-- 인덱스가 있고 where절에 열이름이 나와도 인덱스를 사용하지 않는 경우가 있음
select mem_name, mem_number from member where mem_number >= 1;
-- mysql이 인덱스 검색보다 전체 테이블 검색이 낫다고 판단해서 전체 테이블 검색을 수행함
-- -- 대부분의 행을 가져와야 하므로 그냥 전체 데이터를 읽는 것이 더 효율적인 상황

select mem_name, mem_number from member where mem_number * 2 >= 14;
-- where mem_number >= 7로 조회할 때는 인덱스 검색을 했지만 지금은 전체 테이블 검색을 수행함
-- -- where 절에서 열에 연산을 가하면 인덱스를 사용하지 않음

select mem_name, mem_number from member where mem_number >= 14 / 2;
-- 인덱스를 사용함
-- -- where절에 나온 열에는 아무 연산을 하지 않는 것이 좋음

-- 인덱스 제거 실습
show index from member;

-- 클러스터형 인덱스와 보조 인덱스가 섞여 있을 때는 보조 인덱스를 먼저 제거하는 것이 좋음
-- 보조 인덱스 중에는 어떤 것을 제거해도 상관없음
drop index idx_member_mem_name on member;
drop index idx_member_addr on member;
drop index idx_member_mem_number on member;

-- 기본키 지정으로 자동 생성된 클러스터형 인덱스는 drop index로 제거 되지 않고 alter table로 제거해야 한다.
alter table member
	drop primary key;
-- mem_id 열을 buy가 참조하고 있기 때문에 에러 발생
-- -- 기본키를 제거하기 전에 외래키 관계를 먼저 제거해야함

-- 테이블에는 여러 개의 외래키가 있을 수 있기 때문에 먼저 외래키의 이름을 파악해야함
select table_name, constraint_name
from information_schema.referential_constraints
where constraint_schema = 'market_db';
-- information_schema 데이터베이스의 referential_constraints 테이블은
-- mysql에 포함된 시스템 데이터베이스와 테이블
-- -- mysql 전체의 외래키 정보가 들어있음

-- 외래키를 먼저 제거하고 기본키 제거
alter table buy
	drop foreign key buy_ibfk_1;

alter table member
	drop primary key;

-- 인덱스를 효과적으로 사용하는 방법
-- 1. 인덱스는 열 단위에 생성
-- 2. where 절에서 사용되는 열에 인덱스를 생성
-- 3. where 절에서 사용되더라도 자주 사용될수록 인덱스의 가치가 있음
-- -- 만약 select문은 1년에 한 번만 사용되고, insert문이 주로 사용된다면 오히려 인덱스로 인해 성능이 나빠짐
-- 4. 데이터의 중복이 많은 열은 인덱스를 만들어도 효과가 없음
-- 5. 클러스터형 인덱스는 테이블당 하나만 생성할 수 있음
-- -- 클러스터형 인덱스는 보조 인덱스보다 성능이 더 우수함
-- -- 따라서 클러스터형 인덱스는 조회시 가장 많이 사용되는 열에 지정하는 것이 가장 효과적
-- 6. 사용하지 않는 인덱스는 제거
-- -- 공관 확보 뿐만 아니라 데이터 입력 시에 발생하는 부하도 줄일 수 있음