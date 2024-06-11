create or replace view sta_vw_result as
    select  sdnt_tst.id
    ,       sdnt_tst.usr_id
    ,       sdnt_tst.result
    ,       tst.id                  tst_id
    ,       tst.name                tst_name
    ,       tst.datetime_planned
    ,       crse.id                 crse_id
    ,       crse.name               crse_name
    ,       smsr.id                 smsr_id
    ,       smsr.name               smsr_name
    ,       grde.id                 grde_id
    ,       grde.name               grde_name
    from    sta_student_test sdnt_tst
    join    sta_test tst on sdnt_tst.tst_id = tst.id
    join    sta_course crse on tst.crse_id = crse.id
    join    sta_semester smsr on tst.smsr_id = smsr.id
    join    sta_grade    grde on tst.grde_id = grde.id
    where   usr_id in (select id from sta_vw_student)
;