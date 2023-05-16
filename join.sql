-- 조인
-- 두 개의 테이블을 서로 묶어서 하나의 결과를 만들어 내는 것
-- ex)인터넷 마켓 데이터베이스의 회원 테이블과 구매 테이블
-- -- 회원 테이블에는 회원의 이름, 연락처
-- -- 구매 테이블에는 구매한 물건에 대한 정보
use market_db;
-- 관계형 db에서 데이터는 주제에 따라 분리해서 저장하고 있고 이 분리된 테이블은 서로 관계를 맺고 있음
-- 테이블의 조인을 위해서는 테이블이 일대다 관계로 연결되어야 함
-- -- 일대다 관계 : 회원 테이블의 아이디에는 하나의 값이 한 번만 등장해야하지만
-- -- 다른 테이블에는 여러 개의 값이 존재할 수 있는 관계
-- -- 예) 회원테이블에서 회원 아이디는 한 번만 등장하지만 구매 테이블에서는 한 아이디를 여러 번 찾을 수 있다.
-- -- 이 때 회원 테이블의 아이디를 기본키(Primary key), 구매 테이블의 아이디를 외래키(Foreign key) 로 지정
-- -- -- 기본키 : 테이블에서 유일한 값으로 각 행의 데이터를 유일하게 확인할 수 있는 값
-- -- -- 외래키 : 두 테이블을 서로 연결하는데 사용되는 키,
-- -- -- 외래키가 포함된 테이블을 자식테이블, 외래키값을 제공하는 테이블을 부모테이블 이라고 함
-- -- -- 유사 사례) 회사원 테이블과 급여 테이블, 학생 테이블과 성적 테이블...

-- 내부 조인
-- 결합 조건을 만족하는 데이터만 선택해서 결합하는 것
-- 조인 중 가장 많이 사용되는 조인
-- 내부조인의 형식
select 열 목록 from 첫 번째 테이블
	inner join 두 번째 테이블
	on 조인될 조건
where 검색 조건;

-- 구매 테이블에서 GRL이라는 아이드를 가진 사람이 구매한 물건을 발송하기 위해서
-- 구매자 이름과 주소, 연락처를 알아야 한다면
select * from buy
	inner join member
	on buy.mem_id  = member.mem_id
where buy.mem_id = "GRL";

-- where 조건절을 생략한다면
select * from buy
	inner join member
	on buy.mem_id  = member.mem_id;

SELECT * FROM buy b 
	inner join `member` m 
	on b.mem_id  = m.mem_id;

-- 필요한 정보만 추출하기
-- mem_id 가 양쪽 테이블에 둘 다 존재해서 에러 발생
select mem_id, mem_name, prod_name, addr, concat(phone1, phone2) 연락처
from buy
	inner join member
	on buy.mem_id = member.mem_id;
-- mem_id 가 양쪽 테이블에 둘 다 존재해서 에러 발생
select buy.mem_id, mem_name, prod_name, addr, concat(phone1, phone2) 연락처
from buy
	inner join member
	on buy.mem_id = member.mem_id;
-- sql문을 더 명확하게 하기 위해서 테이블이름.열이름 형식으로 작성하는 것이 좋음

select buy.mem_id, member.mem_name, buy.prod_name, member.addr concat(member.phone1, member.phone2) 연락처
from buy
	inner join member
	on buy.mem_id = member.mem_id;
-- 코드가 너무 길어지는 문제를 별칭으로 해결

-- 가장 권장되는 sql문
select b.mem_id, m.mem_name, b.prod_name, m.addr, concat(m.phone1, m.phone2) 연락처
from buy b
	inner join member m
	on b.mem_id = m.mem_id;

-- 결과를 회원 id 순으로 정렬
select b.mem_id, m.mem_name, b.prod_name, m.addr, concat(m.phone1, m.phone2) 연락처
from buy b
	inner join member m
	on b.mem_id = m.mem_id
order by m.mem_id asc;

-- 현재는 구매한 기록이 있는 회원들의 목록임
-- 내부 조인 : 두 테이블에 모두 있는 내용만 조인되는 방식
-- 외부 조인 : 양쪽 중 한 곳이라도 내용이 있을 때 조인

-- 외부 조인 형식
select 열 목록
from 첫 번째 테이블(left)
	<left|right> outer join 두 번째 테이블(right)
	on 조인될 조건
where 검색 조건;

-- 구매 기록이 없는 회원을포함해서  전체 회원의 구매 기록 출력
select m.mem_id, m.mem_name, b.prod_name, m.addr
from member m
	left outer join buy b 
	on m.mem_id = b.mem_id
order by m.mem_id asc;

