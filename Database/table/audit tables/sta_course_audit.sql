 create table sta_course_audit (
  id number generated by default on null as identity,
  naam        varchar2(4000)
, omschrijving varchar2(4000)
, actie      varchar2(20)
, leerjaren varchar2(4000)
, actie_datum date
, gedaan_door varchar2(4000)
 );

