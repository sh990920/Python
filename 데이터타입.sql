-- MySQL의 데이터 형식
-- 데이터 형식은 크게 숫자형, 문자형, 날짜형이 있음
-- 실제로 저장될 데이터의 형태가 다양하기 때문에
-- 이를 효율적으로 저장하기 위헤 위의 데이터 형식에서 세부적으로 다시 여러 데이터 형식으로 나뉨
-- 예) 사람의 이름을 저장하기 위해서 100 글자를 저장할 칸을 준비하는 것은 비효율적이다.

-- 정수형
-- -- tinyint (숫자 범위 : -128 ~ 127)
-- -- smallint (숫자 범위 : -32768 ~ 32767)
-- -- int (숫자 범위 : 약 -21억 ~ 21억)
-- -- bigint (숫자 범위 : 약 -900경 ~ 900경)

CREATE TABLE tbl_type(
	tinyint_col tinyint,
	smallint_col SMALLINT,
	int_col int,
	bigint_col bigint
);

-- 각 열의 최댓값 까지는 이상 없이 입력 가능
insert into tbl_type values (127, 32767, 2147483647, 9000000000000000000);
select * from tbl_type;

-- 최댓값에 0을 더 붙여서 입력해보
insert into tbl_type values (1270, 327670, 21474836470, 90000000000000000000);
-- Out of range 에러 : 입력값의 범위를 벗어났다는 뜻


-- 문자형
-- 문자형은 글자를 저장하기 위해서 사용
-- 입력할 최대 글자의 개수를 지정해야 함
-- -- char(개수)
-- -- varchar(개수)

-- char는 Character의 약자로, 고정길이 문자형 이라고 부른다.
-- 자리수가 고정됨
-- ex) char(10)에 "가나다" 3글자만 저장해도 10자리를 모두 확보한 후에 앞의 3자리만 사용하고 뒤의 7자리는 낭비하게 됨

-- varchar는 가변길이 문자형으로, "가나다" 3글자만 저장하면 3자리만 사용함(Variable Character)

-- varchar는 char보다 공간을 더 효율적으로 사용할 수 있지만 MySQL의 처리 속도는 char가 더 빠름
-- 예) 거주 지역 컬럼에 서울/부산/경북/전남 과 같이 모두 2글자로 일정한 경우에는 char(2)로 설정하는 것이 더 좋음
-- 반면에 가수 이름은 글자수가 다양하기 때문에 varchar로 설정하는 것이 더 좋다.

-- 위에서 배운 내용을 바탕으로 member 테이블 생성 코드를 다시 작성
create table member( -- 회원 테이블
	mem_id 		char(8) 	not null 	primary key, 	-- 사용자 아이디(pk)
	mem_name 	varchar(8) 	not null,					-- 이름
	mem_number 	tinyint 	not null,					-- 인원수
	addr 		char(2) 	not null,					-- 지역(경기, 서울, 경남 식으로 2글자만 입력)
	phone1 		char(3),								-- 연락처의 국번(02, 031, 055 등)
	phone2 		char(8),								-- 연락처의 나머지 전화번호(하이픈 제외)
	height 		tinyint 	unsigned,					-- 평균 키
	debut_date 	date									-- 데뷔 일자
);
-- 전화번호는 숫자로서의 의미가 없기 때문에 문자열로 지정
-- 숫자로서의 의미를 가지기 위해서는
-- -- 더하기/빼기 등의 연산에 의미가 있거나
-- -- 크다/작다 또는 순서에 의미가 있어야함

-- 대량의 데이터 형식
-- char 는 최대 255까지, varchar는 최대 16383자 까지 지정이 가능
-- 즉 더 큰 값을 가지는 데이터는 저장할 수 없음
-- 대량 데이터 형식
-- -- text(최대 65535자)
-- -- longtext(약 42억자)
-- -- -- 소설이나 영화 대본 등의 대량의 내용을 저장할 떄 사용한다.
-- -- blob
-- -- -- binary Long Object의 약자
-- -- -- 이미지, 동영상 등의 데이터(이진 데이터)를 저장할 때 사용
-- -- lognblob
-- -- -- longtext 및 longblob은최대 4GB까지 입력 가능

