--This view will be used to display all necessary columns for teachers.
create or replace view sta_vw_teacher as
with courses_agg as(
    select   crse_tchr.usr_id
    ,        listagg(crse.name, ', ') within group (order by crse.name) as courses
    from     sta_course_teacher crse_tchr
    join     sta_course crse on crse.id = crse_tchr.crse_id
    group by crse_tchr.usr_id
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
    and     usr.deleted_flg = false
)
select    tchr.*
,         crse_agg.courses
from      w_teacher tchr
left join courses_agg crse_agg on tchr.id = crse_agg.usr_id
    ;

