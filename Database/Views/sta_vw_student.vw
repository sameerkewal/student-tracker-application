--This view will be used to display all necessary columns for students.


create or replace view sta_vw_student
as
    select    usr.id
    ,         usr.first_name
    ,         usr.last_name
    ,         usr.date_of_birth
    ,         usr.address1
    ,         usr.address2
    ,         usr.phone_number1
    ,         usr.clss_id
    ,         usr.in_schoolyear
    ,         grde.id         grde_id
    ,         usr.ctkr_id
    ,         usr.gender
    ,         usr.graduated_flg
    ,         usr.registration_year
    ,         usr.deregistration_year
    ,         usr.origin_school
    from      sta_user usr
    left join sta_class clss on usr.clss_id = clss.id
    left join sta_grade grde on clss.grde_id = grde.id
    join      sta_user_role usr_rle on usr.id = usr_rle.usr_id
    join      sta_role rle on usr_rle.rle_id = rle.id
    where     lower(rle.name) = lower('student')
    and       usr.deleted_flg = 'N'
    order by usr.last_name asc
    ;

