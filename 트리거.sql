-- 트리거 기본
-- 테이블에 어떠한 일이 일어나면 자동으로 실행되는 프로그래밍 기능

-- 트리거의 개요
-- 테이블에 insert, update, delete 작업이 발생하면 실행되는 코드
-- -- 예) market_db의 회원 중 '블랙핑크'가 탈퇴한다면 member 테이블에서 블랙핑크의 정보를 삭제하면 됨
-- -- 하지만 나중에 탈퇴한 사람의 정보를 알아야 한다면 데이터베이스에서 삭제했기 때문에 알 수 있는 방법이 없음
-- -- 이를 방지 하기 위해서 블랙핑크의 행을 삭제하기 전에 그 내용을 다른 곳에 복사하면 됨
-- -- 이런 작업을 매번 수작업으로 하면 데이터를 복사하는 것을 잊어버릴 수도 있음
-- -- 따라서 member에서 delete작업이 일어날 경우 데이터가 삭제되기 전에 다른 곳에 자동으로 저장해주는 기능 구현
-- -- 에 사용되는 것이 트리거

-- 트리거의 기본 작동
-- 트리거는 insert, update, delete 등의 dml(Data Manipulation Language) 이벤트가 발생할 때 작동
-- 테이블에 미리 부착되어있는 프로그램 코드라고도 볼 수 있음

--  스토어드 프로시저와의 차이점
-- 트리거는 call로 직접 실행시킬 수 없고 오직 테이블에 이벤트가 발생할 경우에만 자동으로 실행됨
-- 스토어드 프로시저와는 다르게 트리거에는 in, out 매개변수를 사용할 수 없음

-- 트리거 테스트용 테이블 생성
use market_db;
create table if not exists trigger_table(id int, txt varchar(10));
insert into trigger_table values (1, "레드벨벳");
insert into trigger_table values (2, "잇지");
insert into trigger_table values (3, "블랙핑크");

select * from trigger_table;

-- 테이블에 트리거를 부착
drop trigger if exists myTrigger;
delimiter $$
create trigger myTrigger -- 트리거 이름을 myTrigger로 지정
	after delete -- delete문이 발생한 이후에 작동하라는 의미
	on trigger_table -- 트리거를 부착할 테이블
	for each row -- 각 행마다 적용시킨다는 의미
begin
	set @msg = "가수 그룹이 삭제됨"; -- 트리거 실행시 작동되는 코드들
end  $$
delimiter ;

set @msg = "";
insert into trigger_table values(4, "마마무");
select @msg;

update trigger_table set txt = "블핑" where id = 3;
select @msg;
-- trigger_table에는 delete에만 작동하는 트리거르 부착했기 때문에 insert 문이나 update문에서는
-- 트리거가 작동하지 않음

delete from trigger_table where id = 4;
select @msg;
-- delete문을 실행하면 트리거가 작동해서 @msg 변수에 트리거에서 설정한 내용 입력

-- 트리거 활용
-- 트리거는 테이블에 입력/수정/삭제되는 정보를 백업하는 용도로 활용할 수 있음
-- 예) 은행에서 계좌를 만드는 것은 insert, 입금이나 출금은 update, 폐기는 delete가 작동한다고 할 때
-- 누가 계좌를 생성/수정/삭제했는지 알 수 없다면 계좌에 문제가 발생했을 때 원인을 파악하기 힘듦
-- 이런 상황을 대비해서 데이터에 입력/수정/삭제가 발생할 때 트리거를 자동으로 작동시켜
-- 데이터를 변경한 사용자와 시간 등을 기록

-- market_db의 member에 회원의 정보가 변경될 때 변경한 사용자, 시간, 변경 전의 데이터 등을 기록하는 트리거를 작성
use market_db;
create table singer (select mem_id, mem_name, mem_number, addr from member);
-- 테이블을 복사해서 새로운 테이블 생성

-- 가수 테이블에 insert나 update 작업이 일어나는 경우, 변경되기 전의 데이터를 저장할 백업 테이블 생성
create table backup_singer(
	mem_id char(8) not null,
	mem_name varchar(10) not null,
	mem_number int not null,
	addr char(2) not null,
	modType char(2), -- 변경된 타입, '수정' 또는 '삭제'
	modDate date, -- 변경된 날짜
	modUser varchar(30)-- 변경한 사용자
);













