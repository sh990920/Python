-- tcl연습할 테이블 생성
use market_db;

create table mem_tcl as select mem_id, mem_name, mem_number from member;
drop table mem_ctl;

-- mem_tcl 테이블에 데이터를 입력, 수정, 삭제
insert into mem_tcl value ("ASP", "에스파", 4);

update mem_tcl set mem_number = 5 where mem_name = "에스파";

delete from mem_tcl where mem_name = "에이핑크";

select * from mem_tcl;

-- rollback으로 실행 취소
-- rollback : 현재 트랜잭션에 포함된 데이터 조작 관련 명령어의 수행을 모두 취소
rollback;

select * from mem_tcl;
-- 위에서 실행한 3개의 데이터 조작어는 하나의 트랜잭션에 속해 있음
-- 이 모든 작업을 취소하고 싶다면 rollback을 사용

-- mem_tcl테이블에 데이터를 입력, 수정, 삭제
insert into mem_tcl values ("IVE", "아이브", 6);

update mem_tcl set mem_id = "PINK" where mem_id = "APN";

delete from mem_tcl where mem_id = "BLK";

select * from mem_tcl;

-- commit으로 명령어 반영
commit;

-- commit 명령어는 지금까지 트랜잭션에서 데이터 조작 관련 명령어를 통해 변경된 데이터를 모두
-- 데이터베이스에 영구적으로 반영
-- commit을 사용한 후로는 rollback으로도 되돌릴 수가 없음
-- 실무에서도 commit을 잘못 실행해서 문제가 되는 경우가 많음
-- 트랜잭션 작업이 정상적으로 수행되었다고 확신할 때 사용해야함

select * from mem_tcl;

delete from mem_tcl where mem_id = "IVE";

select * from mem_tcl;
-- dbeaverv에서는 아이브가 삭제된 상태로 조회되고
-- 터미널에서는 아이브가 삭제되기 전 상태로 출력됨

-- dbeaver에서 실행한 delete문의 실행결과가 아직 데이터베이스에 반영되지 않았기 때문(commit이 되지 않았기 때문)
-- 어떤 데이터 조작이 포함된 트랜잭션이 완료되기 전까지는 데이터를 직접 조작하는 세션 외의 다른 세선에서는
-- 데이터 조작 전의 상태가 일관적으로 조회, 출력, 검색되는 특성이 읽기 일관성이다.(read consistency)

commit;

select * from mem_tcl;

-- commit을 실행한 이후에는 delete문 수행 결과가 데이터베이스에 완전히 반영되어서
-- 다른 세션에서도 아이브가 삭제된 상태로 조회됨

-- 하나의 데이터베이스에는 수많은 세션이 연결되고 각 세션에서는 데이터 조작 명령어가 포함된 여러 트랜잭션이
-- 끊임없이 시작되고 종료되면서 실시간으로 작업이 수행됨
-- 데이터를 직접 변경중인 해당 세션을 제외한 모든 세션은 다른 세션의 데이터 변경과 상관없이 이미 확정된 데이터만
-- 검색됨으로써 읽기 일관성을 보장

update mem_tcl set mem_id = "GIRL" where mem_name = "소녀시대";
select * from mem_tcl;

commit;
select * from mem_tcl;

commit;