-- 회원가입만 하고 한번도 구매한 적이 없는 회원의 목록 추출
select distinct m.mem_id, m.mem_name, b.prod_name, m.addr
from member m
	left outer join buy b 
	on m.mem_id = b.mem_id
where b.prod_name is null
order by m.mem_id asc;

-- 상호 조인(cross join)
-- 한 쪽 테이블의 모든 행과 다른 쪽 테이블의 모든 행을 조인
-- 상호 조인 결과의 전체 행 수는 두 테이블의 각 행 수의 곱
select * from buy;
select * from member;
select * from buy cross join member;

-- 자체 조인
-- 자신과 자신이 조인
-- 테이블은 1개만 사용
-- 예) 회사의 조직 관계

-- 데이터 생성
create table emp_table(
	emp char(4),
	manager char(4),
	phone varchar(8)
);


insert into emp_table values ("대표", null, '0000');
insert into emp_table values ("영업이사", "대표", '1111');
insert into emp_table values ("관리이사", "대표", '2222');
insert into emp_table values ("정보이사", "대표", '3333');
insert into emp_table values ("영업과장", "영업이사", '1111-1');
insert into emp_table values ("경리부장", "관리이사", '2222-1');
insert into emp_table values ("인사부장", "관리이사", '2222-2');
insert into emp_table values ("개발팀장", "정보이사", '3333-1');
insert into emp_table values ("개발주임", "정보이사", '3333-2');

select * from emp_table;

-- 자체조인의 기본 형식
select 열 목록
from 테이블 별칭A
	inner join 테이블 별칭B 
	on 조인될 조건
where 검색 조건;

-- 경리부장의 직속 상관 연락처를 알고 싶다면
select a.emp 직원, b.emp 직속상관, b.phone 직속상관연락처
from emp_table a
	inner join emp_table b 
	on a.manager = b.emp
where a.emp = "경리부장";


-- 연습문제
-- 1. buy 테이블과 member 테이블 을 이용해서 한번이라도 구매기록이 있는 테이블 추출하기
select distinct b.mem_id, m.addr 
from buy b
	inner join member m
	on b.mem_id = m.mem_id;

CREATE TABLE aac_outcomes (
age_upon_outcome varchar(15) COLLATE utf8mb4_general_ci NOT NULL,
animal_id char(7) COLLATE utf8mb4_general_ci NOT NULL,
animal_type varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
breed varchar(70) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
color varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
date_of_birth datetime NOT NULL,
datetime datetime NOT NULL,
monthyear varchar(90) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
name varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
outcome_subtype varchar(25) COLLATE utf8mb4_general_ci NOT NULL,
outcome_type varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
sex_upon_outcome varchar(20) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 2. 천재지변으로 인해서 데이터가 유실되었습니다.
select outs.animal_id, outs.name, outs.datetime 나간기록, ins.datetime 들어온기록
from aac_outcomes outs
	left outer join aac_intakes ins
	on outs.animal_id = ins.animal_id
where ins.animal_id  is null
order by outs.animal_id ASC;

select outs.animal_id, outs.name, outs.datetime 나간기록, ins.datetime 들어온기록
from aac_outcomes outs
	left outer join aac_intakes ins
	on outs.animal_id = ins.animal_id
where ins.datetime is null
order by outs.animal_id ASC;

-- 3. 관리자의 실수로 일부 동물의 입양일이 잘못 입력되었음
-- 보호 시작일 보다 입양일이 더 빠른 동물들의 아이디와 이름을 조회하는 sql문 작성하기
-- 단 보호 시작일이 빠른 순으로 조회해야함
select outs.animal_id, outs.name, outs.datetime 입양일, ins.datetime 보호시작일
from aac_outcomes outs
	inner join aac_intakes ins 
	on outs.animal_id = ins.animal_id
where outs.datetime < ins.datetime
order by ins.datetime ASC;

-- 4. 아직 입양을 못간 동물중, 가장 오래보호소에 있던 동물 3마리의 이름과 보호 시작일을 조회하는 sql문
select ins.name, ins.datetime
from aac_intakes ins
	left outer join aac_outcomes outs
	on ins.animal_id = outs.animal_id
where outs.datetime is null
# and ins.name != ""
# and ins.name not like "*%"
order by ins.datetime
limit 3;

-- 5. 보호소에서 중성화 수술을 거친 동물 정보를 알아보려 함
-- 보호소에 들어올 당시에는 중성화되지 않았지만
-- 보호소를 나갈 당시에는 중성화된 동물의 데이터를 조회
select outs.animal_id, outs.animal_type, outs.name, ins.sex_upon_intake , outs.sex_upon_outcome
from aac_intakes ins
	inner join aac_outcomes outs
	on ins.animal_id = outs.animal_id
where outs.sex_upon_outcome != ins.sex_upon_intake
order by ins.animal_id ASC;

















