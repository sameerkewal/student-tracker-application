--This view will be used to display all necessary columns for teachers.
create or replace view sta_vw_teacher as
with courses_agg as(
    select  listagg(distinct  crse.name, ', ') within group ( order by crse.name)        as courses
    ,       usr_id
    from    sta_course_class_teacher crse_clss_tchr
    left    join sta_course crse on  crse_clss_tchr.crse_id = crse.id
    group by usr_id

),
     w_teacher as(
    select usr.id 
    ,      usr.first_name     
    ,      usr.last_name      
    ,      usr.address1       
    ,      usr.address2       
    ,      usr.phone_number1  
    ,      usr.phone_number2
    ,      usr.email
    ,      usr.password  
    from    sta_user usr
    join    sta_user_role usr_rle on usr.id = usr_rle.usr_id
    join    sta_role rle on usr_rle.rle_id = rle.id
    where   lower(rle.name) = lower('teacher')
    and     usr.deleted_flg = 'N'
)
select    tchr.*
,         crse_agg.courses
from      w_teacher tchr
left join courses_agg crse_agg on tchr.id = crse_agg.usr_id
    ;

