-- 스토어드 함수
-- 스토어드 프로시저와 비슷하지만 사용방법과 용도가 조금 다름

-- 스토어드 함수의 개념과 형식
-- 사용자가 직접 만들어서 사용하는 함수를 스토어드 함수(stored function)이라고 함
delimiter $$
create function 스토어드_함수_이름(매개변수)
	returns 반환형식
begin
	프로그래밍 코딩
	return 반환값;
end $$
delimiter ;

select 스토어드_함수_이름();

-- 스토어드 함수와 스토어드 프로시저의 차이점
-- -- 스토어드 함수는 returns로 반환값의 데이터 형식을 지정하고, 본문 안에서는 return으로 하나의 값을 반환해야함
-- -- 스토어드 함수의 매개변수는 모두 입력 매개변수이며, in을 붙이지 않음
-- -- 스토어드 프로시저는 call로 호출하지만, 스토어드 함수는 select문 안에서 호출됨
-- -- 스토어드 프로시저 안에서는 select문을 사용할 수 있지만, 스토어드 함수 안에서는 select를 사용할 수 없음
-- -- 스토어드 프로시저는 여러 sql문이나 숫자 계산 등의 다양한 용도로 사용하지만,
-- -- 스토어드 함수는 어떤 계산을 통해서 하나의 값을 반환하는데 주로 사용

-- 스토어드 함수를 사용하기 위해서는 먼저 스토어드 함수 생성 권한을 허용해줘야 함
set global log_bin_trust_function_creators = 1;

-- 스토어드 함수의 사용
-- 숫자 2개의 합계를 계산하는 스토어드 함수
use market_db;
drop function if exists sumFunc;
delimiter $$
create function sumFunc(number1 int, number2 int) -- 2개의 정수형 매개변수를 전달받음
	returns int -- 반환 데이터의 형식을 정수로 지정
begin
	return number1 + number2; -- 정수형 결과를 반환
end $$
delimiter ;

select sumFunc(100, 200) as '합계'; -- select문에서 호출하면서 개의 매개변수를 전달

-- 데뷔 연도를 입력하면 활동기간이 얼마나 오래 되었는지 출력해주는 함수
-- 함수명 : calcYearFunc;
-- 테스트 코드 : select calcYearFunc(2010); -- 현재 연도 - 데뷔연도 --> int
drop function if exists calcYearFunc;
delimiter $$
create function calcYearFunc(debutYear int)
	returns int
begin
	return year(curdate()) - debutYear;
end $$
delimiter ;

select concat(calcYearFunc(2018), "년") as "활동 기간";

-- 강사님 코드
drop function if exists calcYearFunc;
delimiter $$
create function calcYearFunc(dYear int) -- 데뷔연도를 매개변수로 받음
	returns int
begin
	declare runYear int; -- 활동기간(연도)
	set runYear = year(curdate()) - dYear; -- 실제로 계산을 진행(현재연도 - 데뷔연도)
	return runYear; -- 계산된 결과를 반환
end $$
delimiter ;

select calcYearFunc(2010);

-- 함수의 반환 값을 select ~ into ~ 로 저장했다가 사용할 수도 있음
select calcYearFunc(2007) into @debut2007;
select calcYearFunc(2013) into @debut2013;
select @debut2007 - @debut2013 as '2007과 2013의 차이';


-- member테이블에서 모든 회원이 데뷔한지 몇 년이 되었는지 조회하기
select mem_id, mem_name, calcYearFunc(year(debut_date)) as "활동 햇수" from member;

-- 함수의 삭제
drop function calcYearFunc;

-- 커서(cursor) : 테이블에서 한 행씩 처리하기 위한 방식

-- 커서의 기본 개념
-- 커서는 첫 번째 행을 처리한 후에 마지막 행까지 한 행씩 접근해서 값을 처리함

-- 커서의 작동 순서
-- 1. 커서 선언
-- 2. 반복 조건 설정
-- 3. 커서 열기
-- 4. 데이터 가져오기
-- 5. 데이터 처리하기
-- -- 4 ~ 5번 과정을 반복
-- 6. 커서 닫기

-- 커서는 대부분 스토어드 프로시저와 함께 사용됨

-- 커서의 단계별 실습
-- -- 회원의 평균 인원수를 구하는 스토어드 프로시저를 작성
-- -- -- 단, 커서를 활용하여 한 행씩 접근해서 회원의 인원수를 누적시키는 방법으로 처리

-- 1. 사용할 변수 준비
-- -- 회원의 평균 인원수를 계산하기 위해서 각 회원의 인원수(memNumber), 전체 인원의 합계(totNumber),
-- -- 읽은 행의 수(cnt) 변수를 3개 준비
-- -- 전체 인원의 합계와 읽은 행의 수를 누적시켜야하기 때문에 default를 사용해서 초기값을 0으로 설정
declare memNumber int;
declare cnt int default 0;
declare totNumber int default 0;

-- 행의 끝을 파악하기 위한 변수 endOfRow
declare endOfRow boolean default false;

-- 2. 커서 선언
-- member 테이블을 조회하는 구문을 커서로 선언
declare memberCursor cursor for
	select mem_number from member;

-- 3. 반복 조건 선언
-- 마지막 행에 다다르면 반복을 멈추도록 설정
declare continue handler
	for not found set endOfRow = true;
-- declare continue handler : 반복 조건을 준비하는 예약어
-- for not found : 더 이상 행이 없을 때 뒷 문장을 수행

-- 4. 커서 열기
open memberCursor;

-- 5. 행 반복하기
cursor_loop : loop
	반복할 부분
end loop cursor_loop

-- cursor_loop : 반복할 부분의 이름을 지정한 것
-- 앞 단계에서 행의 끝에 다다르면 endOfRow를 True로 변경하기로 설정했으므로
-- endOfRow가 True가 되면 반복문 종료
if endOfRow then
	leave cursor_loop;
end if;

-- 반복할 부분의 전체 코드
cursor_loop : loop
	fetch memberCursor into memNumber;
	
	if endOfRow then
		leave cursor_loop;
	end if;
	
	set cnt = cnt + 1;
	set totNumber = totNumber + memNumber;
end loop cursor_loop;

-- fatch : 한 행씩 읽어오는 것
-- 2번 과정에서 mem_number 행을 조회하기로 했으므로 memNumber 변수에는 각 회원의 인원수가 한 번에 하나씩 저장됨
-- set 부분에서는 읽은 행의 수(cnt)를 하나씩 증가시키고, 인원수도 totNumber에 누적

-- 반복을 빠져나오면 최종 목표인 평균 인원수를 계산
-- -- 누적된 총 인원수를 읽은 행의 수로 나누기
select (totNumer/cnt) as "회원의 평균 인원 수";

-- 6. 커서 닫기
close memberCursor;


-- 커서 통합 코드
use market_db;
drop procedure if exists cursor_proc;
delimiter $$
create procedure cursor_proc()
begin
	declare memNumber int;
	declare cnt int default 0;
	declare totNumber int default 0;
	declare endOfRow boolean default false;
	
	declare memberCursor cursor for
		select mem_number from member;
	
	declare continue handler
		for not found set endOfRow = true;
	
	open memberCursor;

	cursor_loop: loop
		fetch memberCursor into memNumber;
		
		if endOfRow then
			leave cursor_loop;
		end if;
	
		set cnt = cnt + 1;
		set totNumber = totNumber + memNumber;
	end loop cursor_loop;
	
	select (totNumber/cnt) as "회원의 평균 인원수";

	close memberCursor;
	
end $$
delimiter ;

-- 스토어드 프로시저 실행
call cursor_proc();