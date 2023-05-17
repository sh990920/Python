-- sql 프로그래밍
-- sql은 다른 프로그래밍 언어와는 많이 다르지만 mysql에서 프로그래밍 기능이 필요하다면
-- 스토어드 프로시저를 사용할 수 있음
-- sql 프로그래밍은 기본적으로 스토어드 프로시저 안에서 만들어야 함

-- 스토어드 프로시저의 구조
-- 스토어드 프로시저는 delimiter $$ ~ end $$ 안에 작성하고 call로 호출
delimiter $$
create procedure 스토어드_프로시저_이름()
begin
	sql 프로그래밍 코딩 영역
end$$ -- 스토어드 프로시저 종료
delimiter ; -- 종료문자를 다시 세미콜론으로 변경
call 스토어드_프로시저_이름(); -- 스토어드 프로시저 실행

-- delimiter : 구문 문자를 정의하는 기능
-- 프로시저 내에서 문장을 구분하기 어렵기 때문에 $$ 를 구문 문자로 정의

-- if문
-- 조건문으로 가장 많이 사용되는 프로그래밍 문법

-- if문의 기본 형식
-- 조건식이 참이라면 'sql 문장들' 을 실행하고, 그렇지 않으면 실행하지 않음
if <조건식> then
	sql 문장들
end if;

-- 위의 'sql 문장들' 이 한 문장이라면 그 문장만 써도 되지만
-- 두 문장 이상이 처리되어야 한다면 begin ~ end 로 묶어야 한다.
drop procedure if exists ifProc1; -- 만약 기존에 ifProc1()을 만든적이 있다면 삭제
delimiter $$ -- 세미콜론으로는 sql의 끝인지 스토어드 프로시저의 끝인지 구분하기 힘들기 때문에 $$를사용
create procedure ifProc1() -- 스토어드 프로시저의 이름은 ifPorc1()
begin
	if 100 = 100 then -- 100과 100이 같다면
		select "100은 100과 같습니다.";
	end if;
end $$
delimiter ;
call ifProc1(); -- ifProc1()을 실행

-- if ~ else 문
-- 조건에 따라 다른 부분을 수행
drop procedure if exists ifProc2;
delimiter $$
create procedure ifProc2()
begin
	declare myNum int; -- myNum 변수 선언, 변수의 데이터 형식은 int
	set myNum = 200; -- myNum에 200을 할당
	if myNum = 100 then -- myNum이 100이라면
		select "100입니다.";
	else
		select "100이 아닙니다.";
	end if;
end $$
delimiter ;
call ifProc2();

-- select ~~ into ~ 문
-- select의 결과를 into 뒤의 변수에 저장
select debut_date into @debutDate from member where mem_id = 'apn';
select @debutDate;
-- 스토어드 프로시저에서 변수는 declare로 선언한 후에 사용하지만
-- 일반 sql에서 변수는 @변수명 으로 지정하고 별도의 선언없이 사용할 수 있음

-- 날짜 관련 함수
-- -- current_date() : 오늘 날짜 가져오기
-- -- current_timestamp() : 오늘 날짜 및 시간을 함께 가져오기
-- -- datediff(날짜1, 날짜2) : 날짜2부터 날짜1까지 일수로 며칠인지 계산하기
select current_date(), datediff('2021-12-31', '2000-1-1');

-- if문의 활용
-- market_db의 member 테이블에서 아이디가 apn인 회원의 데뷔 일자가 5년이 넘었는지 확인해보고
-- 5년이 넘었으면 축하 메시지를 출력('데뷔한지 000일이 지났습니다. 축하합니다!')
-- 5년이 넘지 않았으면 메시지 출력('데뷔한지 000일이 지났습니다. 축하합니다!')
drop procedure if exists ifProc3;
delimiter $$
create procedure ifProc3()
begin
 	declare debutDate date;
	declare toDayDate date;
 	declare days int;
	select debut_date into debutDate from market_db.member where mem_id = 'apn';
	set toDayDate = current_date();
	set days = datediff(toDayDate, debutDate);
	if days >= 365 * 5 then
		select concat("데뷔한지", days, "일이 지났습니다. 축하합니다!");
	else
		select concat("데뷔한지", days, "일이 지났습니다.");
	end if;
end $$
delimiter ;
call ifProc3();

-- 강사님 코드
drop procedure if exists ifProc3;
delimiter $$
create procedure ifProc3()
begin
	declare debutDate date; -- 데뷔일자
	declare curDate date; -- 오늘
	declare days int; -- 활동한 일수
	
	select debut_date into debutDate from market_db.member where mem_id = "apn";
	set curDate = current_date(); -- 현재 날짜
	set days = datediff(curDate, debutDate); -- 날짜 차이
	if (days / 365) >= 5 then -- 5년이 지났다면
		select concat('데뷔한지', days, '일이 지났습니다. 축하합니다!');
	else
		select concat('데뷔한지', days, '일이 지났습니다.');
	end if;
end $$
delimiter ;
call ifProc3();

-- case문
-- 여러 가지 조건 중에서 선택해야 하는 다중 분기에서 사용

-- case문의 기본 형식
case
	when 조건1 then
		sql문장1
	when 조건2 then
		sql문장2
	....
	else
		sql문장n
end case;
-- case와 end case 사이에는 여러 조건들을 넣을 수 있음
-- 조건이 여러개라면 when을 여러번 반복하고 모든 조건에 해당하지 않으면 마지막 else부분을 수행

-- 학점을 부여할 때 90점 이상은 A, 80점 이상은 B, 70점 이상은 C, 60점 이상은 D, 60점 미만은 F로 처리하는 경우
drop procedure if exists caseProc;
delimiter $$
create procedure caseProc()
begin
	declare point int;
	declare credit char(1); -- 학점을 저장할 변수
	set point = 88;
	
	case
		when point >= 90 then
			set credit = "A";
		when point >= 80 then
			set credit = "B";
		when point >= 70 then
			set credit = "C";
		when point >= 60 then
			set credit = "D";
		else
			set credit = "F";
	end case;
	select concat("취득 점수 : ", point, "점"), concat("학점 : ", credit);
end $$
delimiter ; 
call caseProc();