-- 넷플릭스 같은 동영상을 다루는 사이트의 테이블 구성
create database netflix_db;
use netflix_db;
create table movie(
	movie_id 		int,
	movie_title 	varchar(30),
	movie_director 	varchar(20),
	movie_star 		varchar(20),
	movie_script 	longtext,
	movie_film 		longblob
);

-- 실수형
-- 소수점이 있는 숫자를 저장할 때 사용
-- float (소수점 아래 7자리까지 표현)
-- double (소수점 아래 15자리까지 표현)

-- 날짜형
-- 날짜 및 시간을 저장할 때 사
-- date (날짜만 저장. YYYY-MM-DD)형식으로 사용
-- time 시간만 저장. HH-MM-SS 형식으로 사용
-- datetime 날짜및 시간을 저장. YYYY-MM-DD HH:MM:SS 형식으로 사용

-- 변수
-- sql도 다른 프로그래밍 언어처럼 변수를 선언하고 사용할 수 있음

-- 변수 사용 형식
set @변수이름 = 변수의 값;
select @변수이름;

set @myVar1 = 5;
set @myVar2 = 4.25;

select @myVar1;
select @myVar2;

select @myVar1 + @myVar2;

set @txt = '가수 이름--> ';
set @height = 166;
use market_db;
select @txt, mem_name, height
from member
where height > @height;

-- limit 에는 변수 사용이 불가
set @count = 3;

select mem_name, height
from member
order by height
limit @count;

-- 대신에 prepare와 execute를 사용할 수 있음
-- sql문을 실행하지 않고 코드만 준비해두고 execute에서 실행하는 방식

prepare select3 from 'select mem_name, height from member order by height limit ?';
-- select3 라는 이름으로 sql문을 준비만 함
-- ? : 현재는 모르지만 나중에 채워지는 값

execute select3 using @count;
-- using으로 물음표에 @count값을 대입해서 실행
-- 즉, 아래 코드가 실행되는 것과 같은 결과
select mem_name, height from member order by height limit 3;

-- 데이터 형 변환
-- 문자형 데이터를 정수형 데이터로 바꾸거나, 정수형 데이터를 문자형 데이터로 바꾸는 등
-- 데이터의 형식을 변환하는 것을 데이터 형 변환(type conversion)이라고 함
-- 형 변환에는 직접 함수를 사용해서 변환하는 명시적 변환(explicit conversion)과
-- 별도의 지시 없이 자연스럽게 변환되는 암시적 변환(imlicit conversion)이 있음

-- 함수를 이용한 명시적 변환
-- 데이터 형식을 변환하는 함수는 cast() convert() 두가지가 있다.

-- 사용 방식
cast (값 as 데이터_형식(길이))
convert (값, 데이터_형식(길이))

-- 사용 예
-- 데이터가 실수형임
select avg(price) as "평균 가격" from buy;

-- 위의 평균 가격을 정수형으로 표현하고 싶다면
select cast(avg(price) as signed) as "평균 가격" from buy;

select convert(avg(price), signed) as "평균 가격" from buy;
-- signed : 문자 -> 정수값으로 데이터 형 변환

-- 다양한 구분자를 이용한 문자열 데이터를 날짜형으로 변경
select cast('2023$02$04' as date);
select cast('2023/02/04' as date);
select cast('2023%02%04' as date);
select cast('2023@02@04' as date);

-- 결과를 원하는 형태로 표현하고 싶을 때
select num, concat(cast(price as char), 'X', cast(amount as char), '=') "가격X수량",
price * amount "구매액" from buy;

-- 길이 조절을 원한다면 
select num, concat(cast(price as char(2)), 'X', cast(amount as char(1)), '=') "가격X수량",
price * amount "구매액" from buy;

-- 암시적 변환
-- cast()나 convert()함수를 사용하지 않고 자연스럽게 데이터 형태가 변환되는 것
select '100' + '200';
-- 문자는 덧셈이 불가하기 때문에 자동으로 숫자 100과 200으로 변환환 뒤 덧셈을 수행

-- 만약 문자 '100'과 문자 '200'을 연결한 '100200'을 만들려면 concat()을 사용해야 한다.
select concat('100', '200');

-- 숫자와 문자를 concat()함수로 연결한다면
select concat(100, '200');

-- 숫자 100과 문자 '200'을 더한다고 한다면
select 100 + '200';