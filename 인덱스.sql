-- 인덱스(index)
-- 데이터를 빠르게 찾을 수 있도록 도와주는 도구
-- 실무에서는 현실적으로 인덱스없이 데이터베이스 운영이 불가

-- 인덱스의 개념
-- 책의 색인 또는 찾아보기와 유사한 개념
-- 예) 책의 내용 중 찾아보고 싶은 내용이 있다면 책의 제일 뒤에 수록되어 있는 색인을 열어보고
-- 원하는 단어를 찾아서 해당 페이지를 빠르게 확인할 수 있음
-- 색인이 없는 책이라면 책을 첫 페이지부터 넘겨가며 확인하는 수 밖에 없음

-- 지금까지 사용한 테이블은 인덱스를 고려하지 않았는데, 이는 색인이 없는 책과 마찬가지로 테이블을 사용한 것임
-- 인덱스가 없었음에도 문제가 되지 않았던 이유는 데이터의 양이 적었기 때문
-- 실무에서 운영하는 테이블에서는 인덱스의 사용 여부에 따라 성능 차이가 날 수 있고,
-- 대용량의 테이블일 경우에는 그 차이가 더욱 커짐
-- -- 인덱스 사용 여부에 따른 결과값의 차이는 없음, 단지 시간이 오래 걸림

-- 인덱스의 문제점
-- 필요 없는 인덱스를 남용하면 데이터베이스의 용량만 늘어나고 속도가 더 느려질 수 있음
-- -- 데이터베이스에 인덱스를 생성해두더라도 mysql이 인덱스를 사용하는 것과 전체 테이블을 검색하는 것 중에
-- -- 더 빠른 방법을 판단해서 사용함
-- -- 사용하지 않는 인덱스를 만들면 쓸데없이 공간낭비만 하게 됨

-- 인덱스의 장점
-- 기존보다 아주 빠른 응답속도를 얻을 수 있음
-- 컴퓨터는 작은 처리량으로 요청한 결과를 빨리 얻을 수 있으니 여유가 생기고 추가로 더 많은 일을 할 수 있게 됨
-- 결과적으로 전체 시스템 성능이 향상됨

-- 인덱스의 단점
-- 인덱스도 공간을 차지하는 데이터이기 때문에 데이터베이스 안에 추가적인 공간이 필요함
-- 처음 인덱스를 만드는 데 시간이 오래 걸릴 수 있음
-- select가 아닌 데이터의 변경 작업이 자주 일어나면 오히려 성능이 나빠질 수 있음

-- 자동으로 생성되는 인덱스
-- 인덱스는 테이블의 컬럼단위에 생성되며, 하나의 열에는 하나의 인덱스만 생성할 수 있음
-- -- 하나의 열에 여러 개의 인덱스를 생성하거나 여러 개의 열을 묶어서 하나의 인덱스를 생성하는 것이 가능은 하지만
-- -- 드문 경우임
-- 테이블에서 기본키를 지정하면 자동으로 클러스터형 인덱스를 생성
-- -- 클러스터형 인덱스 (Clustered Index) : 영어사전처럼 책의 내용이 이미 정렬되어 있는 것
-- 기본키는 테이블에 하나만 지정할 수 있으므로 클러스터형 인덱스는 테이블에 한 개만 만들 수 있음
use market_db;
create table table1(
	col1 int primary key,
	col2 int,
	col3 int
);

-- 테이블의 인덱스 확인
show index from table1;
-- -- Key_name : 'primary'는 '기본키로 설정해서 자동으로 생성된 인덱스'라는 의미(클러스터형 인덱스)
-- -- column_name : 해당 컬럼에 인덱스가 만들어져 있다는 뜻
-- -- non_unlque : 중복이 허용된다 라는 뜻, 0이면 중복이 허용되지 않는다, 1이면 중복이 허용된다.

-- -- 고유 인덱스(Unique Index)
-- -- 인덱스의 값이 중복되지 않는다는 의미이며 반대 의미로는 단순 인덱스(non_Uinque Index)가 있음
-- -- 기본키(Primary key)나 고유키(unique)로 지정하면 값이 중복되지 않으므로 고유 인덱스가 생성됨
-- -- 고유키도 인덱스가 자동으로 생성되며, 고유키로 생성되는 인덱스는 보조 인덱스
-- -- -- 보조 인덱스(Secondary Index) : 책의 색인과 같이 단어를찾고 단어의 주소를찾아야 실제 내용이 있는 형태
create table table2(
	cal1 int primary key,
	cal2 int unique,
	cal3 int unique
);

show index from table2;
-- Key_name에 열 이름이 쓰여진 것은 보조 인덱스
-- 고유키도 중복을 허용하지 않기 때문에 Non_unique가 0
-- 고유키를 여러 개 지정할 수 있듯이 보조 인덱스도 여러개 만들 수 있음

























