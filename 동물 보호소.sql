use market_db;

-- 3. 동물 보호소에 들어온 모든 동물의 정보를 animal_id 오름차순으로 조회하는 sql문 만들기
select animal_id, animal_type, datetime, intake_condition, name, sex_upon_intake
from aac_intakes order by animal_id;

-- 4. 동물 보호소에 들어온 동물 중에서 intake_condition이 sick인 동물의 데이터를 animal_id의 오름차순으로 조회하기
select animal_id, intake_condition, name
from aac_intakes
where intake_condition = "sick"
order by animal_id ASC;

-- 5. 동물보호소에 들어온 동물 중 intake_condition이 Aged가 아닌 동물들의 정보를 animal_id 오름차순으로 조회하기
select animal_id, intake_condition, name
from aac_intakes
# where intake_condition != "Aged"
# where intake_condition <> "Aged"
where not(intake_condition = "Aged")
order by animal_id ASC;
# not 의 연산자로 != 대신 <> 로 사용할 수 있다. 혹은 not 함수를 이용해 작성할 수 있다.

-- 6. 동물보호소에 들어온 모든 동물의 데이터를 이름의 내림차순으로 조회하기
-- 단, 이름이 같은 동물 중에서는 최근에 보호를 시작한 동물을 먼저 조회하기
select animal_id, datetime, name
from aac_intakes
order by name DESC, datetime DESC;

-- 7. 동물보호소에 가장 먼저 들어온 데이터 조회하기
select name, datetime
from aac_intakes
order by datetime ASC 
limit 1;

-- 8. 동물보호소에 들어온 동물의 이름이 총 종류 있는지 조회하기
select count(name) "이름"
from aac_intakes
where name;

select count(distinct name) from aac_intakes where name != "";

-- 9. 동물보호소에 종 별로 몇 마리인지 조회하기
-- 이때 고양이가 개보다 먼저 등장하도록 정렬
select animal_type, count(*) cnt
from aac_intakes
group by animal_type
order by animal_type ASC;


-- 10. 동물 보호소에 들어온 이름중 두 번 이상 쓰인 이름과 해당 이름이 쓰인 횟수를 조회하기
-- 이때 이름이 없는 동물들은 집계에서 제외하며 이름의 오름차순으로 정렬하기
select name, count(*) cnt
from aac_intakes
where name != ''
group by name
having cnt > 1
order by name;

select name, count(*) cnt
from aac_intakes
where name != '' and name not like "*%"
group by name
having cnt > 1
order by name;












