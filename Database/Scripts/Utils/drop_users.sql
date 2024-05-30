-- figuring out how to drop users!
-- for test purposes duh


delete from sta_user
where  id not in (
    select id from sta_vw_caretaker
)
;

delete from sta_user_role
where  usr_id  in (
    select id 
    from sta_user
    where  clss_id is not null
);

delete from sta_class;


delete from sta_user
where  clss_id is not null;

commit;

delete from sta_user;

delete from STA_COURSE_TEACHER;

delete from STA_USER_ROLE
;


select  *
from    STA_VW_TEACHER
;

delete from sta_user_role
where   usr_id = 172;

delete from sta_user
where   id = 172
;


delete from STA_COURSE_TEACHER
where  usr_id = 172;

select  *
from    STA_VW_CARETAKER
;





--delete all students
delete from sta_user_role
where  usr_id in (
    select id from sta_vw_student
    )
;

delete from sta_student_remark;

delete from sta_user
where id in (select id from sta_vw_student)
;

commit;

--delete all caretakers
delete from sta_user_role
where  usr_id in (
    select id from sta_vw_caretaker
    )
;

delete from sta_user
where id in (select id from sta_vw_caretaker)
;

commit;

delete from sta_user
where id not in (
    select usr_id from sta_user_role
    );


select *
from    sta_user
;