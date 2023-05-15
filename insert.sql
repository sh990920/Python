-- 데이터 추가, 수정, 삭제

-- insert
-- 데이터 추가

-- insert문의 기본 문법
-- insert into 테이블 (열1, 열2, 열3...) values (값1, 값2, 값3...)

-- 주의점
-- 테이블 이름 다음에 나오는 열은 생략 가능
-- 다만, 생략할 시에는 values 다음에 나오는 값들의 순서와 갯수는 열의 순서 및 개수와 동일해야한다.

create table toy_shop (toy_id int, toy_name char(4), age int);

insert into toy_shop values (1, '우디', 25);
select * from toy_shop;

-- 아이디와 이름만 입력하고 나이는 입력하고싶지 않을 때
insert into toy_shop (toy_id, toy_name) values(2, "버즈");
SELECT * FROM toy_shop;

-- 열의 순서를 바꿔서 입력하는것도 가능함
insert into toy_shop (toy_name, age, toy_id) values ("제시", 20, 3);
select * from toy_shop;

-- 테이블 삭제
drop table toy_shop;

-- auto_increment
-- 자동으로 증가하는 값 입력
-- insert를 사용할 때 해당 열은 입력하지 않아도 자동으로 증가하는 값이 입력됨

-- 주의점
-- auto_increment로 지정하는 열은 반드시 primary key로 지정해야한다.
-- primary key : 각 행을 구분하는 유일한 값

create table toy_shop2 (
	toy_id int auto_increment primary key,
	toy_name char(4),
	age int
);

-- auto_increment 열은 비워두고 데이터 입력하기
insert into toy_shop2 values(null, '보핍', 25);
insert into toy_shop2 values(null, "슬링키", 22);
insert into toy_shop2 values(null, "렉스", 21);
select * from toy_shop2;

-- 어느 숫자까지 증가되었는지 확인
select last_insert_id();

-- auto_increment로 입력되는 다음 값을 100부터 시작하도록 변경하고 싶다면
alter table toy_shop2 auto_increment = 100;
INSERT INTO toy_shop2 values (null, '헴', 35);
select * from toy_shop2;

-- auto_increment로 입력되는 값을 1000으로 지정하고, 3씩 증가하도록 설정
truncate table toy_shop2; -- toy_shop2 테이블 초기화
alter table toy_shop2 auto_increment = 1000;
-- 한번 지정하면 여러테이블에서 사용하는 모든 increment 값이 3씩 증가한다.
set @@auto_increment_increment = 3;

insert into toy_shop2 values (null, '포테이토', 20);
insert into toy_shop2 values (null, '랜디', 23);
insert into toy_shop2 values (null, '알린', 25);
SELECT * from toy_shop2;

-- 여러 건을 한번에 입력
insert into toy_shop2 (toy_name, age) values ('아미맨', 92), ('빌리', 77);

-- insert into ~ select ~
-- 다른 테이블의 데이터를 한 번에 입력
insert into 테이블 이름 (열 이름1, 열 이름2, ...) select ~~

-- 주의점
-- select문의 결과 데이터의 열 갯수는 insert할 테이블의 열 개수와 같아야 한다.

-- world 데이터베이스의 city 테이블의 데이터 개수 조회
select count(*) from world.city;

-- world.city 테이블 프로퍼티 보기
desc world.city;

-- 데이터 살펴보기
select * from world.city limit 5;

-- 테이블 생성
CREATE TABLE city_popul(
	city_name char(35),
	population int
);

insert into city_popul select name, population from world.city;
select * from city_popul order by population DESC;














