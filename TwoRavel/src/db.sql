create user t2 identified by java1234;
grant connect, resource, dba to t2;
GRANT CREATE TABLE, CREATE VIEW TO t2;



--관리자
create table tblAdmin (
    id varchar2(30) primary key,
    pw varchar2(30) not null
);

-- 회원
create table tblMember (
    mseq number primary key,
    id varchar2(30) not null,
    pw varchar2(30) not null,
    mname varchar2(15) not null,
    gender varchar2(5) not null,
    mtel varchar2(20) not null,
    mptel varchar2(20),
    jumin varchar2(10) not null,
    maddress varchar2(100) not null,
    email varchar2(30) not null,
    active varchar2(1) default 'y' not null,
    mbti varchar2(4)
);

-- 자유 게시판
create table tblBoard (
    bseq number primary key,                                  
    bcontent varchar2(1000) not null,
    bcount number default 0 not null,
    mseq number not null references tblMember(mseq),
    btitle varchar2(150) not null
);

-- 자유 게시판 댓글
create table tblBComment (
    bcseq number primary key,                                  
    bthread number not null,
    bdepth number not null ,
    bccontent varchar2(300) not null,
    bseq number not null references tblBoard(bseq)
);

-- 일정
create table tblPlan (
    pseq number primary key,
    pstart date not null,
    pend date not null,
    pname varchar2(100) not null,
    pshare varchar2(1) default 'n' not null,
    pconnect varchar2(1) default 'n' not null,
    pmcount number default 1 not null,
    ptheme varchar2(50) default '테마없음' not null
);

-- 해시태그
create table tblHashTag (
hseq number primary key,
hname varchar2(30) not null
);


-- 공유 해시태그
create table tblSHashTag (
shseq number primary key,
hseq number references tblHashTag(hseq) not null,
pseq number references tblPlan(pseq) not null
);

-- 회원일정
create table tblMSchedule (
    msseq number primary key,
    mseq number not null references tblMember(mseq),
    pseq number not null references tblPlan(pseq),
    msauth number default 0 not null
);

-- 일정의견
create table tblOpinion (
    oseq number primary key,
    oid varchar2(30) not null,    
    ocontent varchar2(1000) not null,
    ocheck varchar2(1),
    msseq number not null references tblMSchedule(msseq)
);


drop table tblOpinion;
drop sequence seqOpinion;
create sequence seqOpinion;



select o.*, rank() over (order by oseq asc) as rank from tblOpinion o where msseq = 2;

select oseq from (select o.*, rank() over (order by oseq asc) as rank from tblOpinion o where msseq = 2) where rank = 3; 

select * from tblMschedule ms inner join tblPlan p on ms.pseq = p.pseq inner join tblMember m on ms.mseq = m.mseq where pshare = 'y';




-- 뷰 추가 작성
create or replace view vwAuth as select ms.msseq, p.pseq, m.id, ms.msauth from tblMschedule ms inner join tblPlan p on ms.pseq = p.pseq inner join tblMember m on ms.mseq = m.mseq where pshare = 'y' and ms.msauth = 1;



select id from vwAuth where msseq = 7;




select * from tblMember;
select * from tblOpinion where msseq = 1;

update tblOpinion set ocheck = 'y' where oseq = (select oseq from (select o.*, rank() over (order by oseq asc) as rank from tblOpinion o where msseq = 2) where rank = 3);


-- 회원번호가 1인거

select * from tblOpinion;

-- 여행후기 게시판
create table tblReview (
    rseq number primary key,                                  
    rcontent varchar2(1000) not null,
    rcount number default 0 not null,
    rfile varchar2(300),
    rctitle varchar2(100) not null,
    msseq number not null references tblMSchedule(msseq)
);

-- 후기 댓글
create table tblRComment (
    rcseq number primary key,                                  
    rthread number not null,
    rdepth number not null ,
    rccontent varchar2(300) not null,
    rseq number not null references tblReview(rseq)
);

-- 후기 해시태그
create table tblRHashTag (
rhseq number primary key,
hseq number references tblHashTag(hseq) not null,
rseq number references tblReview(rseq) not null
);

-- 일정 공유 게시판
create table tblShare (
    sseq number primary key,
    slike number default 0 not null,
    scount number default 0 not null,
    shseq number references tblSHashTag(shseq),
    pseq number not null references tblPlan(pseq)
);
select * from vwMyPlan;
select * from tblShare;
-- 찜
create table tblLike (
    lseq number primary key,
    mseq number not null references tblMember(mseq),
    sseq number not null references tblShare(sseq)
);
delete from tblLike;
drop sequence seqlike;
create sequence seqlike;

insert into tblLike values (seqlike.nextval, 40, 46);
insert into tblLike values (seqlike.nextval, 40, 41);
insert into tblLike values (seqlike.nextval, 40, 30);
insert into tblLike values (seqlike.nextval, 40, 45);
insert into tblLike values (seqlike.nextval, 40, 15);

select * from tblMember; 
commit;
select * from tblLike where mseq = 40;

select * from tblShare s inner join (select * from tblLike where mseq = 40) l on s.sseq = l.sseq;
select  *from vwbplan;
select * from tblShare;

commit;

select vp.mseq, pname, vp.pseq, msauth, pstart, pend, pconnect, pmcount, ptheme, locname, vp.slike, vp.scount from vwbplan vp inner join (select * from tblShare s inner join (select * from tblLike where mseq = 40) l on s.sseq = l.sseq) sl on vp.pseq = sl.pseq;


select * from tbllike;

select * from vwbplan v inner join tblShare s on s.pseq = v.pseq where msauth = 1;

select * from tblMember;
--**********************************************************
--찜 정보 (찐 뷰)
create or replace view vwjjim as
select pname, locname, pstart, pend, ptheme, l.mseq as mlseq, l.sseq as sseq, vbp.mseq as authmseq, pconnect, pmcount, co, slike, scount from tblLike l inner join (select * from vwbplan where msauth = 1) vbp on l.sseq = vbp.sseq;
select * from vwjjim where mlseq = 40;

select * from vwjjim;


select * from tbllike l inner join (select * from vwbplan v inner join tblShare s on s.pseq = v.pseq where msauth = 1) vs on vs.sseq = l.sseq;


select pname, locname, pstart, pend, ptheme, l.mseq as mlseq, l.sseq as sseq, vbp.mseq as authmseq, pconnect, pmcount, co, slike, scount from tblLike l inner join (select * from vwbplan where msauth = 1) vbp on l.sseq = vbp.sseq;


select * from tblMember;





-- 지역
create table tblLocal (
 locseq number primary key,
 locname varchar2(30) not null,
 loclat number not null,
 loclng number not null,
 loccode varchar2(20) not null
);


-- 랜드마크
create table tblLandMark (
 lmseq number primary key,
 lmname varchar2(50) not null,
 lmaddress varchar2(200) not null,
 lmcontent varchar2(1000) not null,
 lmcount number not null,
 lmlike number  default 0 not null,
 lmfile varchar2(300) null,
 locseq number references tblLocal(locseq) not null
);

-- 랜드마크 한줄 평
create table tblOneLine (
 olseq number primary key,
 olcontent varchar2(150) not null,
 lmseq number references tblLandMark(lmseq) not null,
 mseq number references tblMember(mseq) not null
);

-- 페스티벌
create table tblFestival (
 feseq number primary key,
 fename varchar2(100) not null,
 feplace varchar2(100) not null,
 festart DATE not null,
 feend DATE not null,
 fecontent varchar2(300) not null,
 fetel varchar2(50),
 fepaddress varchar2(500),
 feaddress varchar2(100) not null,
 felat number not null,
 felng number not null,
 locseq number references tblLocal(locseq) not null
);

-- 숙박시설
create table tblAccom (
    aseq number primary key,
    aname varchar2(100) not null,
    aaddress varchar2(500) not null,
    aprice number not null,
    locseq number references tblLocal(locseq)  not null
);

-- 숙박시설 카테고리
create table tblAcCategory (
 acseq number primary key,
 acname varchar2(30) null
);

-- 숙박시설 정보
create table tblAcInfo (
 aiseq number primary key,
 acseq number references tblAcCategory(acseq) not null,
 aseq number references  tblAccom(aseq) not null
);

-- 장소
create table tblPlace (
 plseq number primary key,
 plname varchar2(100) not null,
 locseq number references tblLocal(locseq) not null,
 pllat number not null,
 pllng number not null,
 ptheme varchar2(50) default '없음' not null
);

-- 동선
create table tblRoute (
 roseq number primary key,
 rotime varchar2(30) null,
 rocost number null,
 plstartseq number references tblPlace(plseq) not null,
 plendseq number references tblPlace(plseq) not null
);

-- 고속버스
create table tblBus (
    busseq number primary key,
    bnum varchar2(10) not null,
    bboard date not null,
    btime number not null,
    bstart number references tblLocal(locseq) not null,
    bend number references tblLocal(locseq) not null
);

-- 항공
create table tblFlight (
    fseq number primary key,
    fnum varchar2(10) not null,
    fboard date not null,
    ftime number not null,
    fstart number references tblLocal(locseq) not null,
    fend number references tblLocal(locseq) not null
);

-- KTX
create table tblTrain (
    trseq number primary key,
    trnum varchar2(10) not null,
    trboard date not null,
    trtime number not null,
    trstart number references tblLocal(locseq) not null,
    trend number references tblLocal(locseq) not null
);

-- 교통
create table tblTransfer (
    tseq number primary key,
    pseq number not null references tblPlan(pseq),
    busseq number references tblBus(busseq),
    fseq number references tblFlight(fseq),
    trseq number references tblTrain(trseq)
);


-- 요일 날짜
create table tblDate (
dseq number primary key,
pseq number references tblPlan(pseq) not null,
dday number not null,
ddate number not null
);


-- 요일 장소
create table tblDPlace (
dpseq number primary key,
dpprice number not null,
dporder number not null,
plseq number references tblPlace(plseq) not null,
dseq number references tblDate(dseq) not null

);


-- 요일 숙박
create table tblDAccom (
daseq number primary key,
dseq number references tblDate(dseq) not null,
aseq number references tblAccom(aseq) not null
);

-- 메모
create table tblMemo (
    meseq number primary key,
    mecontent varchar2(150) not null,
    pseq number not null references tblPlan(pseq)
);

------------------------------------- sequence
create sequence seqRComment;
create sequence seqReview;
create sequence seqBoard;
create sequence seqBComment;
create sequence seqAccom;
create sequence seqAcInfo;
create sequence seqAcCategory;
create sequence seqTransfer;
create sequence seqBus;
create sequence seqFlight;
create sequence seqTrain;
create sequence seqMemo;
create sequence seqPlan;
create sequence seqMSchedule;
create sequence seqOpinion;
create sequence seqShare;
create sequence seqLike;
create sequence seqMember;
create sequence seqAdmin;
create sequence seqDate;
create sequence seqDPlace;
create sequence seqDAccom;
create sequence seqLocal;
create sequence seqFestival;
create sequence seqLandMark;
create sequence seqOneLine;
create sequence seqPlace;
create sequence seqRoute;
create sequence seqSHashTag;
create sequence seqRHashTag;
create sequence seqHashTag;


-- drop

drop table tblRComment;
drop table tblReview;

drop table tblBoard;
drop table tblBComment;

drop table tblAccom;
drop table tblAcInfo;
drop table tblAcCategory;

drop table tblTransfer;
drop table tblBus;
drop table tblFlight;
drop table tblTrain;

drop table tblMemo;
drop table tblPlan;

drop table tblMSchedule;
drop table tblOpinion;
drop table tblShare;
drop table tblLike;
drop table tblMember;
drop table tblAdmin;
drop table tblDate;
drop table tblDPlace;
drop table tblDAccom;
drop table tblLocal;
drop table tblFestival;
drop table tblLandMark;
drop table tblOneLine;
drop table tblPlace;

drop table tblRoute;
drop table tblSHashTag;
drop table tblRHashTag;
drop table tblHashTag;

--
drop sequence seqRComment;
drop sequence seqReview;
drop sequence seqBoard;
drop sequence seqBComment;
drop sequence seqAccom;
drop sequence seqAcInfo;
drop sequence seqAcCategory;
drop sequence seqTransfer;
drop sequence seqBus;
drop sequence seqFlight;
drop sequence seqTrain;
drop sequence seqMemo;
drop sequence seqPlan;
drop sequence seqMSchedule;
drop sequence seqOpinion;
drop sequence seqShare;
drop sequence seqLike;
drop sequence seqMember;
drop sequence seqAdmin;
drop sequence seqDate;
drop sequence seqDPlace;
drop sequence seqDAccom;
drop sequence seqLocal;
drop sequence seqFestival;
drop sequence seqLandMark;
drop sequence seqOneLine;
drop sequence seqPlace;
drop sequence seqRoute;
drop sequence seqSHashTag;
drop sequence seqRHashTag;
drop sequence seqHashTag;

-- delete

delete from tblRComment;
delete from tblReview;
delete from tblBoard;
delete from tblBComment;
delete from tblAccom;
delete from tbllAcInfo;
delete from tblAcCategory;
delete from tblTransfer;
delete from tblFlight;
delete from tblTrain;
delete from tblMemo;
delete from tblPlan;
delete from tblMSchedule;
delete from tblOpinion;
delete from tblShare;
delete from tblLike;
delete from tblMember;
delete from tblAdmin;
delete from tblDate;
delete from tblDPlace;
delete from tblDAccom;
delete from tblLocal;
delete from tblFestival;
delete from tblLandMark;
delete from tblOneLine;
delete from tblPlace;
delete from tblRoute;
delete from tblSHashTag;
delete from tblRHashTag;
delete from tblRHashTag;


select * from tblMember;


















-- 관리자
insert into tblAdmin (id, pw) values ('김설화', '1111');
insert into tblAdmin (id, pw) values ('김지현', '1111');
insert into tblAdmin (id, pw) values ('손영우', '1111');
insert into tblAdmin (id, pw) values ('송영주', '1111');
insert into tblAdmin (id, pw) values ('임동균', '1111');
insert into tblAdmin (id, pw) values ('최유찬', '1111');


-- 회원
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'cqhy66', 'Rw808092','정가도', 'f', '010-9718-7158', '010-6023-8407', '740316', '천안시 서구 청담동', 'dxfd32@naver.com', default, 'ISFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ktne48', 'Gv533918','최하연', 'f', '010-8520-1646', null, '771115', '인천시 광진구 청담동', 'lxae68@gmail.com', default, 'ENFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ewbx86', 'Bz634248','공진연', 'f', '010-7406-6824', null, '940710', '부산시 수지구 대치동', 'fjuz85@naver.com', default, 'INFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'oeux27', 'Kf901402','이연리', 'm', '010-2241-3489', null, '900618', '안산시 북구 동백동', 'htkg71@naver.com', default, 'ISFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ogtk55', 'We571570','정다희', 'f', '010-2623-1194', null, '740611', '광주시 중구 서초동', 'nvya75@gmail.com', default, 'ENFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'kavg77', 'Fu349853','박다예', 'm', '010-4075-4629', '010-6194-3777', '980124', '하남시 광진구 삼성1동', 'pwnb13@gmail.com', default, 'INFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ghfm82', 'Lt716399','정우미', 'm', '010-4702-1138', '010-1120-8602', '791105', '경주시 수지구 잠실7동', 'qtbq34@naver.com', default, 'INTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'uzfh98', 'Ki348858','정하나', 'm', '010-7147-5415', null, '880218', '서울시 중구 오금동', 'fcvs50@yahoo.co.kr', default, 'ISFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'mfiz17', 'Os192712','윤가연', 'm', '010-4427-8033', null, '861222', '군포시 처인구 송파1동', 'ursh65@naver.com', default, 'ESTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'azen54', 'Si434570','정서진', 'f', '010-5103-9791', null, '931102', '인천시 처인구 삼성1동', 'piph60@yahoo.co.kr', default, 'ESTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'qlkg10', 'Qq402984','공연도', 'm', '010-8476-7673', '010-3852-7843', '950504', '경주시 강남구 청담동', 'qgao67@naver.com', default, 'INTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'kduk41', 'Wr379028','김다우', 'f', '010-5355-1412', null, '910808', '동백시 북구 송파1동', 'ipme43@daum.net', default, 'ENTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'cqmv42', 'Ms984058','최우가', 'm', '010-3168-9597', '010-1748-2975', '880427', '군포시 수지구 청담동', 'vleb75@daum.net', default, 'INFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'whsl61', 'Jp868594','박나가', 'm', '010-7641-2820', '010-1472-4989', '770414', '천안시 북구 송파1동', 'sgsk76@yahoo.co.kr', default, 'ESTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'bcbt98', 'Zd450331','박도가', 'm', '010-5840-7149', null, '930625', '경주시 동구 삼성1동', 'gcyd49@naver.com', default, 'ISTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'bjau32', 'Ux933977','정나연', 'f', '010-4142-7771', '010-2039-4843', '980728', '안산시 서초구 삼성1동', 'crjx72@gmail.com', default, 'ENTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'fcbn19', 'Ml680335','이은가', 'm', '010-7856-3484', null, '780902', '하남시 남구 송파1동', 'rfro81@gmail.com', default, 'ENFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'umim71', 'Jf979675','최가리', 'f', '010-4833-2781', null, '941201', '동백시 중구 송파1동', 'cqug96@yahoo.co.kr', default, 'ISFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ldwf58', 'Xf294747','정수도', 'f', '010-1540-7447', '010-1206-5337', '910917', '하남시 강남구 대치동', 'pssh63@daum.net', default, 'ESTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'rzgd89', 'Hs594995','정미진', 'f', '010-1351-8930', null, '970307', '동백시 광진구 송파1동', 'mmot74@daum.net', default, 'ENTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'kslu40', 'Ji835959','정우진', 'f', '010-4055-3723', null, '970907', '경주시 수지구 송파1동', 'buoz64@daum.net', default, 'ENFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'wueq57', 'Ib317958','김예예', 'f', '010-8753-8677', null, '960307', '군포시 강남구 서초동', 'dgbr42@yahoo.co.kr', default, 'ENTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'knnr60', 'Kz170566','이미은', 'f', '010-2261-3427', '010-7538-7520', '841108', '동백시 수지구 삼성1동', 'ahnu17@yahoo.co.kr', default, 'INFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ldtt87', 'Wd260394','박우진', 'f', '010-7991-3561', null, '860906', '용인시 중구 청담동', 'uuag42@yahoo.co.kr', default, 'ESFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'nkuh70', 'Bv767660','최진다', 'f', '010-3017-1997', '010-4556-5191', '790525', '하남시 처인구 삼전동', 'tfbj19@naver.com', default, 'ESTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'vhyf47', 'Nj154445','김연희', 'f', '010-3734-4770', null, '860824', '부산시 서구 오금동', 'oopx57@gmail.com', default, 'ISFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'pban64', 'Xf855715','최다은', 'm', '010-3017-4735', null, '940911', '인천시 처인구 잠실7동', 'xjau63@daum.net', default, 'ISTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'vajv35', 'Zv807804','공서가', 'm', '010-4644-1435', null, '920922', '인천시 처인구 잠실7동', 'rabw98@daum.net', default, 'ENTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'xwvc9', 'Io608370','정하우', 'f', '010-7927-7778', '010-7816-9748', '750711', '천안시 강남구 삼전동', 'frax40@naver.com', default, 'ESFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'udmp98', 'Gt518533','윤미진', 'm', '010-9084-6034', null, '761115', '광주시 성동구 오금동', 'fsdn12@naver.com', default, 'ISFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'afjt42', 'Kl987970','공예희', 'f', '010-4834-7850', null, '810126', '하남시 서구 청담동', 'ucew90@daum.net', default, 'INFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'igsb66', 'Ff741603','윤미희', 'f', '010-5085-3365', '010-6392-2652', '800925', '군포시 광진구 삼성1동', 'qgfv79@gmail.com', default, 'INTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ohle38', 'Lw145591','김리다', 'f', '010-2041-8304', null, '970725', '서울시 광진구 청담동', 'iyit84@daum.net', default, 'ISTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'lnln40', 'Nu491838','박수가', 'f', '010-1492-3614', null, '730426', '안산시 중구 송파1동', 'wpvd30@gmail.com', default, 'ENTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'dfwz18', 'Hi456544','공연우', 'm', '010-8592-1974', '010-9723-9151', '750207', '안산시 중구 서초동', 'cozz78@daum.net', default, 'ENTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ttti73', 'Sm701651','정연우', 'm', '010-4810-2027', null, '861213', '부산시 북구 삼성1동', 'fboj70@naver.com', default, 'ESFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'uytm41', 'Vw779731','정가다', 'f', '010-9364-6254', null, '861221', '수원시 서구 오금동', 'axrv44@daum.net', default, 'INTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'dibq16', 'Sd196767','정나하', 'f', '010-4433-6291', null, '960222', '광주시 강남구 삼성1동', 'kzjv44@daum.net', default, 'ENTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'cbqd70', 'Mk307617','윤우은', 'f', '010-5113-6775', '010-8095-6328', '780504', '용인시 남구 오금동', 'lrde17@gmail.com', default, 'INFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'gwer38', 'Gg185115','홍우예', 'm', '010-6311-5502', null, '940815', '서울시 광진구 삼성1동', 'eenh12@naver.com', default, 'INTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'rlwq11', 'Ag193737','공희연', 'm', '010-8956-6549', null, '870813', '인천시 서초구 서초동', 'qceb19@daum.net', default, 'INFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'hhuw46', 'Wr945579','이하미', 'm', '010-2821-7357', '010-5730-1910', '880919', '안산시 처인구 동백동', 'mtcq38@daum.net', default, 'INTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ahtz66', 'Zb126548','공수리', 'f', '010-1340-5083', null, '790507', '경주시 광진구 삼성1동', 'zwpz19@yahoo.co.kr', default, 'INFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'gyli46', 'Ad712544','윤우연', 'm', '010-4872-7289', null, '960808', '용인시 처인구 삼성1동', 'okiz13@yahoo.co.kr', default, 'INFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ozme3', 'Hh696165','최나예', 'f', '010-7218-9406', '010-9591-9305', '830827', '인천시 중구 송파1동', 'idyo46@gmail.com', default, 'ENFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'nuqk64', 'Wk610527','박다나', 'm', '010-1734-3890', '010-3939-1872', '950112', '수원시 동구 동백동', 'pwga45@gmail.com', default, 'ISFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ogla46', 'Jz259219','홍희다', 'm', '010-3152-8520', null, '760424', '동백시 수지구 동백동', 'smhg30@daum.net', default, 'INTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'kpmq54', 'It875205','이도연', 'm', '010-9245-1311', '010-8515-7091', '841208', '경주시 처인구 삼성1동', 'nwwt36@daum.net', default, 'ENFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'igvi60', 'Ro213886','박도나', 'f', '010-4661-8023', '010-5423-6577', '841022', '광주시 남구 잠실7동', 'eyvn38@daum.net', default, 'ENFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'kqfx25', 'Gh317458','홍다미', 'm', '010-5158-9422', null, '851013', '하남시 서초구 송파1동', 'lrly72@naver.com', default, 'ISFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'pzeg80', 'Wc637410','윤가진', 'm', '010-3487-3442', '010-3590-3776', '970516', '부산시 강남구 청담동', 'hqxp10@daum.net', default, 'ENTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'lctr12', 'Sq490759','김은리', 'f', '010-4087-4783', '010-2230-8049', '831218', '수원시 남구 대치동', 'gbog44@naver.com', default, 'ISFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'dfbm11', 'Rv563538','공연가', 'm', '010-3467-5143', null, '991022', '부산시 북구 삼전동', 'qadq51@gmail.com', default, 'ISFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'dsfd56', 'Lv246324','이우수', 'm', '010-2205-8466', null, '830227', '군포시 광진구 오금동', 'wgff82@yahoo.co.kr', default, 'ENFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'csdy9', 'Fi688300','박서희', 'm', '010-2335-4322', null, '730402', '부산시 강남구 삼전동', 'irxk88@gmail.com', default, 'INTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'rrks89', 'Zq119129','박진희', 'f', '010-3839-6873', null, '961004', '군포시 서초구 오금동', 'lejy71@naver.com', default, 'ENTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'uosi88', 'Gz380493','공수도', 'f', '010-2568-6669', null, '780323', '인천시 동구 서초동', 'rxhn62@naver.com', default, 'ESTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'cjyu28', 'Uq806000','정예우', 'f', '010-9231-9932', null, '991109', '하남시 서초구 오금동', 'pxvb36@naver.com', default, 'ENTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'rqkk12', 'Qm323561','윤가하', 'f', '010-2895-1488', '010-4763-7188', '820916', '서울시 중구 송파1동', 'dvmg79@daum.net', default, 'ISTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'lhza56', 'Bc540941','윤하나', 'f', '010-3788-4055', null, '790602', '동백시 강남구 송파1동', 'nnjd26@daum.net', default, 'ESTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'uvet76', 'Ko254946','최서도', 'f', '010-3020-4598', null, '811108', '천안시 서구 청담동', 'icsa42@yahoo.co.kr', default, 'ENTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'iddt64', 'Fh545131','윤다연', 'f', '010-8683-8194', null, '971104', '인천시 광진구 삼전동', 'mytk20@gmail.com', default, 'INTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'xfpx71', 'Kz839163','이수서', 'm', '010-4941-5867', '010-5134-8485', '821122', '동백시 남구 서초동', 'jnyu79@naver.com', default, 'ISTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'cfgu23', 'Jf457100','윤우하', 'm', '010-2612-9502', null, '900410', '경주시 중구 동백동', 'rmqi65@naver.com', default, 'ENFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'unmo99', 'Gb608112','최예미', 'm', '010-9761-1828', null, '920616', '서울시 남구 삼성1동', 'pskp81@naver.com', default, 'ENTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'xubc19', 'Fw654147','정수희', 'm', '010-9856-2055', null, '970211', '하남시 동구 서초동', 'ptxu29@daum.net', default, 'INTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'rzfy24', 'Ub278412','김도다', 'm', '010-7517-7765', '010-9727-6242', '900524', '경주시 북구 삼성1동', 'wjvh60@yahoo.co.kr', default, 'ENFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'zdad28', 'De855161','최은예', 'f', '010-4960-7483', null, '740916', '용인시 서초구 동백동', 'iltg31@gmail.com', default, 'ESTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'xtnt3', 'Xk359871','윤진도', 'f', '010-5377-9856', null, '910818', '경주시 북구 대치동', 'hnil80@naver.com', default, 'ESTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'xfif32', 'Pv901041','홍진가', 'f', '010-2257-1838', '010-6589-7000', '950406', '광주시 남구 서초동', 'zlti42@gmail.com', default, 'ISFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'qsfz52', 'Gz192051','윤수진', 'f', '010-9035-1552', null, '960106', '수원시 북구 송파1동', 'bcus38@gmail.com', default, 'ESTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'oklo75', 'Ag348786','윤도가', 'f', '010-3012-9847', '010-4264-5052', '750622', '수원시 광진구 삼전동', 'scdl18@naver.com', default, 'INFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'dper97', 'Su557506','공미진', 'm', '010-3522-9746', '010-8732-4607', '750723', '동백시 북구 오금동', 'apcy47@daum.net', default, 'ESFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'cenb5', 'Ui923113','김가하', 'm', '010-3481-7803', null, '790508', '용인시 동구 대치동', 'kbzz31@gmail.com', default, 'ESFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'kxfk93', 'Pv549709','최나우', 'm', '010-3358-9276', null, '980622', '인천시 북구 오금동', 'tahf41@naver.com', default, 'ISFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'nrzs69', 'Uv554735','홍희우', 'f', '010-1971-5308', '010-5236-4533', '910124', '서울시 동구 대치동', 'aydi87@yahoo.co.kr', default, 'ESTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'weug61', 'Py675923','홍수희', 'm', '010-7867-9988', null, '740705', '부산시 처인구 오금동', 'vhvw42@gmail.com', default, 'ESTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'uyoi38', 'Zo682485','최리미', 'm', '010-6071-9037', null, '851212', '광주시 동구 동백동', 'wxut38@naver.com', default, 'INFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'sifh48', 'Zn461957','정우다', 'f', '010-9182-1639', null, '980828', '경주시 서초구 삼전동', 'qixz39@daum.net', default, 'INTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'rccw29', 'Yz711170','최리나', 'm', '010-2701-6094', '010-4262-3087', '801227', '용인시 서초구 청담동', 'nimc71@yahoo.co.kr', default, 'ISTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'bwyb65', 'Fz822170','최희나', 'f', '010-4279-2044', '010-6002-7610', '960720', '용인시 성동구 삼성1동', 'crwz62@gmail.com', default, 'ESTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'nasu21', 'Nv131998','김연연', 'm', '010-5313-9711', '010-8781-5278', '900126', '수원시 중구 동백동', 'lxtl67@naver.com', default, 'ENTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'tcos61', 'Qi586093','윤가하', 'f', '010-8277-5356', null, '761219', '광주시 서초구 동백동', 'nuar55@daum.net', default, 'ESFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'trwj24', 'Mn685398','공은진', 'm', '010-4675-1107', null, '971012', '인천시 처인구 삼전동', 'quaf27@daum.net', default, 'ENTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'dkjr27', 'Gx587335','공리도', 'm', '010-1848-9623', null, '801028', '광주시 중구 동백동', 'xtwl81@yahoo.co.kr', default, 'ENFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'sejq31', 'Hi292867','정도은', 'm', '010-9851-1531', null, '750313', '군포시 북구 삼전동', 'dcrb56@naver.com', default, 'ISFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'sauy32', 'Fq812354','정예희', 'm', '010-8984-7581', '010-4335-5845', '961017', '군포시 남구 동백동', 'bpwd47@naver.com', default, 'ESFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'msjw73', 'Vt658545','최우미', 'm', '010-1392-4236', '010-6516-9186', '950625', '하남시 수지구 대치동', 'qhey11@daum.net', default, 'ENTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'mamy54', 'Ul973332','윤다가', 'f', '010-1172-7663', null, '880316', '천안시 서초구 동백동', 'oyzr75@yahoo.co.kr', default, 'ESTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'cllr40', 'Tv493793','이은은', 'f', '010-5095-8414', null, '860328', '수원시 광진구 잠실7동', 'nhgt67@yahoo.co.kr', default, 'ISTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'waqc61', 'Ya745260','이우다', 'm', '010-8814-3434', null, '900614', '하남시 북구 대치동', 'yzei41@yahoo.co.kr', default, 'ISFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'jamj95', 'Ts452370','김예리', 'm', '010-4369-1706', '010-2305-9356', '951001', '부산시 수지구 동백동', 'kooe82@daum.net', default, 'ESTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'tomj60', 'Nw882405','박예은', 'f', '010-8578-7759', null, '990519', '광주시 광진구 서초동', 'lnfx68@naver.com', default, 'ISFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'vskl89', 'Ne998666','이도하', 'f', '010-3309-3160', null, '860818', '안산시 성동구 삼전동', 'tzhq58@yahoo.co.kr', default, 'INFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'wipi42', 'Xi933148','박가가', 'f', '010-2942-7896', null, '900113', '천안시 서초구 대치동', 'mygl86@naver.com', default, 'ISFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'hiwc65', 'Yy299700','홍수서', 'm', '010-2509-1498', null, '770927', '서울시 동구 동백동', 'uqhv14@daum.net', default, 'ISTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'aspu24', 'Hx867080','윤하하', 'f', '010-4508-2546', null, '830805', '인천시 동구 대치동', 'fsfu26@yahoo.co.kr', default, 'INTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'jevf53', 'Ym931054','정수연', 'm', '010-7348-9665', '010-9481-7072', '980204', '하남시 수지구 삼전동', 'gbhu81@daum.net', default, 'INFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'rtrp44', 'Tq177742','박진도', 'm', '010-5756-3227', null, '951017', '군포시 북구 대치동', 'prwj65@yahoo.co.kr', default, 'ENTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'rqnf28', 'Og132682','박우서', 'f', '010-8460-2130', '010-1477-7065', '781014', '서울시 수지구 잠실7동', 'rkgn70@yahoo.co.kr', default, 'ISTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'fyak68', 'Ya424790','최수다', 'f', '010-8029-9384', null, '831104', '용인시 수지구 삼전동', 'bovo49@naver.com', default, 'ISTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'mjag26', 'Nk565430','김다희', 'f', '010-6813-8565', null, '880418', '부산시 성동구 삼성1동', 'yzls99@daum.net', default, 'ISTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'shnl93', 'Ey876037','공리미', 'f', '010-7635-3189', null, '770113', '서울시 북구 삼전동', 'znxt19@naver.com', default, 'ISFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'fkmf77', 'Pt666658','윤도은', 'f', '010-4938-3571', '010-1021-3051', '940809', '용인시 동구 청담동', 'bgad18@daum.net', default, 'ISFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'wesj83', 'Hy746096','김나은', 'f', '010-4099-2505', null, '930906', '용인시 남구 오금동', 'fxew94@naver.com', default, 'INTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'lrra86', 'Zf161956','윤미연', 'm', '010-6253-9329', null, '860615', '서울시 중구 대치동', 'wzfo99@gmail.com', default, 'INFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'immt81', 'Bx873107','정은은', 'f', '010-6938-6781', null, '760710', '하남시 남구 삼전동', 'ytam40@yahoo.co.kr', default, 'ISFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'hqge8', 'Os344066','박나나', 'f', '010-7979-6014', '010-7633-9386', '900507', '천안시 동구 동백동', 'ahuf59@daum.net', default, 'INTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'qlwn7', 'Dm585252','공도하', 'f', '010-3253-9304', '010-4432-9021', '820101', '부산시 성동구 삼성1동', 'tndw31@naver.com', default, 'ENTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'tcow79', 'Cv400469','최연연', 'm', '010-1266-2845', '010-7896-2607', '920820', '수원시 성동구 삼전동', 'dcnz83@daum.net', default, 'ISFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'xzzl68', 'Kn260430','홍서연', 'm', '010-4418-1746', '010-6545-1559', '811207', '용인시 수지구 동백동', 'cocy68@daum.net', default, 'ISFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ylco6', 'Zx233454','이나나', 'm', '010-8222-4751', null, '820814', '하남시 북구 송파1동', 'dpkz20@gmail.com', default, 'ESFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ifll26', 'Ns699718','홍리은', 'f', '010-9252-8954', null, '911012', '부산시 서초구 잠실7동', 'fweh48@daum.net', default, 'INFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'brlr17', 'Ud843456','윤은다', 'm', '010-1316-8097', '010-9376-9761', '940120', '안산시 강남구 서초동', 'odum60@daum.net', default, 'ISTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'zbud48', 'Ol584188','홍연희', 'f', '010-7213-5166', null, '940527', '동백시 강남구 서초동', 'tvde33@yahoo.co.kr', default, 'ISTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'gbrf92', 'Yw316897','최우가', 'f', '010-6502-5126', null, '771106', '부산시 중구 동백동', 'xvim21@daum.net', default, 'ENTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'vwrp87', 'Ra381783','홍하가', 'm', '010-2061-6422', null, '891220', '인천시 중구 청담동', 'tdvt35@daum.net', default, 'ESTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ajat60', 'Db708405','최진희', 'f', '010-8236-7904', null, '740608', '용인시 서초구 오금동', 'hifa86@naver.com', default, 'ISFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'pgyz62', 'Bt877385','윤연진', 'f', '010-1247-2052', null, '970903', '하남시 중구 잠실7동', 'ucgi52@daum.net', default, 'ESFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'xsom85', 'Jb848720','김희미', 'f', '010-5571-9649', '010-9197-5881', '781005', '용인시 서구 청담동', 'sguo37@yahoo.co.kr', default, 'INFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'wrae20', 'Ma874850','박희미', 'm', '010-2900-5363', null, '840622', '용인시 북구 송파1동', 'ksji58@yahoo.co.kr', default, 'ISTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ewfh76', 'Ga993407','정예서', 'm', '010-5607-6377', null, '850511', '서울시 서초구 동백동', 'uuew60@yahoo.co.kr', default, 'INTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'wxqu9', 'Vn447276','최수우', 'f', '010-4231-6762', null, '841219', '광주시 서초구 대치동', 'ssux30@daum.net', default, 'ESTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'nazl35', 'Zz735595','공나우', 'f', '010-3732-6595', '010-4481-9529', '770204', '인천시 남구 청담동', 'eooj40@daum.net', default, 'ESFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ygpy72', 'Ho154523','박리도', 'm', '010-5136-7422', null, '771016', '하남시 북구 대치동', 'rgqc13@naver.com', default, 'INTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'pudx86', 'Vn447363','이수나', 'f', '010-9442-5769', null, '910326', '안산시 처인구 삼성1동', 'khzi49@naver.com', default, 'ENFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'judn75', 'Si966663','최연우', 'f', '010-5917-6384', null, '930321', '광주시 서구 삼전동', 'fswq14@gmail.com', default, 'ENTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'tmit72', 'Rr878588','정다우', 'm', '010-7615-4897', null, '991123', '인천시 처인구 잠실7동', 'haea50@daum.net', default, 'ESFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ifbu58', 'Ks323167','정서나', 'm', '010-5740-5649', null, '760916', '용인시 처인구 삼전동', 'gwug89@naver.com', default, 'ENFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'noll66', 'Pq683711','이희다', 'f', '010-3438-1051', null, '991127', '수원시 중구 송파1동', 'ndca54@naver.com', default, 'ESTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'xlvj2', 'Nd888388','홍수리', 'm', '010-1028-7160', '010-3434-2256', '800203', '군포시 처인구 서초동', 'cgbn39@yahoo.co.kr', default, 'ESFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'dtul45', 'Tk776167','정가하', 'f', '010-8293-9280', null, '860719', '군포시 서초구 대치동', 'uqlj84@daum.net', default, 'ENTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ucgc22', 'Uo846967','이희미', 'm', '010-3618-4541', null, '861217', '경주시 남구 청담동', 'igrj76@yahoo.co.kr', default, 'ENTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'qldu11', 'Gx779084','정가도', 'm', '010-7988-3417', null, '900120', '광주시 서초구 청담동', 'eqfz34@daum.net', default, 'ENTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'lyzd87', 'Ar221721','공연진', 'f', '010-5049-2941', null, '760916', '안산시 북구 잠실7동', 'sjkz58@daum.net', default, 'ISTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'hkoa28', 'Vr921736','윤수진', 'm', '010-1417-8769', null, '881011', '동백시 광진구 잠실7동', 'csip11@gmail.com', default, 'INTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'hzps81', 'Mg920822','홍가우', 'm', '010-5057-8762', null, '830116', '천안시 동구 삼성1동', 'pdbi10@naver.com', default, 'INTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'utgm43', 'Qa515325','홍수우', 'f', '010-3032-8681', '010-8593-9144', '810115', '동백시 처인구 오금동', 'fsoi70@yahoo.co.kr', default, 'INTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ihwx28', 'Ud604325','김도리', 'm', '010-4376-7925', null, '980109', '군포시 강남구 청담동', 'gqog80@daum.net', default, 'ISFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ytnb45', 'Ag662585','최연은', 'm', '010-9008-6198', '010-9697-6853', '800513', '경주시 처인구 삼전동', 'riyz62@gmail.com', default, 'ISTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ozoe93', 'Kj434679','정다나', 'm', '010-6975-1786', null, '770515', '경주시 서구 삼전동', 'mlmr42@yahoo.co.kr', default, 'ENTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'wpkf59', 'Qm731871','박희수', 'm', '010-4641-8921', null, '751002', '천안시 남구 대치동', 'qypa34@naver.com', default, 'INTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'skog22', 'Im952145','김은연', 'm', '010-2628-6712', null, '770123', '수원시 처인구 청담동', 'ihss26@daum.net', default, 'INFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'svmb59', 'Ix624234','이리가', 'f', '010-7841-7619', '010-4426-4850', '810715', '광주시 서구 삼전동', 'kecp12@gmail.com', default, 'ESFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'xgeq87', 'Yi704288','공수하', 'f', '010-4462-9451', null, '970819', '부산시 서초구 서초동', 'dlba90@yahoo.co.kr', default, 'ENFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'olqt80', 'Ln547415','이예진', 'f', '010-9222-4483', null, '781219', '수원시 처인구 대치동', 'jcuv27@yahoo.co.kr', default, 'ESTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'hnjo61', 'Zp839760','김희미', 'm', '010-1103-8079', '010-1994-9699', '981014', '동백시 동구 삼성1동', 'jcdi46@daum.net', default, 'ISFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'yvgq98', 'Pr875911','정수다', 'm', '010-1965-2351', '010-3925-6930', '991111', '동백시 강남구 잠실7동', 'fsco41@daum.net', default, 'INFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'glmp83', 'Og590914','최희하', 'f', '010-8930-2794', null, '890501', '광주시 북구 청담동', 'semg75@daum.net', default, 'INFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'dbgd5', 'Su409576','최도다', 'f', '010-8369-2939', '010-7210-2448', '770628', '용인시 수지구 청담동', 'bdch23@daum.net', default, 'ENTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'pxca38', 'Xl367457','박나다', 'f', '010-4916-9198', '010-5489-2960', '820310', '동백시 처인구 잠실7동', 'eehc86@naver.com', default, 'ESFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'tkfl87', 'Ez779575','윤하연', 'm', '010-9415-1257', '010-3061-2606', '820521', '서울시 동구 삼성1동', 'pglx57@naver.com', default, 'ISTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'bypp47', 'Wb849431','홍은미', 'f', '010-5831-2593', null, '980307', '부산시 동구 오금동', 'bmqq82@gmail.com', default, 'ESFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'cbvn70', 'Qf262219','홍도서', 'f', '010-5085-1796', null, '840507', '인천시 서구 서초동', 'urff12@yahoo.co.kr', default, 'ENTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ngal42', 'Fg950632','이서희', 'm', '010-8706-1987', null, '811009', '안산시 서구 삼전동', 'hrix31@daum.net', default, 'ISFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'obif89', 'Tz149880','홍미서', 'm', '010-6875-8923', '010-7511-2191', '740101', '천안시 서초구 청담동', 'luxn41@naver.com', default, 'ESTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'dexx88', 'Le892323','김수우', 'm', '010-7534-8242', null, '810119', '안산시 동구 송파1동', 'kacw97@naver.com', default, 'INTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'qsmm14', 'Xc319957','홍진수', 'm', '010-2114-7288', '010-2563-3049', '831202', '서울시 처인구 대치동', 'sbgh18@yahoo.co.kr', default, 'INTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'lmpj15', 'Lh288217','윤은가', 'm', '010-4459-5548', '010-1006-6456', '930613', '천안시 동구 동백동', 'sxij55@gmail.com', default, 'ESTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'fict8', 'Li712324','박우은', 'f', '010-2345-6962', '010-3235-6437', '770402', '인천시 중구 삼전동', 'ywbu71@yahoo.co.kr', default, 'ISFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'igin67', 'Qt946549','김진나', 'f', '010-8192-5586', '010-1480-9978', '760417', '천안시 동구 대치동', 'cjwe82@yahoo.co.kr', default, 'ISFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'dhxv90', 'Jo450805','홍예다', 'f', '010-3143-4630', null, '861003', '경주시 처인구 대치동', 'jcvd84@yahoo.co.kr', default, 'ENTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'zgtm22', 'Ua555278','정서서', 'm', '010-1407-2766', null, '780825', '서울시 동구 오금동', 'elkv76@naver.com', default, 'ISFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'bnna55', 'Yu592175','정다수', 'f', '010-7514-1069', null, '850816', '인천시 중구 송파1동', 'bowb30@gmail.com', default, 'ISFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'bzvg4', 'Hb581507','김우하', 'm', '010-5159-3232', '010-1763-7847', '730104', '천안시 북구 청담동', 'wgmf77@yahoo.co.kr', default, 'ESTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'kuit99', 'Zk537684','홍서우', 'm', '010-4230-2674', null, '861202', '광주시 광진구 삼전동', 'vzga23@daum.net', default, 'ISFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'fihk36', 'Vd741133','최미서', 'f', '010-8325-1633', null, '910715', '안산시 광진구 삼성1동', 'xvht22@naver.com', default, 'ENFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'swjm17', 'Bg776359','최서리', 'f', '010-7817-9730', null, '900720', '천안시 북구 삼성1동', 'xqhu91@gmail.com', default, 'INFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'sgqj56', 'Fb456658','김다리', 'm', '010-6875-3908', '010-2568-2664', '900428', '부산시 서초구 삼성1동', 'ixdz83@daum.net', default, 'ISFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'vgpy27', 'Go402868','최희미', 'f', '010-8858-7737', null, '800212', '인천시 성동구 청담동', 'ivkg29@daum.net', default, 'ENFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'qcrv33', 'Mp270819','박우나', 'f', '010-8609-5806', '010-2831-3687', '810809', '동백시 강남구 송파1동', 'jxza59@yahoo.co.kr', default, 'ISFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'zgge2', 'Qj757907','박서진', 'f', '010-3842-2494', '010-9468-7113', '740814', '하남시 북구 서초동', 'hchr13@daum.net', default, 'INTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'bdkx11', 'Hh240204','공진나', 'm', '010-1265-8497', null, '790416', '인천시 서구 청담동', 'uuaj90@yahoo.co.kr', default, 'ENTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'cvpn2', 'Eb227826','박수다', 'f', '010-7299-8042', null, '800909', '부산시 강남구 삼전동', 'ytbg39@gmail.com', default, 'ENFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'oroq42', 'Tt396588','박진가', 'f', '010-3941-7074', null, '950711', '군포시 강남구 청담동', 'ysug69@yahoo.co.kr', default, 'ENTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'zgzq10', 'Bp426198','김진수', 'm', '010-1860-5410', null, '810208', '경주시 중구 오금동', 'duep76@yahoo.co.kr', default, 'ESTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'rfcu77', 'Tv759945','박리가', 'm', '010-3036-2620', null, '961207', '동백시 서초구 청담동', 'lrzq48@daum.net', default, 'ENTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'yjeh33', 'Bk200516','정진수', 'f', '010-5223-6574', null, '771216', '하남시 중구 송파1동', 'goxd54@gmail.com', default, 'INFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'tjym65', 'Mm659817','공은희', 'f', '010-8499-5744', null, '740806', '천안시 처인구 동백동', 'knco72@daum.net', default, 'ENFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'drto25', 'Dd690922','공연진', 'm', '010-5793-3463', '010-7488-1867', '800419', '광주시 처인구 삼전동', 'hbig57@gmail.com', default, 'ESTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'oebi15', 'Fe322919','공리나', 'm', '010-3783-6972', null, '800417', '동백시 동구 대치동', 'eavb59@yahoo.co.kr', default, 'ESTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'pzqd41', 'Kx805180','정은예', 'f', '010-8352-5330', null, '861214', '서울시 북구 삼전동', 'wjmc83@gmail.com', default, 'ENFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'mqwq35', 'Yt171049','홍연하', 'm', '010-8231-3060', '010-2423-3295', '770309', '서울시 남구 송파1동', 'umtc91@naver.com', default, 'ISFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'jtzo74', 'Uk710309','윤가희', 'm', '010-7123-1547', null, '820819', '안산시 수지구 동백동', 'hpzg71@yahoo.co.kr', default, 'ESFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'nrgj61', 'Dy523475','이리미', 'm', '010-4751-3168', null, '800314', '동백시 강남구 청담동', 'stdg84@yahoo.co.kr', default, 'ISTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'jhzb16', 'Qm222788','최가예', 'f', '010-9243-2041', null, '931005', '안산시 광진구 동백동', 'tylk93@yahoo.co.kr', default, 'ISTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'pyqb82', 'Tc426529','박연수', 'f', '010-1112-9538', null, '830506', '서울시 남구 동백동', 'csxb99@naver.com', default, 'ESFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'dwwb35', 'Bx617624','정연도', 'f', '010-5448-7810', null, '781214', '안산시 강남구 삼전동', 'wicw52@gmail.com', default, 'INTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'dedb80', 'Zr710110','이희리', 'm', '010-8948-3812', null, '730425', '광주시 중구 서초동', 'gknx40@yahoo.co.kr', default, 'ENFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'uzev0', 'Xd864385','윤리가', 'm', '010-1686-1419', null, '760223', '부산시 중구 동백동', 'imgz89@yahoo.co.kr', default, 'ENTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'klpc32', 'Lv407157','정리희', 'm', '010-5038-9036', null, '821009', '하남시 북구 삼전동', 'fyrr39@gmail.com', default, 'ENFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'hlve97', 'Ji910635','홍도은', 'f', '010-2989-4519', '010-5504-2599', '920501', '군포시 동구 청담동', 'qvym46@naver.com', default, 'ESFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'bkqn28', 'Tz273609','김희예', 'm', '010-2784-7261', '010-4053-3960', '961001', '동백시 북구 삼성1동', 'kgoh13@daum.net', default, 'ESFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'nvor30', 'Xt797009','공하수', 'f', '010-7872-3137', null, '760703', '서울시 북구 대치동', 'cwju19@daum.net', default, 'ESFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'mluj49', 'Tj415149','홍진연', 'f', '010-3773-4410', null, '860226', '인천시 광진구 오금동', 'pjtr30@daum.net', default, 'ENTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'llsr83', 'Ha712419','정예가', 'f', '010-4261-5024', null, '971203', '천안시 광진구 동백동', 'zhfv80@yahoo.co.kr', default, 'INFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'wvtl38', 'Ax470682','이은미', 'f', '010-9333-3873', '010-8202-4184', '980317', '수원시 강남구 대치동', 'dltr85@yahoo.co.kr', default, 'ENFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'wejw95', 'Xp347053','공은은', 'f', '010-9579-5311', '010-2225-7104', '840506', '경주시 성동구 잠실7동', 'wbai22@daum.net', default, 'ESTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'wgwf43', 'Ca826593','홍다은', 'f', '010-6519-5193', null, '880502', '부산시 중구 청담동', 'qvzu63@gmail.com', default, 'ENTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'tyte66', 'Rd668093','홍도서', 'm', '010-8562-7582', null, '731216', '인천시 서초구 삼성1동', 'kqku70@yahoo.co.kr', default, 'ISTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'duwd70', 'Zw758405','윤리연', 'm', '010-6001-4808', null, '820918', '수원시 강남구 삼성1동', 'tcyb21@naver.com', default, 'ISTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'pdkn3', 'Rz254984','박미하', 'f', '010-5780-2905', null, '801222', '동백시 중구 삼성1동', 'rhof10@yahoo.co.kr', default, 'ESTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'hiee96', 'Kr636463','이도희', 'm', '010-5932-8053', null, '880717', '인천시 남구 오금동', 'tznc48@daum.net', default, 'INTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'qfgs37', 'Sc236113','김은리', 'f', '010-2905-6819', '010-5479-7960', '800726', '서울시 중구 삼성1동', 'giln71@daum.net', default, 'INTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'lbrw89', 'Oo569317','김하리', 'm', '010-5307-2206', null, '770902', '경주시 동구 삼성1동', 'besn16@naver.com', default, 'ENTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'sxll36', 'Nc657295','이은리', 'm', '010-3584-5335', null, '920205', '수원시 서구 동백동', 'jcct45@daum.net', default, 'ENTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'nzio92', 'Wj468863','박리미', 'm', '010-1668-3199', null, '820111', '수원시 강남구 서초동', 'jjos13@gmail.com', default, 'ESTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'jylk17', 'Dh167025','정나수', 'f', '010-3425-8980', null, '910112', '천안시 서구 오금동', 'mjpt96@gmail.com', default, 'INFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'yjqw74', 'Lt561856','윤나진', 'f', '010-3062-2184', null, '881106', '하남시 강남구 삼성1동', 'fmbk52@gmail.com', default, 'INTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'lwtg94', 'Uq380775','정나가', 'f', '010-2583-4906', null, '950101', '인천시 성동구 삼전동', 'xcoz40@naver.com', default, 'ESFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'fnfp58', 'Tt139143','정예수', 'm', '010-9089-7409', null, '800214', '서울시 중구 삼성1동', 'iror14@yahoo.co.kr', default, 'INTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'lsmy45', 'Du767943','공은도', 'm', '010-9747-4101', null, '730325', '수원시 북구 오금동', 'dxkd31@naver.com', default, 'INFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ocwr55', 'Js503047','윤서나', 'm', '010-2908-3995', null, '801011', '용인시 수지구 서초동', 'cksl39@daum.net', default, 'ISTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'amcn8', 'Ki129907','박도희', 'f', '010-1339-7109', '010-5564-8573', '890728', '부산시 처인구 동백동', 'fcnq27@gmail.com', default, 'ENTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'cfgj71', 'Jn890625','홍연도', 'm', '010-8080-5181', null, '990712', '서울시 남구 잠실7동', 'cpmg95@gmail.com', default, 'INTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'vxqz78', 'Nk191643','박예우', 'm', '010-3641-1112', null, '880209', '하남시 서구 삼성1동', 'uunn11@daum.net', default, 'INFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'yrbt11', 'Sk746133','윤하은', 'f', '010-6291-8617', null, '811019', '동백시 북구 삼전동', 'hvwl17@naver.com', default, 'INTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'mzrm36', 'Pi784459','박다예', 'm', '010-9616-2542', null, '970920', '안산시 서구 대치동', 'exlc25@yahoo.co.kr', default, 'ESTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'vfhj0', 'Sg808407','김예다', 'f', '010-6696-5522', null, '760104', '경주시 동구 삼성1동', 'hmlo80@yahoo.co.kr', default, 'ESTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'iuhm62', 'Pg759947','박예도', 'f', '010-3577-5431', '010-4050-2134', '820302', '인천시 동구 삼전동', 'clcy39@naver.com', default, 'ISFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ojne65', 'Rk436876','이은은', 'm', '010-3018-4308', '010-4806-9385', '970820', '용인시 동구 청담동', 'sdph87@yahoo.co.kr', default, 'INFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'szhf6', 'Jo110087','김수다', 'm', '010-9996-4235', null, '801010', '군포시 광진구 송파1동', 'cgvp19@yahoo.co.kr', default, 'ISFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'omjn67', 'Ao689977','공연도', 'm', '010-2288-9431', null, '840601', '부산시 동구 삼전동', 'pitn74@gmail.com', default, 'INTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'pdlf87', 'Ct343474','정희진', 'f', '010-8731-5461', '010-5510-1140', '851002', '수원시 강남구 삼전동', 'ypak63@yahoo.co.kr', default, 'INFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ezha58', 'Pr258203','홍진은', 'm', '010-3604-3089', null, '850618', '천안시 북구 송파1동', 'mamr62@naver.com', default, 'ISTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'btsa88', 'Md899635','박은수', 'f', '010-6463-6997', null, '780617', '하남시 처인구 삼전동', 'tlwp93@gmail.com', default, 'INFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'unlt93', 'Tb211713','공서서', 'm', '010-4844-7143', '010-8533-8464', '960912', '서울시 수지구 잠실7동', 'apai54@daum.net', default, 'INFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'zslg40', 'Uh827107','공하우', 'm', '010-5613-1250', null, '890718', '안산시 남구 삼전동', 'jsbq22@yahoo.co.kr', default, 'INTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'piol41', 'Vc155867','박서하', 'f', '010-2394-2855', null, '740516', '군포시 중구 서초동', 'vwop98@daum.net', default, 'ENFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'eeqm38', 'Ju266872','이희나', 'f', '010-1667-6513', null, '830315', '인천시 광진구 동백동', 'tkrt32@naver.com', default, 'ESTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'jbwx60', 'Ba788502','김다연', 'f', '010-1407-9860', null, '771117', '서울시 중구 삼전동', 'linj59@naver.com', default, 'ENFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'argm25', 'Cq854539','홍다우', 'f', '010-1540-3221', null, '840819', '부산시 동구 청담동', 'kadl39@naver.com', default, 'ESFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'yuzk9', 'Bj718830','윤서우', 'm', '010-2987-2318', null, '830926', '부산시 강남구 오금동', 'ebwz38@daum.net', default, 'ESFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'qndu81', 'Ge913594','홍하수', 'f', '010-2924-4946', '010-3334-3474', '850318', '서울시 북구 오금동', 'zykg19@daum.net', default, 'ENTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ngth41', 'Rl107239','김도도', 'm', '010-8520-9573', null, '790709', '천안시 동구 삼성1동', 'njbm53@naver.com', default, 'ISTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'xzfc93', 'Up723667','최우다', 'm', '010-7381-3856', null, '770925', '인천시 수지구 오금동', 'kxbc10@daum.net', default, 'ISTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ysju39', 'Yb774272','공미서', 'f', '010-4046-2665', '010-3396-5187', '950911', '군포시 남구 대치동', 'vfgj46@daum.net', default, 'ESFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ueqo42', 'Dn846645','윤수나', 'm', '010-6520-8249', null, '890126', '광주시 중구 송파1동', 'zobh60@naver.com', default, 'ESFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'ffai1', 'Wq898700','윤도희', 'f', '010-7392-5792', null, '740311', '인천시 성동구 동백동', 'zfyi46@daum.net', default, 'ENFP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'meqe38', 'Jk903835','김수미', 'm', '010-9535-9415', '010-8092-8321', '780303', '수원시 북구 잠실7동', 'iqli25@yahoo.co.kr', default, 'ESFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'otkv68', 'Mt772134','김연희', 'f', '010-8620-1773', null, '900922', '동백시 광진구 청담동', 'vajr59@daum.net', default, 'INTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'bbdn42', 'Qj633280','박예가', 'f', '010-2854-9550', null, '860804', '부산시 북구 잠실7동', 'jbde13@naver.com', default, 'ISFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'mmyk62', 'Dc938281','최우가', 'f', '010-3297-4657', null, '990910', '용인시 북구 삼전동', 'mhle42@yahoo.co.kr', default, 'INFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'hvco26', 'Ud782913','윤우나', 'f', '010-9049-5274', '010-6636-7630', '830728', '용인시 동구 동백동', 'iixc47@naver.com', default, 'ENFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'jsln27', 'Ou393634','최예희', 'f', '010-9865-2216', null, '781127', '천안시 동구 서초동', 'pqkv40@yahoo.co.kr', default, 'ESTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'iomk19', 'Hl179786','홍미리', 'm', '010-4929-9789', null, '870811', '광주시 중구 송파1동', 'ujwu57@daum.net', default, 'ISFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'vpgi53', 'Vt535691','박리리', 'f', '010-4575-5634', '010-2875-6780', '800828', '경주시 성동구 서초동', 'egsb46@yahoo.co.kr', default, 'ISFJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'qtkg63', 'Nk757081','홍우수', 'f', '010-9168-5488', null, '980421', '인천시 성동구 동백동', 'bexv13@daum.net', default, 'ESTP');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'aovu38', 'No204605','공하희', 'f', '010-4635-8259', null, '960722', '용인시 동구 동백동', 'gbbm89@gmail.com', default, 'ESTJ');
insert into tblMember (mseq, id, pw, mname, gender, mtel, mptel, jumin, maddress, email, active, mbti) values (seqMember.nextVal, 'zljf68', 'Ej405056','김은서', 'f', '010-6444-8603', null, '800624', '서울시 처인구 삼전동', 'fchi58@yahoo.co.kr', default, 'ESTP');

select * from tblBoard;
-- 자유게시판
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 82, 103, '새로 감성적인 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis.', 4, 214, '친구랑 재미있는 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 70, 223, '친구랑 감성적인 ');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 87, 77, '새로 재미있는 모음집');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio.', 271, 246, '친구랑 사랑스러운 모음집');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', 215, 168, '새로 감성적인 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 97, 112, '새로 사랑스러운 계획을 짜보자');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue.', 219, 152, '혼자 재미있는 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 115, 34, '친구랑 감성적인 계획을 짜보자');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 210, 160, '새로 사랑스러운 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 178, 228, '친구랑 인기있는 모음집');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 78, 167, '새로 사랑스러운 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh.', 85, 22, '친구랑 감성적인 계획을 짜보자');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices.', 129, 177, '새로 인기있는 모음집');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis.', 288, 12, '혼자 사랑스러운 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 208, 48, '친구랑 감성적인 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla.', 104, 108, '혼자 감성적인 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 265, 247, '새로 사랑스러운 ');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Nam tristique tortor eu pede.', 293, 34, '친구랑 사랑스러운 ');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 2, 24, '친구랑 감성적인 ');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue.', 230, 219, '친구랑 감성적인 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.', 203, 156, '새로 감성적인 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 186, 150, '여기에 사랑스러운 ');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo.', 88, 63, '친구랑 감성적인 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst.', 102, 101, '친구랑 사랑스러운 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis.', 294, 171, '새로 감성적인 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 165, 166, '친구랑 재미있는 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', 76, 137, '친구랑 감성적인 ');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo.', 248, 179, '새로 사랑스러운 장소 어디 없나요');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 85, 73, '새로 감성적인 장소 어디 없나요');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor.', 40, 103, '새로 감성적인 모음집');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 273, 246, '친구랑 감성적인 계획을 짜보자');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum.', 292, 227, '친구랑 감성적인 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc.', 179, 221, '혼자 사랑스러운 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum.', 256, 56, '새로 감성적인 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc.', 259, 239, '혼자 감성적인 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 98, 128, '새로 사랑스러운 ');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 94, 177, '친구랑 감성적인 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque.', 108, 134, '새로 인기있는 ');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 56, 33, '새로 감성적인 모음집');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst.', 70, 49, '새로 감성적인 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 294, 114, '새로 감성적인 모음집');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum.', 262, 39, '혼자 재미있는 모음집');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor.', 109, 126, '새로 사랑스러운 모음집');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Nam tristique tortor eu pede.', 294, 98, '혼자 감성적인 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti.', 95, 80, '친구랑 감성적인 계획을 짜보자');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.', 134, 1, '새로 사랑스러운 계획을 짜보자');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 139, 165, '친구랑 재미있는 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 181, 158, '혼자 사랑스러운 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.', 47, 87, '새로 사랑스러운 모음집');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante.', 236, 161, '새로 재미있는 장소 어디 없나요');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui.', 75, 104, '친구랑 재미있는 모음집');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna.', 202, 39, '새로 감성적인 장소 어디 없나요');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 88, 31, '새로 재미있는 ');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet.', 233, 163, '혼자 감성적인 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 72, 121, '새로 감성적인 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum.', 81, 240, '새로 감성적인 모음집');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo.', 298, 93, '여행을 감성적인 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 230, 227, '새로 재미있는 모음집');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo.', 156, 15, '친구랑 사랑스러운 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 68, 196, '새로 감성적인 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo.', 137, 149, '새로 인기있는 장소 어디 없나요');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 146, 49, '새로 사랑스러운 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 224, 248, '새로 감성적인 ');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna.', 269, 76, '혼자 감성적인 ');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 195, 249, '새로 감성적인 모음집');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.', 246, 80, '새로 인기있는 장소 어디 없나요');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor.', 50, 232, '친구랑 재미있는 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 87, 107, '새로 감성적인 계획을 짜보자');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum.', 253, 80, '친구랑 사랑스러운 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero.', 191, 78, '친구랑 재미있는 ');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui.', 9, 205, '새로 감성적인 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', 135, 63, '새로 감성적인 모음집');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem.', 73, 11, '새로 감성적인 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum.', 93, 163, '혼자 재미있는 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 21, 194, '혼자 사랑스러운 모음집');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 65, 231, '새로 감성적인 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.', 71, 38, '1박2일으로 감성적인 ');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 145, 87, '친구랑 감성적인 ');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia.', 100, 202, '장거리로 재미있는 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 18, 34, '새로 사랑스러운 모음집');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis.', 125, 206, '친구랑 재미있는 모음집');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 71, 245, '새로 사랑스러운 장소 어디 없나요');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis.', 174, 229, '새로 사랑스러운 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.', 78, 226, '새로 감성적인 장소 어디 없나요');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo.', 153, 71, '새로 재미있는 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam.', 277, 67, '새로 감성적인 ');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti.', 229, 207, '친구랑 감성적인 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis.', 37, 165, '친구랑 사랑스러운 장소 어디 없나요');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl.', 258, 118, '친구랑 감성적인 ');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna.', 32, 24, '새로 감성적인 장소 어디 없나요');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum.', 197, 50, '친구랑 인기있는 계획을 짜보자');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.', 283, 106, '친구랑 감성적인 계획을 짜보자');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', 184, 92, '혼자 사랑스러운 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 255, 210, '친구랑 계획적인 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh.', 98, 233, '새로 재미있는 계획을 짜보자');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 52, 8, '새로 재미있는 모음집');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl.', 24, 128, '새로 인기있는 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst.', 226, 232, '친구랑 인기있는 카페');
insert into tblBoard (bseq, bcontent, bcount, mseq, btitle) values (seqBoard.nextVal, 'Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst.', 226, 232, '친구랑 인기있는 카페');


-- 자유게시판 댓글
insert into tblBComment values (seqBComment.nextVal, 0, 0, '옛날 부터 추운데 좋네요.', 9);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '저기요 후 쩐다!', 72);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '아 하 쩐다!', 41);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '저기요 부럽다 가봤었어요!', 65);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '와 느낌이 가봤었어요!', 55);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '이거 강원도에서 부럽다.', 61);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '아 강원도에서 어때요?', 31);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '오 나는 언제 가봤었어요!', 34);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재밌는 하 어때요?', 34);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '오 부럽다 여행 가고 싶었던 곳이에요.', 79);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재미있네요 나는 언제 계획이 뭐에요.', 37);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '진짜 하 정보 좀 주세요.', 55);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '와 경기도에서 부럽다.', 36);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '오 느낌이 정보 좀 주세요.', 97);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '저기요 더운데 맛있는 식당이에요.', 62);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '우와 강원도에서 짱이다!', 72);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '하 제주에서 계획이 뭐에요.', 3);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '오 더운데 쩐다!', 62);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '헐 후 계획이 뭐에요.', 96);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '진짜 강원도에서 어때요?', 90);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '옛날 부터 부럽다 짱이다!', 15);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '아 ㅋㅋㅋㅋ 짱이다!', 67);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '헐 부럽다 여행 가고 싶었던 곳이에요.', 45);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '아 하 정보 좀 주세요.', 12);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '나도 더운데 좋네요.', 97);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '진짜 강원도에서 쩐다!', 15);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '옛날 부터 경기도에서 맛있는 식당이에요.', 72);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '진짜 배고픈데 부럽다.', 92);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '이거 더운데 여행 가고 싶었던 곳이에요.', 5);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '와 추운데 좋네요.', 26);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '우와 비용이 짱이다!', 96);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '아 서울에서 가봤었어요!', 46);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '헐 나는 언제 맛있는 식당이에요.', 4);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '진짜 부럽다 정보 좀 주세요.', 32);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '헐 배고픈데 계획이 뭐에요.', 42);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '아 후 좋네요.', 87);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '이거 나는 언제 계획이 뭐에요.', 13);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '우와 경기도에서 맛있는 식당이에요.', 14);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재미있네요 ㅋㅋㅋㅋ 계획이 뭐에요.', 6);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '우와 더운데 맛있는 식당이에요.', 78);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '이거 제주에서 가봤었어요!', 3);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '와 강원도에서 계획이 뭐에요.', 80);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '나도 ㅋㅋㅋㅋ 가봤었어요!', 58);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '진짜 강원도에서 정보 좀 주세요.', 26);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재밌는 후 짱이다!', 76);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재밌는 ㅋㅋㅋㅋ 짱이다!', 11);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '나도 느낌이 여행 가고 싶었던 곳이에요.', 84);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '와 배고픈데 좋네요.', 28);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '오 더운데 계획이 뭐에요.', 91);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '저기요 ㅋㅋㅋㅋ 부럽다.', 11);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '저기요 느낌이 어때요?', 11);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '아 강원도에서 맛있는 식당이에요.', 1);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '헐 더운데 좋네요.', 82);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재밌는 나는 언제 어때요?', 9);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재밌는 후 쩐다!', 17);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '와 제주에서 맛있는 식당이에요.', 45);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '와 제주에서 어때요?', 83);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '진짜 서울에서 쩐다!', 34);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재밌는 부럽다 맛있는 식당이에요.', 74);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재미있네요 후 어때요?', 52);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '와 ㅋㅋㅋㅋ 어때요?', 58);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재미있네요 서울에서 가봤었어요!', 96);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '나도 진짜 부럽다.', 86);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '오 나는 언제 여행 가고 싶었던 곳이에요.', 64);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '와 부럽다 정보 좀 주세요.', 57);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '아 후 가봤었어요!', 27);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '와 진짜 좋네요.', 62);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '진짜 하 어때요?', 35);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '옛날 부터 비용이 좋네요.', 37);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '진짜 나는 언제 계획이 뭐에요.', 5);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '진짜 나는 언제 어때요?', 83);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '나도 나는 언제 가봤었어요!', 1);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '옛날 부터 강원도에서 여행 가고 싶었던 곳이에요.', 34);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '헐 느낌이 여행 가고 싶었던 곳이에요.', 28);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '진짜 더운데 짱이다!', 48);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '나도 비용이 짱이다!', 51);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재밌는 부럽다 정보 좀 주세요.', 47);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '옛날 부터 배고픈데 정보 좀 주세요.', 30);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '하 나는 언제 부럽다.', 36);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '아 추운데 짱이다!', 64);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '이거 진짜 좋네요.', 1);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '오 서울에서 쩐다!', 91);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '저기요 부럽다 짱이다!', 20);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재미있네요 추운데 계획이 뭐에요.', 82);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '옛날 부터 하 정보 좀 주세요.', 79);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '와 서울에서 계획이 뭐에요.', 65);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '헐 ㅋㅋㅋㅋ 어때요?', 88);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재미있네요 서울에서 정보 좀 주세요.', 81);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '하 후 어때요?', 56);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '아 더운데 계획이 뭐에요.', 82);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '옛날 부터 하 좋네요.', 73);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '와 배고픈데 부럽다.', 90);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재미있네요 추운데 쩐다!', 14);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '하 후 맛있는 식당이에요.', 85);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재미있네요 나는 언제 가봤었어요!', 79);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '오 비용이 계획이 뭐에요.', 8);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재미있네요 진짜 가봤었어요!', 60);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '우와 비용이 맛있는 식당이에요.', 96);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '저기요 추운데 정보 좀 주세요.', 56);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '오 ㅋㅋㅋㅋ 계획이 뭐에요.', 18);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '나도 경기도에서 짱이다!', 52);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '이거 느낌이 정보 좀 주세요.', 66);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '저기요 제주에서 가봤었어요!', 55);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '진짜 진짜 가봤었어요!', 54);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재미있네요 강원도에서 좋네요.', 52);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '옛날 부터 비용이 부럽다.', 1);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '옛날 부터 더운데 부럽다.', 9);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '옛날 부터 서울에서 쩐다!', 50);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '와 비용이 어때요?', 84);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '우와 진짜 계획이 뭐에요.', 9);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '우와 진짜 정보 좀 주세요.', 42);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '옛날 부터 배고픈데 여행 가고 싶었던 곳이에요.', 62);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '하 나는 언제 맛있는 식당이에요.', 82);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '이거 비용이 계획이 뭐에요.', 70);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '아 나는 언제 여행 가고 싶었던 곳이에요.', 88);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '오 추운데 어때요?', 51);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재밌는 배고픈데 좋네요.', 15);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '와 부럽다 좋네요.', 32);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '우와 배고픈데 여행 가고 싶었던 곳이에요.', 65);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '오 후 여행 가고 싶었던 곳이에요.', 8);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '이거 배고픈데 가봤었어요!', 91);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '와 하 정보 좀 주세요.', 73);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '나도 강원도에서 부럽다.', 84);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '진짜 느낌이 가봤었어요!', 67);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재미있네요 경기도에서 계획이 뭐에요.', 45);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '진짜 ㅋㅋㅋㅋ 좋네요.', 21);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '진짜 추운데 여행 가고 싶었던 곳이에요.', 95);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '오 하 가봤었어요!', 48);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '오 경기도에서 부럽다.', 18);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '나도 비용이 계획이 뭐에요.', 8);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '아 진짜 어때요?', 45);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '헐 나는 언제 부럽다.', 48);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재밌는 하 정보 좀 주세요.', 77);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '아 하 맛있는 식당이에요.', 6);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '오 느낌이 쩐다!', 81);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '옛날 부터 후 가봤었어요!', 18);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '오 진짜 여행 가고 싶었던 곳이에요.', 73);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재밌는 비용이 짱이다!', 14);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '오 부럽다 부럽다.', 77);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재밌는 진짜 정보 좀 주세요.', 68);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '헐 강원도에서 좋네요.', 60);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '저기요 후 좋네요.', 97);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '하 느낌이 가봤었어요!', 99);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '와 강원도에서 좋네요.', 86);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '와 하 맛있는 식당이에요.', 89);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '우와 더운데 좋네요.', 99);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '헐 비용이 어때요?', 98);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '이거 제주에서 쩐다!', 9);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재밌는 강원도에서 쩐다!', 41);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '옛날 부터 ㅋㅋㅋㅋ 좋네요.', 81);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '아 서울에서 부럽다.', 92);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재밌는 서울에서 부럽다.', 69);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '나도 추운데 가봤었어요!', 33);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '저기요 하 정보 좀 주세요.', 99);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '나도 느낌이 짱이다!', 29);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '와 나는 언제 부럽다.', 98);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재미있네요 제주에서 좋네요.', 50);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재미있네요 추운데 맛있는 식당이에요.', 35);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '나도 제주에서 짱이다!', 93);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '이거 느낌이 부럽다.', 97);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '우와 서울에서 어때요?', 86);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '우와 추운데 계획이 뭐에요.', 74);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '진짜 나는 언제 여행 가고 싶었던 곳이에요.', 37);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '우와 느낌이 어때요?', 60);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '진짜 서울에서 좋네요.', 13);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '와 추운데 가봤었어요!', 21);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재밌는 느낌이 여행 가고 싶었던 곳이에요.', 22);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '와 ㅋㅋㅋㅋ 정보 좀 주세요.', 76);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '아 후 가봤었어요!', 24);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '와 서울에서 계획이 뭐에요.', 21);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '아 서울에서 좋네요.', 63);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '와 서울에서 가봤었어요!', 29);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '저기요 추운데 좋네요.', 26);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재밌는 서울에서 정보 좀 주세요.', 12);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '하 추운데 계획이 뭐에요.', 14);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '이거 서울에서 짱이다!', 73);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '옛날 부터 경기도에서 쩐다!', 66);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재밌는 부럽다 짱이다!', 70);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '와 더운데 쩐다!', 39);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '이거 느낌이 계획이 뭐에요.', 7);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '하 진짜 짱이다!', 22);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '나도 배고픈데 정보 좀 주세요.', 25);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '이거 경기도에서 쩐다!', 82);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '하 진짜 맛있는 식당이에요.', 88);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '진짜 배고픈데 여행 가고 싶었던 곳이에요.', 89);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '우와 비용이 여행 가고 싶었던 곳이에요.', 51);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재밌는 하 좋네요.', 16);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '헐 ㅋㅋㅋㅋ 여행 가고 싶었던 곳이에요.', 4);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '저기요 후 가봤었어요!', 45);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '헐 더운데 쩐다!', 27);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '저기요 나는 언제 부럽다.', 10);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '오 느낌이 여행 가고 싶었던 곳이에요.', 37);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '우와 추운데 정보 좀 주세요.', 93);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재미있네요 ㅋㅋㅋㅋ 좋네요.', 47);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재미있네요 비용이 쩐다!', 15);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '헐 제주에서 좋네요.', 58);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재미있네요 배고픈데 어때요?', 11);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '옛날 부터 더운데 가봤었어요!', 90);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '옛날 부터 강원도에서 부럽다.', 73);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '옛날 부터 나는 언제 부럽다.', 1);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '나도 하 부럽다.', 85);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '나도 비용이 계획이 뭐에요.', 74);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재미있네요 배고픈데 정보 좀 주세요.', 36);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '하 경기도에서 좋네요.', 40);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '이거 배고픈데 부럽다.', 31);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '하 비용이 짱이다!', 38);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '진짜 비용이 좋네요.', 36);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '우와 추운데 맛있는 식당이에요.', 54);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '아 더운데 좋네요.', 82);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '우와 부럽다 가봤었어요!', 28);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '옛날 부터 경기도에서 여행 가고 싶었던 곳이에요.', 98);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '하 제주에서 맛있는 식당이에요.', 98);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '저기요 부럽다 좋네요.', 74);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '오 후 어때요?', 75);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재미있네요 서울에서 계획이 뭐에요.', 47);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '나도 경기도에서 짱이다!', 14);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '아 하 여행 가고 싶었던 곳이에요.', 12);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '이거 더운데 어때요?', 22);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재밌는 제주에서 좋네요.', 82);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '우와 나는 언제 계획이 뭐에요.', 77);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '옛날 부터 더운데 짱이다!', 91);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '오 서울에서 계획이 뭐에요.', 18);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '아 배고픈데 쩐다!', 93);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '하 배고픈데 가봤었어요!', 64);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '오 진짜 좋네요.', 34);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '와 하 정보 좀 주세요.', 90);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '진짜 배고픈데 정보 좀 주세요.', 19);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '헐 부럽다 짱이다!', 83);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '진짜 진짜 좋네요.', 71);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '저기요 서울에서 부럽다.', 50);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '저기요 느낌이 짱이다!', 47);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '진짜 비용이 좋네요.', 28);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '이거 더운데 좋네요.', 21);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '아 배고픈데 짱이다!', 86);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '나도 하 짱이다!', 55);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '하 나는 언제 정보 좀 주세요.', 62);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '진짜 비용이 어때요?', 66);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '나도 하 여행 가고 싶었던 곳이에요.', 30);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '옛날 부터 경기도에서 좋네요.', 93);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '저기요 추운데 쩐다!', 6);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '헐 ㅋㅋㅋㅋ 계획이 뭐에요.', 5);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '나도 더운데 좋네요.', 29);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '하 추운데 계획이 뭐에요.', 76);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '저기요 하 가봤었어요!', 44);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '우와 더운데 좋네요.', 48);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '옛날 부터 강원도에서 계획이 뭐에요.', 40);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '우와 나는 언제 정보 좀 주세요.', 34);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '저기요 나는 언제 맛있는 식당이에요.', 83);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '우와 배고픈데 맛있는 식당이에요.', 73);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '이거 비용이 부럽다.', 67);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재미있네요 나는 언제 부럽다.', 70);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '우와 진짜 좋네요.', 31);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재밌는 경기도에서 여행 가고 싶었던 곳이에요.', 28);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '아 진짜 맛있는 식당이에요.', 7);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '하 배고픈데 계획이 뭐에요.', 79);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재미있네요 경기도에서 좋네요.', 45);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재밌는 진짜 가봤었어요!', 50);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재밌는 추운데 계획이 뭐에요.', 76);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '저기요 강원도에서 맛있는 식당이에요.', 30);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '오 진짜 좋네요.', 58);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '이거 경기도에서 계획이 뭐에요.', 67);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '헐 하 맛있는 식당이에요.', 40);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '하 비용이 쩐다!', 55);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '이거 서울에서 쩐다!', 10);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '아 비용이 쩐다!', 12);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '오 하 짱이다!', 76);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '이거 비용이 맛있는 식당이에요.', 4);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '헐 서울에서 정보 좀 주세요.', 58);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '하 서울에서 짱이다!', 92);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '저기요 더운데 가봤었어요!', 37);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '이거 나는 언제 좋네요.', 16);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '오 경기도에서 부럽다.', 61);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '헐 ㅋㅋㅋㅋ 맛있는 식당이에요.', 38);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '옛날 부터 후 짱이다!', 40);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '옛날 부터 느낌이 여행 가고 싶었던 곳이에요.', 40);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '이거 더운데 여행 가고 싶었던 곳이에요.', 25);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '진짜 나는 언제 정보 좀 주세요.', 56);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '옛날 부터 서울에서 가봤었어요!', 92);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '진짜 부럽다 쩐다!', 3);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '헐 추운데 좋네요.', 70);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '우와 강원도에서 짱이다!', 5);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재밌는 추운데 정보 좀 주세요.', 55);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '와 서울에서 어때요?', 9);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '우와 더운데 어때요?', 65);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '나도 경기도에서 가봤었어요!', 3);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '이거 나는 언제 짱이다!', 83);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '이거 진짜 짱이다!', 31);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '와 하 짱이다!', 93);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '이거 경기도에서 쩐다!', 60);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '아 나는 언제 좋네요.', 48);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재미있네요 진짜 쩐다!', 48);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재미있네요 추운데 어때요?', 60);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '나도 경기도에서 짱이다!', 24);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '하 느낌이 짱이다!', 16);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재밌는 비용이 여행 가고 싶었던 곳이에요.', 46);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재미있네요 느낌이 가봤었어요!', 70);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '옛날 부터 강원도에서 쩐다!', 89);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '진짜 제주에서 여행 가고 싶었던 곳이에요.', 45);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '하 비용이 부럽다.', 72);
insert into tblBComment values (seqBComment.nextVal, 0, 0, '재미있네요 진짜 가봤었어요!', 48);

select * from tblPlan;
-- 일정
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-08-16', '2022-08-19', '추억의 제주 계획', 'y', 'y', 1, '산속휴양');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-06-04', '2022-06-04', '추억의 제주도 여행', 'n', 'n', 5, '먹방투어');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-09-15', '2022-09-19', '즐거운 충청 여행계획', 'y', 'n', 4, '가족여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-01-01', '2022-01-09', '여행', 'y', 'n', 5, '친환경');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-07-14', '2022-07-18', '예쁜 전라도 계획', 'y', 'n', 5, '시간여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-05-27', '2022-05-30', '행복한 핵심장소', 'y', 'n', 2, 'SNS명소');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-10-24', '2022-10-31', '계획', 'y', 'n', 3, '활동적인');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-10-19', '2022-10-23', '추억의 제주도 모음집', 'y', 'y', 4, '이색체험');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-07-19', '2022-07-20', '예쁜 대전 계획', 'y', 'n', 2, '가성비');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-04-05', '2022-04-06', '신나는 제주 여행', 'n', 'n', 6, '시간여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-10-02', '2022-10-05', '여행계획', 'y', 'y', 4, '생태체험');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-10-03', '2022-10-05', '울산 핵심장소', 'y', 'n', 6, '안심여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-07-28', '2022-07-28', '추억의 모음집', 'y', 'n', 5, '친환경');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-05-11', '2022-05-18', '여행', 'y', 'y', 3, '바다여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-06-11', '2022-06-15', '행복한 인천 일정', 'n', 'n', 2, '쇼핑여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-05-23', '2022-05-31', '전라도 계획', 'y', 'n', 3, '시간여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-01-22', '2022-01-29', '즐거운 광주 계획', 'y', 'n', 2, '전통시장');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-09-07', '2022-09-08', '경주 핵심지', 'n', 'n', 6, '한옥여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-12-29', '2022-12-30', '제주 핵심장소', 'y', 'n', 1, '골목여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-04-26', '2022-04-30', '예쁜 제주도 여행계획', 'n', 'n', 5, '전망좋은');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-11-13', '2022-11-15', '경주 계획', 'n', 'n', 3, '안심여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-08-27', '2022-08-31', '인천 여행', 'n', 'y', 4, '낭만적인');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-07-04', '2022-07-08', '추억의 전라도 여행', 'y', 'n', 5, '골목여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-02-21', '2022-02-25', '행복한 제주도 여행', 'n', 'n', 5, '호캉스');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-12-14', '2022-12-14', '추억의 경기도 핵심장소', 'y', 'y', 2, '가성비');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-04-22', '2022-04-25', '제주도 여행', 'y', 'y', 5, '골목여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-08-19', '2022-08-21', '전라도 계획', 'y', 'n', 2, '가족여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-10-14', '2022-10-20', '강원도 여행', 'y', 'y', 2, '낭만적인');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-01-23', '2022-01-24', '신나는 인천 계획', 'y', 'y', 1, '맛집여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2022-08-19', '2022-08-22', '즐거운 인천 일정', 'n', 'n', 1, '친환경');


insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-06-04', '2023-06-06', '제주 계획', 'y', 'n', 2, '문화예술');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-04-10', '2023-04-10', '예쁜 경주 여행계획', 'y', 'y', 1, '안심여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-02-05', '2023-02-06', '전주 계획', 'n', 'y', 5, '산속휴양');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-06-03', '2023-06-11', '인천 여행계획', 'y', 'n', 1, '전통시장');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-03-14', '2023-03-22', '경기도 계획', 'n', 'y', 4, '산업관광');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-02-27', '2023-02-28', '일정', 'n', 'n', 4, '감성힐링');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-03-14', '2023-03-18', '강원도 계획', 'y', 'n', 4, '한옥여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-03-09', '2023-03-12', '서울 여행일지', 'y', 'n', 1, '호캉스');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-01-12', '2023-01-16', '제주 계획', 'n', 'n', 5, '산속휴양');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-05-26', '2023-05-31', '광주 여행계획', 'y', 'y', 3, '친환경');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-05-25', '2023-05-28', '경기도 여행', 'y', 'n', 2, '시간여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-06-20', '2023-06-27', '계획', 'n', 'y', 2, '쇼핑여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-06-02', '2023-06-05', '제주 여행', 'y', 'y', 2, '낭만적인');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-01-12', '2023-01-14', '예쁜 전라도 여행', 'y', 'n', 4, '먹방투어');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-06-18', '2023-06-24', '광주 여행계획', 'y', 'n', 6, '전망좋은');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-04-23', '2023-04-24', '추억의 충청 여행', 'n', 'n', 2, '감성힐링');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-03-29', '2023-03-31', '계획', 'y', 'n', 1, '가족여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-02-12', '2023-02-14', '서울 여행계획', 'n', 'n', 6, '산업관광');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-06-19', '2023-06-23', '충청 여행일지', 'n', 'n', 6, '산속휴양');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-01-01', '2023-01-03', '여행계획', 'n', 'y', 4, '한옥여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-04-05', '2023-04-10', '울산 여행', 'y', 'y', 5, '시간여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-06-19', '2023-06-26', '여행', 'n', 'n', 6, '감성힐링');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-05-22', '2023-05-24', '광주 여행일지', 'y', 'n', 5, '산업관광');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-05-09', '2023-05-14', '전라도 여행', 'y', 'y', 6, '가성비');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-03-17', '2023-03-18', '계획', 'y', 'y', 6, '전망좋은');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-02-23', '2023-02-28', '계획', 'y', 'y', 1, '생태체험');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-05-24', '2023-05-27', '경기도 핵심장소', 'n', 'n', 2, 'SNS명소');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-02-14', '2023-02-15', '행복한 전라도 모음집', 'n', 'n', 5, '산업관광');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-03-20', '2023-03-22', '대전 여행계획', 'n', 'y', 2, '이국적인');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-04-27', '2023-04-30', '강원도 계획', 'n', 'y', 2, '친환경');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-06-10', '2023-06-17', '계획', 'y', 'n', 4, '가성비');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-05-04', '2023-05-08', '모음집', 'y', 'n', 4, '생태체험');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-06-10', '2023-06-16', '충청 여행', 'n', 'n', 1, '가성비');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-03-29', '2023-04-01', '강원도 핵심장소', 'y', 'n', 1, '활동적인');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-01-15', '2023-01-22', '제주 핵심장소', 'y', 'n', 6, '시간여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-03-29', '2023-04-03', '계획', 'n', 'n', 4, '골목여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-02-14', '2023-02-19', '가고싶은곳', 'y', 'y', 3, '맛집여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-03-16', '2023-03-23', '광주 일정', 'n', 'y', 1, 'SNS명소');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-01-01', '2023-01-05', '경주 여행일지', 'n', 'y', 4, '한옥여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-05-19', '2023-05-27', '충청 여행', 'n', 'y', 4, '등산여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-06-21', '2023-06-25', '추억의 서울 모음집', 'n', 'n', 6, '이국적인');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-05-14', '2023-05-16', '여행', 'n', 'y', 6, '안심여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-06-18', '2023-06-21', '충청 일정', 'n', 'n', 6, '친환경');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-01-21', '2023-01-26', '울산 계획', 'n', 'y', 1, '가성비');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-06-25', '2023-06-28', '여행', 'n', 'n', 6, '낭만적인');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-04-28', '2023-04-28', '서울 계획', 'n', 'y', 2, '바다여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-02-22', '2023-02-28', '전주 여행', 'y', 'n', 1, 'SNS명소');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-03-25', '2023-03-30', '여행', 'n', 'y', 3, '맛집여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-05-27', '2023-05-29', '대구 여행', 'y', 'n', 6, '활동적인');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-01-03', '2023-01-04', '충청 핵심지', 'y', 'y', 4, '문화예술');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-05-14', '2023-05-21', '울산 여행', 'n', 'y', 5, '이색체험');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-03-03', '2023-03-04', '여행', 'n', 'y', 4, '전망좋은');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-03-19', '2023-03-19', '전주 여행계획', 'n', 'y', 2, '맛집여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-05-12', '2023-05-16', '여행일지', 'n', 'n', 5, '바다여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-01-20', '2023-01-23', '울산 여행', 'y', 'y', 5, '전통시장');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-01-12', '2023-01-14', '울산 핵심지', 'y', 'n', 6, '산속휴양');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-04-19', '2023-04-27', '행복한 여행', 'n', 'y', 4, '골목여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-07-29', '2023-07-30', '예쁜 여행계획', 'y', 'n', 3, '전망좋은');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-01-24', '2023-01-26', '행복한 모음집', 'n', 'n', 3, '한옥여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-02-26', '2023-02-27', '경기도 계획', 'n', 'n', 1, '안심여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-05-14', '2023-05-14', '여행계획', 'n', 'y', 5, '바다여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-05-11', '2023-05-11', '경기도 일정', 'n', 'y', 6, '이색체험');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-03-14', '2023-03-15', '행복한 핵심장소', 'n', 'y', 5, '골목여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-05-14', '2023-05-18', '즐거운 서울 여행', 'n', 'y', 5, '등산여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-03-10', '2023-03-13', '충청 여행계획', 'y', 'y', 1, '맛집여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-05-23', '2023-05-28', '인천 핵심장소', 'n', 'n', 2, '활동적인');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-04-12', '2023-04-16', '제주 일정', 'y', 'y', 5, '낭만적인');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-01-05', '2023-01-06', '여행', 'y', 'n', 1, '바다여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-03-22', '2023-03-23', '여행계획', 'y', 'n', 6, '감성힐링');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-05-18', '2023-05-25', '여행', 'y', 'n', 6, '호캉스');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-02-14', '2023-02-17', '인천 계획', 'y', 'n', 2, '호캉스');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-02-11', '2023-02-13', '여행일지', 'n', 'y', 4, '등산여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-05-21', '2023-05-22', '일정', 'n', 'n', 3, '호캉스');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-06-04', '2023-06-06', '전주 일정', 'y', 'y', 4, '이국적인');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-04-21', '2023-04-22', '강원도 핵심지', 'n', 'n', 4, '먹방투어');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-01-22', '2023-01-28', '계획', 'y', 'n', 3, '이색체험');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-05-07', '2023-05-11', '대구 여행', 'y', 'y', 4, '안심여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-05-09', '2023-05-10', '강원도 여행계획', 'y', 'y', 6, '안심여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-03-29', '2023-03-30', '대구 계획', 'y', 'y', 6, '안심여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-04-27', '2023-04-29', '추억의 강원도 계획', 'n', 'y', 1, '호캉스');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-03-17', '2023-03-23', '경기도 가고싶은곳', 'n', 'y', 5, '쇼핑여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-04-03', '2023-04-06', '즐거운 여행', 'y', 'n', 4, '산업관광');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-04-15', '2023-04-15', '신나는 충청 여행계획', 'n', 'y', 1, '생태체험');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-05-05', '2023-05-09', '제주 여행계획', 'n', 'y', 2, 'SNS명소');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-03-18', '2023-03-23', '전라도 핵심장소', 'n', 'y', 3, '바다여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-01-26', '2023-01-28', '예쁜 여행', 'y', 'n', 4, '쇼핑여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-06-22', '2023-06-25', '충청 여행', 'y', 'y', 5, '전통시장');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-06-20', '2023-06-23', '전라도 모음집', 'y', 'y', 2, '호캉스');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-05-22', '2023-05-23', '핵심장소', 'y', 'y', 5, '쇼핑여행');
insert into tblPlan (pseq, pstart, pend, pname, pshare, pconnect, pmcount, ptheme) values (seqPlan.nextVal, '2023-05-14', '2023-05-20', '인천 계획', 'y', 'n', 4, '전망좋은');

select * from tblHashTag;
-- 해시태그
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '감성');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '재미');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '레포츠');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '엑티비티');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '힐링');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, 'SNS명소');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '데이트');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '가성비');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '트래킹');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '캠핑');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '맛집');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '연애');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '가족여행');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '애완동물');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '봄여행');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '가을여행');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '여름여행');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '겨울여행');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '소통');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '사진');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '신혼');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '친구');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '행복');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '여행메이트');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '여행스타그램');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, 'travel');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '일상');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '셀카');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, '데일리');
insert into tblHashTag (hseq, hname) values (seqHashTag.nextVal, 'daily');

select * from tblSHashTag;

-- 공유해시태그
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 19, 33);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 9, 27);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 4, 61);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 19, 39);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 20, 48);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 30, 1);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 12, 89);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 20, 87);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 9, 51);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 29, 38);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 9, 31);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 22, 14);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 25, 21);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 13, 24);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 5, 51);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 17, 55);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 29, 94);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 26, 50);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 21, 64);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 27, 43);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 1, 55);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 2, 15);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 14, 80);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 28, 24);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 12, 46);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 11, 68);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 19, 25);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 13, 32);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 19, 88);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 17, 36);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 29, 41);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 18, 27);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 14, 62);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 2, 30);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 1, 19);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 30, 19);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 12, 52);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 23, 56);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 7, 97);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 14, 11);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 20, 42);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 6, 59);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 10, 70);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 29, 15);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 3, 38);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 10, 33);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 9, 28);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 26, 83);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 27, 64);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 5, 56);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 21, 57);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 20, 58);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 6, 73);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 18, 23);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 9, 98);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 14, 88);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 5, 61);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 7, 44);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 14, 20);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 27, 80);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 22, 11);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 7, 45);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 6, 76);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 11, 60);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 2, 42);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 9, 87);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 2, 49);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 10, 40);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 16, 69);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 2, 36);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 6, 12);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 20, 69);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 7, 90);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 10, 88);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 24, 84);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 29, 16);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 25, 12);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 4, 87);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 26, 37);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 30, 67);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 18, 39);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 4, 62);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 28, 96);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 1, 98);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 23, 91);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 24, 78);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 13, 43);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 12, 93);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 12, 78);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 8, 20);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 6, 36);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 15, 1);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 10, 31);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 8, 14);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 10, 77);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 24, 39);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 17, 5);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 25, 83);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 14, 38);
insert into tblSHashTag (shseq, hseq, pseq) values (seqSHashTag.nextVal, 7, 27);

delete from tbl MSchedule;
-- 회원일정
insert into tblMSchedule values (seqMSchedule.nextVal, 1, 1, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 2, 2, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 3, 2, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 4, 2, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 5, 2, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 6, 2, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 7, 3, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 8, 3, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 9, 3, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 10, 3, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 11, 4, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 12, 4, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 13, 4, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 14, 4, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 15, 4, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 25, 5, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 26, 5, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 27, 5, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 28, 5, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 29, 5, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 30, 6, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 31, 6, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 32, 7, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 33, 7, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 34, 7, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 35, 8, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 36, 8, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 37, 8, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 38, 8, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 39, 9, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 40, 9, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 41, 10, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 42, 10, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 43, 10, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 44, 10, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 45, 10, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 46, 10, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 47, 11, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 48, 11, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 49, 11, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 50, 11, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 51, 12, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 52, 12, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 53, 12, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 54, 12, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 55, 12, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 56, 12, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 57, 13, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 58, 13, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 59, 13, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 60, 13, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 61, 13, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 62, 14, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 63, 14, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 64, 14, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 65, 15, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 66, 15, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 67, 16, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 68, 16, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 69, 16, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 70, 17, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 71, 17, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 72, 18, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 73, 18, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 74, 18, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 75, 18, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 76, 18, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 77, 18, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 78, 19, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 79, 20, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 80, 20, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 81, 20, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 82, 20, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 83, 20, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 84, 21, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 85, 21, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 86, 21, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 87, 22, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 88, 22, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 89, 22, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 90, 22, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 91, 23, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 92, 23, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 93, 23, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 94, 23, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 95, 23, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 96, 24, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 97, 24, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 98, 24, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 99, 24, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 100, 24, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 101, 25, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 102, 25, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 103, 26, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 104, 26, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 105, 26, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 106, 26, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 107, 26, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 108, 27, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 109, 27, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 110, 28, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 111, 28, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 112, 29, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 113, 30, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 114, 31, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 115, 31, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 116, 32, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 117, 33, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 118, 33, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 119, 33, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 120, 33, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 121, 33, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 122, 34, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 123, 35, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 124, 35, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 125, 35, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 126, 35, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 127, 35, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 128, 36, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 129, 36, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 130, 36, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 131, 36, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 132, 37, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 133, 37, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 134, 37, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 135, 37, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 136, 38, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 137, 39, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 138, 39, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 139, 39, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 140, 39, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 141, 39, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 142, 40, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 143, 40, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 144, 40, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 145, 41, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 146, 41, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 147, 42, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 148, 42, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 149, 43, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 150, 43, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 151, 44, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 152, 44, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 153, 44, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 154, 44, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 155, 45, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 156, 45, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 157, 45, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 158, 45, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 159, 45, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 160, 45, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 161, 46, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 162, 46, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 163, 47, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 164, 48, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 165, 48, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 166, 48, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 167, 48, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 168, 48, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 169, 48, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 170, 49, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 171, 49, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 172, 49, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 173, 49, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 174, 49, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 175, 49, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 176, 50, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 177, 50, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 178, 50, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 179, 50, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 180, 51, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 181, 51, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 182, 51, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 183, 51, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 184, 51, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 185, 52, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 186, 52, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 187, 52, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 188, 52, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 189, 52, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 190, 52, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 191, 53, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 192, 53, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 193, 53, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 194, 53, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 195, 53, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 196, 54, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 197, 54, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 198, 54, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 199, 54, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 200, 54, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 201, 54, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 202, 55, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 203, 55, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 204, 55, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 205, 55, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 206, 55, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 207, 55, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 208, 56, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 209, 57, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 210, 57, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 211, 58, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 212, 58, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 213, 58, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 214, 58, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 215, 58, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 216, 59, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 217, 59, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 218, 60, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 219, 60, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 220, 61, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 221, 61, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 222, 61, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 223, 61, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 224, 62, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 225, 62, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 226, 62, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 227, 62, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 228, 63, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 229, 64, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 230, 65, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 231, 65, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 232, 65, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 233, 65, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 234, 65, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 235, 65, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 236, 66, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 237, 66, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 238, 66, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 239, 66, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 240, 67, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 241, 67, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 242, 67, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 243, 68, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 244, 69, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 245, 69, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 246, 69, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 247, 69, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 248, 70, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 249, 70, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 250, 70, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 1, 70, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 2, 71, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 3, 71, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 4, 71, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 5, 71, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 6, 71, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 7, 71, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 8, 72, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 9, 72, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 10, 72, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 11, 72, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 12, 72, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 13, 72, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 14, 73, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 15, 73, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 16, 73, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 17, 73, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 18, 73, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 19, 73, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 20, 74, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 21, 75, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 22, 75, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 23, 75, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 24, 75, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 25, 75, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 26, 75, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 27, 76, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 28, 76, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 29, 77, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 30, 78, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 31, 78, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 32, 78, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 33, 79, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 34, 79, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 35, 79, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 36, 79, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 37, 79, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 38, 79, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 39, 80, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 40, 80, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 41, 80, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 42, 80, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 43, 81, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 44, 81, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 45, 81, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 46, 81, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 47, 81, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 48, 82, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 49, 82, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 50, 82, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 51, 82, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 52, 83, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 53, 83, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 54, 84, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 55, 84, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 56, 84, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 57, 84, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 58, 84, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 59, 85, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 60, 85, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 61, 85, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 62, 85, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 63, 85, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 64, 86, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 65, 86, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 66, 86, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 67, 86, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 68, 86, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 69, 86, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 70, 87, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 71, 87, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 72, 87, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 73, 87, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 74, 88, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 75, 88, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 76, 88, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 77, 89, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 78, 89, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 79, 89, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 80, 90, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 81, 91, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 82, 91, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 83, 91, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 84, 91, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 85, 91, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 86, 92, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 87, 92, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 88, 92, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 89, 92, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 90, 92, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 91, 92, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 92, 93, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 93, 93, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 94, 93, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 95, 93, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 96, 93, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 97, 94, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 98, 94, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 99, 94, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 100, 94, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 101, 94, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 102, 95, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 103, 96, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 104, 96, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 105, 97, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 106, 97, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 107, 97, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 108, 97, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 109, 97, 2); 
insert into tblMSchedule values (seqMSchedule.nextVal, 110, 98, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 111, 99, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 112, 99, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 113, 99, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 114, 99, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 115, 99, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 116, 99, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 117, 100, 1);
insert into tblMSchedule values (seqMSchedule.nextVal, 118, 100, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 119, 100, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 120, 100, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 121, 100, 2);
insert into tblMSchedule values (seqMSchedule.nextVal, 122, 100, 2);

select * from tblReview;

-- 여행후기게시판
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 116, null, '울산 너무 행복했어요ㅎㅎ', 100);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 136, null, '대전 가볼만한 곳 알려드릴게요~', 67);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 165, null, '전북 너무 행복했어요ㅎㅎ', 39);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 286, null, '강원도 힐링하고가요~', 72);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 73, null, '충남 행복한 여행이었어요..', 4);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 28, null, '전남 여러곳 다녀왔어요~', 22);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 196, null, '강원도 힐링하고가요.', 67);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 181, null, '제주도 힐링하고가요~', 37);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 198, null, '전남 너무 행복했어요~', 75);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 4, null, '대구 가볼만한 곳 알려드릴게요!!', 60);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 152, null, '대구 너무 행복했어요~*^^*', 70);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 293, null, '부산 예쁜 곳 다녀왔어요~*^^*', 32);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 219, null, '제주도 행복한 여행이었어요.!', 59);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 210, null, '제주도 다녀왔어요~', 94);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 62, null, '경상남도 가볼만한 곳 알려드릴게요~', 81);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 84, null, '경상남도 여행 후기입니다!', 53);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 115, null, '전북 행복한 여행이었어요..', 24);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 200, null, '전남 가볼만한 곳 알려드릴게요~*^^*', 74);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 96, null, '전남 행복한 여행이었어요.~*^^*', 34);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 19, null, '경상북도 행복한 여행이었어요.ㅋㅋㅋ', 8);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 163, null, '부산 여러곳 다녀왔어요ㅋㅋㅋ', 4);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 222, null, '대전 여러곳 다녀왔어요~', 64);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 297, null, '경상북도 행복한 여행이었어요.~*^^*', 92);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 248, null, '인천 가볼만한 곳 알려드릴게요ㅋㅋㅋ', 82);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 167, null, '전남 여행 후기입니다.', 92);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 87, null, '서울 힐링하고가요~', 32);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 174, null, '전북 여러곳 다녀왔어요!', 64);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 33, null, '대구 다녀왔어요ㅋㅋㅋ', 58);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 156, null, '경기도 여러곳 다녀왔어요.', 17);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 251, null, '제주도 행복한 여행이었어요.~', 30);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 43, null, '경기도 너무 행복했어요~*^^*', 24);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 31, null, '전북 힐링하고가요~', 67);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 191, null, '전북 여러곳 다녀왔어요!', 98);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 280, null, '전남 가볼만한 곳 알려드릴게요~*^^*', 43);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 19, null, '울산 행복한 여행이었어요.!', 100);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 1, null, '제주도 예쁜 곳 다녀왔어요~*^^*', 70);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 264, null, '전남 너무 행복했어요~*^^*', 93);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 203, null, '경상북도 예쁜 곳 다녀왔어요ㅎㅎ', 80);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 43, null, '광주 너무 행복했어요.', 20);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 272, null, '대구 다녀왔어요ㅎㅎ', 27);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 87, null, '전남 명소 추천드려요ㅋㅋㅋ', 53);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 239, null, '충북 예쁜 곳 다녀왔어요ㅋㅋㅋ', 49);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 272, null, '경상남도 명소 추천드려요ㅋㅋㅋ', 52);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 253, null, '경기도 여러곳 다녀왔어요ㅎㅎ', 42);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 184, null, '충남 행복한 여행이었어요.~*^^*', 86);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 33, null, '대구 행복한 여행이었어요.~', 12);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 195, null, '인천 여행 후기입니다~', 14);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 93, null, '전남 여러곳 다녀왔어요~*^^*', 40);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 115, null, '대전 다녀왔어요!!', 36);
insert into tblReview(rseq, rcontent, rcount, rfile, rctitle, msseq) values (seqReview.nextVal, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Harum in laborum est nihil veniam dicta possimus eum! Quo atque nobis perferendis labore est provident accusantium dolore adipisci. Esse obcaecati deleniti aspernatur veritatis iusto dolores reprehenderit molestiae animi culpa est illo dolorum voluptate sit ducimus numquam reiciendis dolorem nisi suscipit quis corporis eos inventore dolore necessitatibus minima beatae aut repellat excepturi. Molestias dolore eos nobis saepe perferendis aut neque quod nam suscipit nulla quasi quam modi asperiores. Voluptate autem nam quos voluptates nisi quam fuga dicta nostrum nesciunt laudantium corrupti optio distinctio illum cupiditate eum quas maxime voluptatum sapiente ipsum dignissimos alias et soluta. Unde perferendis deleniti', 182, null, '경상남도 여행 후기입니다!!', 101);



-- 후기댓글
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '예쁜 곳 이에요..', 20);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '어딘지 아는 곳 알려주세요?', 24);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋진 처음 보는 곳 이에요?', 42);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와 꿈꾸던 곳 정보좀요!', 5);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '새로운 곳 이네요?', 14);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '추억 생각나는 곳 가보고싶어요!', 4);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '가보고싶은 곳 알려주세요?', 39);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '처음 보는 곳 이에요!', 8);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '어딘지 아는 곳 이에요!!', 47);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '진짜 가보고싶은 곳 정보 알려주세요!', 36);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '사람 많은 곳 최고네요!', 36);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '추억 생각나는 가보고싶은 곳 최고네요!', 6);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '꼭 예전에 가본 곳 멋있어요?', 33);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋진 가보고싶은 곳 멋있어요?', 22);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋있는 사람 많은 곳 가보고싶어요!!', 5);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '대박! 어딘지 아는 곳 최고네요!!', 9);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '헐! 사람 많은 곳 어딘가요!', 27);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '대박! 곳 정보좀요!', 32);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와아아아어딘지 아는 곳 멋있어요..', 18);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '추억 생각나는 예전에 가본 곳 정보 알려주세요!', 26);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '대박! 예전에 가본 곳 인데요..', 38);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '사람 많은 곳 이에요!', 37);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '언젠간 가보고싶은 곳 최고네요!', 12);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '예쁜 꿈꾸던 곳 어딘가요?', 30);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와 가보고싶은 곳 최고네요?', 14);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '처음 보는 곳 인데요..', 48);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '언젠간 가보고싶은 곳 인데요!!', 31);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '처음 보는 곳 이네요..', 36);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '추억 생각나는 처음 보는 곳 이네요?', 26);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '예쁜 처음 보는 곳 가보고싶어요?', 41);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '와 대박언젠간 가보고싶은 곳 정보 알려주세요?', 15);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '대박! 언젠간 가보고싶은 곳 이네요?', 29);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '추억 생각나는 언젠간 가보고싶은 곳 정보 알려주세요!', 19);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '대박! 곳 최고네요..', 12);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '꼭 어딘지 아는 곳 어딘가요..', 27);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋진 어딘지 아는 곳 이네요!!', 17);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '꿈꾸던 곳 정보좀요!!', 15);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '진짜 예전에 가본 곳 정보 공유해주세요!', 37);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와 꿈꾸던 곳 최고네요..', 17);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '신나보이는 어딘지 아는 곳 가보고싶어요..', 23);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '예전에 가본 곳 이네요..', 4);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '예전에 가본 곳 정보 알려주세요?', 10);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '예전에 가본 곳 인데요..', 7);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '와 대박어딘지 아는 곳 가보고싶어요!', 8);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와 예전에 가본 곳 어딘가요?', 45);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '꼭 예전에 가본 곳 인데요!', 39);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '신나보이는 처음 보는 곳 알려주세요?', 21);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '예쁜 사람 많은 곳 정보 공유해주세요?', 3);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '어딘지 아는 곳 알려주세요!!', 45);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '꼭 새로운 곳 인데요?', 50);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '어딘지 아는 곳 멋있어요!', 11);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '대박! 꿈꾸던 곳 최고네요!', 10);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '헐! 어딘지 아는 곳 정보 공유해주세요?', 7);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '신나보이는 언젠간 가보고싶은 곳 어딘가요!!', 40);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋있는 예전에 가본 곳 정보 알려주세요?', 26);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '헐! 곳 멋있어요!!', 34);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋있는 언젠간 가보고싶은 곳 정보좀요?', 31);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와아아아어딘지 아는 곳 어딘가요..', 9);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '진짜 곳 이네요!!', 31);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와 곳 어딘가요!', 9);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋진 꿈꾸던 곳 가보고싶어요!', 32);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '처음 보는 곳 정보 공유해주세요!!', 35);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋진 곳 알려주세요?', 43);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와 어딘지 아는 곳 최고네요..', 12);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '가보고싶은 곳 알려주세요..', 5);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '꿈꾸던 곳 가보고싶어요..', 9);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋진 어딘지 아는 곳 최고네요..', 12);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '곳 가보고싶어요..', 50);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와아아아새로운 곳 알려주세요!', 2);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와 예전에 가본 곳 정보좀요!!', 17);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '와 대박처음 보는 곳 최고네요..', 31);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '헐! 곳 알려주세요!!', 22);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '사람 많은 곳 알려주세요!!', 42);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '새로운 곳 멋있어요!', 14);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '대박! 새로운 곳 정보좀요!', 29);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋진 어딘지 아는 곳 어딘가요?', 31);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '곳 이네요..', 11);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '신나보이는 어딘지 아는 곳 인데요?', 34);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋진 사람 많은 곳 정보좀요!!', 37);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '곳 알려주세요..', 36);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '새로운 곳 알려주세요?', 43);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋있는 예전에 가본 곳 어딘가요..', 48);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '대박! 예전에 가본 곳 정보 알려주세요!', 42);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '와 대박예전에 가본 곳 최고네요?', 17);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '새로운 곳 정보 알려주세요!!', 34);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '예쁜 사람 많은 곳 이에요!', 28);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '가보고싶은 곳 알려주세요!', 11);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '언젠간 가보고싶은 곳 정보 알려주세요!', 45);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋진 처음 보는 곳 멋있어요..', 30);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋있는 곳 정보 공유해주세요?', 43);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '꼭 가보고싶은 곳 이네요!!', 2);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '가보고싶은 어딘지 아는 곳 인데요!', 3);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '진짜 곳 정보 알려주세요!!', 30);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '진짜 새로운 곳 가보고싶어요!!', 20);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '새로운 곳 정보 알려주세요?', 37);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '예쁜 예전에 가본 곳 이에요?', 20);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋있는 언젠간 가보고싶은 곳 어딘가요!!', 5);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '새로운 곳 인데요..', 10);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '예전에 가본 곳 정보 공유해주세요!!', 43);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '꿈꾸던 곳 정보 공유해주세요!!', 20);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와 예전에 가본 곳 멋있어요..', 34);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '곳 가보고싶어요?', 28);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '언젠간 가보고싶은 곳 최고네요!!', 26);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '예전에 가본 곳 인데요!', 49);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '새로운 곳 최고네요..', 33);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '신나보이는 사람 많은 곳 이네요?', 27);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '예쁜 언젠간 가보고싶은 곳 어딘가요!!', 41);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '새로운 곳 정보 알려주세요!', 24);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '추억 생각나는 어딘지 아는 곳 이에요..', 7);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋있는 사람 많은 곳 멋있어요?', 24);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와아아아사람 많은 곳 이에요?', 4);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '추억 생각나는 새로운 곳 이네요!', 8);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '어딘지 아는 곳 인데요..', 10);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋있는 새로운 곳 멋있어요?', 5);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '와 대박언젠간 가보고싶은 곳 이네요..', 36);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와 처음 보는 곳 정보 알려주세요!!', 1);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '곳 알려주세요!!', 27);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '대박! 새로운 곳 멋있어요?', 42);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '곳 인데요..', 50);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '사람 많은 곳 인데요!', 13);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '신나보이는 언젠간 가보고싶은 곳 정보 알려주세요!', 2);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '처음 보는 곳 정보 공유해주세요?', 11);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '신나보이는 곳 이에요!!', 35);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '새로운 곳 멋있어요!', 7);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '가보고싶은 곳 정보 알려주세요..', 49);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '헐! 예전에 가본 곳 이네요!!', 11);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '헐! 처음 보는 곳 이에요!', 30);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '사람 많은 곳 가보고싶어요..', 41);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '진짜 곳 인데요!!', 24);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '언젠간 가보고싶은 곳 알려주세요!', 25);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와아아아예전에 가본 곳 정보 알려주세요..', 37);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와아아아어딘지 아는 곳 최고네요!', 42);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '신나보이는 처음 보는 곳 어딘가요!', 7);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '와 대박가보고싶은 곳 알려주세요..', 41);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋진 예전에 가본 곳 최고네요!', 14);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '가보고싶은 언젠간 가보고싶은 곳 정보 공유해주세요?', 28);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '신나보이는 곳 어딘가요..', 13);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '추억 생각나는 언젠간 가보고싶은 곳 이에요!!', 22);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '와 대박꿈꾸던 곳 멋있어요..', 22);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와아아아언젠간 가보고싶은 곳 이에요!!', 14);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와 꿈꾸던 곳 이에요?', 32);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '처음 보는 곳 정보 공유해주세요?', 40);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '헐! 사람 많은 곳 이네요!', 24);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '추억 생각나는 사람 많은 곳 인데요!', 1);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '와 대박사람 많은 곳 정보 알려주세요!!', 4);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와 예전에 가본 곳 멋있어요!', 21);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '헐! 곳 정보 알려주세요?', 22);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '꿈꾸던 곳 인데요!!', 41);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '와 대박처음 보는 곳 어딘가요?', 32);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋진 꿈꾸던 곳 이에요!', 21);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '새로운 곳 이네요?', 19);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '처음 보는 곳 이네요?', 10);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '신나보이는 새로운 곳 멋있어요!', 15);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '대박! 가보고싶은 곳 정보 공유해주세요!!', 8);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와 사람 많은 곳 어딘가요!', 15);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '진짜 가보고싶은 곳 이에요?', 49);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '신나보이는 어딘지 아는 곳 인데요..', 31);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '진짜 어딘지 아는 곳 알려주세요..', 17);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋있는 처음 보는 곳 정보 알려주세요?', 44);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '추억 생각나는 어딘지 아는 곳 정보 알려주세요!', 23);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '새로운 곳 이에요!', 49);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '진짜 처음 보는 곳 정보좀요!', 32);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '진짜 새로운 곳 알려주세요!!', 14);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '꿈꾸던 곳 정보좀요..', 11);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '추억 생각나는 가보고싶은 곳 어딘가요?', 45);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋있는 예전에 가본 곳 정보 알려주세요?', 27);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와아아아예전에 가본 곳 정보 공유해주세요!', 20);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '진짜 사람 많은 곳 인데요!!', 45);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '꼭 예전에 가본 곳 정보 공유해주세요..', 30);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋있는 예전에 가본 곳 이에요?', 40);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '신나보이는 꿈꾸던 곳 어딘가요..', 49);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '진짜 새로운 곳 최고네요?', 14);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '가보고싶은 곳 알려주세요..', 38);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와 처음 보는 곳 정보 알려주세요!', 8);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '진짜 예전에 가본 곳 최고네요..', 29);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '꿈꾸던 곳 가보고싶어요!', 3);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋있는 처음 보는 곳 정보 공유해주세요!', 31);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '꿈꾸던 곳 정보좀요?', 20);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '대박! 사람 많은 곳 이에요..', 11);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '대박! 예전에 가본 곳 최고네요?', 41);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '예전에 가본 곳 가보고싶어요!!', 41);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '신나보이는 어딘지 아는 곳 이네요..', 25);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '꿈꾸던 곳 최고네요!', 48);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '곳 가보고싶어요..', 13);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '신나보이는 사람 많은 곳 최고네요?', 25);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '곳 정보 공유해주세요!!', 37);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '언젠간 가보고싶은 곳 최고네요!', 49);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와 꿈꾸던 곳 인데요!!', 42);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '대박! 어딘지 아는 곳 가보고싶어요!', 39);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '예쁜 곳 인데요!!', 19);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와 어딘지 아는 곳 정보 알려주세요!', 17);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '꼭 가보고싶은 곳 정보 공유해주세요!', 26);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '가보고싶은 꿈꾸던 곳 최고네요!!', 40);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '어딘지 아는 곳 알려주세요!!', 23);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '추억 생각나는 어딘지 아는 곳 이네요..', 14);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '새로운 곳 어딘가요..', 25);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '추억 생각나는 새로운 곳 이네요!', 1);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋있는 예전에 가본 곳 멋있어요!!', 4);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '진짜 새로운 곳 정보 알려주세요!!', 16);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와 꿈꾸던 곳 정보 알려주세요..', 31);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와 곳 정보 공유해주세요!', 32);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와 사람 많은 곳 가보고싶어요!', 7);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와아아아가보고싶은 곳 정보 공유해주세요!', 31);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '새로운 곳 이에요!', 9);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '진짜 언젠간 가보고싶은 곳 정보좀요..', 8);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '와 대박언젠간 가보고싶은 곳 인데요!', 3);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '예쁜 언젠간 가보고싶은 곳 최고네요?', 9);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '사람 많은 곳 가보고싶어요..', 4);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '예쁜 언젠간 가보고싶은 곳 이에요?', 50);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '어딘지 아는 곳 인데요!', 47);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '사람 많은 곳 이네요?', 12);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '곳 정보 알려주세요?', 41);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '대박! 새로운 곳 정보 공유해주세요?', 9);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋진 꿈꾸던 곳 가보고싶어요?', 20);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '사람 많은 곳 인데요?', 42);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '언젠간 가보고싶은 곳 인데요..', 29);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '와 대박꿈꾸던 곳 알려주세요..', 25);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '대박! 새로운 곳 멋있어요..', 27);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '헐! 언젠간 가보고싶은 곳 인데요!', 20);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '추억 생각나는 가보고싶은 곳 이에요?', 37);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '추억 생각나는 어딘지 아는 곳 정보 알려주세요!', 3);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '가보고싶은 곳 이에요..', 7);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '어딘지 아는 곳 인데요!!', 5);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와 언젠간 가보고싶은 곳 정보 공유해주세요!', 44);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '가보고싶은 예전에 가본 곳 정보 알려주세요..', 23);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '꼭 꿈꾸던 곳 최고네요?', 37);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋있는 처음 보는 곳 최고네요!!', 50);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '예쁜 사람 많은 곳 알려주세요?', 3);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '대박! 언젠간 가보고싶은 곳 알려주세요?', 28);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '추억 생각나는 처음 보는 곳 정보좀요!', 49);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '사람 많은 곳 정보 알려주세요?', 23);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '대박! 예전에 가본 곳 이에요!', 36);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '꼭 어딘지 아는 곳 이네요!!', 17);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '언젠간 가보고싶은 곳 인데요!!', 43);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와 어딘지 아는 곳 이네요..', 48);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '가보고싶은 사람 많은 곳 어딘가요?', 49);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '처음 보는 곳 어딘가요!!', 50);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '새로운 곳 멋있어요!', 16);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '가보고싶은 곳 멋있어요!', 48);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋있는 곳 멋있어요!!', 14);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '처음 보는 곳 정보 공유해주세요!', 44);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '예쁜 가보고싶은 곳 정보좀요!!', 18);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '진짜 곳 가보고싶어요!!', 4);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '추억 생각나는 사람 많은 곳 정보 알려주세요!!', 37);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '대박! 곳 가보고싶어요?', 27);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋있는 처음 보는 곳 멋있어요..', 11);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋있는 처음 보는 곳 정보 공유해주세요!', 49);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '대박! 처음 보는 곳 최고네요?', 36);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '대박! 어딘지 아는 곳 정보 공유해주세요..', 18);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '와 대박처음 보는 곳 인데요!', 3);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '가보고싶은 가보고싶은 곳 가보고싶어요..', 17);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '예쁜 꿈꾸던 곳 가보고싶어요!!', 27);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '예쁜 꿈꾸던 곳 알려주세요..', 11);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '예전에 가본 곳 이에요!', 44);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '헐! 어딘지 아는 곳 알려주세요?', 10);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '헐! 꿈꾸던 곳 가보고싶어요!', 38);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와아아아어딘지 아는 곳 가보고싶어요!!', 33);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '추억 생각나는 처음 보는 곳 알려주세요?', 1);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '사람 많은 곳 정보좀요?', 36);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '언젠간 가보고싶은 곳 알려주세요!!', 45);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '예쁜 새로운 곳 어딘가요!', 24);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '예쁜 언젠간 가보고싶은 곳 정보 알려주세요..', 39);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '꼭 곳 멋있어요!!', 37);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와아아아언젠간 가보고싶은 곳 정보 공유해주세요..', 36);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '진짜 꿈꾸던 곳 이에요!', 36);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와 어딘지 아는 곳 정보 공유해주세요..', 34);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋진 사람 많은 곳 정보 공유해주세요?', 15);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '새로운 곳 정보 알려주세요!', 17);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와아아아예전에 가본 곳 알려주세요..', 40);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋있는 꿈꾸던 곳 어딘가요!!', 15);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와아아아예전에 가본 곳 이네요!!', 38);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와 사람 많은 곳 정보 공유해주세요..', 48);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '신나보이는 새로운 곳 어딘가요?', 47);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '와 대박언젠간 가보고싶은 곳 정보 공유해주세요!', 19);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '가보고싶은 꿈꾸던 곳 멋있어요?', 6);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋진 사람 많은 곳 가보고싶어요!!', 47);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '헐! 새로운 곳 멋있어요!!', 7);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋진 사람 많은 곳 멋있어요!!', 4);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와 예전에 가본 곳 최고네요!!', 24);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '진짜 곳 정보좀요!', 5);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '처음 보는 곳 이에요?', 25);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '헐! 언젠간 가보고싶은 곳 정보 공유해주세요?', 40);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '언젠간 가보고싶은 곳 가보고싶어요..', 39);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '예쁜 꿈꾸던 곳 이에요!!', 15);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '대박! 가보고싶은 곳 가보고싶어요?', 32);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와 사람 많은 곳 정보좀요!!', 37);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와아아아처음 보는 곳 정보 알려주세요?', 40);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋있는 꿈꾸던 곳 정보좀요?', 20);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋있는 가보고싶은 곳 이네요!', 11);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋진 곳 정보좀요!', 46);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와아아아가보고싶은 곳 정보 공유해주세요..', 7);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '가보고싶은 곳 가보고싶어요!!', 47);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '예쁜 어딘지 아는 곳 정보좀요?', 7);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '가보고싶은 꿈꾸던 곳 알려주세요?', 6);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '헐! 곳 인데요?', 21);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '어딘지 아는 곳 알려주세요..', 47);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '사람 많은 곳 이에요!', 14);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '우와아아아처음 보는 곳 최고네요!!', 49);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '대박! 곳 알려주세요?', 48);
insert into tblRComment (rcseq, rthread, rdepth, rccontent, rseq) values (seqRComment.nextVal, 0, 0, '멋있는 처음 보는 곳 이네요!!', 23);



-- 후기 해시태그
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 11, 16);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 12, 48);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 21, 21);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 9, 4);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 30, 12);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 13, 23);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 27, 44);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 10, 15);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 11, 49);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 30, 50);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 9, 16);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 27, 6);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 14, 6);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 17, 36);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 27, 1);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 15, 47);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 25, 45);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 9, 8);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 4, 49);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 21, 33);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 27, 32);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 28, 21);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 14, 29);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 29, 10);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 14, 17);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 11, 36);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 23, 14);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 3, 1);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 26, 40);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 6, 13);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 25, 16);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 15, 36);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 13, 12);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 16, 43);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 3, 38);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 28, 22);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 15, 4);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 14, 37);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 12, 5);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 26, 7);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 22, 42);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 6, 46);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 2, 50);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 30, 42);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 13, 50);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 1, 39);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 5, 28);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 1, 36);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 14, 27);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 8, 26);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 2, 24);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 9, 12);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 14, 18);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 17, 7);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 28, 25);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 2, 2);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 15, 1);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 27, 49);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 26, 21);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 26, 34);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 20, 28);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 21, 17);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 13, 1);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 23, 29);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 16, 2);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 25, 40);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 27, 2);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 4, 13);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 19, 9);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 4, 27);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 1, 22);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 25, 34);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 21, 4);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 4, 43);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 21, 47);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 12, 19);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 26, 36);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 1, 32);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 22, 34);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 24, 40);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 26, 35);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 11, 17);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 26, 49);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 18, 50);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 23, 17);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 12, 27);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 30, 13);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 6, 20);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 1, 16);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 6, 28);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 19, 18);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 27, 8);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 16, 18);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 6, 24);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 1, 27);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 19, 31);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 13, 14);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 2, 40);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 5, 9);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 2, 35);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 20, 5);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 19, 10);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 19, 22);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 28, 11);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 9, 23);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 29, 37);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 3, 43);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 18, 33);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 22, 26);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 29, 43);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 29, 12);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 1, 31);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 12, 4);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 3, 12);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 3, 45);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 10, 26);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 18, 38);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 9, 41);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 8, 42);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 16, 4);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 19, 44);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 18, 17);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 10, 4);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 27, 10);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 27, 17);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 16, 35);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 24, 3);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 19, 16);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 18, 49);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 5, 23);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 22, 29);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 4, 16);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 14, 30);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 16, 21);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 8, 46);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 13, 4);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 15, 15);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 3, 25);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 24, 4);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 27, 34);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 3, 18);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 12, 28);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 27, 29);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 7, 10);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 1, 34);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 19, 48);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 27, 50);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 18, 28);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 25, 18);
insert into tblRHashTag (rhseq, hseq, rseq) values (seqRHashTag.nextVal, 6, 39);


-- 일정공유 게시판
insert into tblShare values (seqShare.nextVal, 10, 30, 6, 1);
insert into tblShare values (seqShare.nextVal, 0, 1, null, 3);
insert into tblShare values (seqShare.nextVal, 34, 40, null, 4);
insert into tblShare values (seqShare.nextVal, 14, 23, 97, 5); 
insert into tblShare values (seqShare.nextVal, 93, 100, null, 6);
insert into tblShare values (seqShare.nextVal, 12, 31, null, 7);
insert into tblShare values (seqShare.nextVal, 10, 21, null, 8);
insert into tblShare values (seqShare.nextVal, 5, 7, null, 9);
insert into tblShare values (seqShare.nextVal, 23, 24, 61, 11);
insert into tblShare values (seqShare.nextVal, 11, 20, 71, 12);
insert into tblShare values (seqShare.nextVal, 4, 10, null, 13);
insert into tblShare values (seqShare.nextVal, 40, 60, 12, 14);
insert into tblShare values (seqShare.nextVal, 10, 11, 76, 16);
insert into tblShare values (seqShare.nextVal, 50,52, null, 17);
insert into tblShare values (seqShare.nextVal, 11, 15, 36, 19);
insert into tblShare values (seqShare.nextVal, 50, 77, 54, 23);
insert into tblShare values (seqShare.nextVal, 13,23, 27, 25);
insert into tblShare values (seqShare.nextVal, 3, 5, null, 26);
insert into tblShare values (seqShare.nextVal, 11, 13, 2, 27);
insert into tblShare values (seqShare.nextVal, 50, 70, null, 28);
insert into tblShare values (seqShare.nextVal, 11, 20, null, 29);
insert into tblShare values (seqShare.nextVal, 2, 10, 11, 31);
insert into tblShare values (seqShare.nextVal, 3, 7, 28, 32);
insert into tblShare values (seqShare.nextVal, 0, 3, null, 34);
insert into tblShare values (seqShare.nextVal, 14, 17, 79, 37);
insert into tblShare values (seqShare.nextVal, 7, 9, 10, 38);
insert into tblShare values (seqShare.nextVal, 1, 3, 68, 40);
insert into tblShare values (seqShare.nextVal, 0, 1, 6, 41);
insert into tblShare values (seqShare.nextVal, 2, 18, 87, 43);
insert into tblShare values (seqShare.nextVal, 14, 20, 58, 44);
insert into tblShare values (seqShare.nextVal, 6, 7, 62, 45);
insert into tblShare values (seqShare.nextVal, 5, 9, null, 47);
insert into tblShare values (seqShare.nextVal, 3, 7, 9, 51);
insert into tblShare values (seqShare.nextVal, 0, 1, null, 53);
insert into tblShare values (seqShare.nextVal, 2, 24, null, 54);
insert into tblShare values (seqShare.nextVal, 0, 10, null, 55);
insert into tblShare values (seqShare.nextVal, 120, 156, 50, 56);
insert into tblShare values (seqShare.nextVal, 22, 30, 3, 61);
insert into tblShare values (seqShare.nextVal, 11, 16, 33, 62);
insert into tblShare values (seqShare.nextVal, 0, 1, 49, 64);
insert into tblShare values (seqShare.nextVal, 80, 93, 6, 65);
insert into tblShare values (seqShare.nextVal, 0, 1, 80, 67);
insert into tblShare values (seqShare.nextVal, 2, 16, 95, 77);
insert into tblShare values (seqShare.nextVal, 4, 19, null, 79);
insert into tblShare values (seqShare.nextVal, 2, 20, 23, 80);
insert into tblShare values (seqShare.nextVal, 8, 35, null, 85);
insert into tblShare values (seqShare.nextVal, 91, 105, null, 86);
insert into tblShare values (seqShare.nextVal, 30, 54, 56, 88);
insert into tblShare values (seqShare.nextVal, 0, 1, null, 95);
insert into tblShare values (seqShare.nextVal, 12, 15, 39, 97);
insert into tblShare values (seqShare.nextVal, 1, 12, 55, 98);
insert into tblShare values (seqShare.nextVal, 13, 40, null, 99);
insert into tblShare values (seqShare.nextVal, 0, 20, null, 100);
insert into tblShare values (seqShare.nextVal, 0, 10, null, 101);
insert into tblShare values (seqShare.nextVal, 0, 1, null, 104);
insert into tblShare values (seqShare.nextVal, 12, 15, null, 106);
insert into tblShare values (seqShare.nextVal, 0, 1, null, 107);
insert into tblShare values (seqShare.nextVal, 0, 24, null, 108);
insert into tblShare values (seqShare.nextVal, 14, 22, null, 109);
insert into tblShare values (seqShare.nextVal, 0, 10, null, 112);
insert into tblShare values (seqShare.nextVal, 0, 60, null, 116);
insert into tblShare values (seqShare.nextVal, 1, 40, null, 117);
insert into tblShare values (seqShare.nextVal, 0, 1, null, 118);
insert into tblShare values (seqShare.nextVal, 0, 6, null, 119);
insert into tblShare values (seqShare.nextVal, 1, 5, null, 120);

select s.*, dense_rank() over (order by slike desc) rank from tblShare s;

select * from (select s.*, dense_rank() over (order by slike desc) rank from tblShare s) where rank <= 3;

select * from tblMember;
create or replace view vwplan as
select ms.mseq as mseq, m.mname as mname, p.pname as pname, p.ptheme as ptheme, s.slike as slike, un.locname as local from tblMSchedule ms inner join tblPlan p on p.pseq = ms.pseq inner join tblMember m on ms.mseq = m.mseq inner join (select * from(select pseq,count(pseq) as co from tblMSchedule where (msauth = 1 or msauth = 2) group by pseq)) c on c.pseq = p.pseq inner join tblShare s on s.pseq = p.pseq inner join (select locname, p.pseq as pseq from (select * from tblLocal l inner join tblTrain tr on l.locseq = tr.trend inner join tblTransfer t on tr.trseq = t.trseq union all select * from tblLocal l inner join tblFlight f on l.locseq = f.fend inner join tblTransfer t on f.fseq = t.fseq union all select * from tblLocal l inner join tblBus b on l.locseq = b.bend inner join tblTransfer t on b.busseq = t.busseq) u inner join tblPlan p on u.pseq = p.pseq) un on un.pseq = p.pseq;

-- 찐 일정 뷰
create or replace view vwplan as
select distinct sseq, pname, locname, mname, slike, ptheme from tblMSchedule ms inner join tblPlan p on p.pseq = ms.pseq inner join tblMember m on ms.mseq = m.mseq inner join (select * from(select pseq,count(pseq) as co from tblMSchedule where (msauth = 1 or msauth = 2) group by pseq)) c on c.pseq = p.pseq inner join tblShare s on s.pseq = p.pseq inner join (select locname, p.pseq as pseq from (select * from tblLocal l inner join tblTrain tr on l.locseq = tr.trend inner join tblTransfer t on tr.trseq = t.trseq union all select * from tblLocal l inner join tblFlight f on l.locseq = f.fend inner join tblTransfer t on f.fseq = t.fseq union all select * from tblLocal l inner join tblBus b on l.locseq = b.bend inner join tblTransfer t on b.busseq = t.busseq) u inner join tblPlan p on u.pseq = p.pseq) un on un.pseq = p.pseq where msauth = 1;

select * from vwplan;

-- 일정 좋아요 top3 쿼리문
select * from (select v.*, dense_rank() over (order by slike desc) rank from vwplan v) where rank <= 3;

select * from tblMember;


select * from (select v.*, dense_rank() over (order by slike desc) rank from vwplan v) where rank <= 3;
-- 마이페이지  정보 뷰
create or replace view vwmyplan as
select distinct m.mseq, p.pseq, msauth, pstart, pend, pname, pconnect, pmcount, ptheme, mname, locname, scount, slike, co from tblMSchedule ms inner join tblPlan p on p.pseq = ms.pseq inner join tblMember m on ms.mseq = m.mseq inner join (select * from(select pseq,count(pseq) as co from tblMSchedule where (msauth = 1 or msauth = 2) group by pseq)) c on c.pseq = p.pseq inner join tblShare s on s.pseq = p.pseq inner join (select locname, p.pseq as pseq from (select * from tblLocal l inner join tblTrain tr on l.locseq = tr.trend inner join tblTransfer t on tr.trseq = t.trseq union all select * from tblLocal l inner join tblFlight f on l.locseq = f.fend inner join tblTransfer t on f.fseq = t.fseq union all select * from tblLocal l inner join tblBus b on l.locseq = b.bend inner join tblTransfer t on b.busseq = t.busseq) u inner join tblPlan p on u.pseq = p.pseq) un on un.pseq = p.pseq;

select * from vwmyplan;

select * from tblPlan p inner join (select * from vwmyplan where mseq = 39) vp on p.pseq = vp.pseq;

select * from tblMember m inner join (select * from vwmyplan where mseq = 68 and msauth = 2) k on m.mseq = k.mseq;

select mname from tblMember where mseq = (select mseq from tblMSchedule where pseq = (select pseq from vwmyplan where mseq = 68 and msauth = 2) and msauth = 1); --권한 2의 주인

select * from tblMSchedule; 
select * from tblPlan;
select * from tblBus;
-- 베이직 플랜 뷰
create or replace view vwbplan as
select distinct m.mseq, p.pseq, msauth, pstart, pend, pname, pconnect, pmcount, ptheme, mname, locname, scount, slike, co, sseq from tblMSchedule ms inner join tblPlan p on p.pseq = ms.pseq inner join tblMember m on ms.mseq = m.mseq inner join (select * from(select pseq,count(pseq) as co from tblMSchedule where (msauth = 1 or msauth = 2) group by pseq)) c on c.pseq = p.pseq inner join tblShare s on s.pseq = p.pseq inner join (select locname, p.pseq as pseq from (select * from tblLocal l inner join tblTrain tr on l.locseq = tr.trend inner join tblTransfer t on tr.trseq = t.trseq union all select * from tblLocal l inner join tblFlight f on l.locseq = f.fend inner join tblTransfer t on f.fseq = t.fseq union all select * from tblLocal l inner join tblBus b on l.locseq = b.bend inner join tblTransfer t on b.busseq = t.busseq) u inner join tblPlan p on u.pseq = p.pseq) un on un.pseq = p.pseq;

select * from vwbplan;

select * from tblMSchedule ms inner join tblPlan p on p.pseq = ms.pseq inner join tblMember m on ms.mseq = m.mseq inner join (select * from(select pseq,count(pseq) as co from tblMSchedule where (msauth = 1 or msauth = 2) group by pseq)) c on c.pseq = p.pseq inner join tblShare s on s.pseq = p.pseq inner join (select locname, p.pseq as pseq from (select * from tblLocal l inner join tblTrain tr on l.locseq = tr.trend inner join tblTransfer t on tr.trseq = t.trseq union all select * from tblLocal l inner join tblFlight f on l.locseq = f.fend inner join tblTransfer t on f.fseq = t.fseq union all select * from tblLocal l inner join tblBus b on l.locseq = b.bend inner join tblTransfer t on b.busseq = t.busseq) u inner join tblPlan p on u.pseq = p.pseq) un on un.pseq = p.pseq;

insert into tblMSchedule values(seqmschedule.nextVal, 40, 25, 1);
select * from tblMSchedule;
select * from tbltransfer;
insert into tbltransfer values (seqtransfer.nextVal, 25, 46, null, null);

select mseq, count(mseq) from vwmyplan group by mseq; --42번 예시

select * from vwmyplan where mseq = 40;

select * from tblMSchedule ms inner join tblPlan p on p.pseq = ms.pseq inner join tblMember m on ms.mseq = m.mseq inner join (select * from(select pseq,count(pseq) as co from tblMSchedule where (msauth = 1 or msauth = 2) group by pseq)) c on c.pseq = p.pseq inner join tblShare s on s.pseq = p.pseq inner join (select locname, p.pseq as pseq from (select * from tblLocal l inner join tblTrain tr on l.locseq = tr.trend inner join tblTransfer t on tr.trseq = t.trseq union all select * from tblLocal l inner join tblFlight f on l.locseq = f.fend inner join tblTransfer t on f.fseq = t.fseq union all select * from tblLocal l inner join tblBus b on l.locseq = b.bend inner join tblTransfer t on b.busseq = t.busseq) u inner join tblPlan p on u.pseq = p.pseq) un on un.pseq = p.pseq;

select pseq,count(pseq) as co from tblMSchedule where (msauth = 1 or msauth = 2) group by pseq;

select * from tbllike;

delete from tbllike where mseq = 40 and sseq = 15;

select * from tblLike;


select * from tblMember;
select * from tblMSchedule;
select * from tblMSchedule where mseq = 1 and msauth = 1;
select * from tblMSchedule where mseq = 1 and msauth = 2;

select * from tblPlan p inner join (select * from tblMSchedule where mseq = 1 and msauth = 1) ms on p.pseq = ms.pseq;

select v.*, dense_rank() over (order by slike desc) rank from vwplan v;

select * from tblPlan;
delete from tblShare;
drop sequence seqshare;
create sequence seqShare;
select * from tblShare;

select * from tblPlan where pshare = 'n';
-- 지역
insert into tblLocal values (seqLocal.nextval, '강원도', 37.88530515733651, 127.72981402913192, '11D10000');
insert into tblLocal values (seqLocal.nextval, '경기도',  37.28898993783225, 127.05344314489604, '11B00000');
insert into tblLocal values (seqLocal.nextval, '경상남도', 35.23766422253718, 128.6919319519881, '11H20000');
insert into tblLocal values (seqLocal.nextval, '경상북도', 36.57594259771448, 128.5058004482194, '11H10000');
insert into tblLocal values (seqLocal.nextval, '광주광역시', 35.16009519646143, 126.85162722736375, '11F20000');
insert into tblLocal values (seqLocal.nextval, '대구광역시', 35.871372127028444, 128.60180754157656, '11H10000');
insert into tblLocal values (seqLocal.nextval, '대전광역시', 36.35051402769861, 127.38486257527438, '11C20000');
insert into tblLocal values (seqLocal.nextval, '부산광역시', 35.17973757693896, 129.07506234566324, '11H20000');
insert into tblLocal values (seqLocal.nextval, '서울특별시', 37.56682645465332, 126.97864942841608, '11B00000');
insert into tblLocal values (seqLocal.nextval, '울산광역시', 35.53959226710968, 129.31160886513516, '11H20000');
insert into tblLocal values (seqLocal.nextval, '인천광역시', 37.45600447269905, 126.70526089561174, '11B00000');
insert into tblLocal values (seqLocal.nextval, '전라남도', 34.81605238097452, 126.46278360820781, '11F20000');
insert into tblLocal values (seqLocal.nextval, '전라북도', 35.8201841944526, 127.10897946184605, '11F10000');
insert into tblLocal values (seqLocal.nextval, '제주도', 33.48888231965717, 126.49834770765807, '11G00000');
insert into tblLocal values (seqLocal.nextval, '충청남도', 36.658844034201366, 126.67274425498694, '11C20000');
insert into tblLocal values (seqLocal.nextval, '충청북도', 36.63533253067888, 127.49145325008416, '11C10000');


-- 랜드마크
insert into tblLandmark values (seqLandMark.nextVal, '경복궁', '서울특별시 종로구 사직로 161', '경복궁은 대한민국 서울특별시 청와대로에 있는 조선 왕조의 법궁이다. 태조 4년인 1395년 창건되어 1592년 임진왜란으로 전소되었고, 1868년 흥선대원군의 주도로 중건되었다. 일제강점기에 훼손되어 현재 복원사업이 진행중이다. 고공기에 입각하여 건축되었다. 3문 3조로 구성되었는데 각각 외조, 내조, 연조이다. 내조는 근정전을 중심으로 하는데, 궁 밖에서 근정전까지 바깥부터 광화문, 흥례문, 근정문이다.', 0, 0,  '경복궁.jpg', 9);
insert into tblLandmark values (seqLandMark.nextVal, 'N 서울타워', '서울특별시 용산구 남산공원길 105', 'N서울타워는 대한민국 서울특별시 용산구 용산동2가 남산 정상 부근에 위치한 전파 송출 및 관광용 타워이다. 1969년에 착공하여 1975년 7월 30일 완공되었다. 높이는 236.7m, 해발 479.7m이다. 수도권의 지상파 방송사들이 이 타워를 이용하여 전파를 송출한다. 전망대에서 서울 시내 전역을 내려다볼 수 있으며, 맑은 날씨에 찾는 관광지로 잘 알려져 있다. 남산에 있어서 보통 남산타워라고 널리 부르고, 서울에 있어서 서울타워라고 부르기도 하지만, 행정안전부에 등록된 정식 명칭은 YTN서울타워이다.', 0, 0,  '서울타워.jpg', 9);
insert into tblLandmark values (seqLandMark.nextVal, '북촌 한옥마을', '서울특별시 종로구 계동길 37', '북촌 한옥마을은 서울특별시 종로구의 가회동과 삼청동 내에 위치한 한옥마을이다. 지리상으로 경복궁과 창덕궁, 종묘의 사이에 자리잡고 있다. 조선 왕조의 두 궁궐 사이에 위치한 이 지역은 예로부터 청계천과 종로의 윗동네라는 의미로 ‘북촌’이라 불리었으며, 현재의 가회동, 삼청동, 원서동, 재동, 계동 일대에 해당한다. 많은 사적과 문화재, 민속자료가 있어 도심 속의 박물관이라 불리기도 한다.', 0, 0,  '북촌한옥마을.jpg', 9);
insert into tblLandmark values (seqLandMark.nextVal, '감천 문화마을', '부산광역시 사하구 감내1로 200', '감천문화마을(甘川文化마을)은 행정구역상 부산광역시 사하구 감천동에 위치한 마을이다. 1950년대에 태극도 신도들과 6.25 전쟁 피난민들이 모여서 이루어졌다. 지금도 태극도의 본부가 있다. 그동안 태극도마을이라는 이름의 낙후된 동네로 알려졌으나 ‘보존과 재생’을 바탕으로 진행된 도시재생의 일환으로 부산지역의 예술가와 주민들이 합심해 담장이나 건물 벽에 벽화 등을 그리는 마을미술 프로젝트가 진행되어 부산의 대표적인 관광지로 자리잡았다.', 0, 0,  '감천 문화마을.jpg', 8);
insert into tblLandmark values (seqLandMark.nextVal, '청계천', '서울특별시 종로구 서린동 148', '청계천(淸溪川)은 대한민국 서울특별시 내부에 있는 지방하천으로, 한강 수계에 속하며 중랑천의 지류이다. 최장 발원지는 종로구 청운동에 위치한 백운동 계곡이며, 남으로 흐르다가 청계광장 부근의 지하에서 삼청동천을 합치며 몸집을 키운다. 이곳에서 방향을 동쪽으로 틀어 서울의 전통적인 도심지를 가로지르다가, 한양대학교 서울캠퍼스 옆에서 중랑천으로 흘러든다. ', 0, 0,  '청계천.jpg', 9);
insert into tblLandmark values (seqLandMark.nextVal, '수원화성', '경기도 수원시 장안구 영화동 320-2', '수원 화성(水原 華城) 혹은 화성(華城)은 대한민국 경기도 수원시 팔달구 장안동에 있는 길이가 5.52킬로미터인 성곽이다. 1963년 대한민국의 사적 제3호로 지정되었으며, 1997년 유네스코 세계문화유산으로 등록되었다. 화성은 한국 성의 구성 요소인 옹성, 성문, 암문, 산대, 체성, 치성, 적대, 포대, 봉수대 등을 모두 갖추어 대한민국의 성곽 건축 기술을 집대성했다고 평가된다. 지형에 맞추어 읍성과 산성의 구조가 모두 존재하도록 축조되었다.', 0, 0,  '수원화성.jpg', 2);
insert into tblLandmark values (seqLandMark.nextVal, '불국사', '경상북도 경주시 진현동 15-1', '불국사(佛國寺)는 대한민국 경상북도 경주시 동쪽 토함산에 있는 대한불교 조계종 소속 사찰이다. 신라시대인 경덕왕에서 혜공왕 시대에 걸쳐 대규모로 중창되었다. 신라 이후 고려와 조선시대에 이르기까지 여러 번 수축되었으나 임진왜란 때 불타버렸다. 대한불교 조계종 제11교구 본사이고, 1995년 유네스코 세계문화유산으로 지정되었다.', 0, 0,  '불국사.jpg', 4);
insert into tblLandmark values (seqLandMark.nextVal, '롯데월드타워', '서울특별시 송파구 올림픽로 300', '롯데월드타워(영어: Lotte World Tower)는 대한민국 서울특별시 송파구 올림픽로 300에 위치한 마천루이며, 흔히 제2롯데월드(영어: Lotte World 2)라고 하는 건물이 바로 이 마천루다. 지상 123층, 높이 555m의 마천루로 2010년에 착공을 시작하여 2015년 12월 22일 123층까지 상량 완료했으며, 2016년 3월경 첨탑공사가 완료됨으로써 외장 공사가 완료되었고, 2016년 12월 22일에 완공된 후 2017년 4월 3일에 개장하였다. 또한 줄여서 롯데타워라고 부르는 경우도 있다.', 0, 0,  '롯데월드타워.jpg', 9);
insert into tblLandmark values (seqLandMark.nextVal, '명동성당', '서울특별시 중구 명동길 74', '한국 천주교 서울대교구 주교좌 명동대성당, 통칭 명동성당(明洞聖堂, 영어: Myeongdong Cathedral)은 대한민국 서울특별시 중구 명동2가에 있는 천주교 서울대교구의 대성당이다. 한반도에서 처음으로 지어진 대규모의 고딕 양식 천주교 성당이자, 한국 최초의 본당(사제가 상주하며 사목하는 성당)이다. 1977년 11월 22일 대한민국의 사적 제258호로 지정되었다.', 0, 0, '명동성당.jpg', 9);
insert into tblLandmark values (seqLandMark.nextVal, '한국민속촌', '경기도 용인시 기흥구 민속촌로 90', '한국 천주교 서울대교구 주교좌 명동대성당, 통칭 명동성당(明洞聖堂, 영어: Myeongdong Cathedral)은 대한민국 서울특별시 중구 명동2가에 있는 천주교 서울대교구의 대성당이다. 한반도에서 처음으로 지어진 대규모의 고딕 양식 천주교 성당이자, 한국 최초의 본당(사제가 상주하며 사목하는 성당)이다. 1977년 11월 22일 대한민국의 사적 제258호로 지정되었다.', 0, 0,  '한국민속촌.jpg', 2);
insert into tblLandmark values (seqLandMark.nextVal, '해동 용궁사', '부산광역시 기장군 용궁길 86', '해동용궁사(海東龍宮寺)는 부산광역시 기장군 기장읍 시랑리에 있는 절이다. 바다와 가장 가까운 사찰로 대한민국의 관음성지(觀音聖地)의 하나다. 대한불교 조계종 제19교구 본사 화엄사의 말사이다. 절측에서는 1376년 나옹화상 혜근이 창건한 사찰이라 주장하지만 실상 1970년대 신축된 현대사찰에 불과하다. 원래 절이 있던 곳은 깨를 심거나 소를 먹이던 빈터였다. 나옹 혜근이 세웠다는 둥의 소리는 절측에서 신도 확보를 위해 지어낸 것으로 보인다.', 0, 0,  '해동용궁사.jpg', 8);
insert into tblLandmark values (seqLandMark.nextVal, '태종대', '부산광역시 영도구 전망로 24', '태종대(太宗臺)는 부산광역시 영도구 동삼동에 있는 명승지이다. 영도의 남동쪽 끝에 위치하는 해발 고도 200m 이하의 구릉 지역으로, 부산 일대에서 보기 드문 울창한 숲과 기암 괴석으로 된 해식 절벽 및 푸른 바다 등이 조화를 이루어 장관이다. 맑은 날에는 일본 쓰시마섬도 볼 수 있다. 2005년 11월 1일 대한민국의 명승 제17호로 지정됐다.', 0, 0,  '태종대.jpg', 8);
insert into tblLandmark values (seqLandMark.nextVal, '광화문', '서울특별시 종로구 효자로 12', '광화문(光化門)은 경복궁의 남쪽에 있는 정문이다. 임금의 큰 덕(德)이 온 나라를 비춘다는 의미이다. 1395년에 세워졌으며, 2층 누각인 광화문 앞의 양쪽에는 한 쌍의 해치 조각상이 자리잡고 있다. 광화문의 석축부에는 세 개의 홍예문(虹霓門, 아치문)이 있다. 가운데 문은 임금이 다니던 문이고, 나머지 좌우의 문은 신하들이 다니던 문이었는데 왼쪽 문은 무신이, 오른쪽 문은 문신이 출입했다. 광화문의 가운데 문 천장에는 주작이 그려져 있고, 왼쪽 문에는 거북이가, 오른쪽 문에는 천마가 그려져 있다.', 0, 0,  '광화문.jpg', 9);
insert into tblLandmark values (seqLandMark.nextVal, '주상절리', '제주특별자치도 서귀포시 이어도로 36-30', '제주중문 ·대포해안주상절리대는 서귀포시 중문동 ·대포동 해안을 따라 분포되어 있다. 약 3.5km에 이르며, 용암의 표면에는 클링커가 형성되어 거친 표면을 보이나, 파도의 침식에 의해 나타나 있는 용암단위(熔岩單位)의 중간부분을 나타내는 그 단면에서는 벽화와 같은 아름다운 주상절리가 잘 발달한다.', 0, 0,  '주상절리.jpg', 14);
insert into tblLandmark values (seqLandMark.nextVal, '광안대교', '부산 수영구 광안해변로 219', '광안대교(廣安大橋, 영어: Gwangan Bridge) 혹은 다이아몬드 브릿지(영어: Diamond Bridge)는 부산광역시에 위치한 다리이며 부산광역시도 제66호선의 일부이다. 이 다리는 수영구 남천동 49호 광장과 해운대구 우동 센텀시티를 연결하는 대한민국 최대의 해상 복층 교량이다. 남천동 49호 광장에서 센텀시티 방면으로 갈 때는 1층 교각 도로로, 반대편인 센텀시티에서 남천동 49호 광장 방면으로 갈 때는 2층 교각 도로를 이용하여 주행해야 한다.', 0, 0,  '광안대교.jpg', 8);
insert into tblLandmark values (seqLandMark.nextVal, '전주 한옥마을', '전북 전주시 완산구 풍남동3가 64-1', '전주한옥마을(영어: Jeonju Hanok Village)은 전라북도 전주시 완산구 풍남동에 있는 한옥마을이다. 현재 947가구, 2,202명의 인구가 거주하고 있다. 총 947동의 건물 중에 한옥이 735개이고 비한옥이 212개이다. 전주에는 지금으로부터 약 1만 5천년 전부터 사람이 살기 시작했다고 추측되고 있다. 원래 자연부락 형태의 마을들이 산자락에 형성되었었으나, 665년 신라 문무왕 때 완산주(完山州)가 설치되면서 주거지가 평지로 이동했다. 전주사람들의 본격적인 평지에서의 생활은 전주성의 축조와 함께 시작되었다.', 0, 0,  '전주한옥마을.JPG', 13);
insert into tblLandmark values (seqLandMark.nextVal, '해인사', '경남 합천군 가야면 해인사길 122', '해인사(海印寺)는 대한민국 경상남도 합천군 가야면 치인리 가야산 중턱에 있는 사찰로서 양산 통도사(불보사찰), 순천 송광사(승보사찰)와 더불어 한국 삼보사찰로 불리고 있다. 팔만대장경이 세계기록유산, 팔만대장경을 보관하는 장경판전이 세계문화유산으로 지정되었다. 대한불교 조계종 제12교구 본사로 150여 개의 말사(末寺)를 거느리고 있다. 불교의 삼보사찰 중 법보(法寶) 사찰로 유명하다. 대적광전(大寂光殿)의 본존불은 비로자나불이다.', 0, 0,  '해인사.jpg', 3);
insert into tblLandmark values (seqLandMark.nextVal, '안동 하회마을', '경북 안동시 풍천면 하회리 1176-1', '안동 하회마을(安東 河回마을)은 경상북도 안동시 풍천면에 있는 전통 민속마을이다. 문화재로 지정된 건축물들은 보물 2점, 국가민속문화재 9점 등을 포함하여 11점이고 이밖에 국보 2점이 있다. 2010년 7월 31일 브라질 브라질리아에서 열린 유네스코 세계유산위원회(WHC)의 제34차 회의에서 경주 양동마을과 함께 세계문화유산 등재가 확정되었다.', 0, 0,  '안동하회마을.jpg', 4);
insert into tblLandmark values (seqLandMark.nextVal, '섭지코지', '제주특별자치도 서귀포시 성산읍 섭지코지로 107', '섭지코지는 제주특별자치도 서귀포시 성산읍 고성리에 위치한 해안이다. 제주 방언으로 좁은 땅이라는 뜻의 섭지와 곶이라는 뜻의 코지가 합쳐져서 섭지코지라는 이름이 만들어졌다. 조선시대에는 이곳에 봉화를 올렸던 연대가 있고, 다른 해안과 달리 붉은 화산재 송이로 덮여 있으며 많은 기암괴석이 자리잡고 있다. 여명의 눈동자, 단적비연수, 거침없이 하이킥, 런닝맨, 올인 등 여러 드라마, 영화의 촬영지로 유명하다.', 0, 0,  '섭지코지.jpg', 14);
insert into tblLandmark values (seqLandMark.nextVal, '낙산사', '강원 양양군 강현면 낙산사로 100', '낙산사 (洛山寺)는 대한민국 강원도 양양군 오봉산에 있는 사찰로 조계종 제3교구 신흥사의 말사이다. 강원도 영동 지방의 빼어난 절경을 뜻하는 관동팔경 가운데 하나이다. 671년에 창건된 이후 여러 차례 중건, 복원과 화재를 반복하였다. 2005년 산불의 피해를 입어 여러 문화재가 훼손되기도 하였다. 사내에 칠층석탑(보물 499호), 건칠관음보살좌상(보물 1362호), 해수관음공중사리탑 및 사라장엄구 일괄(보물 1723호) 등의 문화재가 있다. 2005년 화재로 보물 479호였던 낙산사 동종이 융해, 소실되어 문화재 지정이 해제되었다.', 0, 0,  '낙산사.jpg', 1);
insert into tblLandmark values (seqLandMark.nextVal, '진주성', '경남 진주시 남강로 626', '진주성(晋州城)은 경상남도 진주시 본성동에 있는 석성으로, 삼국시대 백제에 의해 건립되었다. 1963년 1월 21일에 사적 제118호로 지정되었다. 진주성 내의 진주 촉석루는 1604년부터는 경상우병영의 병영이었고, 1895년 5월부터는 경상도관찰사부가 경남관찰사부, 경북관찰사부로 나뉘면서 경상남도관찰사부의 소재지가 되었다.', 0, 0,  '진주성.jpg', 3);
insert into tblLandmark values (seqLandMark.nextVal, '천마총', '경북 경주시 계림로 9', '천마총(天馬塚)은 신라 22대 지증왕의 능으로 추정되는 경주의 고분이다. 지름 47m, 높이 12.7m이며, 1973년에 발굴되어, 천마도(국보 제207호), 금관(국보 제188호), 금모(국보 제189호) 등 11,297점의 부장품이 출토되었다. 유물 중에 순백의 천마(天馬) 한 마리가 하늘로 날아 올라가는 그림이 그려진 자작나무 껍질로 만든 천마도가 출토되어 천마총이란 이름이 붙여졌다. 그 밖에 서조도(瑞鳥圖)와 기마인물도(騎馬人物圖)도 출토되었다. 현재 경상북도 경주시 (대릉원 내)에 위치해있으며 무덤 내부를 복원하여 공개하고 있다. 2017년 보수 후 원래 위치에서 조금 밀려서 복원된 목곽을 원 위치로 옮기고 적석과 봉분을 제대로 복원하였으며 관리용 복도 부분도 전시 부분으로 활용하고 있다.', 0, 0,  '천마총.jpg', 4);
insert into tblLandmark values (seqLandMark.nextVal, '호미곶', '경북 포항시 남구 호미곶면 대보리', '호미곶(虎尾串)또는 동외곶(冬外串)또는 장기곶(長鬐串)은 포항시의 동쪽 끝에 있는 곶이다. 원래 생김새가 말갈기와 같다 하여 장기곶으로 불렸는데, 1918년 일제강점기 때 일본식 표현인 갑(岬)으로 고쳐 장기갑으로 불리다가 1995년에 장기곶으로 변경하였다. 2001년 12월부터 일본식 표현을 뺀 호미곶으로 변경하였다. 포항시 남구 대보면 대보리 소재 장기곶이 호미곶으로 지명 변경됨에 다라 지정문화재인 "장기곶등대"를 지도표기와 동일한 명칭인 "호미곶등대"로 변경한다. 해돋이 명소로 유명하다.', 0, 0,  '호미곶.jpg', 4);
insert into tblLandmark values (seqLandMark.nextVal, '경포해변', '강원 강릉시 창해로 514', '경포 해수욕장(鏡浦海水浴場) 또는 경포해변(鏡浦海濱, Gyeongpo Beach)은 강원도 강릉시 안현동에 위치한 해수욕장이다. 모래사장의 총면적은 144,000m2 , 길이는 1.8 km, 폭은 80m이다. 경포해수욕장은 강원도 강릉시 강문동·안현동 일대에 있는 동해안 최대의 해수욕장이다. 경포호에서 흘러 내려오는 물줄기를 경계로 북쪽은 경포해변, 남쪽은 강문해변으로 나뉜다. 피서철에는 하루 평균 50만명의 피서인파가 몰리기도 한다. 경사가 완만하며 수질이 깨끗하고 모래의 질이 곱다. 경포해변 일대는 1982년 6월 도립공원으로 지정되었다.', 0, 0,  '경포해변.jpg', 1);
insert into tblLandmark values (seqLandMark.nextVal, '성산일출봉', '제주특별자치도 서귀포시 성산읍 성산리 78', '성산일출봉(城山日出峰)은 제주특별자치도 서귀포시 성산읍 성산리에 있는 산이다. 커다란 사발 모양의 분화구가 특징으로, 분화구 내부의 면적은 129,774m2이다. 높이는 182m이다. 성산 일출봉에서의 일출은 대한민국에서 가장 아름다운 해돋이로 꼽히며 영주십경(瀛州十景) 중 하나이다. 일출봉 분화구와 주변 1km 해역이 성산일출봉 천연보호구역(城山日出峰 天然保護區域, 영어: Seongsan Ilchulbong Tuff Cone Natural Reserve)으로 2000년 7월 18일 대한민국의 천연기념물 제420호로 지정되었다. 또한 2007년 성산 일출봉 응회구의 1.688km2가 제주 화산섬과 용암 동굴의 일부로 세계자연유산으로 등재되었다. 또한 성산일출봉은 일출을 화려하게 구경할수있다.', 0, 0,  '성산일출봉.jpg', 14);
insert into tblLandmark values (seqLandMark.nextVal, '한라산', '제주특별자치도 제주시 오등동 산 182', '한라산(漢拏山)은 대한민국 제주도 중앙부에 있는 해발 1,947.06m, 면적 약 1,820km2의 화산으로, 제주도의 면적 대부분을 차지하고 있다. 정상에 백록담(白鹿潭)이라는 화산호가 있는데, 백록담이라는 이름은 흰 사슴이 물을 먹는 곳이라는 뜻에서 왔다고 전해진다. 산자락 곳곳에 오름 또는 악(岳)이라 부르는 다양한 크기의 측화산들이 분포해 있는 것이 큰 특징이다. 일반적으로 한라산은 폭발 가능성이 없는 사화산으로 알려져 왔지만 다시 폭발할 수도 있는 활화산일 가능성도 제기되었다.', 0, 0,  '한라산.jpg', 14);
insert into tblLandmark values (seqLandMark.nextVal, '창덕궁', '서울특별시 종로구 율곡로 99', '창덕궁(昌德宮)은 대한민국 서울특별시의 북악산 왼쪽 봉우리인 응봉자락에 자리 잡고 있는 조선 시대 궁궐로 동쪽으로 창경궁과 맞닿아 있다. 경복궁의 동쪽에 있어서 조선 시대에는 창경궁과 더불어 동궐(東闕)이라 불렀다. 창덕궁은 비교적 원형이 잘 보존되어 있는 중요한 고궁이며, 특히 창덕궁 후원은 한국의 유일한 궁궐후원이라는 점과 한국의 정원을 대표한다는 점에서 그 가치가 높다. 1997년에 유네스코가 지정한 세계문화유산으로 등록되었다.', 0, 0,  '창덕궁.jpg', 9);
insert into tblLandmark values (seqLandMark.nextVal, '봉은사', '서울특별시 강남구 봉은사로 531', '봉은사(奉恩寺)는 대한민국 서울특별시 강남구 삼성동 수도산 기슭에 있는 사찰이다. 조계종 사찰이며, 신라 말기에 창건된 것으로 알려졌다. 봉은사(奉恩寺)는 신라시대의 고승 연회국사(緣會國師)가 794년(원성왕 10)에 견성암(見性庵)이란 이름으로 창건(創建)했다. 삼국유사에 의하면, 연회국사는 영축산에 은거했던 고승으로 원성왕에 의해서 국사로 임명되었다', 0, 0,  '봉은사.jpg', 9);
insert into tblLandmark values (seqLandMark.nextVal, '정림사지', '충청남도 부여군 부여읍 동남리 254번지', '부여 정림사지(扶餘 定林寺址)는 충청남도 부여군 부여읍 동남리에 있는 백제의 사찰 터이다. 1983년 3월 26일 대한민국의 사적 제301호로 지정되었다. 가람배치는 전형적인 일탑식(一塔式) 배치로, 남쪽에서 북쪽으로 중문(中門)·석탑(石塔)·금당(金堂)·강당이 일직선상에 세워져 있고, 주위를 회랑(回廊)으로 구획지었다. 국보 제9호인 정림사지 오층석탑과 보물 제108호인 부여 정림사지 석조여래좌상 등의 유물이 남아 있다. 2015년 7월 4일 독일 본에서 열린 제39차 유네스코 세계유산위원회(WHC)에서 백제역사유적지구(총 8개의 유적지들 중 공주지역에 2곳(공산성, 송산리 고분군), 부여 4곳(관북리 유적 및 부소산성, 능산리 고분군, 정림사지, 부여 나성))가 세계 유산 등재 심사를 최종 통과했다. 이번 세계 유산 등재는 충청권에서는 최초로 선정되었다.', 0, 0,  '정림사지.jpg', 15);
insert into tblLandmark values (seqLandMark.nextVal, '각원사', '충청남도 천안시 동남구 각원사길 245', '각원사는 천안시 동남구에 있는 대한불교 조계종 사찰이다.1975년에 세워진 ‘태조산각원사’는 절집의 규모도 크지만 국내최고 크기의 불상이 유명하다. 또한 대웅보전은 건평 661㎡으로 34개의 주춧돌과 100여만 재의 목재가 투입된 외(外) 9포, 내(內) 20포, 전면 7간, 측면 4간의 국내 최대 규모 목조건물이다. 각원사를 창건한 법인(法印) 은 1931년 경남 충무에서 출생해 1946년 해인사 백련암에서 출가, 윤포산(尹飽山) 선사를 은사로 득도했다.', 0, 0,  '각원사.jpg', 15);

UPDATE tblLandmark
SET 
lmfile = '전주한옥마을.jpg'
WHERE
lmseq = 16;

-- 랜드마크 한줄평
insert into tblOneLine values(seqOneLine.nextval,'바다랑 절벽이 너무 이뻤습니다!',14,41); 
insert into tblOneLine values(seqOneLine.nextval,'절이 엄청 웅장해요~',20,124); 
insert into tblOneLine values(seqOneLine.nextval,'열차타고 편하게 구경한거 같아요~',12,8); 
insert into tblOneLine values(seqOneLine.nextval,'템플스테이하면서 정말 제대로 휴식한 기분입니다',17,146); 
insert into tblOneLine values(seqOneLine.nextval,'주차장이 좀 찾기 어려웠어요',22,90); 
insert into tblOneLine values(seqOneLine.nextval,'밤에 꼭 가서 구경하세요!',15,139); 
insert into tblOneLine values(seqOneLine.nextval,'체험시설이 엄청 많아서 좋았어요',10,136); 
insert into tblOneLine values(seqOneLine.nextval,'교과서에서만 보던 다보탑이랑 석가탑을 직접 봐서 신기했습니다',7,62); 
insert into tblOneLine values(seqOneLine.nextval,'나무랑 한옥들이 너무 이뻤어요~',18,54); 
insert into tblOneLine values(seqOneLine.nextval,'한옥들이랑 골목이 잘 어울려서 진짜 좋았습니다',3,168); 
insert into tblOneLine values(seqOneLine.nextval,'진짜 넓어서 놀랐어요',1,186); 
insert into tblOneLine values(seqOneLine.nextval,'서울이 한 눈에 시원하게 다 보여요~',2,83); 
insert into tblOneLine values(seqOneLine.nextval,'집들이 엄청 알록달록해서 이뻐요!',4,102); 
insert into tblOneLine values(seqOneLine.nextval,'날씨 좋은날 산책하기 좋은 곳입니다.서울의 구도심을 둘러보며 걷기에도 좋아요',5,7); 
insert into tblOneLine values(seqOneLine.nextval,'성벽을 따라서 산책하기 좋은 곳입니다!',6,250); 
insert into tblOneLine values(seqOneLine.nextval,'진짜 높아서 놀랬어요! 타워 안에도 시설 많아서 구경거리가 많습니다!',8,198); 
insert into tblOneLine values(seqOneLine.nextval,'대한민국 천주교의 1번지. 천주교 신자라면 가서 미사 참례해봐야한다.',9,181); 
insert into tblOneLine values(seqOneLine.nextval,'바다랑 산이 너무 아름답게 어울러져서 한번 가볼만한 곳인거 같아요~',11,1); 
insert into tblOneLine values(seqOneLine.nextval,'경복궁,교보문고 연계해서 구경하기좋아요.특히 밤이 야경보기 예쁩니다.',13,21); 
insert into tblOneLine values(seqOneLine.nextval,'전주에서 유명한 곳이에요. 한국의 전통 문화를 체험할 수 있다.',16,34); 
insert into tblOneLine values(seqOneLine.nextval,'섭지코지 서귀피안 카페 정말 넓고 맛있으니 한번 가보세요!',19,82);
insert into tblOneLine values(seqOneLine.nextval,'아름다운 진주 시내 풍경을 볼 수 있는 곳,전통적인 목조건축물과 수목이 잘 조성된 멋진 공원',21,54); 
insert into tblOneLine values(seqOneLine.nextval,'상생의 손이 우리를 맞이하는 곳, 해돋이를 보는 것이 아니더라도 한번쯤 방문할 만한 곳',23,220); 
insert into tblOneLine values(seqOneLine.nextval,'조용하면서도 관광객이 많고 카페도 많아 여행객들에게 최고!',24,87); 
insert into tblOneLine values(seqOneLine.nextval,'2분이면 일출이 끝나니 성산일출봉 소요시간을 확인하고 올라가도록 하세요.',25,5); 
insert into tblOneLine values(seqOneLine.nextval,'코스 정해서 준비 철저히 하시고 올라가세요~',26,95); 
insert into tblOneLine values(seqOneLine.nextval,'커플,친구,가족등 다양한사람들과 가기좋은곳입니다',27,127); 
insert into tblOneLine values(seqOneLine.nextval,'도심 한가운데 이렇게 사찰이 있을줄 몰랐는데, 너무너무 멋집니다',28,67); 
insert into tblOneLine values(seqOneLine.nextval,'궁림지 가는길에 들른 정림사지 석탑. 주차장도 잘되어있고 궁림지와 같이 묶어서 가면 좋을것 같아요. ',29,192); 
insert into tblOneLine values(seqOneLine.nextval,'봄에 가면 딱 입니다. 겹벛꽃이 가장 예쁘게 피는 절 일거에요.',30,10); 
insert into tblOneLine values(seqOneLine.nextval,'친구들과 약속을 잡을 때 주로 가는 곳! 다양한 식당과 커피숍, 디저트 가게들이 있어요',13,106); 
insert into tblOneLine values(seqOneLine.nextval,'여전히 젊은 거리 다른 곳은 조금씩 변했는데 이곳만은 젊음을 간직하고있다.',7,130); 
insert into tblOneLine values(seqOneLine.nextval,'주말에 갔더니 사람이 너무 많아서 제대로 관람을 못했네요..',7,173); 
insert into tblOneLine values(seqOneLine.nextval,'주말에 갔더니 사람이 너무 많아서 제대로 관람을 못했네요..',19,118); 
insert into tblOneLine values(seqOneLine.nextval,'넓고 실내 구조가 잘 되어 있어서 돌아다니기 편한 곳 입니다.',9,248); 
insert into tblOneLine values(seqOneLine.nextval,'한국 여행의 진정한 맛을 느끼기 위해선 전통 시장에서의 맛 체험이 필수이다. ',24,99); 
insert into tblOneLine values(seqOneLine.nextval,'친구들과 약속을 잡을 때 주로 가는 곳! 다양한 식당과 커피숍, 디저트 가게들이 있어요',10,245); 
insert into tblOneLine values(seqOneLine.nextval,'친구들과 약속을 잡을 때 주로 가는 곳! 다양한 식당과 커피숍, 디저트 가게들이 있어요',25,158); 
insert into tblOneLine values(seqOneLine.nextval,'한국 여행의 진정한 맛을 느끼기 위해선 전통 시장에서의 맛 체험이 필수이다. ',17,211); 
insert into tblOneLine values(seqOneLine.nextval,'주말에 갔더니 사람이 너무 많아서 제대로 관람을 못했네요..',17,74); 
insert into tblOneLine values(seqOneLine.nextval,'여전히 젊은 거리 다른 곳은 조금씩 변했는데 이곳만은 젊음을 간직하고있다.',9,210); 
insert into tblOneLine values(seqOneLine.nextval,'넓고 실내 구조가 잘 되어 있어서 돌아다니기 편한 곳 입니다.',25,153); 
insert into tblOneLine values(seqOneLine.nextval,'여전히 젊은 거리 다른 곳은 조금씩 변했는데 이곳만은 젊음을 간직하고있다.',21,249); 
insert into tblOneLine values(seqOneLine.nextval,'친구들과 약속을 잡을 때 주로 가는 곳! 다양한 식당과 커피숍, 디저트 가게들이 있어요',24,184); 
insert into tblOneLine values(seqOneLine.nextval,'넓고 실내 구조가 잘 되어 있어서 돌아다니기 편한 곳 입니다.',25,131); 
insert into tblOneLine values(seqOneLine.nextval,'넓고 실내 구조가 잘 되어 있어서 돌아다니기 편한 곳 입니다.',30,163); 
insert into tblOneLine values(seqOneLine.nextval,'넓고 실내 구조가 잘 되어 있어서 돌아다니기 편한 곳 입니다.',22,164); 
insert into tblOneLine values(seqOneLine.nextval,'주말에 갔더니 사람이 너무 많아서 제대로 관람을 못했네요..',12,198); 
insert into tblOneLine values(seqOneLine.nextval,'여전히 젊은 거리 다른 곳은 조금씩 변했는데 이곳만은 젊음을 간직하고있다.',24,44); 
insert into tblOneLine values(seqOneLine.nextval,'넓고 실내 구조가 잘 되어 있어서 돌아다니기 편한 곳 입니다.',1,151); 
insert into tblOneLine values(seqOneLine.nextval,'친구들과 약속을 잡을 때 주로 가는 곳! 다양한 식당과 커피숍, 디저트 가게들이 있어요',7,8); 
insert into tblOneLine values(seqOneLine.nextval,'주말에 갔더니 사람이 너무 많아서 제대로 관람을 못했네요..',15,36); 
insert into tblOneLine values(seqOneLine.nextval,'한국 여행의 진정한 맛을 느끼기 위해선 전통 시장에서의 맛 체험이 필수이다. ',16,69); 
insert into tblOneLine values(seqOneLine.nextval,'넓고 실내 구조가 잘 되어 있어서 돌아다니기 편한 곳 입니다.',24,244); 
insert into tblOneLine values(seqOneLine.nextval,'여전히 젊은 거리 다른 곳은 조금씩 변했는데 이곳만은 젊음을 간직하고있다.',25,136); 
insert into tblOneLine values(seqOneLine.nextval,'주말에 갔더니 사람이 너무 많아서 제대로 관람을 못했네요..',17,189); 
insert into tblOneLine values(seqOneLine.nextval,'주말에 갔더니 사람이 너무 많아서 제대로 관람을 못했네요..',13,44); 
insert into tblOneLine values(seqOneLine.nextval,'여전히 젊은 거리 다른 곳은 조금씩 변했는데 이곳만은 젊음을 간직하고있다.',8,156); 
insert into tblOneLine values(seqOneLine.nextval,'여전히 젊은 거리 다른 곳은 조금씩 변했는데 이곳만은 젊음을 간직하고있다.',2,115); 
insert into tblOneLine values(seqOneLine.nextval,'넓고 실내 구조가 잘 되어 있어서 돌아다니기 편한 곳 입니다.',25,149); 
insert into tblOneLine values(seqOneLine.nextval,'여전히 젊은 거리 다른 곳은 조금씩 변했는데 이곳만은 젊음을 간직하고있다.',26,215); 
insert into tblOneLine values(seqOneLine.nextval,'주말에 갔더니 사람이 너무 많아서 제대로 관람을 못했네요..',27,119); 
insert into tblOneLine values(seqOneLine.nextval,'넓고 실내 구조가 잘 되어 있어서 돌아다니기 편한 곳 입니다.',23,97); 
insert into tblOneLine values(seqOneLine.nextval,'한국 여행의 진정한 맛을 느끼기 위해선 전통 시장에서의 맛 체험이 필수이다. ',29,239); 
insert into tblOneLine values(seqOneLine.nextval,'주말에 갔더니 사람이 너무 많아서 제대로 관람을 못했네요..',20,112); 
insert into tblOneLine values(seqOneLine.nextval,'주말에 갔더니 사람이 너무 많아서 제대로 관람을 못했네요..',28,183); 
insert into tblOneLine values(seqOneLine.nextval,'친구들과 약속을 잡을 때 주로 가는 곳! 다양한 식당과 커피숍, 디저트 가게들이 있어요',27,133); 
insert into tblOneLine values(seqOneLine.nextval,'여전히 젊은 거리 다른 곳은 조금씩 변했는데 이곳만은 젊음을 간직하고있다.',22,109); 
insert into tblOneLine values(seqOneLine.nextval,'넓고 실내 구조가 잘 되어 있어서 돌아다니기 편한 곳 입니다.',17,241); 
insert into tblOneLine values(seqOneLine.nextval,'한국 여행의 진정한 맛을 느끼기 위해선 전통 시장에서의 맛 체험이 필수이다. ',14,200); 
insert into tblOneLine values(seqOneLine.nextval,'주말에 갔더니 사람이 너무 많아서 제대로 관람을 못했네요..',10,235); 
insert into tblOneLine values(seqOneLine.nextval,'여전히 젊은 거리 다른 곳은 조금씩 변했는데 이곳만은 젊음을 간직하고있다.',26,178); 
insert into tblOneLine values(seqOneLine.nextval,'넓고 실내 구조가 잘 되어 있어서 돌아다니기 편한 곳 입니다.',17,44); 
insert into tblOneLine values(seqOneLine.nextval,'한국 여행의 진정한 맛을 느끼기 위해선 전통 시장에서의 맛 체험이 필수이다. ',12,75); 
insert into tblOneLine values(seqOneLine.nextval,'주말에 갔더니 사람이 너무 많아서 제대로 관람을 못했네요..',6,242); 
insert into tblOneLine values(seqOneLine.nextval,'한국 여행의 진정한 맛을 느끼기 위해선 전통 시장에서의 맛 체험이 필수이다. ',8,13); 
insert into tblOneLine values(seqOneLine.nextval,'주말에 갔더니 사람이 너무 많아서 제대로 관람을 못했네요..',29,191); 
insert into tblOneLine values(seqOneLine.nextval,'친구들과 약속을 잡을 때 주로 가는 곳! 다양한 식당과 커피숍, 디저트 가게들이 있어요',22,213); 
insert into tblOneLine values(seqOneLine.nextval,'주말에 갔더니 사람이 너무 많아서 제대로 관람을 못했네요..',3,161); 
insert into tblOneLine values(seqOneLine.nextval,'넓고 실내 구조가 잘 되어 있어서 돌아다니기 편한 곳 입니다.',24,93); 
insert into tblOneLine values(seqOneLine.nextval,'한국 여행의 진정한 맛을 느끼기 위해선 전통 시장에서의 맛 체험이 필수이다. ',3,87); 
insert into tblOneLine values(seqOneLine.nextval,'친구들과 약속을 잡을 때 주로 가는 곳! 다양한 식당과 커피숍, 디저트 가게들이 있어요',3,234); 
insert into tblOneLine values(seqOneLine.nextval,'한국 여행의 진정한 맛을 느끼기 위해선 전통 시장에서의 맛 체험이 필수이다. ',21,90); 
insert into tblOneLine values(seqOneLine.nextval,'한국 여행의 진정한 맛을 느끼기 위해선 전통 시장에서의 맛 체험이 필수이다. ',14,138); 
insert into tblOneLine values(seqOneLine.nextval,'여전히 젊은 거리 다른 곳은 조금씩 변했는데 이곳만은 젊음을 간직하고있다.',26,72); 
insert into tblOneLine values(seqOneLine.nextval,'넓고 실내 구조가 잘 되어 있어서 돌아다니기 편한 곳 입니다.',19,138); 
insert into tblOneLine values(seqOneLine.nextval,'한국 여행의 진정한 맛을 느끼기 위해선 전통 시장에서의 맛 체험이 필수이다. ',1,82); 
insert into tblOneLine values(seqOneLine.nextval,'한국 여행의 진정한 맛을 느끼기 위해선 전통 시장에서의 맛 체험이 필수이다. ',16,38); 
insert into tblOneLine values(seqOneLine.nextval,'주말에 갔더니 사람이 너무 많아서 제대로 관람을 못했네요..',15,74); 
insert into tblOneLine values(seqOneLine.nextval,'친구들과 약속을 잡을 때 주로 가는 곳! 다양한 식당과 커피숍, 디저트 가게들이 있어요',22,167); 
insert into tblOneLine values(seqOneLine.nextval,'주말에 갔더니 사람이 너무 많아서 제대로 관람을 못했네요..',27,23); 
insert into tblOneLine values(seqOneLine.nextval,'친구들과 약속을 잡을 때 주로 가는 곳! 다양한 식당과 커피숍, 디저트 가게들이 있어요',8,179); 
insert into tblOneLine values(seqOneLine.nextval,'친구들과 약속을 잡을 때 주로 가는 곳! 다양한 식당과 커피숍, 디저트 가게들이 있어요',21,209); 
insert into tblOneLine values(seqOneLine.nextval,'넓고 실내 구조가 잘 되어 있어서 돌아다니기 편한 곳 입니다.',10,183); 
insert into tblOneLine values(seqOneLine.nextval,'넓고 실내 구조가 잘 되어 있어서 돌아다니기 편한 곳 입니다.',29,87); 
insert into tblOneLine values(seqOneLine.nextval,'주말에 갔더니 사람이 너무 많아서 제대로 관람을 못했네요..',11,236); 
insert into tblOneLine values(seqOneLine.nextval,'주말에 갔더니 사람이 너무 많아서 제대로 관람을 못했네요..',25,136); 
insert into tblOneLine values(seqOneLine.nextval,'넓고 실내 구조가 잘 되어 있어서 돌아다니기 편한 곳 입니다.',11,72); 
insert into tblOneLine values(seqOneLine.nextval,'여전히 젊은 거리 다른 곳은 조금씩 변했는데 이곳만은 젊음을 간직하고있다.',25,179); 
insert into tblOneLine values(seqOneLine.nextval,'넓고 실내 구조가 잘 되어 있어서 돌아다니기 편한 곳 입니다.',18,27);




-- 숙박시설


INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '웰리힐리파크', '강원도 횡성군 둔내면 두원리 204', 155020, 1);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '하이원 리조트', '강원도 정선군 고한읍 고한리 438', 169625, 1);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '홀리데이 인 리조트 알펜시아 평창', '강원도 평창군 대관령면 용산리 195', 118182, 1);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '켄싱턴리조트 지리산하동', '경상남도 하동군 화개면 운수리 384-17', 107308, 3);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '웨스트힐스 프라이빗 풀빌라', '전라남도 여수시 돌산읍 평사리 1403-5', 143316, 12);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, 'BLUE MANGO POOLVILL-RESORT', '전라남도 여수시 돌산읍 평사리 34-1', 160428, 12);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '여수 여수밤바다펜션', '전라남도 여수시 돌산읍 평사리 297-32', 147594, 12);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '여수 비고 풀빌라-리조트', '전라남도 여수시 돌산읍 평사리 1404-44', 157754, 12);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '스탠포드 호텔 명동', '서울특별시 중구 남대문로2가 9-1', 126334, 9);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '호텔 스카이파크 명동 1호점', '서울특별시 중구 충무로1가 24-23', 133622, 9);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '호텔 상상', '경상남도 거제시 일운면 소동리 2-2', 152832, 3);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '거제도 비커밍펜션', '경상남도 거제시 남부면 저구리 372', 174008, 3);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '토모노야 호텔 - 료칸', '경상남도 거제시 동부면 학동리 495-2', 97632, 3);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '거제 프래밀리 풀빌라 앤 호텔', '경상남도 거제시 일운면 와현리 544-5', 117897, 3);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '스터번 호텔', '경상남도 거제시 동부면 학동리 218-3', 139327, 3);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '더케이호텔 경주', '경상북도 경주시 신평동 150-2', 125430, 4);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '제주 미니 호텔', '경상북도 경주시 황오동 296', 152066, 4);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '썬 앤 문 리조트', '제주도 서귀포시 안덕면 사계리 2166-3', 167417, 14);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '와이리조트 제주', '제주도 서귀포시 안덕면 화순리 1888', 165104, 14);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '더 그랜드 섬오름', '제주도 서귀포시 법환동 1513', 319225, 14);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, 'MJ 리조트', '제주특별자치도 제주시 구좌읍 하도리 1810', 293639, 14);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '소노벨 청송  (구 대명리조트 청송)', '경상북도 청송군 주왕산면 하의리 859', 290033, 4);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '부산역 시티호텔', '부산광역시 동구 초량동 1163-2', 311202, 8);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '뉴 제주호텔', '제주도 제주시 노형동 928-3', 250860, 14);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '호텔 스카이파크 제주 1호점', '제주도 제주시 연동 272-29', 152776, 14);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '쏘타컬렉션 더 여수', '전라남도 여수시 국동 159-29', 194862, 12);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '여수 웅천 퍼스트 바이 쏘타', '전라남도 여수시 웅천동 1868-2', 212817, 12);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '여수 호텔 퍼스트 시티', '전라남도 여수시 웅천동 1868-2', 202270, 12);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '여수 호텔더원', '전라남도 여수시 국동 37-28', 134093, 12);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '여수 스테이 호텔', '전라남도 여수시 봉산동 276-5', 141250, 12);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '호텔 파이 종로', '서울특별시 종로구 연지동 119', 100570, 9);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '통통 쁘띠호텔', '서울특별시 종로구 봉익동 6', 161025, 9);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '호텔 더 디자이너스 종로', '서울특별시 종로구 관수동 14-1', 154057, 9);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '호텔스카이파크 킹스타운 동대문', '서울특별시 중구 을지로6가 17-2', 181177, 9);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '호텔 스카이파크 대전 1호점', '대전광역시 유성구 용산동 579', 136730, 7);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '라마다 바이 윈덤 대전', '대전광역시 유성구 봉명동 548-13', 124865, 7);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '베니키아 테크노밸리 호텔', '대전광역시 유성구 관평동 796', 115486, 7);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '에스앤나봄호텔', '대전광역시 유성구 관평동 781', 114356, 7);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '베스트웨스턴 플러스 호텔 세종', '세종 어진동 540', 152324, 15);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '호텔오노마 대전 오토그래프컬렉션', '대전광역시 유성구 도룡동 3-1', 161590, 7);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '호텔 탑스텐 정동진', '강원도 강릉시 옥계면 금진리 92-1', 153454, 1);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, 'SL호텔 강릉', '강원도 강릉시 주문진읍 교항리 190-4', 138708, 1);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '컨피네스 오션 스위트', '강원도 강릉시 사천면 사천진리 86-81', 144640, 1);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '나비 호스텔 홍대', '서울특별시 마포구 동교동 155-30', 123923, 9);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '버틀러리 제이엘', '서울특별시 마포구 동교동 198-30 홍대LJ빌딩', 105883, 9);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '지리산 일성 콘도', '전라북도 남원시 산내면 대정리 805-1', 432244, 13);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '산청 지리산신세계리조트', '경상남도 산청군 금서면 지막리 1118', 758605, 3);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '산청 휴롬빌리지', '경상남도 산청군 금서면 신아리 130-7', 685676, 3);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '엘시티 레지던스 와이컬렉션', '부산광역시 해운대구 중동 1829', 763316, 8);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '고성 뮤 (경상)', '경상남도 고성군 고성읍 월평리 344-2', 684413, 3);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '고성 명품무인호텔 시그니처', '경상남도 고성군 고성읍 교사리 840-7', 770338, 3);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '고성 봄 무인텔', '경상남도 고성군 고성읍 월평리 344', 282352, 3);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '라까사 호텔 서울', '서울특별시 강남구 신사동 527-2', 361764, 9);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '보코서울강남', '서울특별시 강남구 논현동 6', 394117, 9);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, 'UH 스위트 더 서울', '서울특별시 중구 만리동1가 33-1', 258823, 9);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '테이크 호텔 광명', '경기도 광명시 일직동 512-3', 396078, 2);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '나인트리 프리미어 호텔 서울 판교', '경기도 성남시 수정구 시흥동 296-3', 529411, 2);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '양지파인리조트', '경기도 용인시 처인구 양지면 남곡리 18-1', 270588, 2);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '마레보비치호텔', '제주도 제주시 애월읍 곽지리 1565-18', 323530, 14);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '에월스테이인제주', '제주도 제주시 애월읍 구엄리 609-1', 168628, 14);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '한화리조트 해운대', '부산광역시 해운대구 우동 1410-3', 192157, 8);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '기장 더베이 클럽 호텔', '부산광역시 기장군 기장읍 대변리 279', 508601, 8);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '베스트루이스해밀턴호텔 오션테라스', '부산광역시 기장군 기장읍 연화리 376-4', 129412, 8);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '오아시스 호텔', '경상남도 거제시 장평동 815-21', 684098, 3);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '호텔 큐브 경포', '강원도 강릉시 강문동 304-1', 690723, 1);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '브라운도트 경포', '강원도 강릉시 강문동 304-2', 188235, 1);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '강릉 루이스 호텔', '강원도 강릉시 옥천동 334-8', 188114, 1);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '부티크 호텔 봄봄', '강원도 강릉시 교동 1871-4', 223529, 1);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '강릉 씨티호텔', '강원도 강릉시 교동 1883-5', 215378, 1);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '강릉 파인시티 호텔', '강원도 강릉시 옥천동 211', 188721, 1);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '강릉 라피네 호텔', '강원도 강릉시 구정면 제비리 924-20', 187500, 1);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '브라운도트 남포 충무점', '부산광역시 서구 충무동3가 1-166', 194312, 8);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '남포 플래티넘 호텔', '부산광역시 중구 창선동1가 40-1', 194447, 8);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, 'YTT 호텔 남포', '부산광역시 중구 동광동3가 14', 194497, 8);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '버튼호텔', '부산광역시 서구 충무동1가 4-10', 189485, 8);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '글랜스호텔', '부산광역시 영도구 봉래동1가 2-1', 184513, 8);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '더하운드호텔', '부산광역시 중구 동광동3가 31-1', 194197, 8);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '남포 스테이웰 호텔', '부산광역시 중구 남포동2가 37', 194118, 8);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '서면 더클럽 호텔', '부산광역시 부산진구 부전동 520-3', 196463, 8);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '시티호텔 지앤지', '부산광역시 부산진구 부전동 521-17', 195873, 8);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '서면 덴바스타 센트럴호텔', '부산광역시 부산진구 부전동 524-17', 191593, 8);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '춘천아이관광호텔', '강원도 춘천시 효자동 685-22', 230070, 1);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '춘천캣츠호텔', '강원도 춘천시 효자동 685-12', 192756, 1);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '춘천 HOTEL 몽', '강원도 춘천시 효자동 685-5', 213458, 1);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '춘천 호텔 리츠', '강원도 춘천시 근화동 284-1', 206093, 1);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '춘천 S쁘띠', '강원도 춘천시 효자동 590-7', 188516, 1);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '춘천올리브', '강원도 춘천시 퇴계동 344-10', 276470, 1);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '춘천 필호텔', '강원도 춘천시 퇴계동 395-60', 341176, 1);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '수 호텔 여수', '전라남도 여수시 종화동 581-2', 152941, 12);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '여수 호텔 헤이븐', '전라남도 여수시 돌산읍 우두리 757', 341154, 12);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '포포인츠 바이쉐라톤 조선 서울역', '서울특별시 용산구 동자동 56', 318490, 9);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '씨사이드관광호텔', '인천광역시 중구 무의동 291-7 무의씨사이드관광호텔', 317161, 11);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '페어몬트 앰배서더 서울', '서울특별시 영등포구 여의도동 22', 318447, 9);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '포레스트 리솜', '충청북도 제천시 백운면 평동리 707', 318524, 16);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '여수 베이원파크', '전라남도 여수시 웅천동 1876-1', 317575, 12);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '어반스테이 여수웅천', '전라남도 여수시 웅천동 1868-4', 301118, 12);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '드래곤 수 여수', '전라남도 여수시 국동 105', 323225, 12);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '포포인츠 바이 쉐라톤 조선 서울역', '서울특별시 용산구 동자동 56', 328444, 9);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '코트야드 메리어트 서울 남대문', '서울특별시 중구 남대문로4가 17-23', 274826, 9);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '신천 상주호텔', '서울특별시 송파구 잠실동 193-1', 273935, 9);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '거제 솔스파펜션', '경상남도 거제시 장목면 외포리 589-1', 235294, 3);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '거제 디스커버리', '경상남도 거제시 장목면 시방리 782-1', 200000, 3);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '거제 지니스파펜션', '경상남도 거제시 장목면 외포리 481-6', 187255, 3);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '거제 스타마린풀빌라펜션', '경상남도 거제시 일운면 망치리 463-2', 209529, 3);

INSERT INTO tblAccom (aseq, aname, aaddress, aprice, locseq) 
VALUES (seqAccom.nextVal, '신라스테이 여수', '전라남도 여수시 수정동 621', 207404, 12);




-- 숙박시설 카테고리

insert into tblAcCategory (acseq, acname) values (seqAcCategory.nextVal, '호텔');

insert into tblAcCategory (acseq, acname) values (seqAcCategory.nextVal, '모텔');

insert into tblAcCategory (acseq, acname) values (seqAcCategory.nextVal, '게스트하우스');

insert into tblAcCategory (acseq, acname) values (seqAcCategory.nextVal, '펜션');




-- 숙박시설 정보
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 3, 1);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 3, 2);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 1, 3);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 3, 4);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 1, 5);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 3, 6);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 3, 7);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 1, 8);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 1, 9);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 1, 10);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 1, 11);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 3, 12);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 4, 13);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 4, 14);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 1, 15);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 4, 16);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 3, 17);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 3, 18);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 1, 19);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 4, 20);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 4, 21);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 3, 22);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 23);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 24);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 25);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 1, 26);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 1, 27);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 4, 28);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 29);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 30);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 31);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 4, 32);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 3, 33);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 34);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 35);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 3, 36);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 37);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 4, 38);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 3, 39);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 1, 40);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 41);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 42);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 4, 43);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 4, 44);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 45);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 46);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 47);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 3, 48);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 49);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 50);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 1, 51);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 1, 52);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 3, 53);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 3, 54);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 55);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 3, 56);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 3, 57);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 1, 58);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 1, 59);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 1, 60);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 1, 61);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 3, 62);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 63);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 64);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 3, 65);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 66);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 67);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 4, 68);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 69);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 3, 70);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 4, 71);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 72);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 4, 73);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 1, 74);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 3, 75);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 3, 76);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 1, 77);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 4, 78);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 4, 79);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 80);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 1, 81);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 4, 82);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 4, 83);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 3, 84);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 4, 85);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 4, 86);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 1, 87);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 88);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 4, 89);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 1, 90);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 91);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 92);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 1, 93);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 3, 94);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 95);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 4, 96);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 97);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 4, 98);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 4, 99);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 100);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 3, 101);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 102);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 2, 103);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 4, 104);
insert into tblAcInfo(aiseq, acseq, aseq) values(seqAcInfo.nextVal, 4, 105);


-- 장소
INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '어답산관광지', 1, 37.59380861, 128.0575207, '활동적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '구덕운동장', 8, 35.11659638, 129.0145297, '낭만적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '임시수도기념관', 8, 35.10374876, 129.0175954, '이색체험 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '송도오션파크', 8, 35.0727183, 129.0174477, '감성힐링 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '치산관광지', 4, 36.04693281, 128.712821, '가성비 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '영산포 역사갤러리', 12, 35.00072134, 126.7115039, '쇼핑여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '나주복암리고분전시관', 12, 34.99608962, 126.6570592, '시간여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '일본인근대가옥', 12, 34.99946578, 126.7131249, '문화예술 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '빛가람호수공원전망대', 12, 35.01683337, 126.7904361, '이국적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '최참판댁', 3, 35.15590905, 127.688408, '생태체험 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '화개장터', 3, 35.18798946, 127.6240666, '친환경 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '삼성궁', 3, 35.23870093, 127.7054288, '골목여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '이병주문학관', 3, 35.09720238, 127.8942256, '호캉스 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '하동레일파크', 3, 35.11333681, 127.8929765, '전통시장 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '지리산역사관', 3, 35.2896912, 127.646527, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '하동알프스레포츠', 3, 34.98260917, 127.894714, 'SNS명소 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '하동 플라이웨이 케이블카', 3, 34.98083847, 127.8952769, '전망좋은 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '유현문화관광지', 1, 37.52903211, 127.8186829, '먹방투어 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '법기수원지', 8, 35.34825271, 129.1079758, '가족여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '양산시립박물관', 3, 35.35849531, 129.0490358, '산업관광 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '양산타워', 3, 35.32782588, 129.0276012, '한옥여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '임경대', 3, 35.32243455, 128.9778074, '안심여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '황산공원', 3, 35.30173083, 128.9895949, '바다여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '송도해상케이블카', 8, 35.07664334, 129.0233986, '등산여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '송도해수욕장', 8, 35.07682117, 129.0180502, '활동적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '암남공원', 8, 35.0616574, 129.0149368, '낭만적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '구덕문화공원', 8, 35.12641369, 129.005742, '이색체험 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '송도해안산책로', 8, 35.0616574, 129.0149368, '감성힐링 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '대신공원', 8, 35.121591, 129.0161785, '가성비 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '부산공동어시장', 8, 35.08990091, 129.0263675, '쇼핑여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '천마산조각공원', 8, 35.08903987, 129.0174786, '시간여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '소요산관광지', 2, 37.94652177, 127.0693409, '문화예술 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '탑산약수온천', 4, 36.30396195, 128.5892642, '이국적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '진하해수욕장', 10, 35.3855388, 129.3415755, '생태체험 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '영남알프스 복합웰컴센터', 10, 35.55645417, 129.0679842, '친환경 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '외고산옹기마을', 10, 35.435094, 129.2795067, '골목여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '울주 대곡리 반구대 암각화', 10, 35.60863087, 129.172957, '호캉스 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '작괘천', 10, 35.55162452, 129.0953395, '전통시장 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '대운산 내원암 계곡', 10, 35.39913422, 129.2309807, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '간절곶 공원', 10, 35.3625312, 129.3591079, 'SNS명소 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '오전약수관광지', 4, 37.01209531, 128.7457209, '전망좋은 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '다덕약수관광지', 4, 36.9141215, 128.8273232, '먹방투어 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '두타연', 1, 38.246783, 127.9816923, '가족여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '한반도섬', 1, 38.130582, 127.982972, '산업관광 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '국토정중앙천문대', 1, 38.0689384, 128.0296768, '한옥여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '을지전망대', 1, 38.32452923, 128.1356817, '안심여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '제4땅굴', 1, 38.31963688, 128.1107257, '바다여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '양구 DMZ 조이나믹 체험장', 1, 38.28900491, 128.1464817, '등산여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '양구 통일관', 1, 38.2900609, 128.1455851, '활동적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '양구수목원', 1, 38.19204231, 128.0762778, '낭만적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '오-월드', 7, 36.28749924, 127.3985039, '이색체험 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '뿌리공원', 7, 36.28538043, 127.3883, '감성힐링 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '청도박물관', 4, 35.6942561, 128.6865383, '가성비 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '한국코미디타운', 4, 35.69358927, 128.6863109, '쇼핑여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '예천포리관광지', 4, 36.70015808, 128.514204, '시간여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '소싸움테마파크', 4, 35.68529236, 128.7242012, '문화예술 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '청도레일바이크', 4, 35.58811543, 128.7661723, '이국적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '청도자전거공원', 4, 35.5881145, 128.7661742, '생태체험 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '심우장', 9, 37.5936268, 126.9916662, '친환경 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '반월호수', 2, 37.32458238, 126.8899642, '호캉스 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '초막골 생태공원', 2, 37.35410097, 126.9191417, '전통시장 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '철쭉동산', 2, 37.35560813, 126.9269137, 'SNS명소 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '물누리체험관', 2, 37.32136505, 126.8996775, '전망좋은 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '누리천문대', 2, 37.33028283, 126.9153444, '먹방투어 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '금마관광지', 13, 36.0015063, 127.0570781, '가족여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '미륵사지관광지', 13, 36.01154232, 127.0287139, '산업관광 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '왕궁보석테마 관광지', 13, 35.99061279, 127.1025486, '한옥여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '웅포관광지', 13, 36.06581391, 126.8754193, '안심여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '불갑사관광지', 12, 35.199675, 126.550047, '바다여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '광명동굴', 2, 37.42467857, 126.8634321, '등산여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '예천삼강', 4, 36.56378393, 128.304509, '활동적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '장사해수욕장관광지', 4, 36.2824187, 129.3755938, '낭만적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '녹진관광지', 12, 34.568986, 126.300201, '이색체험 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '회동관광지', 12, 34.42726548, 126.3513474, '감성힐링 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '아리랑마을관광지', 12, 34.38201529, 126.2310334, '가성비 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '마니산 국민관광지', 11, 37.63245827, 126.4237957, '쇼핑여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '추사박물관', 2, 37.45300477, 127.0287157, '시간여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '남당', 15, 36.53923432, 126.4719154, '문화예술 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '구드래관광지', 15, 36.28718846, 126.9068136, '이국적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '서동요역사관광지', 15, 36.14594895, 126.8248464, '생태체험 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '백제문화관광단지', 15, 36.30386704, 126.9007732, '친환경 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '보문관광단지', 4, 35.843673, 129.2869659, '골목여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '오색관광지', 1, 38.07706115, 128.5128997, '호캉스 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '지경관광지', 1, 37.92741327, 128.7948611, '전통시장 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '설해원(양양국제공항)', 1, 38.05555608, 128.6641979, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '레인보우힐링관광지', 16, 36.15635341, 127.7865137, 'SNS명소 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '송호관광지', 16, 36.12969079, 127.676367, '전망좋은 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '순천만국가정원', 12, 34.92888588, 127.4999591, '먹방투어 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '거차뻘배체험마을', 12, 34.8375993, 127.4474457, '가족여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '순천만습지', 12, 34.88579701, 127.5092833, '산업관광 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '낙안읍성', 12, 34.90640107, 127.3418227, '한옥여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '드라마촬영장', 12, 34.95810919, 127.5378026, '안심여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '뿌리깊은나무박물관', 12, 34.9036464, 127.3399827, '바다여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '송광사', 12, 35.00236255, 127.2748706, '등산여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '선암사', 12, 34.99618213, 127.327356, '활동적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '에코촌유스호스텔', 12, 34.92310938, 127.5164423, '낭만적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '순천자연휴양림', 12, 35.04388083, 127.4744949, '이색체험 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '기독교역사박물관', 12, 34.96043473, 127.4801207, '감성힐링 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '그림책도서관', 12, 34.9579091, 127.4860252, '가성비 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '순천시청소년수련원', 12, 35.04652524, 127.4733227, '쇼핑여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '순천용오름마을', 12, 35.0921171, 127.2020571, '시간여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '순천향매실마을', 12, 35.0622232, 127.4045173, '문화예술 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '순천생태마을', 12, 35.06648711, 127.3602718, '이국적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '낙안민속자연휴양림', 12, 34.91226789, 127.3523884, '생태체험 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '은파관광지', 13, 35.95536227, 126.6890748, '친환경 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '금강호관광지', 13, 36.01987856, 126.7653058, '골목여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '한탄강관광지', 2, 38.00887699, 127.0588604, '호캉스 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '연천재인폭포', 2, 38.07672631, 127.142345, '전통시장 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '연천호로고루', 2, 37.98583872, 126.8596065, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '당포성', 2, 38.02350322, 126.9854182, 'SNS명소 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '연천전곡리유적', 2, 38.01564838, 127.0614526, '전망좋은 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '담양호국민관광지', 12, 35.4019831, 126.9990829, '먹방투어 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '죽녹원', 12, 35.32535666, 126.9866155, '가족여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '메타세쿼이아랜드', 12, 35.32342607, 127.001993, '산업관광 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '소쇄원', 12, 35.18433903, 127.0121793, '한옥여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '한국대나무박물관', 12, 35.30934367, 126.9764088, '안심여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '한국가사문학관', 12, 35.18796216, 127.0054858, '바다여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '슬로시티삼지내마을', 12, 35.23522516, 127.0178498, '등산여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '속초해수욕장', 1, 38.19014712, 128.603531, '활동적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '척산온천', 1, 38.190269, 128.5407013, '낭만적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '설악한화리조트', 1, 38.21030027, 128.5287216, '이색체험 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '부평아트센터', 11, 37.4822383, 126.7049334, '감성힐링 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '기후변화체험관', 11, 37.50932668, 126.7307645, '가성비 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '부평역사박물관', 11, 37.51214216, 126.7379081, '쇼핑여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '인천나비공원', 11, 37.52026697, 126.6927245, '시간여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '용마폭포공원', 9, 37.57335201, 127.0891138, '문화예술 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '망우리공원', 9, 37.59835362, 127.1148164, '이국적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '중랑캠핑숲', 9, 37.606893, 127.1106972, '생태체험 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '옹기테마공원', 9, 37.61265372, 127.0885194, '친환경 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '농월정', 3, 35.62464301, 127.7815571, '골목여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '달성토성마을', 6, 35.87331563, 128.5753765, '호캉스 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '오수의견관광지', 13, 35.54520338, 127.3326779, '전통시장 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '사선대관광지', 13, 35.672357, 127.2746265, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '율포해수욕장', 12, 34.67002926, 127.0890241, 'SNS명소 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '능강관광지', 16, 36.99002277, 128.1956764, '전망좋은 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '금월봉관광지', 16, 37.04384263, 128.1736527, '먹방투어 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '계산관광지', 16, 37.017861, 128.130911, '가족여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '만남의광장', 16, 37.01083356, 128.1811895, '산업관광 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '제천 성내관광지', 16, 37.03366403, 128.1751729, '한옥여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '한국차문화공원', 12, 34.71987643, 127.0817099, '안심여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '고구려대장간마을', 2, 37.56080787, 127.1109492, '바다여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '해양자연사박물관', 8, 35.2219498, 129.075647, '등산여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '작원관지', 3, 35.39853126, 128.8665763, '활동적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '부석사관광지', 4, 36.99435088, 128.6797054, '낭만적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '경산온천', 4, 35.78037855, 128.7922287, '이색체험 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '무극전적국민관광지', 16, 36.95063812, 127.6470132, '감성힐링 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '우수영관광지', 12, 34.57257374, 126.3101147, '가성비 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '땅끝관광지', 12, 34.29471348, 126.5250233, '쇼핑여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '이바구공작소', 8, 35.11709939, 129.0338233, '시간여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '장기려더나눔센터', 8, 35.11853593, 129.0326526, '문화예술 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '이바구충전소', 8, 35.11735028, 129.034686, '이국적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '168계단 부대시설', 8, 35.1176995, 129.0353474, '생태체험 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '김민부전망대', 8, 35.1176995, 129.0353474, '친환경 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '홍길동테마파크', 12, 35.31862071, 126.7265578, '골목여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '분원백자자료관', 2, 37.49625742, 127.3034492, '호캉스 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '유치환의 우체통', 8, 35.12209588, 129.0338423, '전통시장 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '소흥관(한중우호센터)', 8, 35.11507608, 129.0375502, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '만화체험관', 8, 35.13778041, 129.0497944, 'SNS명소 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '안용복기념 부산포개항문화관', 8, 35.13563677, 129.0529467, '전망좋은 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '좌천동굴', 8, 35.13325838, 129.0522683, '먹방투어 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '만화카페', 8, 35.13675143, 129.0496096, '가족여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '명란브랜드연구소', 8, 35.117117, 129.035016, '산업관광 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '제천온천관광지', 16, 36.92183352, 128.1819714, '한옥여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '교리관광지', 16, 37.01656717, 128.1768531, '안심여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '자갈치시장', 8, 35.09661444, 129.0305818, '바다여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '40계단테마거리', 8, 35.10397225, 129.0346287, '등산여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, 'BIFF광장', 8, 35.09862035, 129.0287588, '활동적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '영도대교', 8, 35.09725344, 129.035681, '낭만적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '보수동책방골목', 8, 35.10323904, 129.0263248, '이색체험 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '용두산공원', 8, 35.1009305, 129.0324434, '감성힐링 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '광복로', 8, 35.09947039, 129.0311659, '가성비 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '부산영화체험박물관', 8, 35.10169342, 129.033594, '쇼핑여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '유니온파크', 2, 37.54654783, 127.2205032, '시간여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '광주향교', 2, 37.52207622, 127.1984175, '문화예술 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '이성산성', 2, 37.52530687, 127.1847777, '이국적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '세계무술공원', 16, 36.98782919, 127.9055691, '생태체험 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '충주호체험', 16, 37.02308256, 127.8619229, '친환경 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '능암온천', 16, 37.09370046, 127.802172, '골목여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '충온온천', 16, 37.10173095, 127.7962316, '호캉스 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '평택호관광단지', 2, 36.9148246, 126.912951, '전통시장 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '무릉계곡', 1, 37.463551, 129.014511, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '망상', 1, 37.59225327, 129.0896922, 'SNS명소 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '추암', 1, 37.477063, 129.159196, '전망좋은 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '무이예술관', 1, 37.61527594, 128.348787, '먹방투어 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '백룡동굴', 1, 37.27786356, 128.577051, '가족여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '해인사', 3, 35.801504, 128.0976255, '산업관광 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '대장경테마파크', 3, 35.76749785, 128.1365362, '한옥여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '오도산 자연휴양림', 3, 35.67233319, 128.0553007, '안심여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '합천박물관', 3, 35.58042271, 128.2829423, '바다여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '황매산군립공원', 3, 35.48184913, 128.0037495, '등산여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '영상테마파크청와대세트장', 3, 35.54877253, 128.0728984, '활동적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '합천댐 물문화관', 3, 35.531585, 128.0295197, '낭만적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '황계폭포', 3, 35.51135706, 128.071173, '이색체험 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '정양레포츠공원', 3, 35.55690191, 128.1668052, '감성힐링 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '정양늪생태공원', 3, 35.55322772, 128.162786, '가성비 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '해인사 소리길', 3, 35.76749785, 128.1365362, '쇼핑여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '용문산 관광지', 2, 37.54529617, 127.583066, '시간여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '두물머리', 2, 37.53362262, 127.3174715, '문화예술 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '세미원', 2, 37.54093866, 127.3239608, '이국적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '쉬자파크', 2, 37.51122354, 127.5331978, '생태체험 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '용대관광지', 1, 38.18568475, 128.3061965, '친환경 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '용연동굴', 1, 37.20888277, 128.9418601, '골목여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '철암탄광역사촌', 1, 37.11436554, 129.0372165, '호캉스 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '석탄박물관', 1, 37.11724029, 128.9505662, '전통시장 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '태백고생대자연사박물관', 1, 37.0948994, 129.0396319, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '방동관광지', 1, 37.94387136, 128.3962628, 'SNS명소 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '오토테마파크', 1, 38.00266835, 128.2953846, '전망좋은 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '성류굴 관광지', 4, 36.95884825, 129.3794409, '먹방투어 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '백암온천 관광지', 4, 36.72132775, 129.343467, '가족여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '덕산온천관광단지', 15, 36.69075649, 126.659328, '산업관광 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '장흥관광지', 2, 37.73281632, 126.9492504, '안심여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '실안관광지', 3, 34.94398447, 128.0399764, '바다여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '옥계해변관광지', 1, 37.62739946, 129.0476423, '등산여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '주문진해변관광지', 1, 37.91137845, 128.8178804, '활동적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '연곡해변관광지', 1, 37.858992, 128.851409, '낭만적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '등명해변관광지', 1, 37.70264843, 129.0164178, '이색체험 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '대관령어흘리관광지', 1, 37.719113, 128.793989, '감성힐링 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '수동관광지', 2, 37.75797919, 127.2753596, '가성비 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '송정관광지', 3, 34.7231451, 128.0249667, '쇼핑여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '영도관광안내센터', 8, 35.09454127, 129.0387847, '시간여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '성기동', 12, 34.75653201, 126.6291224, '문화예술 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '마한문화', 12, 34.89539241, 126.5859196, '이국적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '영산호관광지', 12, 34.776135, 126.4577774, '생태체험 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '한려수도조망케이블카', 3, 34.82665041, 128.4251243, '친환경 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '한산도 제승당', 3, 34.79264032, 128.4759648, '골목여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '통영루지', 3, 34.82440908, 128.4241617, '호캉스 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '박경리기념관', 3, 34.802301, 128.4035792, '전통시장 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '해저터널', 3, 34.83609021, 128.411698, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '장사도해상공원', 3, 34.71373747, 128.5588706, 'SNS명소 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '통영시립박물관', 3, 34.84075153, 128.4167887, '전망좋은 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '삼도수군통제영', 3, 34.84715495, 128.423489, '먹방투어 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '춘천호반(삼악산)', 1, 37.825714, 127.659368, '가족여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '청평사', 1, 37.983441, 127.818301, '산업관광 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '구곡폭포', 1, 37.797033, 127.615852, '한옥여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '몰운대', 8, 35.04638172, 128.9680068, '안심여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '다대포해수욕장', 8, 35.04638172, 128.9680068, '바다여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '감천문화마을', 8, 35.09748815, 129.0106077, '등산여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '장림포구', 8, 35.07915955, 128.9513486, '활동적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '꽃보라동산', 6, 35.889576, 128.601059, '낭만적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '운암지수변공원', 6, 35.932633, 128.567671, '이색체험 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '팔달대교 야경', 6, 35.895353, 128.550766, '감성힐링 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '금호강하중도', 6, 35.900092, 128.559326, '가성비 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '경북대학교 캠퍼스', 6, 35.88909849, 128.6143217, '쇼핑여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '함지공원', 6, 35.9424608, 128.570482, '시간여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '구암서원', 6, 35.89881592, 128.5989989, '문화예술 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '침산정', 6, 35.897221, 128.5848591, '이국적인 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '광주광역시어린이교통공원', 5, 35.21837394, 126.8544969, '생태체험 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '국립광주광역시박물관', 5, 35.18965658, 126.8839515, '친환경 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '김대중 컨벤션센터', 5, 35.14677706, 126.8404805, '골목여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '돗통', 14, 33.24960345, 126.29792991125055 , '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '난드르바당', 14, 33.234606, 126.3710321, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '오후새우시', 14, 33.25162507, 126.4242372, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '숙성도 중문점', 14, 33.258277, 126.4074896, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '먹고정 본점', 14, 33.24724494, 126.5624412, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '가시아방국수', 14, 33.43858705, 126.918054, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '소금바치 순이네', 14, 33.43858705, 126.918054, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '달치즈', 14, 33.52415842, 126.8620512, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '파도소리해녀촌', 14, 33.5197302, 126.9488544, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '명진전복', 14, 33.53247538, 126.850158, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '보물선 횟집', 14, 33.51701743, 126.5155847, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '대영수산', 1, 37.89102314, 128.8278316, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '중앙돈가스', 1, 37.75367112, 128.897951, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '속초문어국밥', 1, 38.20393669, 128.5888672, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '강릉짬뽕순두부 동화가든', 1, 37.79107814, 128.9146695, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '아바이 회국수', 1, 38.19989215, 128.5943385, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '고선생화덕생선구이 삼척', 1, 37.46714592, 129.1693411, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '형제칼국수', 1, 37.75786224, 128.8930543, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '초당버거', 1, 37.79137327, 128.914802, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '봉포머구리집', 1, 38.21870883, 128.5932762, '맛집여행 ');

INSERT INTO tblPlace (plseq, plname, locseq, pllat, pllng, ptheme) 
VALUES ( seqPlace.nextVal, '백촌막국수', 1, 38.29295426, 128.5418209, '맛집여행 ');



select * from tblBus;
-- 고속버스
insert into tblBus values(seqBus.nextval,'1321',TO_DATE('2023-01-07 01:00','yyyy-MM-DD hh24:mi'),4,9,8);
insert into tblBus values(seqBus.nextval,'8521',TO_DATE('2023-01-07 02:00','yyyy-MM-DD hh24:mi'),4,9,8);
insert into tblBus values(seqBus.nextval,'7825',TO_DATE('2023-01-07 06:00','yyyy-MM-DD hh24:mi'),4,9,8);
insert into tblBus values(seqBus.nextval,'9981',TO_DATE('2023-01-07 07:20','yyyy-MM-DD hh24:mi'),4,9,8);
insert into tblBus values(seqBus.nextval,'5237',TO_DATE('2023-01-07 09:10','yyyy-MM-DD hh24:mi'),4,9,8);
insert into tblBus values(seqBus.nextval,'7512',TO_DATE('2023-01-07 11:20','yyyy-MM-DD hh24:mi'),4,9,8);
insert into tblBus values(seqBus.nextval,'3452',TO_DATE('2023-01-07 13:50','yyyy-MM-DD hh24:mi'),4,9,8);
insert into tblBus values(seqBus.nextval,'1313',TO_DATE('2023-01-07 15:10','yyyy-MM-DD hh24:mi'),4,9,8);
insert into tblBus values(seqBus.nextval,'8284',TO_DATE('2023-01-07 17:40','yyyy-MM-DD hh24:mi'),4,9,8);
insert into tblBus values(seqBus.nextval,'0753',TO_DATE('2023-01-07 19:40','yyyy-MM-DD hh24:mi'),4,9,8);
insert into tblBus values(seqBus.nextval,'3207',TO_DATE('2023-01-07 21:10','yyyy-MM-DD hh24:mi'),4,9,8);
insert into tblBus values(seqBus.nextval,'1321',TO_DATE('2023-01-09 01:00','yyyy-MM-DD hh24:mi'),4,8, 9);
insert into tblBus values(seqBus.nextval,'8521',TO_DATE('2023-01-09 02:00','yyyy-MM-DD hh24:mi'),4,8, 9);
insert into tblBus values(seqBus.nextval,'7825',TO_DATE('2023-01-09 06:00','yyyy-MM-DD hh24:mi'),4,8, 9);
insert into tblBus values(seqBus.nextval,'9981',TO_DATE('2023-01-09 07:20','yyyy-MM-DD hh24:mi'),4,8, 9);
insert into tblBus values(seqBus.nextval,'5237',TO_DATE('2023-01-09 09:10','yyyy-MM-DD hh24:mi'),4,8, 9);
insert into tblBus values(seqBus.nextval,'7512',TO_DATE('2023-01-09 11:20','yyyy-MM-DD hh24:mi'),4,8, 9);
insert into tblBus values(seqBus.nextval,'3452',TO_DATE('2023-01-09 13:50','yyyy-MM-DD hh24:mi'),4,8, 9);
insert into tblBus values(seqBus.nextval,'1313',TO_DATE('2023-01-09 15:10','yyyy-MM-DD hh24:mi'),4,8, 9);
insert into tblBus values(seqBus.nextval,'8284',TO_DATE('2023-01-09 17:40','yyyy-MM-DD hh24:mi'),4,8, 9);
insert into tblBus values(seqBus.nextval,'0753',TO_DATE('2023-01-09 19:40','yyyy-MM-DD hh24:mi'),4,8, 9);
insert into tblBus values(seqBus.nextval,'3207',TO_DATE('2023-01-09 21:10','yyyy-MM-DD hh24:mi'),4,8, 9);
insert into tblBus values(seqBus.nextval,'3454',TO_DATE('2022-12-30 01:16','yyyy-MM-DD hh24:mi'),6,11,15);
insert into tblBus values(seqBus.nextval,'1658',TO_DATE('2022-12-19 07:36','yyyy-MM-DD hh24:mi'),8,7,8);
insert into tblBus values(seqBus.nextval,'8656',TO_DATE('2022-12-12 15:14','yyyy-MM-DD hh24:mi'),5,2,16);
insert into tblBus values(seqBus.nextval,'4538',TO_DATE('2022-12-21 08:59','yyyy-MM-DD hh24:mi'),5,5,3);
insert into tblBus values(seqBus.nextval,'4847',TO_DATE('2022-12-18 06:33','yyyy-MM-DD hh24:mi'),5,6,2);
insert into tblBus values(seqBus.nextval,'2755',TO_DATE('2022-12-09 20:09','yyyy-MM-DD hh24:mi'),2,11,15);
insert into tblBus values(seqBus.nextval,'4147',TO_DATE('2022-12-30 07:35','yyyy-MM-DD hh24:mi'),6,16,15);
insert into tblBus values(seqBus.nextval,'9576',TO_DATE('2022-12-20 17:58','yyyy-MM-DD hh24:mi'),6,2,6);
insert into tblBus values(seqBus.nextval,'4843',TO_DATE('2022-12-10 04:53','yyyy-MM-DD hh24:mi'),8,5,13);
insert into tblBus values(seqBus.nextval,'1164',TO_DATE('2022-12-08 17:15','yyyy-MM-DD hh24:mi'),3,2,8);
insert into tblBus values(seqBus.nextval,'3335',TO_DATE('2022-12-22 01:52','yyyy-MM-DD hh24:mi'),4,16,8);
insert into tblBus values(seqBus.nextval,'3475',TO_DATE('2022-12-13 14:59','yyyy-MM-DD hh24:mi'),6,6,5);
insert into tblBus values(seqBus.nextval,'8128',TO_DATE('2022-12-06 11:8','yyyy-MM-DD hh24:mi'),8,4,3);
insert into tblBus values(seqBus.nextval,'8915',TO_DATE('2022-12-17 11:17','yyyy-MM-DD hh24:mi'),5,11,7);
insert into tblBus values(seqBus.nextval,'2744',TO_DATE('2022-12-10 02:00','yyyy-MM-DD hh24:mi'),5,2,5);
insert into tblBus values(seqBus.nextval,'3876',TO_DATE('2022-12-21 01:10','yyyy-MM-DD hh24:mi'),5,4,15);
insert into tblBus values(seqBus.nextval,'6869',TO_DATE('2022-12-28 03:4','yyyy-MM-DD hh24:mi'),5,15,12);
insert into tblBus values(seqBus.nextval,'6426',TO_DATE('2022-12-16 18:19','yyyy-MM-DD hh24:mi'),6,11,1);
insert into tblBus values(seqBus.nextval,'3395',TO_DATE('2022-12-14 09:15','yyyy-MM-DD hh24:mi'),4,3,6);
insert into tblBus values(seqBus.nextval,'2292',TO_DATE('2022-12-27 06:21','yyyy-MM-DD hh24:mi'),7,2,10);
insert into tblBus values(seqBus.nextval,'5503',TO_DATE('2022-12-28 23:48','yyyy-MM-DD hh24:mi'),6,16,12);
insert into tblBus values(seqBus.nextval,'1036',TO_DATE('2022-12-09 21:26','yyyy-MM-DD hh24:mi'),5,11,6);
insert into tblBus values(seqBus.nextval,'4592',TO_DATE('2022-12-08 22:28','yyyy-MM-DD hh24:mi'),2,11,9);
insert into tblBus values(seqBus.nextval,'8025',TO_DATE('2022-12-14 15:43','yyyy-MM-DD hh24:mi'),8,16,7);
insert into tblBus values(seqBus.nextval,'1318',TO_DATE('2022-12-13 07:12','yyyy-MM-DD hh24:mi'),2,2,15);
insert into tblBus values(seqBus.nextval,'1441',TO_DATE('2022-12-18 17:20','yyyy-MM-DD hh24:mi'),4,11,9);
insert into tblBus values(seqBus.nextval,'2317',TO_DATE('2022-12-25 14:49','yyyy-MM-DD hh24:mi'),3,10,2);
insert into tblBus values(seqBus.nextval,'3764',TO_DATE('2022-12-30 20:12','yyyy-MM-DD hh24:mi'),3,7,2);
insert into tblBus values(seqBus.nextval,'3735',TO_DATE('2022-12-26 15:22','yyyy-MM-DD hh24:mi'),1,11,3);
insert into tblBus values(seqBus.nextval,'8003',TO_DATE('2022-12-12 01:19','yyyy-MM-DD hh24:mi'),6,12,10);
insert into tblBus values(seqBus.nextval,'5598',TO_DATE('2022-12-24 15:59','yyyy-MM-DD hh24:mi'),4,15,1);
insert into tblBus values(seqBus.nextval,'1505',TO_DATE('2022-12-04 01:23','yyyy-MM-DD hh24:mi'),1,10,16);
insert into tblBus values(seqBus.nextval,'4491',TO_DATE('2022-12-10 15:06','yyyy-MM-DD hh24:mi'),6,12,8);
insert into tblBus values(seqBus.nextval,'5123',TO_DATE('2022-12-10 08:20','yyyy-MM-DD hh24:mi'),4,2,8);
insert into tblBus values(seqBus.nextval,'3233',TO_DATE('2022-12-28 03:20','yyyy-MM-DD hh24:mi'),5,7,6);
insert into tblBus values(seqBus.nextval,'7940',TO_DATE('2022-12-13 03:50','yyyy-MM-DD hh24:mi'),8,15,11);
insert into tblBus values(seqBus.nextval,'7910',TO_DATE('2022-12-25 08:43','yyyy-MM-DD hh24:mi'),3,4,14);
insert into tblBus values(seqBus.nextval,'3404',TO_DATE('2022-12-16 04:44','yyyy-MM-DD hh24:mi'),3,12,16);
insert into tblBus values(seqBus.nextval,'2317',TO_DATE('2022-12-30 03:45','yyyy-MM-DD hh24:mi'),5,13,5);
insert into tblBus values(seqBus.nextval,'2532',TO_DATE('2022-12-22 03:20','yyyy-MM-DD hh24:mi'),1,2,15);
insert into tblBus values(seqBus.nextval,'1844',TO_DATE('2022-12-17 18:50','yyyy-MM-DD hh24:mi'),7,12,8);
insert into tblBus values(seqBus.nextval,'4987',TO_DATE('2022-12-05 20:06','yyyy-MM-DD hh24:mi'),2,2,9);
insert into tblBus values(seqBus.nextval,'9371',TO_DATE('2022-12-29 18:8','yyyy-MM-DD hh24:mi'),8,4,1);
insert into tblBus values(seqBus.nextval,'5687',TO_DATE('2022-12-25 11:35','yyyy-MM-DD hh24:mi'),6,8,2);
insert into tblBus values(seqBus.nextval,'3717',TO_DATE('2022-12-18 12:40','yyyy-MM-DD hh24:mi'),3,15,9);
insert into tblBus values(seqBus.nextval,'2184',TO_DATE('2022-12-10 09:44','yyyy-MM-DD hh24:mi'),6,12,16);
insert into tblBus values(seqBus.nextval,'6117',TO_DATE('2022-12-04 12:19','yyyy-MM-DD hh24:mi'),7,5,5);
insert into tblBus values(seqBus.nextval,'6274',TO_DATE('2022-12-24 06:59','yyyy-MM-DD hh24:mi'),4,13,5);
insert into tblBus values(seqBus.nextval,'3281',TO_DATE('2022-12-05 01:20','yyyy-MM-DD hh24:mi'),1,6,2);
insert into tblBus values(seqBus.nextval,'4629',TO_DATE('2022-12-04 18:39','yyyy-MM-DD hh24:mi'),3,11,7);
---------------------------------------------------------------------------------------------------------
insert into tblBus values(seqBus.nextval,'4309',TO_DATE('2023-01-22 23:50','yyyy-MM-DD hh24:mi'),4,6,12);
insert into tblBus values(seqBus.nextval,'4740',TO_DATE('2023-01-20 20:47','yyyy-MM-DD hh24:mi'),7,4,1);
insert into tblBus values(seqBus.nextval,'8247',TO_DATE('2023-01-01 03:13','yyyy-MM-DD hh24:mi'),3,16,7);
insert into tblBus values(seqBus.nextval,'9490',TO_DATE('2023-01-26 06:53','yyyy-MM-DD hh24:mi'),7,5,5);
insert into tblBus values(seqBus.nextval,'1576',TO_DATE('2023-01-07 16:24','yyyy-MM-DD hh24:mi'),4,9,1);
insert into tblBus values(seqBus.nextval,'9492',TO_DATE('2023-01-05 13:32','yyyy-MM-DD hh24:mi'),6,4,7);
insert into tblBus values(seqBus.nextval,'7662',TO_DATE('2023-01-21 23:31','yyyy-MM-DD hh24:mi'),1,6,5);
insert into tblBus values(seqBus.nextval,'6179',TO_DATE('2023-01-12 20:14','yyyy-MM-DD hh24:mi'),5,4,16);
insert into tblBus values(seqBus.nextval,'2289',TO_DATE('2023-01-08 03:1','yyyy-MM-DD hh24:mi'),3,10,16);
insert into tblBus values(seqBus.nextval,'7683',TO_DATE('2023-01-30 08:17','yyyy-MM-DD hh24:mi'),4,2,16);
insert into tblBus values(seqBus.nextval,'7829',TO_DATE('2023-01-28 08:9','yyyy-MM-DD hh24:mi'),6,8,8);
insert into tblBus values(seqBus.nextval,'4142',TO_DATE('2023-01-26 01:1','yyyy-MM-DD hh24:mi'),4,15,11);
insert into tblBus values(seqBus.nextval,'9216',TO_DATE('2023-01-15 08:29','yyyy-MM-DD hh24:mi'),1,10,12);
insert into tblBus values(seqBus.nextval,'8933',TO_DATE('2023-01-24 09:40','yyyy-MM-DD hh24:mi'),1,1,7);
insert into tblBus values(seqBus.nextval,'9943',TO_DATE('2023-01-18 08:59','yyyy-MM-DD hh24:mi'),2,5,13);
insert into tblBus values(seqBus.nextval,'4177',TO_DATE('2023-01-18 10:30','yyyy-MM-DD hh24:mi'),5,9,4);
insert into tblBus values(seqBus.nextval,'7241',TO_DATE('2023-01-18 18:17','yyyy-MM-DD hh24:mi'),2,1,3);
insert into tblBus values(seqBus.nextval,'2551',TO_DATE('2023-01-21 08:52','yyyy-MM-DD hh24:mi'),4,2,8);
insert into tblBus values(seqBus.nextval,'7770',TO_DATE('2023-01-14 03:50','yyyy-MM-DD hh24:mi'),6,9,6);
insert into tblBus values(seqBus.nextval,'2546',TO_DATE('2023-01-15 14:58','yyyy-MM-DD hh24:mi'),2,11,3);
insert into tblBus values(seqBus.nextval,'1028',TO_DATE('2023-01-15 03:21','yyyy-MM-DD hh24:mi'),3,10,13);
insert into tblBus values(seqBus.nextval,'6654',TO_DATE('2023-01-14 19:30','yyyy-MM-DD hh24:mi'),1,15,9);
insert into tblBus values(seqBus.nextval,'8340',TO_DATE('2023-01-19 21:55','yyyy-MM-DD hh24:mi'),6,12,9);
insert into tblBus values(seqBus.nextval,'9956',TO_DATE('2023-01-08 11:56','yyyy-MM-DD hh24:mi'),4,11,9);
insert into tblBus values(seqBus.nextval,'7021',TO_DATE('2023-01-26 20:41','yyyy-MM-DD hh24:mi'),8,16,12);
insert into tblBus values(seqBus.nextval,'1721',TO_DATE('2023-01-26 01:52','yyyy-MM-DD hh24:mi'),3,8,16);
insert into tblBus values(seqBus.nextval,'9052',TO_DATE('2023-01-08 05:22','yyyy-MM-DD hh24:mi'),1,8,2);
insert into tblBus values(seqBus.nextval,'6648',TO_DATE('2023-01-09 07:26','yyyy-MM-DD hh24:mi'),8,6,6);
insert into tblBus values(seqBus.nextval,'7203',TO_DATE('2023-01-22 13:19','yyyy-MM-DD hh24:mi'),6,5,1);
insert into tblBus values(seqBus.nextval,'8382',TO_DATE('2023-01-24 09:38','yyyy-MM-DD hh24:mi'),7,15,1);
insert into tblBus values(seqBus.nextval,'7052',TO_DATE('2023-01-19 09:50','yyyy-MM-DD hh24:mi'),7,5,13);
insert into tblBus values(seqBus.nextval,'5925',TO_DATE('2023-01-06 06:56','yyyy-MM-DD hh24:mi'),8,15,11);
insert into tblBus values(seqBus.nextval,'7661',TO_DATE('2023-01-17 21:34','yyyy-MM-DD hh24:mi'),3,3,15);
insert into tblBus values(seqBus.nextval,'1719',TO_DATE('2023-01-3 08:56','yyyy-MM-DD hh24:mi'),7,16,3);
insert into tblBus values(seqBus.nextval,'8299',TO_DATE('2023-01-6 22:11','yyyy-MM-DD hh24:mi'),8,12,13);
insert into tblBus values(seqBus.nextval,'6205',TO_DATE('2023-01-20 17:45','yyyy-MM-DD hh24:mi'),6,10,8);
insert into tblBus values(seqBus.nextval,'6224',TO_DATE('2023-01-13 13:45','yyyy-MM-DD hh24:mi'),1,10,12);
insert into tblBus values(seqBus.nextval,'8624',TO_DATE('2023-01-18 09:12','yyyy-MM-DD hh24:mi'),5,4,1);
insert into tblBus values(seqBus.nextval,'7863',TO_DATE('2023-01-10 21:25','yyyy-MM-DD hh24:mi'),3,7,9);
insert into tblBus values(seqBus.nextval,'9678',TO_DATE('2023-01-25 14:41','yyyy-MM-DD hh24:mi'),2,12,10);
insert into tblBus values(seqBus.nextval,'4501',TO_DATE('2023-01-17 06:24','yyyy-MM-DD hh24:mi'),7,13,5);
insert into tblBus values(seqBus.nextval,'4111',TO_DATE('2023-01-04 22:10','yyyy-MM-DD hh24:mi'),4,13,4);
insert into tblBus values(seqBus.nextval,'1423',TO_DATE('2023-01-10 19:0','yyyy-MM-DD hh24:mi'),8,2,7);
insert into tblBus values(seqBus.nextval,'9122',TO_DATE('2023-01-14 20:56','yyyy-MM-DD hh24:mi'),5,10,1);
insert into tblBus values(seqBus.nextval,'1999',TO_DATE('2023-01-21 18:25','yyyy-MM-DD hh24:mi'),8,15,12);
insert into tblBus values(seqBus.nextval,'7447',TO_DATE('2023-01-14 20:38','yyyy-MM-DD hh24:mi'),5,5,6);
insert into tblBus values(seqBus.nextval,'2711',TO_DATE('2023-01-08 22:31','yyyy-MM-DD hh24:mi'),8,8,5);
insert into tblBus values(seqBus.nextval,'1571',TO_DATE('2023-01-16 03:38','yyyy-MM-DD hh24:mi'),6,5,9);
insert into tblBus values(seqBus.nextval,'8545',TO_DATE('2023-01-06 19:57','yyyy-MM-DD hh24:mi'),6,13,11);
insert into tblBus values(seqBus.nextval,'9186',TO_DATE('2023-01-12 12:21','yyyy-MM-DD hh24:mi'),7,6,8);





-- 항공
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KA494', TO_DATE('2023-01-09 00:10:00','yyyy-MM-DD hh24:mi:ss'), 1, 8, 9);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KD851', TO_DATE('2023-01-09 01:13:00','yyyy-MM-DD hh24:mi:ss'), 1, 8, 9);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KR991', TO_DATE('2023-01-09 03:22:00','yyyy-MM-DD hh24:mi:ss'), 1, 8, 9);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KQ783', TO_DATE('2023-01-09 05:05:00','yyyy-MM-DD hh24:mi:ss'), 1, 8, 9);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KF485', TO_DATE('2023-01-09 08:50:00','yyyy-MM-DD hh24:mi:ss'), 1, 8, 9);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KB164', TO_DATE('2023-01-09 09:13:00','yyyy-MM-DD hh24:mi:ss'), 1, 8, 9);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KO881', TO_DATE('2023-01-09 11:37:00','yyyy-MM-DD hh24:mi:ss'), 1, 8, 9);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KL972', TO_DATE('2023-01-09 13:13:00','yyyy-MM-DD hh24:mi:ss'), 1, 8, 9);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KD853', TO_DATE('2023-01-09 14:34:00','yyyy-MM-DD hh24:mi:ss'), 1, 8, 9);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KC052', TO_DATE('2023-01-09 17:05:00','yyyy-MM-DD hh24:mi:ss'), 1, 8, 9);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KR032', TO_DATE('2023-01-09 19:42:00','yyyy-MM-DD hh24:mi:ss'), 1, 8, 9);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KA123', TO_DATE('2023-01-09 22:13:00','yyyy-MM-DD hh24:mi:ss'), 1, 8, 9);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KF300', TO_DATE('2023-01-09 23:57:00','yyyy-MM-DD hh24:mi:ss'), 1, 8, 9);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KR944', TO_DATE('2023-01-07 01:10:00','yyyy-MM-DD hh24:mi:ss'), 1.6, 9, 8);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KA001', TO_DATE('2023-01-07 03:13:00','yyyy-MM-DD hh24:mi:ss'), 1, 9, 8);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KF491', TO_DATE('2023-01-07 05:22:00','yyyy-MM-DD hh24:mi:ss'), 1, 9, 8);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KT253', TO_DATE('2023-01-07 06:05:00','yyyy-MM-DD hh24:mi:ss'), 1, 9, 8);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KQ485', TO_DATE('2023-01-07 06:50:00','yyyy-MM-DD hh24:mi:ss'), 1, 9, 8);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KB164', TO_DATE('2023-01-07 09:13:00','yyyy-MM-DD hh24:mi:ss'), 1, 9, 8);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KO881', TO_DATE('2023-01-07 11:37:00','yyyy-MM-DD hh24:mi:ss'), 1, 9, 8);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KL972', TO_DATE('2023-01-07 13:13:00','yyyy-MM-DD hh24:mi:ss'), 1, 9, 8);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KD853', TO_DATE('2023-01-07 14:34:00','yyyy-MM-DD hh24:mi:ss'), 1, 9, 8);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KC052', TO_DATE('2023-01-07 17:05:00','yyyy-MM-DD hh24:mi:ss'), 1, 9, 8);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KR032', TO_DATE('2023-01-07 19:42:00','yyyy-MM-DD hh24:mi:ss'), 1, 9, 8);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KA123', TO_DATE('2023-01-07 22:13:00','yyyy-MM-DD hh24:mi:ss'), 1, 9, 8);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KF300', TO_DATE('2023-01-07 23:57:00','yyyy-MM-DD hh24:mi:ss'), 1, 9, 8);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KL030', TO_DATE('2023-01-07 11:13:00','yyyy-MM-DD hh24:mi:ss'), 1.6, 12, 8);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KD130', TO_DATE('2022-07-23 10:29:24','yyyy-MM-DD hh24:mi:ss'), 1.3, 13, 13);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KQ131', TO_DATE('2021-12-01 14:04:19','yyyy-MM-DD hh24:mi:ss'), 1.8, 7, 16);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KJ833', TO_DATE('2022-07-01 21:10:11','yyyy-MM-DD hh24:mi:ss'), 1.2, 14, 3);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KR332', TO_DATE('2022-12-18 08:12:09','yyyy-MM-DD hh24:mi:ss'), 2.0, 7, 10);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KH932', TO_DATE('2022-04-12 23:36:14','yyyy-MM-DD hh24:mi:ss'), 1.3, 10, 3);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KD137', TO_DATE('2022-08-17 21:59:00','yyyy-MM-DD hh24:mi:ss'), 1.4, 15, 4);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KL033', TO_DATE('2022-05-27 19:40:34','yyyy-MM-DD hh24:mi:ss'), 1.8, 2, 15);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KP538', TO_DATE('2022-07-05 01:38:42','yyyy-MM-DD hh24:mi:ss'), 1.3, 12, 1);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KC533', TO_DATE('2022-07-28 20:14:56','yyyy-MM-DD hh24:mi:ss'), 1.1, 4, 8);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KM336', TO_DATE('2022-06-29 23:56:28','yyyy-MM-DD hh24:mi:ss'), 1.9, 13, 9);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KJ833', TO_DATE('2022-08-15 08:17:23','yyyy-MM-DD hh24:mi:ss'), 1.8, 11, 16);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KJ430', TO_DATE('2022-10-01 19:24:22','yyyy-MM-DD hh24:mi:ss'), 1.7, 1, 7);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KB339', TO_DATE('2022-05-27 18:36:26','yyyy-MM-DD hh24:mi:ss'), 1.6, 13, 15);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KT331', TO_DATE('2022-02-02 02:36:11','yyyy-MM-DD hh24:mi:ss'), 1.5, 9, 12);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KA136', TO_DATE('2022-01-08 13:10:49','yyyy-MM-DD hh24:mi:ss'), 1.6, 5, 15);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KD537', TO_DATE('2022-03-31 02:55:42','yyyy-MM-DD hh24:mi:ss'), 1.2, 6, 10);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KK535', TO_DATE('2022-12-15 08:16:10','yyyy-MM-DD hh24:mi:ss'), 1.4, 12, 16);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KZ532', TO_DATE('2022-10-31 06:08:17','yyyy-MM-DD hh24:mi:ss'), 1.6, 11, 13);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KV537', TO_DATE('2022-11-11 20:08:43','yyyy-MM-DD hh24:mi:ss'), 1.6, 4, 2);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KM733', TO_DATE('2022-08-15 08:16:01','yyyy-MM-DD hh24:mi:ss'), 1.4, 15, 9);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KR639', TO_DATE('2022-04-02 13:43:05','yyyy-MM-DD hh24:mi:ss'), 1.3, 14, 9);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KW939', TO_DATE('2022-03-04 04:58:22','yyyy-MM-DD hh24:mi:ss'), 1.5, 5, 16);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KD532', TO_DATE('2022-12-21 02:10:52','yyyy-MM-DD hh24:mi:ss'), 1.6, 4, 7);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KA533', TO_DATE('2022-06-18 16:53:05','yyyy-MM-DD hh24:mi:ss'), 2.0, 6, 16);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KM830', TO_DATE('2022-02-15 06:45:17','yyyy-MM-DD hh24:mi:ss'), 2.0, 8, 3);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KM931', TO_DATE('2022-07-30 05:30:32','yyyy-MM-DD hh24:mi:ss'), 1.8, 9, 5);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KN939', TO_DATE('2022-01-23 19:07:04','yyyy-MM-DD hh24:mi:ss'), 1.0, 16, 13);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KA233', TO_DATE('2022-07-30 18:26:38','yyyy-MM-DD hh24:mi:ss'), 1.0, 1, 7);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KZ637', TO_DATE('2022-10-31 18:16:00','yyyy-MM-DD hh24:mi:ss'), 1.7, 8, 10);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KZ832', TO_DATE('2022-01-29 08:35:53','yyyy-MM-DD hh24:mi:ss'), 1.0, 7, 12);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KV035', TO_DATE('2022-07-30 19:24:54','yyyy-MM-DD hh24:mi:ss'), 1.8, 6, 1);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KI038', TO_DATE('2022-09-18 16:18:20','yyyy-MM-DD hh24:mi:ss'), 1.4, 9, 10);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KL335', TO_DATE('2022-06-30 06:06:53','yyyy-MM-DD hh24:mi:ss'), 1.9, 11, 8);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KM236', TO_DATE('2022-06-27 15:18:25','yyyy-MM-DD hh24:mi:ss'), 1.5, 7, 11);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KJ432', TO_DATE('2022-02-28 18:29:25','yyyy-MM-DD hh24:mi:ss'), 1.6, 4, 14);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KH338', TO_DATE('2022-01-25 23:28:03','yyyy-MM-DD hh24:mi:ss'), 2.0, 5, 10);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KJ031', TO_DATE('2022-03-12 20:25:23','yyyy-MM-DD hh24:mi:ss'), 1.2, 11, 16);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KQ331', TO_DATE('2022-06-20 17:20:36','yyyy-MM-DD hh24:mi:ss'), 1.9, 3, 6);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KC535', TO_DATE('2022-09-01 13:42:39','yyyy-MM-DD hh24:mi:ss'), 1.6, 8, 4);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KJ134', TO_DATE('2022-09-06 23:14:36','yyyy-MM-DD hh24:mi:ss'), 1.1, 13, 3);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KW336', TO_DATE('2022-04-16 23:44:21','yyyy-MM-DD hh24:mi:ss'), 1.5, 10, 4);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KS533', TO_DATE('2022-03-02 17:54:14','yyyy-MM-DD hh24:mi:ss'), 1.4, 1, 7);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KW736', TO_DATE('2022-03-05 06:21:32','yyyy-MM-DD hh24:mi:ss'), 1.3, 8, 16);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KE236', TO_DATE('2022-12-09 05:29:48','yyyy-MM-DD hh24:mi:ss'), 1.0, 2, 14);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KT431', TO_DATE('2022-09-03 18:07:45','yyyy-MM-DD hh24:mi:ss'), 1.3, 3, 1);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KQ839', TO_DATE('2022-01-30 05:20:42','yyyy-MM-DD hh24:mi:ss'), 1.5, 16, 4);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KT336', TO_DATE('2022-12-15 21:38:25','yyyy-MM-DD hh24:mi:ss'), 1.1, 7, 1);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KO131', TO_DATE('2022-05-26 06:57:09','yyyy-MM-DD hh24:mi:ss'), 1.5, 2, 13);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KY731', TO_DATE('2022-01-08 04:15:00','yyyy-MM-DD hh24:mi:ss'), 1.2, 12, 13);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KV938', TO_DATE('2023-01-13 18:34:13','yyyy-MM-DD hh24:mi:ss'), 1.3, 4, 10);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KB434', TO_DATE('2022-04-06 14:17:52','yyyy-MM-DD hh24:mi:ss'), 1.9, 12, 6);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KR635', TO_DATE('2023-01-19 07:03:39','yyyy-MM-DD hh24:mi:ss'), 1.9, 7, 4);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KX933', TO_DATE('2022-12-04 02:14:05','yyyy-MM-DD hh24:mi:ss'), 1.4, 4, 13);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KN636', TO_DATE('2022-02-24 12:34:51','yyyy-MM-DD hh24:mi:ss'), 1.2, 9, 8);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KJ637', TO_DATE('2022-03-19 02:20:52','yyyy-MM-DD hh24:mi:ss'), 1.9, 16, 4);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KP231', TO_DATE('2022-05-16 08:01:48','yyyy-MM-DD hh24:mi:ss'), 2.0, 9, 6);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KE334', TO_DATE('2022-12-30 23:13:31','yyyy-MM-DD hh24:mi:ss'), 1.4, 16, 7);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KX034', TO_DATE('2022-10-27 18:29:15','yyyy-MM-DD hh24:mi:ss'), 1.3, 8, 15);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KW938', TO_DATE('2022-06-11 09:54:01','yyyy-MM-DD hh24:mi:ss'), 1.5, 8, 9);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KN235', TO_DATE('2022-12-25 06:32:30','yyyy-MM-DD hh24:mi:ss'), 1.9, 11, 10);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KN136', TO_DATE('2022-12-28 02:02:16','yyyy-MM-DD hh24:mi:ss'), 1.8, 12, 15);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KL539', TO_DATE('2022-12-02 23:10:42','yyyy-MM-DD hh24:mi:ss'), 1.5, 13, 7);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KG531', TO_DATE('2022-06-25 17:41:40','yyyy-MM-DD hh24:mi:ss'), 1.7, 13, 14);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KN135', TO_DATE('2022-11-28 15:15:31','yyyy-MM-DD hh24:mi:ss'), 1.3, 8, 10);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KT232', TO_DATE('2021-12-27 09:28:59','yyyy-MM-DD hh24:mi:ss'), 1.4, 10, 13);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KW339', TO_DATE('2022-11-14 21:12:20','yyyy-MM-DD hh24:mi:ss'), 1.6, 1, 3);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KA937', TO_DATE('2022-02-05 09:02:15','yyyy-MM-DD hh24:mi:ss'), 1.9, 9, 8);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KM135', TO_DATE('2021-12-04 00:42:19','yyyy-MM-DD hh24:mi:ss'), 1.5, 7, 16);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KZ038', TO_DATE('2021-12-30 11:05:14','yyyy-MM-DD hh24:mi:ss'), 1.0, 5, 2);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KR837', TO_DATE('2022-03-27 17:26:39','yyyy-MM-DD hh24:mi:ss'), 1.6, 6, 14);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KK231', TO_DATE('2022-01-02 18:53:34','yyyy-MM-DD hh24:mi:ss'), 1.5, 15, 2);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KB231', TO_DATE('2021-12-14 16:07:10','yyyy-MM-DD hh24:mi:ss'), 1.6, 12, 11);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KM334', TO_DATE('2022-06-07 19:23:11','yyyy-MM-DD hh24:mi:ss'), 1.5, 7, 16);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KR134', TO_DATE('2022-10-07 06:54:04','yyyy-MM-DD hh24:mi:ss'), 1.8, 3, 6);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KF932', TO_DATE('2022-04-16 04:15:01','yyyy-MM-DD hh24:mi:ss'), 1.2, 9, 5);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KI133', TO_DATE('2022-07-18 16:26:49','yyyy-MM-DD hh24:mi:ss'), 1.7, 8, 1);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KQ637', TO_DATE('2022-02-11 15:02:23','yyyy-MM-DD hh24:mi:ss'), 1.3, 8, 13);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KI439', TO_DATE('2022-06-04 15:05:25','yyyy-MM-DD hh24:mi:ss'), 1.9, 14, 7);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KY835', TO_DATE('2022-08-16 04:10:23','yyyy-MM-DD hh24:mi:ss'), 1.7, 4, 3);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KO139', TO_DATE('2022-11-10 10:18:52','yyyy-MM-DD hh24:mi:ss'), 1.3, 6, 7);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KQ138', TO_DATE('2022-09-09 12:02:53','yyyy-MM-DD hh24:mi:ss'), 1.6, 12, 13);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KA233', TO_DATE('2022-07-09 13:53:02','yyyy-MM-DD hh24:mi:ss'), 1.2, 11, 15);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KD130', TO_DATE('2022-06-14 14:04:53','yyyy-MM-DD hh24:mi:ss'), 1.1, 4, 10);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KF936', TO_DATE('2021-12-26 12:32:34','yyyy-MM-DD hh24:mi:ss'), 1.0, 16, 7);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KO133', TO_DATE('2022-11-17 10:48:49','yyyy-MM-DD hh24:mi:ss'), 2.0, 9, 7);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KA231', TO_DATE('2022-05-13 08:19:55','yyyy-MM-DD hh24:mi:ss'), 1.7, 12, 7);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KF337', TO_DATE('2022-11-28 01:20:39','yyyy-MM-DD hh24:mi:ss'), 1.6, 1, 9);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KS630', TO_DATE('2022-10-16 06:48:58','yyyy-MM-DD hh24:mi:ss'), 1.5, 14, 9);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KL133', TO_DATE('2022-10-04 14:40:43','yyyy-MM-DD hh24:mi:ss'), 1.7, 13, 2);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KX534', TO_DATE('2022-02-20 01:27:32','yyyy-MM-DD hh24:mi:ss'), 1.2, 6, 13);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KE339', TO_DATE('2022-05-14 06:18:28','yyyy-MM-DD hh24:mi:ss'), 1.4, 13, 9);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KE436', TO_DATE('2022-08-02 17:09:33','yyyy-MM-DD hh24:mi:ss'), 1.7, 9, 12);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KT531', TO_DATE('2023-01-29 23:45:11','yyyy-MM-DD hh24:mi:ss'), 1.9, 13, 2);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KT930', TO_DATE('2023-01-25 16:31:42','yyyy-MM-DD hh24:mi:ss'), 1.8, 8, 5);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KF837', TO_DATE('2022-03-23 23:53:57','yyyy-MM-DD hh24:mi:ss'), 1.9, 6, 2);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KA130', TO_DATE('2022-10-31 19:24:43','yyyy-MM-DD hh24:mi:ss'), 1.9, 10, 6);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KI438', TO_DATE('2022-02-15 04:35:32','yyyy-MM-DD hh24:mi:ss'), 1.1, 10, 2);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KB239', TO_DATE('2022-02-01 20:55:54','yyyy-MM-DD hh24:mi:ss'), 1.2, 12, 16);
insert into tblFlight (fseq, fnum, fboard, ftime, fstart, fend) values (seqFlight.nextVal, 'KC333', TO_DATE('2022-01-19 22:07:11','yyyy-MM-DD hh24:mi:ss'), 1.2, 3, 10);



-- KTX
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX001', TO_DATE('2023-01-09 00:30','yyyy-MM-DD hh24:mi'), 3, 8, 9);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX324', TO_DATE('2023-01-09 01:30','yyyy-MM-DD hh24:mi'), 3, 8, 9);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX574', TO_DATE('2023-01-09 03:30','yyyy-MM-DD hh24:mi'), 3, 8, 9);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX924', TO_DATE('2023-01-09 06:30','yyyy-MM-DD hh24:mi'), 3, 8, 9);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX552', TO_DATE('2023-01-09 08:30','yyyy-MM-DD hh24:mi'), 3, 8, 9);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX232', TO_DATE('2023-01-09 10:30','yyyy-MM-DD hh24:mi'), 3, 8, 9);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX465', TO_DATE('2023-01-09 13:30','yyyy-MM-DD hh24:mi'), 3, 8, 9);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX352', TO_DATE('2023-01-09 14:30','yyyy-MM-DD hh24:mi'), 3, 8, 9);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX224', TO_DATE('2023-01-09 16:30','yyyy-MM-DD hh24:mi'), 3, 8, 9);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX852', TO_DATE('2023-01-09 18:30','yyyy-MM-DD hh24:mi'), 3, 8, 9);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX963', TO_DATE('2023-01-09 19:30','yyyy-MM-DD hh24:mi'), 3, 8, 9);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX741', TO_DATE('2023-01-09 20:30','yyyy-MM-DD hh24:mi'), 3, 8, 9);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX456', TO_DATE('2023-01-09 21:30','yyyy-MM-DD hh24:mi'), 3, 8, 9);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX373', TO_DATE('2023-01-09 23:30','yyyy-MM-DD hh24:mi'), 3, 8, 9);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX001', TO_DATE('2023-01-07 00:30','yyyy-MM-DD hh24:mi'), 3, 9, 8);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX324', TO_DATE('2023-01-07 01:30','yyyy-MM-DD hh24:mi'), 3, 9, 8);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX574', TO_DATE('2023-01-07 03:30','yyyy-MM-DD hh24:mi'), 3, 9, 8);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX924', TO_DATE('2023-01-07 06:30','yyyy-MM-DD hh24:mi'), 3, 9, 8);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX552', TO_DATE('2023-01-07 08:30','yyyy-MM-DD hh24:mi'), 3, 9, 8);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX232', TO_DATE('2023-01-07 10:30','yyyy-MM-DD hh24:mi'), 3, 9, 8);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX465', TO_DATE('2023-01-07 13:30','yyyy-MM-DD hh24:mi'), 3, 9, 8);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX352', TO_DATE('2023-01-07 14:30','yyyy-MM-DD hh24:mi'), 3, 9, 8);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX224', TO_DATE('2023-01-07 16:30','yyyy-MM-DD hh24:mi'), 3, 9, 8);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX852', TO_DATE('2023-01-07 18:30','yyyy-MM-DD hh24:mi'), 3, 9, 8);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX963', TO_DATE('2023-01-07 19:30','yyyy-MM-DD hh24:mi'), 3, 9, 8);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX741', TO_DATE('2023-01-07 20:30','yyyy-MM-DD hh24:mi'), 3, 9, 8);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX456', TO_DATE('2023-01-07 21:30','yyyy-MM-DD hh24:mi'), 3, 9, 8);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX373', TO_DATE('2023-01-07 23:30','yyyy-MM-DD hh24:mi'), 3, 9, 8);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX001', TO_DATE('2022-12-01 08:30','yyyy-MM-DD hh24:mi'), 1, 1, 2);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX002', TO_DATE('2022-12-02 09:15','yyyy-MM-DD hh24:mi'), 6, 1, 3);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX003', TO_DATE('2022-12-07 10:40','yyyy-MM-DD hh24:mi'), 5, 1, 4);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX004', TO_DATE('2022-12-17 11:25','yyyy-MM-DD hh24:mi'), 4, 1, 5);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX005', TO_DATE('2022-12-19 12:40','yyyy-MM-DD hh24:mi'), 3, 1, 6);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX006', TO_DATE('2022-12-24 13:10','yyyy-MM-DD hh24:mi'), 2, 1, 7);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX007', TO_DATE('2022-12-25 14:50','yyyy-MM-DD hh24:mi'), 6, 1, 8);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX008', TO_DATE('2022-12-26 15:10','yyyy-MM-DD hh24:mi'), 1, 2, 9);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX009', TO_DATE('2022-12-30 16:00','yyyy-MM-DD hh24:mi'), 5, 2, 10);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX010', TO_DATE('2022-12-31 16:40','yyyy-MM-DD hh24:mi'), 2, 2, 11);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX011', TO_DATE('2023-01-01 17:10','yyyy-MM-DD hh24:mi'), 4, 2, 12);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX012', TO_DATE('2023-01-11 17:50','yyyy-MM-DD hh24:mi'), 3, 2, 13);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX013', TO_DATE('2023-01-21 18:45','yyyy-MM-DD hh24:mi'), 10, 2, 15);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX014', TO_DATE('2023-01-28 19:35','yyyy-MM-DD hh24:mi'), 3, 2, 16);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX015', TO_DATE('2023-01-31 20:25','yyyy-MM-DD hh24:mi'), 2, 3, 1);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX016', TO_DATE('2022-12-03 08:30','yyyy-MM-DD hh24:mi'), 1, 3, 2);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX017', TO_DATE('2022-12-04 09:15','yyyy-MM-DD hh24:mi'), 6, 3, 4);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX018', TO_DATE('2022-12-06 10:40','yyyy-MM-DD hh24:mi'), 5, 3, 5);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX019', TO_DATE('2022-12-18 11:25','yyyy-MM-DD hh24:mi'), 4, 3, 6);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX020', TO_DATE('2022-12-19 12:40','yyyy-MM-DD hh24:mi'), 3, 3, 7);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX021', TO_DATE('2022-12-22 13:10','yyyy-MM-DD hh24:mi'), 2, 3, 8);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX022', TO_DATE('2022-12-23 14:50','yyyy-MM-DD hh24:mi'), 6, 3, 9);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX023', TO_DATE('2022-12-28 15:10','yyyy-MM-DD hh24:mi'), 1, 4, 1);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX024', TO_DATE('2022-12-31 16:00','yyyy-MM-DD hh24:mi'), 5, 4, 10);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX025', TO_DATE('2023-01-01 16:40','yyyy-MM-DD hh24:mi'), 2, 4, 11);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX026', TO_DATE('2023-01-06 17:10','yyyy-MM-DD hh24:mi'), 4, 4, 12);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX027', TO_DATE('2023-01-11 17:50','yyyy-MM-DD hh24:mi'), 3, 4, 13);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX028', TO_DATE('2023-01-21 18:45','yyyy-MM-DD hh24:mi'), 10, 4, 15);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX029', TO_DATE('2023-01-28 19:35','yyyy-MM-DD hh24:mi'), 3, 4, 16);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX030', TO_DATE('2023-01-31 20:25','yyyy-MM-DD hh24:mi'), 2, 5, 1);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX031', TO_DATE('2022-12-01 08:30','yyyy-MM-DD hh24:mi'), 1, 5, 2);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX032', TO_DATE('2022-12-02 09:15','yyyy-MM-DD hh24:mi'), 6, 5, 3);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX033', TO_DATE('2022-12-03 10:40','yyyy-MM-DD hh24:mi'), 5, 5, 4);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX034', TO_DATE('2022-12-12 11:25','yyyy-MM-DD hh24:mi'), 4, 5, 6);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX035', TO_DATE('2022-12-13 12:40','yyyy-MM-DD hh24:mi'), 3, 5, 7);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX036', TO_DATE('2022-12-25 13:10','yyyy-MM-DD hh24:mi'), 2, 5, 8);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX037', TO_DATE('2022-12-26 14:50','yyyy-MM-DD hh24:mi'), 6, 5, 9);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX038', TO_DATE('2022-12-28 15:10','yyyy-MM-DD hh24:mi'), 1, 6, 9);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX039', TO_DATE('2022-12-30 16:00','yyyy-MM-DD hh24:mi'), 5, 6, 10);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX040', TO_DATE('2023-01-04 16:40','yyyy-MM-DD hh24:mi'), 2, 6, 11);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX041', TO_DATE('2023-01-05 17:10','yyyy-MM-DD hh24:mi'), 4, 6, 12);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX042', TO_DATE('2023-01-15 17:50','yyyy-MM-DD hh24:mi'), 3, 6, 13);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX043', TO_DATE('2023-01-23 18:45','yyyy-MM-DD hh24:mi'), 10, 6, 15);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX044', TO_DATE('2023-01-25 19:35','yyyy-MM-DD hh24:mi'), 3, 6, 16);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX045', TO_DATE('2023-01-30 20:25','yyyy-MM-DD hh24:mi'), 2, 7, 16);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX046', TO_DATE('2022-12-02 08:30','yyyy-MM-DD hh24:mi'), 1, 7, 1);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX047', TO_DATE('2022-12-03 09:15','yyyy-MM-DD hh24:mi'), 6, 7, 2);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX048', TO_DATE('2022-12-04 10:40','yyyy-MM-DD hh24:mi'), 5, 7, 3);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX049', TO_DATE('2022-12-16 11:25','yyyy-MM-DD hh24:mi'), 4, 7, 4);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX050', TO_DATE('2022-12-18 12:40','yyyy-MM-DD hh24:mi'), 3, 7, 5);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX051', TO_DATE('2022-12-25 13:10','yyyy-MM-DD hh24:mi'), 2, 7, 6);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX052', TO_DATE('2022-12-26 14:50','yyyy-MM-DD hh24:mi'), 6, 7, 8);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX053', TO_DATE('2022-12-27 15:10','yyyy-MM-DD hh24:mi'), 1, 8, 9);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX054', TO_DATE('2022-12-30 16:00','yyyy-MM-DD hh24:mi'), 5, 8, 10);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX055', TO_DATE('2023-01-02 16:40','yyyy-MM-DD hh24:mi'), 2, 8, 11);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX056', TO_DATE('2023-01-03 17:10','yyyy-MM-DD hh24:mi'), 4, 8, 12);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX057', TO_DATE('2023-01-14 17:50','yyyy-MM-DD hh24:mi'), 3, 8, 13);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX058', TO_DATE('2023-01-25 18:45','yyyy-MM-DD hh24:mi'), 10, 8, 15);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX059', TO_DATE('2023-01-27 19:35','yyyy-MM-DD hh24:mi'), 3, 8, 16);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX060', TO_DATE('2023-01-31 20:25','yyyy-MM-DD hh24:mi'), 2, 9, 1);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX061', TO_DATE('2022-12-02 08:30','yyyy-MM-DD hh24:mi'), 1, 9, 2);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX062', TO_DATE('2022-12-03 09:15','yyyy-MM-DD hh24:mi'), 6, 9, 3);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX063', TO_DATE('2022-12-04 10:40','yyyy-MM-DD hh24:mi'), 5, 9, 4);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX064', TO_DATE('2022-12-16 11:25','yyyy-MM-DD hh24:mi'), 4, 9, 5);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX065', TO_DATE('2022-12-18 12:40','yyyy-MM-DD hh24:mi'), 3, 9, 6);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX066', TO_DATE('2022-12-25 13:10','yyyy-MM-DD hh24:mi'), 2, 9, 7);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX067', TO_DATE('2022-12-26 14:50','yyyy-MM-DD hh24:mi'), 6, 9, 8);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX068', TO_DATE('2022-12-27 15:10','yyyy-MM-DD hh24:mi'), 1, 10, 8);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX069', TO_DATE('2022-12-30 16:00','yyyy-MM-DD hh24:mi'), 5, 10, 9);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX070', TO_DATE('2023-01-02 16:40','yyyy-MM-DD hh24:mi'), 2, 10, 11);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX071', TO_DATE('2023-01-03 17:10','yyyy-MM-DD hh24:mi'), 4, 10, 12);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX072', TO_DATE('2023-01-14 17:50','yyyy-MM-DD hh24:mi'), 3, 10, 13);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX073', TO_DATE('2023-01-25 18:45','yyyy-MM-DD hh24:mi'), 10, 10, 15);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX074', TO_DATE('2023-01-27 19:35','yyyy-MM-DD hh24:mi'), 3, 10, 16);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX075', TO_DATE('2023-01-31 20:25','yyyy-MM-DD hh24:mi'), 2, 11, 1);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX076', TO_DATE('2022-12-02 08:30','yyyy-MM-DD hh24:mi'), 1, 11, 2);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX077', TO_DATE('2022-12-03 09:15','yyyy-MM-DD hh24:mi'), 6, 11, 3);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX078', TO_DATE('2022-12-04 10:40','yyyy-MM-DD hh24:mi'), 5, 11, 4);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX079', TO_DATE('2022-12-16 11:25','yyyy-MM-DD hh24:mi'), 4, 11, 5);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX080', TO_DATE('2022-12-18 12:40','yyyy-MM-DD hh24:mi'), 3, 11, 6);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX081', TO_DATE('2022-12-25 13:10','yyyy-MM-DD hh24:mi'), 2, 11, 7);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX082', TO_DATE('2022-12-26 14:50','yyyy-MM-DD hh24:mi'), 6, 11, 8);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX083', TO_DATE('2022-12-27 15:10','yyyy-MM-DD hh24:mi'), 1, 12, 9);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX084', TO_DATE('2022-12-30 16:00','yyyy-MM-DD hh24:mi'), 5, 12, 10);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX085', TO_DATE('2023-01-02 16:40','yyyy-MM-DD hh24:mi'), 2, 12, 11);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX086', TO_DATE('2023-01-03 17:10','yyyy-MM-DD hh24:mi'), 4, 12, 13);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX087', TO_DATE('2023-01-14 17:50','yyyy-MM-DD hh24:mi'), 3, 12, 15);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX088', TO_DATE('2023-01-25 18:45','yyyy-MM-DD hh24:mi'), 10, 12, 16);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX089', TO_DATE('2023-01-27 19:35','yyyy-MM-DD hh24:mi'), 3, 12, 1);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX090', TO_DATE('2023-01-31 20:25','yyyy-MM-DD hh24:mi'), 2, 12, 2);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX091', TO_DATE('2022-12-25 13:10','yyyy-MM-DD hh24:mi'), 2, 13, 6);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX092', TO_DATE('2022-12-26 14:50','yyyy-MM-DD hh24:mi'), 6, 13, 7);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX093', TO_DATE('2022-12-27 15:10','yyyy-MM-DD hh24:mi'), 1, 13, 8);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX094', TO_DATE('2022-12-30 16:00','yyyy-MM-DD hh24:mi'), 5, 13, 9);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX095', TO_DATE('2023-01-02 16:40','yyyy-MM-DD hh24:mi'), 2, 15, 1);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX096', TO_DATE('2023-01-03 17:10','yyyy-MM-DD hh24:mi'), 4, 15, 2);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX097', TO_DATE('2023-01-14 17:50','yyyy-MM-DD hh24:mi'), 3, 15, 3);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX098', TO_DATE('2023-01-25 18:45','yyyy-MM-DD hh24:mi'), 10, 16, 4);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX099', TO_DATE('2023-01-27 19:35','yyyy-MM-DD hh24:mi'), 3, 16, 6);
insert into tblTrain (trseq, trnum, trboard, trtime, trstart, trend) values (seqTrain.nextVal, 'KTX100', TO_DATE('2023-01-31 20:25','yyyy-MM-DD hh24:mi'), 2, 16, 7);



-- 교통

insert into tblTransfer values(seqTransfer.nextVal, 19, null, 73, null);  
insert into tblTransfer values(seqTransfer.nextVal, 25, 19, null, null);  
insert into tblTransfer values(seqTransfer.nextVal, 50, null, null, 11);  
insert into tblTransfer values(seqTransfer.nextVal, 74, null, null, 13);  
insert into tblTransfer values(seqTransfer.nextVal, 65, null, null, 42);  
insert into tblTransfer values(seqTransfer.nextVal, 116, 54, null, null);  
insert into tblTransfer values(seqTransfer.nextVal, 44, 58, null, null);  
insert into tblTransfer values(seqTransfer.nextVal, 80, 60, null, null);  
insert into tblTransfer values(seqTransfer.nextVal, 89, 64, null, null);  
insert into tblTransfer values(seqTransfer.nextVal, 106, 79, null, null);  
insert into tblTransfer values(seqTransfer.nextVal, 85, 86, null, null);  
insert into tblTransfer values(seqTransfer.nextVal, 86, 100, null, null);  
insert into tblTransfer values(seqTransfer.nextVal, 98, 56, null, null);  
insert into tblTransfer values(seqTransfer.nextVal, 69, 53, null, null); 


-- 요일날짜
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 1, 4, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 1, 4, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 1, 4, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 1, 4, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 2, 1, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 3, 5, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 3, 5, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 3, 5, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 3, 5, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 3, 5, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 4, 9, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 4, 9, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 4, 9, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 4, 9, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 4, 9, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 4, 9, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 4, 9, 7);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 4, 9, 8);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 4, 9, 9);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 5, 5, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 5, 5, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 5, 5, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 5, 5, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 5, 5, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 6, 4, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 6, 4, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 6, 4, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 6, 4, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 7, 8, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 7, 8, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 7, 8, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 7, 8, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 7, 8, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 7, 8, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 7, 8, 7);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 7, 8, 8);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 8, 5, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 8, 5, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 8, 5, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 8, 5, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 8, 5, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 9, 2, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 9, 2, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 10, 2, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 10, 2, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 11, 4, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 11, 4, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 11, 4, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 11, 4, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 12, 2, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 12, 2, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 13, 1, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 14, 8, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 14, 8, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 14, 8, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 14, 8, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 14, 8, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 14, 8, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 14, 8, 7);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 14, 8, 8);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 15, 5, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 15, 5, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 15, 5, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 15, 5, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 15, 5, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 16, 9, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 16, 9, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 16, 9, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 16, 9, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 16, 9, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 16, 9, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 16, 9, 7);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 16, 9, 8);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 16, 9, 9);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 17, 8, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 17, 8, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 17, 8, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 17, 8, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 17, 8, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 17, 8, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 17, 8, 7);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 17, 8, 8);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 18, 2, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 18, 2, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 19, 2, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 19, 2, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 20, 5, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 20, 5, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 20, 5, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 20, 5, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 20, 5, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 21, 2, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 21, 2, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 22, 5, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 22, 5, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 22, 5, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 22, 5, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 22, 5, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 23, 5, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 23, 5, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 23, 5, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 23, 5, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 23, 5, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 24, 5, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 24, 5, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 24, 5, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 24, 5, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 24, 5, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 25, 1, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 26, 4, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 26, 4, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 26, 4, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 26, 4, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 27, 3, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 27, 3, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 27, 3, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 28, 7, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 28, 7, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 28, 7, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 28, 7, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 28, 7, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 28, 7, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 28, 7, 7);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 29, 2, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 29, 2, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 30, 4, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 30, 4, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 30, 4, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 30, 4, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 31, 2, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 31, 2, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 32, 1, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 33, 2, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 33, 2, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 34, 9, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 34, 9, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 34, 9, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 34, 9, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 34, 9, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 34, 9, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 34, 9, 7);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 34, 9, 8);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 34, 9, 9);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 35, 9, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 35, 9, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 35, 9, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 35, 9, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 35, 9, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 35, 9, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 35, 9, 7);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 35, 9, 8);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 35, 9, 9);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 36, 2, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 36, 2, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 37, 5, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 37, 5, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 37, 5, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 37, 5, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 37, 5, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 38, 4, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 38, 4, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 38, 4, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 38, 4, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 39, 5, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 39, 5, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 39, 5, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 39, 5, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 39, 5, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 40, 6, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 40, 6, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 40, 6, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 40, 6, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 40, 6, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 40, 6, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 41, 4, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 41, 4, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 41, 4, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 41, 4, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 42, 8, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 42, 8, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 42, 8, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 42, 8, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 42, 8, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 42, 8, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 42, 8, 7);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 42, 8, 8);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 43, 4, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 43, 4, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 43, 4, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 43, 4, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 44, 3, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 44, 3, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 44, 3, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 45, 7, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 45, 7, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 45, 7, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 45, 7, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 45, 7, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 45, 7, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 45, 7, 7);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 46, 2, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 46, 2, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 47, 3, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 47, 3, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 47, 3, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 48, 3, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 48, 3, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 48, 3, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 49, 5, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 49, 5, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 49, 5, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 49, 5, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 49, 5, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 50, 3, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 50, 3, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 50, 3, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 51, 6, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 51, 6, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 51, 6, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 51, 6, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 51, 6, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 51, 6, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 52, 8, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 52, 8, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 52, 8, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 52, 8, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 52, 8, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 52, 8, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 52, 8, 7);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 52, 8, 8);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 53, 2, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 53, 2, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 54, 6, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 54, 6, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 54, 6, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 54, 6, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 54, 6, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 54, 6, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 55, 2, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 55, 2, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 56, 6, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 56, 6, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 56, 6, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 56, 6, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 56, 6, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 56, 6, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 57, 4, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 57, 4, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 57, 4, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 57, 4, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 58, 2, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 58, 2, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 59, 3, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 59, 3, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 59, 3, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 60, 4, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 60, 4, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 60, 4, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 60, 4, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 61, 8, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 61, 8, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 61, 8, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 61, 8, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 61, 8, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 61, 8, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 61, 8, 7);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 61, 8, 8);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 62, 5, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 62, 5, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 62, 5, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 62, 5, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 62, 5, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 63, 7, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 63, 7, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 63, 7, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 63, 7, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 63, 7, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 63, 7, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 63, 7, 7);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 64, 3, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 64, 3, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 64, 3, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 65, 8, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 65, 8, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 65, 8, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 65, 8, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 65, 8, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 65, 8, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 65, 8, 7);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 65, 8, 8);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 66, 5, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 66, 5, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 66, 5, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 66, 5, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 66, 5, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 67, 6, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 67, 6, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 67, 6, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 67, 6, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 67, 6, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 67, 6, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 68, 8, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 68, 8, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 68, 8, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 68, 8, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 68, 8, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 68, 8, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 68, 8, 7);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 68, 8, 8);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 69, 5, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 69, 5, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 69, 5, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 69, 5, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 69, 5, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 70, 9, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 70, 9, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 70, 9, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 70, 9, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 70, 9, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 70, 9, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 70, 9, 7);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 70, 9, 8);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 70, 9, 9);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 71, 5, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 71, 5, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 71, 5, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 71, 5, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 71, 5, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 72, 3, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 72, 3, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 72, 3, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 73, 4, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 73, 4, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 73, 4, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 73, 4, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 74, 6, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 74, 6, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 74, 6, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 74, 6, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 74, 6, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 74, 6, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 75, 4, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 75, 4, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 75, 4, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 75, 4, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 76, 1, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 77, 7, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 77, 7, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 77, 7, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 77, 7, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 77, 7, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 77, 7, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 77, 7, 7);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 78, 6, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 78, 6, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 78, 6, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 78, 6, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 78, 6, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 78, 6, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 79, 3, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 79, 3, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 79, 3, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 80, 2, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 80, 2, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 81, 8, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 81, 8, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 81, 8, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 81, 8, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 81, 8, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 81, 8, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 81, 8, 7);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 81, 8, 8);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 82, 2, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 82, 2, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 83, 1, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 84, 5, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 84, 5, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 84, 5, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 84, 5, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 84, 5, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 85, 4, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 85, 4, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 85, 4, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 85, 4, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 86, 3, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 86, 3, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 86, 3, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 87, 9, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 87, 9, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 87, 9, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 87, 9, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 87, 9, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 87, 9, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 87, 9, 7);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 87, 9, 8);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 87, 9, 9);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 88, 2, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 88, 2, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 89, 3, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 89, 3, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 89, 3, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 90, 2, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 90, 2, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 91, 1, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 92, 1, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 93, 2, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 93, 2, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 94, 5, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 94, 5, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 94, 5, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 94, 5, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 94, 5, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 95, 4, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 95, 4, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 95, 4, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 95, 4, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 96, 6, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 96, 6, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 96, 6, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 96, 6, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 96, 6, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 96, 6, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 97, 5, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 97, 5, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 97, 5, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 97, 5, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 97, 5, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 98, 2, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 98, 2, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 99, 2, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 99, 2, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 100, 8, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 100, 8, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 100, 8, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 100, 8, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 100, 8, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 100, 8, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 100, 8, 7);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 100, 8, 8);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 101, 4, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 101, 4, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 101, 4, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 101, 4, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 102, 3, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 102, 3, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 102, 3, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 103, 2, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 103, 2, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 104, 3, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 104, 3, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 104, 3, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 105, 2, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 105, 2, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 106, 7, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 106, 7, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 106, 7, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 106, 7, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 106, 7, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 106, 7, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 106, 7, 7);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 107, 5, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 107, 5, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 107, 5, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 107, 5, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 107, 5, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 108, 2, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 108, 2, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 109, 2, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 109, 2, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 110, 3, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 110, 3, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 110, 3, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 111, 7, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 111, 7, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 111, 7, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 111, 7, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 111, 7, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 111, 7, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 111, 7, 7);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 112, 4, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 112, 4, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 112, 4, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 112, 4, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 113, 1, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 114, 5, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 114, 5, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 114, 5, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 114, 5, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 114, 5, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 115, 6, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 115, 6, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 115, 6, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 115, 6, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 115, 6, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 115, 6, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 116, 3, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 116, 3, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 116, 3, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 117, 4, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 117, 4, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 117, 4, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 117, 4, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 118, 4, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 118, 4, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 118, 4, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 118, 4, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 119, 2, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 119, 2, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 120, 7, 1);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 120, 7, 2);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 120, 7, 3);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 120, 7, 4);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 120, 7, 5);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 120, 7, 6);
insert into tblDate (dseq, pseq, dday, ddate) values (seqDate.nextVal, 120, 7, 7);



-- 요일장소
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 247698, 4, 134, 310);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 360372, 1, 208, 397);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 232772, 4, 252, 310);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 319124, 2, 99, 96);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 23468, 2, 185, 274);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 109908, 1, 182, 218);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 64122, 2, 162, 360);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 464688, 3, 209, 99);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 432441, 2, 215, 102);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 370770, 1, 38, 322);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 37777, 1, 239, 244);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 404782, 3, 266, 17);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 81401, 3, 31, 184);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 242830, 2, 152, 141);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 366079, 3, 181, 277);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 273594, 1, 153, 101);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 321789, 3, 256, 385);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 112973, 4, 172, 17);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 218896, 4, 205, 294);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 93889, 1, 114, 458);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 235683, 1, 201, 255);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 122216, 3, 121, 422);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 187046, 3, 19, 32);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 281476, 4, 38, 172);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 53804, 2, 151, 181);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 310366, 4, 44, 101);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 149510, 1, 119, 276);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 459704, 3, 82, 84);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 114469, 2, 40, 367);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 79515, 2, 178, 2);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 336197, 4, 145, 505);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 465970, 3, 60, 32);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 168798, 1, 265, 62);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 90746, 2, 74, 295);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 180594, 1, 254, 288);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 359106, 3, 124, 394);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 412508, 3, 204, 208);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 138033, 1, 157, 406);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 41509, 4, 232, 263);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 293676, 4, 222, 30);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 37080, 2, 121, 172);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 291355, 3, 232, 181);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 148010, 2, 75, 24);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 76521, 3, 270, 303);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 100124, 4, 144, 42);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 381815, 3, 16, 211);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 292625, 3, 153, 122);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 214412, 1, 250, 318);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 15362, 2, 25, 477);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 192778, 1, 32, 14);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 113157, 4, 225, 223);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 334724, 2, 2, 34);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 33302, 2, 142, 361);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 198495, 1, 24, 36);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 126843, 3, 214, 487);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 54122, 4, 63, 328);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 91003, 1, 107, 498);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 86505, 2, 33, 45);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 327969, 2, 54, 221);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 77208, 4, 6, 183);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 408985, 1, 109, 372);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 499744, 1, 22, 409);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 488426, 1, 63, 190);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 411476, 2, 164, 116);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 491556, 3, 16, 196);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 483348, 2, 265, 245);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 327714, 3, 139, 173);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 51897, 4, 138, 110);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 343505, 4, 65, 373);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 204795, 3, 184, 369);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 300684, 4, 121, 477);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 107980, 3, 220, 231);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 497705, 2, 66, 44);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 390900, 1, 269, 448);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 357769, 4, 224, 487);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 226334, 3, 166, 45);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 14983, 3, 51, 500);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 78057, 1, 104, 341);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 170251, 4, 230, 307);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 484111, 3, 265, 242);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 410539, 1, 195, 382);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 227220, 2, 139, 57);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 410209, 2, 166, 162);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 166144, 2, 194, 472);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 369116, 1, 64, 467);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 321476, 3, 11, 386);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 60115, 3, 130, 90);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 222064, 1, 207, 284);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 464629, 1, 137, 383);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 366779, 3, 79, 335);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 34758, 2, 162, 242);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 81155, 3, 122, 411);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 438231, 3, 23, 121);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 20718, 2, 246, 24);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 4274, 1, 267, 209);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 153067, 2, 104, 512);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 367802, 4, 105, 395);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 81292, 4, 155, 302);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 45954, 2, 141, 177);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 368732, 2, 245, 496);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 127334, 3, 118, 436);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 272492, 3, 174, 445);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 236091, 3, 169, 87);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 207589, 4, 250, 215);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 472970, 1, 220, 328);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 327374, 1, 77, 224);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 496063, 3, 16, 92);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 454905, 3, 218, 474);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 493189, 1, 55, 415);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 356476, 2, 210, 360);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 488342, 2, 240, 310);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 376610, 3, 242, 176);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 171256, 4, 141, 196);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 298201, 4, 157, 278);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 5424, 2, 140, 462);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 350388, 4, 37, 467);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 429325, 4, 58, 108);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 245461, 4, 23, 355);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 464036, 2, 170, 12);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 217592, 3, 207, 383);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 341339, 2, 197, 326);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 222970, 1, 193, 508);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 95642, 1, 44, 235);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 23975, 1, 157, 512);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 86714, 2, 221, 314);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 126953, 3, 83, 198);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 300710, 4, 72, 179);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 411758, 3, 94, 134);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 325244, 2, 220, 34);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 60697, 4, 169, 103);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 337749, 4, 3, 259);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 14644, 2, 181, 29);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 196091, 1, 182, 168);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 54781, 1, 150, 149);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 108245, 2, 88, 418);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 143462, 1, 135, 164);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 267461, 1, 236, 234);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 49781, 4, 69, 151);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 146902, 4, 250, 157);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 60381, 1, 235, 488);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 61674, 3, 189, 459);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 168156, 1, 101, 508);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 143473, 1, 31, 26);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 401921, 1, 144, 249);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 10867, 4, 59, 379);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 79793, 2, 156, 299);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 109382, 4, 186, 140);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 295816, 1, 109, 263);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 342760, 1, 179, 463);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 442969, 3, 61, 321);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 341533, 1, 101, 265);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 258093, 2, 146, 8);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 102147, 2, 126, 9);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 301974, 2, 99, 111);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 223009, 1, 270, 390);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 475545, 1, 55, 148);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 401284, 4, 58, 5);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 260948, 3, 106, 80);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 94743, 1, 242, 401);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 75950, 3, 259, 150);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 234445, 2, 19, 67);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 399138, 3, 122, 14);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 35239, 2, 203, 289);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 427336, 3, 159, 221);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 95360, 4, 234, 89);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 425668, 4, 225, 368);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 87593, 2, 10, 371);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 170101, 1, 213, 434);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 123800, 1, 157, 75);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 158551, 3, 12, 30);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 482735, 4, 44, 279);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 323599, 3, 3, 407);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 241296, 3, 213, 417);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 487281, 1, 178, 402);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 93999, 2, 268, 79);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 453671, 1, 241, 368);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 2360, 3, 50, 32);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 250299, 1, 210, 355);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 159347, 2, 50, 246);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 462400, 1, 205, 53);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 415823, 1, 210, 99);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 445634, 3, 248, 404);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 299779, 2, 224, 439);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 264202, 2, 53, 28);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 348170, 1, 70, 515);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 416094, 1, 152, 159);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 178192, 2, 226, 54);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 197207, 2, 205, 128);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 45922, 1, 39, 471);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 412054, 4, 58, 207);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 400167, 4, 113, 484);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 90200, 3, 148, 412);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 345203, 4, 201, 8);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 82160, 3, 15, 408);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 271502, 4, 184, 38);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 79184, 2, 243, 226);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 477902, 2, 75, 154);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 243473, 3, 219, 484);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 44929, 3, 129, 437);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 201854, 3, 148, 480);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 79524, 2, 153, 184);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 191788, 1, 24, 238);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 484244, 1, 244, 325);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 268, 1, 94, 196);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 364085, 3, 118, 348);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 356955, 4, 19, 218);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 68715, 2, 219, 17);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 387973, 4, 161, 115);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 322697, 4, 219, 115);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 287244, 2, 137, 259);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 390895, 4, 199, 485);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 205198, 2, 218, 337);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 475866, 4, 248, 162);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 261200, 4, 170, 224);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 177081, 1, 255, 58);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 220709, 2, 264, 155);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 420771, 2, 176, 471);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 487691, 2, 250, 108);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 427967, 1, 238, 338);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 338157, 4, 128, 167);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 39939, 3, 236, 481);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 42805, 3, 154, 182);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 456404, 3, 56, 418);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 125428, 2, 195, 503);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 103900, 1, 165, 381);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 476927, 3, 82, 434);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 57379, 2, 166, 25);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 398313, 2, 143, 9);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 389537, 4, 193, 225);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 59522, 4, 24, 33);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 377204, 2, 212, 284);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 133702, 2, 195, 204);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 33681, 4, 95, 46);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 205363, 2, 259, 237);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 23601, 1, 77, 280);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 26985, 2, 181, 166);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 36200, 3, 154, 330);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 454879, 2, 182, 441);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 43134, 3, 22, 65);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 36265, 4, 71, 292);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 54583, 2, 195, 211);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 346439, 1, 126, 297);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 397106, 4, 168, 48);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 304635, 3, 120, 479);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 391377, 4, 129, 270);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 460227, 2, 122, 442);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 269971, 3, 65, 160);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 328742, 3, 261, 364);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 389275, 1, 94, 493);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 292256, 1, 68, 390);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 165950, 1, 177, 486);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 341973, 1, 258, 201);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 315183, 4, 71, 500);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 405519, 4, 161, 96);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 287076, 4, 31, 208);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 438144, 4, 216, 469);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 164198, 3, 194, 320);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 436792, 1, 218, 448);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 104845, 1, 15, 54);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 312011, 3, 255, 311);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 275601, 3, 204, 96);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 135618, 3, 39, 159);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 226003, 3, 179, 177);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 30323, 1, 65, 236);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 338293, 3, 210, 104);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 457939, 3, 147, 360);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 26506, 4, 148, 331);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 475253, 2, 69, 497);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 377634, 3, 18, 151);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 229416, 1, 195, 64);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 480314, 2, 252, 333);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 228355, 2, 34, 112);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 287656, 1, 264, 98);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 173808, 2, 216, 283);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 17877, 4, 225, 159);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 348404, 3, 198, 103);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 319845, 3, 9, 318);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 268972, 4, 152, 52);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 239852, 4, 166, 312);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 480354, 4, 244, 139);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 419590, 1, 66, 455);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 324774, 2, 23, 236);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 84473, 3, 119, 13);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 108629, 2, 191, 325);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 31527, 4, 83, 319);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 43658, 3, 96, 76);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 216678, 4, 207, 84);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 368257, 1, 103, 261);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 258665, 2, 185, 294);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 54335, 4, 252, 55);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 337949, 3, 69, 471);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 410463, 2, 104, 178);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 143763, 2, 13, 141);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 44830, 2, 61, 323);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 38026, 4, 54, 10);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 25138, 1, 257, 329);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 1641, 3, 253, 444);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 465074, 3, 244, 502);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 333543, 3, 82, 464);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 158922, 3, 270, 446);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 5478, 3, 87, 101);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 183648, 3, 249, 483);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 191631, 1, 145, 297);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 409005, 1, 149, 298);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 350791, 1, 144, 355);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 174520, 1, 224, 15);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 140854, 1, 206, 469);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 24422, 1, 219, 509);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 329254, 2, 187, 227);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 436234, 1, 169, 85);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 387396, 2, 28, 272);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 330999, 3, 236, 58);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 385072, 1, 218, 307);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 9878, 4, 128, 260);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 117868, 1, 35, 376);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 415113, 1, 8, 271);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 320918, 2, 250, 425);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 40233, 4, 183, 262);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 449198, 1, 254, 179);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 154337, 1, 209, 56);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 376697, 3, 199, 18);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 116207, 4, 209, 94);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 279658, 2, 237, 298);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 431878, 2, 78, 480);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 444553, 3, 183, 464);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 174625, 2, 182, 373);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 12701, 3, 118, 225);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 144054, 2, 84, 337);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 284612, 3, 145, 166);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 472008, 4, 244, 481);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 467322, 4, 240, 376);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 71073, 2, 51, 257);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 159870, 1, 106, 118);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 100430, 3, 61, 394);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 78119, 2, 250, 26);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 262910, 3, 21, 278);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 276199, 1, 109, 320);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 363544, 1, 124, 462);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 228512, 2, 137, 96);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 493151, 2, 103, 406);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 395200, 3, 231, 496);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 148309, 4, 258, 142);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 199768, 1, 6, 193);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 384201, 2, 190, 86);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 143755, 2, 239, 170);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 272799, 1, 59, 495);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 251794, 3, 168, 293);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 243154, 2, 116, 234);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 81966, 1, 84, 371);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 432574, 2, 23, 82);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 332354, 4, 194, 143);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 400578, 4, 14, 63);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 204065, 1, 97, 269);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 260492, 3, 52, 269);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 198174, 4, 206, 395);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 251275, 2, 212, 233);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 352098, 3, 51, 190);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 55368, 1, 199, 335);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 29678, 4, 1, 105);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 21061, 4, 109, 347);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 385586, 1, 49, 4);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 395964, 3, 98, 337);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 452855, 4, 201, 261);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 485290, 3, 127, 73);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 167357, 2, 102, 368);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 317240, 4, 172, 385);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 192067, 2, 150, 401);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 301091, 4, 103, 6);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 352093, 3, 25, 320);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 109026, 3, 262, 393);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 295001, 3, 198, 27);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 186644, 2, 249, 170);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 159378, 2, 89, 496);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 355789, 2, 84, 226);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 168872, 4, 243, 501);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 296924, 1, 8, 148);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 88059, 1, 236, 345);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 116099, 4, 146, 180);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 389662, 3, 151, 28);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 431905, 1, 233, 156);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 457895, 2, 186, 501);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 377316, 4, 163, 151);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 338983, 4, 239, 177);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 160899, 3, 35, 100);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 374197, 1, 24, 135);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 96868, 4, 76, 415);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 30315, 3, 98, 244);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 498230, 2, 247, 481);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 417384, 4, 257, 247);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 331921, 1, 121, 181);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 88781, 1, 32, 41);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 398357, 1, 224, 340);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 369882, 4, 203, 227);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 295281, 3, 45, 444);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 455840, 1, 27, 248);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 202894, 1, 66, 172);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 205136, 2, 221, 44);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 376906, 2, 11, 224);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 98284, 2, 141, 502);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 436084, 1, 64, 323);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 432427, 2, 154, 505);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 171855, 1, 197, 314);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 122461, 4, 5, 65);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 375251, 3, 9, 175);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 96180, 3, 49, 417);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 462148, 2, 164, 42);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 357643, 2, 57, 164);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 489678, 4, 126, 163);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 38466, 4, 227, 50);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 31021, 3, 102, 316);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 445145, 2, 143, 243);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 407230, 4, 118, 361);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 109810, 3, 235, 419);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 253797, 1, 122, 8);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 216723, 4, 243, 424);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 278142, 1, 55, 415);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 307537, 3, 232, 306);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 337774, 3, 119, 471);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 139625, 1, 119, 480);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 411354, 1, 255, 234);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 148936, 4, 254, 19);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 298773, 3, 211, 456);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 425332, 4, 130, 432);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 51303, 1, 60, 377);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 323814, 4, 33, 410);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 162341, 4, 126, 11);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 54209, 3, 2, 411);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 849, 1, 267, 348);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 457138, 4, 121, 319);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 187402, 3, 133, 142);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 27000, 2, 214, 109);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 14900, 4, 141, 90);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 412864, 4, 82, 177);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 105472, 4, 19, 444);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 184192, 3, 241, 242);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 442096, 1, 40, 66);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 442134, 2, 63, 183);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 251090, 3, 112, 493);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 178941, 2, 140, 78);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 336502, 4, 84, 127);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 177868, 3, 44, 160);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 193643, 1, 116, 351);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 490426, 2, 45, 102);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 48165, 4, 105, 393);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 377611, 4, 232, 194);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 401151, 1, 6, 104);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 27240, 1, 256, 337);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 88117, 2, 195, 396);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 175764, 4, 54, 399);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 144773, 4, 111, 106);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 99575, 4, 239, 505);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 95589, 1, 195, 504);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 359311, 1, 268, 132);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 348709, 4, 167, 422);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 363413, 3, 186, 53);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 397916, 4, 257, 326);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 67173, 3, 39, 324);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 469374, 3, 72, 255);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 365128, 4, 205, 86);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 221850, 4, 22, 193);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 784, 2, 147, 351);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 48005, 1, 62, 59);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 260156, 2, 195, 515);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 129466, 1, 265, 398);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 363058, 4, 197, 384);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 36254, 1, 226, 338);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 359759, 1, 243, 116);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 247589, 4, 55, 203);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 495981, 2, 43, 211);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 96420, 1, 18, 190);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 77175, 2, 61, 381);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 223417, 4, 10, 357);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 10282, 2, 183, 327);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 297981, 3, 240, 129);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 253511, 4, 87, 1);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 178489, 1, 49, 479);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 381578, 4, 101, 483);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 212233, 3, 104, 387);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 407368, 3, 215, 318);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 4394, 1, 13, 260);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 282888, 2, 132, 492);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 124729, 1, 146, 449);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 214316, 2, 172, 421);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 19203, 3, 23, 482);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 119310, 3, 98, 278);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 109065, 4, 109, 88);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 212089, 1, 125, 427);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 128714, 2, 85, 121);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 351919, 2, 101, 89);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 348111, 3, 235, 72);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 275934, 4, 116, 362);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 319669, 1, 132, 168);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 185328, 2, 120, 65);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 208679, 3, 200, 30);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 419962, 1, 18, 66);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 18035, 4, 49, 303);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 135749, 4, 196, 260);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 56426, 4, 112, 130);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 274986, 3, 218, 503);
insert into tblDPlace (dpseq, dpprice, dporder, plseq, dseq) values (seqDPlace.nextVal, 121373, 2, 125, 302);





-- 요일숙박
insert into tblDAccom values (seqDAccom.nextVal, 175, 48);
insert into tblDAccom values (seqDAccom.nextVal, 464, 105);
insert into tblDAccom values (seqDAccom.nextVal, 125, 47);
insert into tblDAccom values (seqDAccom.nextVal, 202, 89);
insert into tblDAccom values (seqDAccom.nextVal, 259, 85);
insert into tblDAccom values (seqDAccom.nextVal, 198, 13);
insert into tblDAccom values (seqDAccom.nextVal, 142, 101);
insert into tblDAccom values (seqDAccom.nextVal, 393, 92);
insert into tblDAccom values (seqDAccom.nextVal, 277, 28);
insert into tblDAccom values (seqDAccom.nextVal, 43, 24);
insert into tblDAccom values (seqDAccom.nextVal, 198, 96);
insert into tblDAccom values (seqDAccom.nextVal, 298, 6);
insert into tblDAccom values (seqDAccom.nextVal, 152, 7);
insert into tblDAccom values (seqDAccom.nextVal, 137, 6);
insert into tblDAccom values (seqDAccom.nextVal, 41, 79);
insert into tblDAccom values (seqDAccom.nextVal, 136, 61);
insert into tblDAccom values (seqDAccom.nextVal, 255, 59);
insert into tblDAccom values (seqDAccom.nextVal, 314, 67);
insert into tblDAccom values (seqDAccom.nextVal, 221, 5);
insert into tblDAccom values (seqDAccom.nextVal, 313, 18);
insert into tblDAccom values (seqDAccom.nextVal, 133, 66);
insert into tblDAccom values (seqDAccom.nextVal, 145, 99);
insert into tblDAccom values (seqDAccom.nextVal, 197, 73);
insert into tblDAccom values (seqDAccom.nextVal, 92, 38);
insert into tblDAccom values (seqDAccom.nextVal, 174, 70);
insert into tblDAccom values (seqDAccom.nextVal, 64, 94);
insert into tblDAccom values (seqDAccom.nextVal, 148, 101);
insert into tblDAccom values (seqDAccom.nextVal, 261, 7);
insert into tblDAccom values (seqDAccom.nextVal, 100, 59);
insert into tblDAccom values (seqDAccom.nextVal, 442, 58);
insert into tblDAccom values (seqDAccom.nextVal, 251, 27);
insert into tblDAccom values (seqDAccom.nextVal, 164, 76);
insert into tblDAccom values (seqDAccom.nextVal, 147, 105);
insert into tblDAccom values (seqDAccom.nextVal, 273, 18);
insert into tblDAccom values (seqDAccom.nextVal, 21, 11);
insert into tblDAccom values (seqDAccom.nextVal, 397, 26);
insert into tblDAccom values (seqDAccom.nextVal, 444, 56);
insert into tblDAccom values (seqDAccom.nextVal, 15, 28);
insert into tblDAccom values (seqDAccom.nextVal, 144, 66);
insert into tblDAccom values (seqDAccom.nextVal, 298, 92);
insert into tblDAccom values (seqDAccom.nextVal, 365, 27);
insert into tblDAccom values (seqDAccom.nextVal, 156, 34);
insert into tblDAccom values (seqDAccom.nextVal, 439, 74);
insert into tblDAccom values (seqDAccom.nextVal, 262, 31);
insert into tblDAccom values (seqDAccom.nextVal, 359, 88);
insert into tblDAccom values (seqDAccom.nextVal, 144, 16);
insert into tblDAccom values (seqDAccom.nextVal, 21, 89);
insert into tblDAccom values (seqDAccom.nextVal, 23, 89);
insert into tblDAccom values (seqDAccom.nextVal, 204, 73);
insert into tblDAccom values (seqDAccom.nextVal, 102, 26);
insert into tblDAccom values (seqDAccom.nextVal, 357, 54);
insert into tblDAccom values (seqDAccom.nextVal, 109, 81);
insert into tblDAccom values (seqDAccom.nextVal, 336, 4);
insert into tblDAccom values (seqDAccom.nextVal, 383, 45);
insert into tblDAccom values (seqDAccom.nextVal, 269, 25);
insert into tblDAccom values (seqDAccom.nextVal, 332, 66);
insert into tblDAccom values (seqDAccom.nextVal, 59, 10);
insert into tblDAccom values (seqDAccom.nextVal, 170, 75);
insert into tblDAccom values (seqDAccom.nextVal, 493, 67);
insert into tblDAccom values (seqDAccom.nextVal, 489, 92);
insert into tblDAccom values (seqDAccom.nextVal, 364, 7);
insert into tblDAccom values (seqDAccom.nextVal, 215, 93);
insert into tblDAccom values (seqDAccom.nextVal, 323, 84);
insert into tblDAccom values (seqDAccom.nextVal, 337, 101);
insert into tblDAccom values (seqDAccom.nextVal, 216, 83);
insert into tblDAccom values (seqDAccom.nextVal, 175, 40);
insert into tblDAccom values (seqDAccom.nextVal, 77, 29);
insert into tblDAccom values (seqDAccom.nextVal, 58, 2);
insert into tblDAccom values (seqDAccom.nextVal, 502, 91);
insert into tblDAccom values (seqDAccom.nextVal, 300, 87);
insert into tblDAccom values (seqDAccom.nextVal, 513, 82);
insert into tblDAccom values (seqDAccom.nextVal, 299, 54);
insert into tblDAccom values (seqDAccom.nextVal, 201, 26);
insert into tblDAccom values (seqDAccom.nextVal, 248, 38);
insert into tblDAccom values (seqDAccom.nextVal, 296, 21);
insert into tblDAccom values (seqDAccom.nextVal, 33, 90);
insert into tblDAccom values (seqDAccom.nextVal, 134, 52);
insert into tblDAccom values (seqDAccom.nextVal, 287, 64);
insert into tblDAccom values (seqDAccom.nextVal, 1, 92);
insert into tblDAccom values (seqDAccom.nextVal, 53, 30);
insert into tblDAccom values (seqDAccom.nextVal, 316, 57);
insert into tblDAccom values (seqDAccom.nextVal, 386, 89);
insert into tblDAccom values (seqDAccom.nextVal, 159, 82);
insert into tblDAccom values (seqDAccom.nextVal, 142, 3);
insert into tblDAccom values (seqDAccom.nextVal, 482, 2);
insert into tblDAccom values (seqDAccom.nextVal, 375, 49);
insert into tblDAccom values (seqDAccom.nextVal, 43, 30);
insert into tblDAccom values (seqDAccom.nextVal, 10, 87);
insert into tblDAccom values (seqDAccom.nextVal, 4, 51);
insert into tblDAccom values (seqDAccom.nextVal, 380, 100);
insert into tblDAccom values (seqDAccom.nextVal, 152, 8);
insert into tblDAccom values (seqDAccom.nextVal, 209, 5);
insert into tblDAccom values (seqDAccom.nextVal, 190, 104);
insert into tblDAccom values (seqDAccom.nextVal, 470, 104);
insert into tblDAccom values (seqDAccom.nextVal, 16, 79);
insert into tblDAccom values (seqDAccom.nextVal, 219, 14);
insert into tblDAccom values (seqDAccom.nextVal, 70, 26);
insert into tblDAccom values (seqDAccom.nextVal, 228, 29);
insert into tblDAccom values (seqDAccom.nextVal, 355, 7);
insert into tblDAccom values (seqDAccom.nextVal, 250, 6);
insert into tblDAccom values (seqDAccom.nextVal, 425, 45);
insert into tblDAccom values (seqDAccom.nextVal, 467, 97);
insert into tblDAccom values (seqDAccom.nextVal, 391, 85);
insert into tblDAccom values (seqDAccom.nextVal, 15, 8);
insert into tblDAccom values (seqDAccom.nextVal, 3, 31);
insert into tblDAccom values (seqDAccom.nextVal, 75, 27);
insert into tblDAccom values (seqDAccom.nextVal, 499, 3);
insert into tblDAccom values (seqDAccom.nextVal, 313, 67);
insert into tblDAccom values (seqDAccom.nextVal, 399, 9);
insert into tblDAccom values (seqDAccom.nextVal, 292, 75);
insert into tblDAccom values (seqDAccom.nextVal, 439, 80);
insert into tblDAccom values (seqDAccom.nextVal, 194, 74);
insert into tblDAccom values (seqDAccom.nextVal, 199, 92);
insert into tblDAccom values (seqDAccom.nextVal, 469, 86);
insert into tblDAccom values (seqDAccom.nextVal, 509, 8);
insert into tblDAccom values (seqDAccom.nextVal, 317, 16);
insert into tblDAccom values (seqDAccom.nextVal, 453, 49);
insert into tblDAccom values (seqDAccom.nextVal, 379, 37);
insert into tblDAccom values (seqDAccom.nextVal, 6, 53);
insert into tblDAccom values (seqDAccom.nextVal, 428, 53);
insert into tblDAccom values (seqDAccom.nextVal, 501, 85);
insert into tblDAccom values (seqDAccom.nextVal, 372, 1);
insert into tblDAccom values (seqDAccom.nextVal, 471, 43);
insert into tblDAccom values (seqDAccom.nextVal, 33, 37);
insert into tblDAccom values (seqDAccom.nextVal, 357, 70);
insert into tblDAccom values (seqDAccom.nextVal, 484, 23);
insert into tblDAccom values (seqDAccom.nextVal, 146, 18);
insert into tblDAccom values (seqDAccom.nextVal, 225, 88);
insert into tblDAccom values (seqDAccom.nextVal, 184, 66);
insert into tblDAccom values (seqDAccom.nextVal, 88, 61);
insert into tblDAccom values (seqDAccom.nextVal, 315, 36);
insert into tblDAccom values (seqDAccom.nextVal, 311, 23);
insert into tblDAccom values (seqDAccom.nextVal, 129, 23);
insert into tblDAccom values (seqDAccom.nextVal, 23, 44);
insert into tblDAccom values (seqDAccom.nextVal, 347, 57);
insert into tblDAccom values (seqDAccom.nextVal, 433, 28);
insert into tblDAccom values (seqDAccom.nextVal, 493, 65);
insert into tblDAccom values (seqDAccom.nextVal, 43, 33);
insert into tblDAccom values (seqDAccom.nextVal, 124, 25);
insert into tblDAccom values (seqDAccom.nextVal, 210, 79);
insert into tblDAccom values (seqDAccom.nextVal, 490, 93);
insert into tblDAccom values (seqDAccom.nextVal, 225, 82);
insert into tblDAccom values (seqDAccom.nextVal, 416, 6);
insert into tblDAccom values (seqDAccom.nextVal, 444, 16);
insert into tblDAccom values (seqDAccom.nextVal, 28, 10);
insert into tblDAccom values (seqDAccom.nextVal, 82, 103);
insert into tblDAccom values (seqDAccom.nextVal, 283, 34);
insert into tblDAccom values (seqDAccom.nextVal, 88, 43);
insert into tblDAccom values (seqDAccom.nextVal, 278, 1);
insert into tblDAccom values (seqDAccom.nextVal, 280, 25);
insert into tblDAccom values (seqDAccom.nextVal, 56, 50);
insert into tblDAccom values (seqDAccom.nextVal, 477, 68);
insert into tblDAccom values (seqDAccom.nextVal, 204, 101);
insert into tblDAccom values (seqDAccom.nextVal, 52, 20);
insert into tblDAccom values (seqDAccom.nextVal, 250, 88);
insert into tblDAccom values (seqDAccom.nextVal, 353, 77);
insert into tblDAccom values (seqDAccom.nextVal, 215, 50);
insert into tblDAccom values (seqDAccom.nextVal, 64, 51);
insert into tblDAccom values (seqDAccom.nextVal, 193, 104);
insert into tblDAccom values (seqDAccom.nextVal, 66, 11);
insert into tblDAccom values (seqDAccom.nextVal, 221, 86);
insert into tblDAccom values (seqDAccom.nextVal, 213, 49);
insert into tblDAccom values (seqDAccom.nextVal, 243, 22);
insert into tblDAccom values (seqDAccom.nextVal, 463, 61);
insert into tblDAccom values (seqDAccom.nextVal, 155, 89);
insert into tblDAccom values (seqDAccom.nextVal, 384, 15);
insert into tblDAccom values (seqDAccom.nextVal, 270, 43);
insert into tblDAccom values (seqDAccom.nextVal, 127, 92);
insert into tblDAccom values (seqDAccom.nextVal, 257, 62);
insert into tblDAccom values (seqDAccom.nextVal, 282, 19);
insert into tblDAccom values (seqDAccom.nextVal, 200, 72);
insert into tblDAccom values (seqDAccom.nextVal, 37, 1);
insert into tblDAccom values (seqDAccom.nextVal, 140, 102);
insert into tblDAccom values (seqDAccom.nextVal, 422, 38);
insert into tblDAccom values (seqDAccom.nextVal, 140, 58);
insert into tblDAccom values (seqDAccom.nextVal, 449, 59);
insert into tblDAccom values (seqDAccom.nextVal, 87, 62);
insert into tblDAccom values (seqDAccom.nextVal, 189, 85);
insert into tblDAccom values (seqDAccom.nextVal, 470, 61);
insert into tblDAccom values (seqDAccom.nextVal, 417, 67);
insert into tblDAccom values (seqDAccom.nextVal, 311, 77);
insert into tblDAccom values (seqDAccom.nextVal, 355, 12);
insert into tblDAccom values (seqDAccom.nextVal, 209, 42);
insert into tblDAccom values (seqDAccom.nextVal, 416, 97);
insert into tblDAccom values (seqDAccom.nextVal, 468, 97);
insert into tblDAccom values (seqDAccom.nextVal, 16, 4);
insert into tblDAccom values (seqDAccom.nextVal, 361, 57);
insert into tblDAccom values (seqDAccom.nextVal, 134, 31);
insert into tblDAccom values (seqDAccom.nextVal, 173, 103);
insert into tblDAccom values (seqDAccom.nextVal, 505, 81);
insert into tblDAccom values (seqDAccom.nextVal, 273, 101);
insert into tblDAccom values (seqDAccom.nextVal, 147, 85);
insert into tblDAccom values (seqDAccom.nextVal, 353, 84);
insert into tblDAccom values (seqDAccom.nextVal, 464, 73);
insert into tblDAccom values (seqDAccom.nextVal, 86, 11);
insert into tblDAccom values (seqDAccom.nextVal, 26, 85);
insert into tblDAccom values (seqDAccom.nextVal, 417, 22);
insert into tblDAccom values (seqDAccom.nextVal, 482, 94);
insert into tblDAccom values (seqDAccom.nextVal, 179, 82);
insert into tblDAccom values (seqDAccom.nextVal, 50, 95);
insert into tblDAccom values (seqDAccom.nextVal, 146, 92);
insert into tblDAccom values (seqDAccom.nextVal, 200, 60);
insert into tblDAccom values (seqDAccom.nextVal, 83, 67);
insert into tblDAccom values (seqDAccom.nextVal, 220, 37);
insert into tblDAccom values (seqDAccom.nextVal, 13, 13);
insert into tblDAccom values (seqDAccom.nextVal, 119, 50);
insert into tblDAccom values (seqDAccom.nextVal, 93, 75);
insert into tblDAccom values (seqDAccom.nextVal, 240, 3);
insert into tblDAccom values (seqDAccom.nextVal, 400, 50);
insert into tblDAccom values (seqDAccom.nextVal, 23, 65);
insert into tblDAccom values (seqDAccom.nextVal, 150, 6);
insert into tblDAccom values (seqDAccom.nextVal, 295, 4);
insert into tblDAccom values (seqDAccom.nextVal, 218, 37);
insert into tblDAccom values (seqDAccom.nextVal, 200, 58);
insert into tblDAccom values (seqDAccom.nextVal, 238, 44);
insert into tblDAccom values (seqDAccom.nextVal, 479, 74);
insert into tblDAccom values (seqDAccom.nextVal, 91, 61);
insert into tblDAccom values (seqDAccom.nextVal, 456, 14);
insert into tblDAccom values (seqDAccom.nextVal, 113, 22);
insert into tblDAccom values (seqDAccom.nextVal, 54, 73);
insert into tblDAccom values (seqDAccom.nextVal, 286, 100);
insert into tblDAccom values (seqDAccom.nextVal, 361, 55);
insert into tblDAccom values (seqDAccom.nextVal, 138, 79);
insert into tblDAccom values (seqDAccom.nextVal, 494, 100);
insert into tblDAccom values (seqDAccom.nextVal, 360, 50);
insert into tblDAccom values (seqDAccom.nextVal, 467, 23);
insert into tblDAccom values (seqDAccom.nextVal, 422, 76);
insert into tblDAccom values (seqDAccom.nextVal, 96, 104);
insert into tblDAccom values (seqDAccom.nextVal, 71, 39);
insert into tblDAccom values (seqDAccom.nextVal, 51, 6);
insert into tblDAccom values (seqDAccom.nextVal, 371, 25);
insert into tblDAccom values (seqDAccom.nextVal, 73, 61);
insert into tblDAccom values (seqDAccom.nextVal, 51, 60);
insert into tblDAccom values (seqDAccom.nextVal, 67, 60);
insert into tblDAccom values (seqDAccom.nextVal, 107, 67);
insert into tblDAccom values (seqDAccom.nextVal, 441, 70);
insert into tblDAccom values (seqDAccom.nextVal, 287, 90);
insert into tblDAccom values (seqDAccom.nextVal, 271, 77);
insert into tblDAccom values (seqDAccom.nextVal, 128, 78);
insert into tblDAccom values (seqDAccom.nextVal, 423, 44);
insert into tblDAccom values (seqDAccom.nextVal, 207, 92);
insert into tblDAccom values (seqDAccom.nextVal, 140, 48);
insert into tblDAccom values (seqDAccom.nextVal, 165, 101);
insert into tblDAccom values (seqDAccom.nextVal, 50, 87);
insert into tblDAccom values (seqDAccom.nextVal, 501, 98);
insert into tblDAccom values (seqDAccom.nextVal, 469, 69);
insert into tblDAccom values (seqDAccom.nextVal, 444, 57);
insert into tblDAccom values (seqDAccom.nextVal, 104, 50);
insert into tblDAccom values (seqDAccom.nextVal, 179, 59);
insert into tblDAccom values (seqDAccom.nextVal, 17, 14);
insert into tblDAccom values (seqDAccom.nextVal, 133, 96);
insert into tblDAccom values (seqDAccom.nextVal, 209, 25);
insert into tblDAccom values (seqDAccom.nextVal, 487, 100);
insert into tblDAccom values (seqDAccom.nextVal, 61, 53);
insert into tblDAccom values (seqDAccom.nextVal, 189, 16);
insert into tblDAccom values (seqDAccom.nextVal, 282, 7);
insert into tblDAccom values (seqDAccom.nextVal, 244, 67);
insert into tblDAccom values (seqDAccom.nextVal, 342, 2);
insert into tblDAccom values (seqDAccom.nextVal, 337, 104);
insert into tblDAccom values (seqDAccom.nextVal, 410, 97);
insert into tblDAccom values (seqDAccom.nextVal, 439, 33);
insert into tblDAccom values (seqDAccom.nextVal, 441, 102);
insert into tblDAccom values (seqDAccom.nextVal, 502, 19);
insert into tblDAccom values (seqDAccom.nextVal, 116, 30);
insert into tblDAccom values (seqDAccom.nextVal, 411, 29);
insert into tblDAccom values (seqDAccom.nextVal, 504, 63);
insert into tblDAccom values (seqDAccom.nextVal, 333, 17);
insert into tblDAccom values (seqDAccom.nextVal, 149, 100);
insert into tblDAccom values (seqDAccom.nextVal, 221, 26);
insert into tblDAccom values (seqDAccom.nextVal, 444, 70);
insert into tblDAccom values (seqDAccom.nextVal, 475, 2);
insert into tblDAccom values (seqDAccom.nextVal, 290, 51);
insert into tblDAccom values (seqDAccom.nextVal, 100, 34);
insert into tblDAccom values (seqDAccom.nextVal, 168, 12);
insert into tblDAccom values (seqDAccom.nextVal, 189, 16);
insert into tblDAccom values (seqDAccom.nextVal, 250, 74);
insert into tblDAccom values (seqDAccom.nextVal, 8, 96);
insert into tblDAccom values (seqDAccom.nextVal, 191, 78);
insert into tblDAccom values (seqDAccom.nextVal, 337, 16);
insert into tblDAccom values (seqDAccom.nextVal, 454, 102);
insert into tblDAccom values (seqDAccom.nextVal, 105, 89);
insert into tblDAccom values (seqDAccom.nextVal, 291, 81);
insert into tblDAccom values (seqDAccom.nextVal, 336, 87);
insert into tblDAccom values (seqDAccom.nextVal, 103, 42);
insert into tblDAccom values (seqDAccom.nextVal, 17, 75);
insert into tblDAccom values (seqDAccom.nextVal, 316, 17);
insert into tblDAccom values (seqDAccom.nextVal, 404, 75);
insert into tblDAccom values (seqDAccom.nextVal, 297, 77);
insert into tblDAccom values (seqDAccom.nextVal, 428, 89);
insert into tblDAccom values (seqDAccom.nextVal, 228, 16);
insert into tblDAccom values (seqDAccom.nextVal, 2, 68);
insert into tblDAccom values (seqDAccom.nextVal, 414, 66);
insert into tblDAccom values (seqDAccom.nextVal, 446, 85);
insert into tblDAccom values (seqDAccom.nextVal, 259, 104);
insert into tblDAccom values (seqDAccom.nextVal, 45, 81);
insert into tblDAccom values (seqDAccom.nextVal, 352, 62);
insert into tblDAccom values (seqDAccom.nextVal, 478, 10);
insert into tblDAccom values (seqDAccom.nextVal, 13, 20);
insert into tblDAccom values (seqDAccom.nextVal, 432, 11);
insert into tblDAccom values (seqDAccom.nextVal, 77, 58);
insert into tblDAccom values (seqDAccom.nextVal, 141, 7);
insert into tblDAccom values (seqDAccom.nextVal, 37, 91);
insert into tblDAccom values (seqDAccom.nextVal, 266, 37);
insert into tblDAccom values (seqDAccom.nextVal, 253, 28);
insert into tblDAccom values (seqDAccom.nextVal, 406, 53);
insert into tblDAccom values (seqDAccom.nextVal, 378, 59);
insert into tblDAccom values (seqDAccom.nextVal, 278, 7);
insert into tblDAccom values (seqDAccom.nextVal, 189, 66);
insert into tblDAccom values (seqDAccom.nextVal, 349, 18);
insert into tblDAccom values (seqDAccom.nextVal, 370, 26);
insert into tblDAccom values (seqDAccom.nextVal, 491, 81);
insert into tblDAccom values (seqDAccom.nextVal, 495, 1);
insert into tblDAccom values (seqDAccom.nextVal, 125, 101);
insert into tblDAccom values (seqDAccom.nextVal, 118, 39);
insert into tblDAccom values (seqDAccom.nextVal, 50, 35);
insert into tblDAccom values (seqDAccom.nextVal, 273, 34);
insert into tblDAccom values (seqDAccom.nextVal, 38, 46);
insert into tblDAccom values (seqDAccom.nextVal, 117, 14);
insert into tblDAccom values (seqDAccom.nextVal, 9, 33);
insert into tblDAccom values (seqDAccom.nextVal, 348, 3);
insert into tblDAccom values (seqDAccom.nextVal, 377, 23);
insert into tblDAccom values (seqDAccom.nextVal, 429, 69);
insert into tblDAccom values (seqDAccom.nextVal, 149, 48);
insert into tblDAccom values (seqDAccom.nextVal, 52, 91);
insert into tblDAccom values (seqDAccom.nextVal, 502, 37);
insert into tblDAccom values (seqDAccom.nextVal, 355, 87);
insert into tblDAccom values (seqDAccom.nextVal, 9, 35);
insert into tblDAccom values (seqDAccom.nextVal, 476, 20);
insert into tblDAccom values (seqDAccom.nextVal, 391, 53);
insert into tblDAccom values (seqDAccom.nextVal, 452, 80);
insert into tblDAccom values (seqDAccom.nextVal, 180, 60);
insert into tblDAccom values (seqDAccom.nextVal, 129, 94);
insert into tblDAccom values (seqDAccom.nextVal, 435, 32);
insert into tblDAccom values (seqDAccom.nextVal, 368, 65);
insert into tblDAccom values (seqDAccom.nextVal, 13, 59);
insert into tblDAccom values (seqDAccom.nextVal, 148, 17);
insert into tblDAccom values (seqDAccom.nextVal, 303, 74);
insert into tblDAccom values (seqDAccom.nextVal, 266, 46);
insert into tblDAccom values (seqDAccom.nextVal, 319, 9);
insert into tblDAccom values (seqDAccom.nextVal, 325, 36);
insert into tblDAccom values (seqDAccom.nextVal, 129, 37);
insert into tblDAccom values (seqDAccom.nextVal, 472, 63);
insert into tblDAccom values (seqDAccom.nextVal, 392, 4);
insert into tblDAccom values (seqDAccom.nextVal, 231, 72);
insert into tblDAccom values (seqDAccom.nextVal, 103, 21);
insert into tblDAccom values (seqDAccom.nextVal, 266, 73);
insert into tblDAccom values (seqDAccom.nextVal, 412, 50);
insert into tblDAccom values (seqDAccom.nextVal, 411, 19);
insert into tblDAccom values (seqDAccom.nextVal, 420, 27);
insert into tblDAccom values (seqDAccom.nextVal, 480, 85);
insert into tblDAccom values (seqDAccom.nextVal, 452, 33);
insert into tblDAccom values (seqDAccom.nextVal, 117, 42);
insert into tblDAccom values (seqDAccom.nextVal, 9, 89);
insert into tblDAccom values (seqDAccom.nextVal, 239, 31);
insert into tblDAccom values (seqDAccom.nextVal, 94, 97);
insert into tblDAccom values (seqDAccom.nextVal, 383, 13);
insert into tblDAccom values (seqDAccom.nextVal, 453, 65);
insert into tblDAccom values (seqDAccom.nextVal, 305, 15);
insert into tblDAccom values (seqDAccom.nextVal, 252, 9);
insert into tblDAccom values (seqDAccom.nextVal, 221, 54);
insert into tblDAccom values (seqDAccom.nextVal, 150, 12);
insert into tblDAccom values (seqDAccom.nextVal, 382, 93);
insert into tblDAccom values (seqDAccom.nextVal, 294, 62);
insert into tblDAccom values (seqDAccom.nextVal, 180, 85);
insert into tblDAccom values (seqDAccom.nextVal, 1, 15);
insert into tblDAccom values (seqDAccom.nextVal, 312, 46);
insert into tblDAccom values (seqDAccom.nextVal, 203, 87);
insert into tblDAccom values (seqDAccom.nextVal, 64, 18);
insert into tblDAccom values (seqDAccom.nextVal, 253, 69);
insert into tblDAccom values (seqDAccom.nextVal, 324, 67);
insert into tblDAccom values (seqDAccom.nextVal, 354, 10);
insert into tblDAccom values (seqDAccom.nextVal, 314, 95);
insert into tblDAccom values (seqDAccom.nextVal, 453, 83);
insert into tblDAccom values (seqDAccom.nextVal, 285, 69);
insert into tblDAccom values (seqDAccom.nextVal, 363, 48);
insert into tblDAccom values (seqDAccom.nextVal, 182, 75);
insert into tblDAccom values (seqDAccom.nextVal, 131, 46);
insert into tblDAccom values (seqDAccom.nextVal, 114, 62);
insert into tblDAccom values (seqDAccom.nextVal, 318, 66);
insert into tblDAccom values (seqDAccom.nextVal, 289, 85);
insert into tblDAccom values (seqDAccom.nextVal, 361, 35);
insert into tblDAccom values (seqDAccom.nextVal, 316, 81);
insert into tblDAccom values (seqDAccom.nextVal, 124, 6);
insert into tblDAccom values (seqDAccom.nextVal, 368, 79);
insert into tblDAccom values (seqDAccom.nextVal, 60, 41);
insert into tblDAccom values (seqDAccom.nextVal, 74, 72);
insert into tblDAccom values (seqDAccom.nextVal, 229, 22);
insert into tblDAccom values (seqDAccom.nextVal, 447, 66);
insert into tblDAccom values (seqDAccom.nextVal, 51, 93);
insert into tblDAccom values (seqDAccom.nextVal, 502, 84);
insert into tblDAccom values (seqDAccom.nextVal, 363, 17);
insert into tblDAccom values (seqDAccom.nextVal, 497, 52);
insert into tblDAccom values (seqDAccom.nextVal, 218, 83);
insert into tblDAccom values (seqDAccom.nextVal, 475, 20);
insert into tblDAccom values (seqDAccom.nextVal, 423, 14);
insert into tblDAccom values (seqDAccom.nextVal, 471, 80);
insert into tblDAccom values (seqDAccom.nextVal, 61, 33);
insert into tblDAccom values (seqDAccom.nextVal, 382, 26);
insert into tblDAccom values (seqDAccom.nextVal, 492, 66);
insert into tblDAccom values (seqDAccom.nextVal, 123, 40);
insert into tblDAccom values (seqDAccom.nextVal, 283, 82);
insert into tblDAccom values (seqDAccom.nextVal, 39, 93);
insert into tblDAccom values (seqDAccom.nextVal, 102, 30);
insert into tblDAccom values (seqDAccom.nextVal, 359, 91);
insert into tblDAccom values (seqDAccom.nextVal, 255, 2);
insert into tblDAccom values (seqDAccom.nextVal, 202, 65);
insert into tblDAccom values (seqDAccom.nextVal, 243, 91);
insert into tblDAccom values (seqDAccom.nextVal, 317, 93);
insert into tblDAccom values (seqDAccom.nextVal, 479, 98);
insert into tblDAccom values (seqDAccom.nextVal, 464, 53);
insert into tblDAccom values (seqDAccom.nextVal, 301, 62);
insert into tblDAccom values (seqDAccom.nextVal, 384, 73);
insert into tblDAccom values (seqDAccom.nextVal, 4, 5);
insert into tblDAccom values (seqDAccom.nextVal, 372, 105);
insert into tblDAccom values (seqDAccom.nextVal, 97, 30);
insert into tblDAccom values (seqDAccom.nextVal, 129, 5);
insert into tblDAccom values (seqDAccom.nextVal, 343, 67);
insert into tblDAccom values (seqDAccom.nextVal, 494, 53);
insert into tblDAccom values (seqDAccom.nextVal, 368, 76);
insert into tblDAccom values (seqDAccom.nextVal, 264, 18);
insert into tblDAccom values (seqDAccom.nextVal, 442, 3);
insert into tblDAccom values (seqDAccom.nextVal, 370, 50);
insert into tblDAccom values (seqDAccom.nextVal, 125, 32);
insert into tblDAccom values (seqDAccom.nextVal, 117, 97);
insert into tblDAccom values (seqDAccom.nextVal, 37, 63);
insert into tblDAccom values (seqDAccom.nextVal, 147, 17);
insert into tblDAccom values (seqDAccom.nextVal, 439, 24);
insert into tblDAccom values (seqDAccom.nextVal, 34, 101);
insert into tblDAccom values (seqDAccom.nextVal, 490, 22);
insert into tblDAccom values (seqDAccom.nextVal, 349, 100);
insert into tblDAccom values (seqDAccom.nextVal, 170, 28);
insert into tblDAccom values (seqDAccom.nextVal, 92, 36);
insert into tblDAccom values (seqDAccom.nextVal, 164, 45);
insert into tblDAccom values (seqDAccom.nextVal, 241, 12);
insert into tblDAccom values (seqDAccom.nextVal, 495, 72);
insert into tblDAccom values (seqDAccom.nextVal, 204, 17);
insert into tblDAccom values (seqDAccom.nextVal, 196, 102);
insert into tblDAccom values (seqDAccom.nextVal, 311, 60);
insert into tblDAccom values (seqDAccom.nextVal, 344, 80);
insert into tblDAccom values (seqDAccom.nextVal, 104, 95);
insert into tblDAccom values (seqDAccom.nextVal, 350, 15);
insert into tblDAccom values (seqDAccom.nextVal, 164, 38);
insert into tblDAccom values (seqDAccom.nextVal, 209, 23);
insert into tblDAccom values (seqDAccom.nextVal, 38, 6);
insert into tblDAccom values (seqDAccom.nextVal, 344, 9);
insert into tblDAccom values (seqDAccom.nextVal, 320, 50);
insert into tblDAccom values (seqDAccom.nextVal, 69, 55);
insert into tblDAccom values (seqDAccom.nextVal, 282, 35);
insert into tblDAccom values (seqDAccom.nextVal, 304, 34);
insert into tblDAccom values (seqDAccom.nextVal, 286, 20);
insert into tblDAccom values (seqDAccom.nextVal, 246, 51);
insert into tblDAccom values (seqDAccom.nextVal, 462, 63);
insert into tblDAccom values (seqDAccom.nextVal, 333, 22);
insert into tblDAccom values (seqDAccom.nextVal, 399, 80);
insert into tblDAccom values (seqDAccom.nextVal, 455, 12);
insert into tblDAccom values (seqDAccom.nextVal, 214, 24);
insert into tblDAccom values (seqDAccom.nextVal, 500, 9);
insert into tblDAccom values (seqDAccom.nextVal, 66, 38);
insert into tblDAccom values (seqDAccom.nextVal, 159, 53);
insert into tblDAccom values (seqDAccom.nextVal, 365, 64);
insert into tblDAccom values (seqDAccom.nextVal, 222, 49);
insert into tblDAccom values (seqDAccom.nextVal, 309, 31);
insert into tblDAccom values (seqDAccom.nextVal, 373, 91);
insert into tblDAccom values (seqDAccom.nextVal, 505, 6);
insert into tblDAccom values (seqDAccom.nextVal, 335, 55);
insert into tblDAccom values (seqDAccom.nextVal, 400, 15);
insert into tblDAccom values (seqDAccom.nextVal, 442, 9);
insert into tblDAccom values (seqDAccom.nextVal, 37, 9);
insert into tblDAccom values (seqDAccom.nextVal, 116, 21);
insert into tblDAccom values (seqDAccom.nextVal, 108, 93);
insert into tblDAccom values (seqDAccom.nextVal, 74, 31);
insert into tblDAccom values (seqDAccom.nextVal, 87, 3);
insert into tblDAccom values (seqDAccom.nextVal, 332, 57);
insert into tblDAccom values (seqDAccom.nextVal, 13, 40);
insert into tblDAccom values (seqDAccom.nextVal, 328, 53);
insert into tblDAccom values (seqDAccom.nextVal, 335, 61);
insert into tblDAccom values (seqDAccom.nextVal, 277, 69);
insert into tblDAccom values (seqDAccom.nextVal, 197, 87);
insert into tblDAccom values (seqDAccom.nextVal, 307, 18);
insert into tblDAccom values (seqDAccom.nextVal, 424, 37);
insert into tblDAccom values (seqDAccom.nextVal, 435, 5);
insert into tblDAccom values (seqDAccom.nextVal, 300, 93);
insert into tblDAccom values (seqDAccom.nextVal, 497, 99);
insert into tblDAccom values (seqDAccom.nextVal, 455, 55);
insert into tblDAccom values (seqDAccom.nextVal, 364, 35);
insert into tblDAccom values (seqDAccom.nextVal, 289, 71);
insert into tblDAccom values (seqDAccom.nextVal, 80, 79);
insert into tblDAccom values (seqDAccom.nextVal, 253, 75);
insert into tblDAccom values (seqDAccom.nextVal, 218, 49);
insert into tblDAccom values (seqDAccom.nextVal, 396, 67);
insert into tblDAccom values (seqDAccom.nextVal, 60, 21);
insert into tblDAccom values (seqDAccom.nextVal, 182, 14);
insert into tblDAccom values (seqDAccom.nextVal, 73, 10);
insert into tblDAccom values (seqDAccom.nextVal, 168, 70);
insert into tblDAccom values (seqDAccom.nextVal, 113, 86);
insert into tblDAccom values (seqDAccom.nextVal, 292, 91);
insert into tblDAccom values (seqDAccom.nextVal, 337, 53);
insert into tblDAccom values (seqDAccom.nextVal, 6, 57);
insert into tblDAccom values (seqDAccom.nextVal, 360, 11);
insert into tblDAccom values (seqDAccom.nextVal, 61, 67);

-- 페스티벌



-- 메모, 찜, 의견, 동선은 없는 데이터
-- 페스티벌은 영우님이 올려주시고

commit;



