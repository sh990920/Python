-- 스토어드 프로시저(stored procedure) 개념과 형식
-- mysql에서 제공하는 프로그래밍 기능
-- 쿼리문의 집합으로 볼 수 있으며, 어떠한 동작을 일괄 처리하기 위한 용도
-- 자주 사용하는 쿼리문은 스토어드 프로시저로 묶어두고 필요할 때마다 간단히 호출하면 편리하게 mysql을 운영할 수 있음
delimiter $$
create procedure 스토어드_프로시저_이름(in 또는 out 매개변수)
begin
	sql 프로그래밍 코드 작성
end $$
delimiter ;

-- delimiter : 구분자. mysql에서 구분자는 기본적으로 세미콜론을 사용하는데,
-- 스토어드 프로시저 안의 sql문에서도 세미콜론을 사용하기 때문에 sql의 끝인지 스토어드 프로시저의 끝인지 모호할 수 있음
-- 따라서 구분자를 $$로 바꿔서 $$가 나올때까지는 스토어드 프로시저가 끝난 것이 아니라는 것을 표시

-- 스토어드 프로시저 호출 형식
call 스토어드_프로시저_이름();

-- 스토어드 프로시저의 생성
use market_db;
drop procedure if exists user_proc;
delimiter $$
create procedure user_proc()
begin
	select * from member;
end $$
delimiter ;

call user_proc();

-- 스토어드 프로시저의 삭제
drop procedure user_proc;
-- create proceduer에서는 스토어드 프로시저 이름 뒤에 괄호를 사용했지만 drop procedure에서는 괄호를 사용하지 않음

-- 스토어드 프로시저 매개변수의 사용
-- 스토어드 프로시저는 실행시 입력 매개변수(parameter)를 지정할 수 있음
in 입력_매개변수_이름 데이터_형식

-- 입력 매개변수가 있는 스토어드 프로시저를 실행하기 위해서는 괄호안에 값을 전달
call 스토어드_프로시저_이름(전달_값);

-- 스토어드 프로시저의 처리 결과를 출력 매개변수를 통해 얻을 수도 있음
-- 출력 매개변수의 형식
out 출력_매개변수_이름 데이터_형식

-- 출력매개변수가 있는 스토어드 프로시저 실행
call 프로시저_이름(@변수명);
select @변수명;

-- 입력 매개변수의 활용
use market_db;
drop procedure if exists user_proc1;
delimiter $$
create procedure user_proc1(in userName varchar(10)) -- 입력 매개변수 userName 지정
begin
	select * from member where mem_name = userName; -- 입력 매개변수에 대한 데이터 조회
end $$
delimiter ;
call user_proc1("에이핑크"); -- '에이핑크'를 입력 매개변수로 전달

-- 2개의 입력 매개변수가 있는 스토어드 프로시저
drop procedure if exists user_porc2;
delimiter $$
create procedure user_proc2(in userNumber int, in userHeight int)
begin
	select * from member where mem_number > userNumber AND height > userHeight;
end $$
delimiter ;

call user_proc2(6, 165); -- userNumber에는 6, userHeigh에는 165가 대입

-- 출력 매개변수 활용
drop procedure if exists user_proc3;
delimiter $$
create procedure user_proc3(in txtValue char(10), out outValue int) -- 출력 매개변수 outValue 지정
begin
	insert into noTable values(null, txtValue);
	select max(id) into outValue from noTable; -- outValue 변수에 id열의 최댓값 저장
end $$
delimiter ;

desc noTable;
-- noTable을 만든 적이 없기 때문에 에러 발생
-- 스토어드 프로시저를 만드는 시점에는 존재하지 않는 테이블을 사용해도 됨
-- -- 단, call로 실행을 하는 시점에는 테이블이 존재해야 함

create table if not exists noTable(
	id int auto_increment primary key,
	txt char(10)
);

-- 출력 매개변수가 있는 스토어드 프로시저 호출
-- 출력 매개변수의 위치에 @변수명 형태로 변수를 전달하면 그 변수에 결과가 저장됨
call user_proc3("테스트1", @myValue);
select concat("입력된 ID 값 ==>", @myValue);
select * from noTable;

