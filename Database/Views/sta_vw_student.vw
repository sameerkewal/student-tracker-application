--This view will be used to display all necessary columns for students.


create or replace view sta_vw_student
as
    select  usr.id
    ,       usr.first_name
    ,       usr.last_name
    ,       usr.date_of_birth
    ,       usr.address1
    ,       usr.address2
    ,       usr.phone_number1
    ,       usr.remarks
    ,       usr.clss_id
    ,       usr.ctkr_id
    ,       usr.gender
    ,       usr.registration_year
    ,       usr.deregistration_year
    ,       usr.origin_school
    from    sta_user usr
    join    sta_user_role usr_rle on usr.id = usr_rle.usr_id
    join    sta_role rle on usr_rle.rle_id = rle.id
    where   lower(rle.name) = lower('student')
    and     usr.deleted_flg = false
    ;