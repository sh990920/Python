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












