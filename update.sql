-- UPDATE 
-- 데이터수정
-- update 의 기본 문법
update 테이블 이름 set 열1 = 값1, 열2 = 값2 ... where 조건;

-- city popul 테이블의 도시 이름 중에서 Seoul을 서울로 변경하기
select * from city_popul where city_name = "seoul";

update city_popul set city_name = "서울" where city_name = "Seoul";
select * from city_popul where city_name = "서울";

-- 한번에 여러 열 수정하기
-- 도시이름 New york 을 뉴욕으로 변경하면서 인구를 0으로 변경
select * from city_popul where city_name = 'new york';
update city_popul set city_name = "뉴욕", population = 0 where city_name = "New York";
select * from city_popul where city_name = '뉴욕';

-- 주의점
-- update문에서 where 절은 생략이 가능하지만, where절을 생략하면 모든 행의 값이 바뀜
select * from city_popul;


-- city_popul 테이블의 인구를 10000명 단위로 변경하는 등의 특수한 경우가 아니라면 주의해야 한다.
update city_popul set population = population / 10000;
select * from city_popul limit 5;