-- DELETE 
-- 데이터 삭제
-- delete문의 기본 문법
delte from 테이블 이름 where 조건;

-- city_popul 테이블에서 "New" 로 시작하는 도시를 삭제하고 싶다면
select * from city_popul where city_name like 'New%';
delete from city_popul where city_name like 'New%';

-- 만약에 'New'로 시작하는 도시 중 상위 몇 건만 삭제하려면 limit와 함께 사용할 수 있다.
delete from city_popul where city_name like 'New%' limit 5;



