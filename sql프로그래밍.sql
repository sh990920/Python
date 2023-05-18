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

-- case 문의 활용
-- 인터넷 마켓 데이터베이스의 회원들의 총 구매액을 계산해서 회원의 등급을 4단계로 나누려고 한다.
-- -- 총 구매액이 1500 이상이면 회원등급은 최우수고객
-- -- 총 구매액이 1000 ~ 1499 면 회원등급은 우수고객
-- -- 총 구매액이 1 ~ 999 면 회원등급은 일반고객
-- -- 총 구매액이 0 이하(구매한적 없음)이면 회원등급은 유령고객
select m.mem_id, m.mem_name, sum(b.price * b.amount) 총구매액
, case 
		when (sum(b.price * b.amount) >= 1500) then '최우수고객'
		when (sum(b.price * b.amount) >= 1000) then '우수고객'
		when (sum(b.price * b.amount) >= 1) then '일반고객'
		else '유령고객'
	end 회원등급
from buy b
	right outer join member m
	on b.mem_id = m.mem_id
group by m.mem_id
order by 총구매액 DESC;

-- while문
-- 필요한 만큼 계속 같은 내용을 반복
-- 조건식이 참인 동안 'sql 문장들'을 계속 반복

-- while문의 기본 형식
while <조건식> do
	sql 문장들
end while;

-- while문을 이용해서 1에서 100까지의 값을 모두 더하는 기능 구현
drop procedure if exists whileProc;
delimiter $$
create procedure whileProc()
begin
	declare i int; -- 1 에서 100까지 증가할 변수
	declare hap int; -- 더한 값을 누적할 변수
	set i = 1;
	set hap = 0;
	
	while(i <= 100) do
		set hap = hap + i; -- hap의 원래 값에 i를 더해서 다시 hap에 넣기
		set i = i + 1; -- i의 원래값에 1을 더해서 i의 값에 넣기
	end while; -- i가 100이하인 동안에 계속 반복
	select '1부터 100까지의 합==>', hap;
end $$
delimiter ;
call whileProc();

-- while문의 응용
-- iterate [레이블] : 지정한 레이블로 돌아가 계속 진행, 파이썬의 continue와 유사
-- leave [레이블] : 지정한 레이블을 빠져나감, 파이썬의 break와 유사

-- 1에서 100까지 합계에서 4의 배수를 제외하고 합게가 1000이 넘으면 더하는 것을 그만두고
-- 1000이 넘는 순간에 숫자를 출력한 후 프로그램 종료
drop procedure if exists whileProc2;
delimiter $$
create procedure whileProc2()
begin
	declare i int; -- 1에서 100까지 증가할 변수
	declare hap int; -- 더한 값에 누적할 변수
	set i = 1;
	set hap = 0;
	
	myWhile: -- while문을 myWhile이라는 레이블로 지정
	while (1 <= 100) do
		if(i % 4 = 0) then
			set i = i + 1;
			iterate myWhile; -- 지정한 레이블로 돌아가서 다시 진행(continue)
		end if;
		set hap = hap + i; -- i가 4의 배수가 아니면 hap에 누적
		if (hap >= 1000) then
			leave myWhile; -- 지정한 label문을 떠남, while문 종료(break)
		end if;
		set i = i + 1;
	end while;
	select '1부터 100까지의 합(4의 배수 제외), 1000 넘으면 종료 -->', hap;
end $$
delimiter ;
call whileProc2();

-- 동적 sql
-- sql문은 내용이 고정되어 있는 경우가 대부분이지만 상황에 따라 내용 변경이 필요할 때
-- 동적 sql을 사용하면 변경되는 내용을 실시간으로 적용시켜 사용할 수 있음

-- prepare와 execute
-- prepare : sql문을 실행하지 않고 미리 준비만 해둠
-- execute : 준비한 sql문을 실행
-- -- 실행한후에는 deallocate prepare로 문장을 해제

use market_db;
prepare myQuery from 'select * from member where mem_id = "blk"';
execute myQuery; -- 실행이 필요한 시점에서 execute myQuery로 실행
deallocate prepare myQuery;

-- 동적 sql의 활용
-- prepare문에서는 ?로 향후에 입력될 값을 비워두고, execute에서 using으로 ?에 값을 전달할 수 있음
-- 실시간으로 필요한 값들을 전달해서 동적으로 sql이 실행

-- 보안이 중요한 출입문에서 출입한 내역을 테이블에 기록하는데
-- 이때 출입증을 태그하는 순간의 날짜와 시간이 insert문으로 입력되도록 코드 작성
drop table if exists gate_table;
-- 출입기록용 테이블 생성
create table gate_table (id int auto_increment primary key, entry_time datetime);

set @curDate = current_timestamp() -- 현재 날짜와 시간

-- ?를 사용해서 entry_time에 입력할 값을 비워둠
prepare myQuery from 'insert into gate_table values(null, ?)';
execute myQuery using @curDate; -- 앞에서 준비한 @curDate변수를 넣은 후 실행
deallocate prepare myQuery;

select * from gate_table;


























