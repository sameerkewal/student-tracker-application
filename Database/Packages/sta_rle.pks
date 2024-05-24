create or replace package sta_rle
is
    --global variables


    function f_get_rle(pi_id sta_role.id%type)return sta_role%rowtype;

    function f_get_rle_id(pi_name sta_role.name%type)return sta_role.id%type;

    procedure p_add_rle( pi_id sta_role.id%type
                       , pi_name sta_role.name%type
                       , pi_description sta_role.description%type
                       );

    -- Returns true if teacher is also an admin
    function is_tchr_also_admin(pi_id sta_user.id%type) return boolean;


    -- Can return one of 4 things
    -- 1. 'TEACHER' if the user is a teacher
    -- 2. 'ADMIN' if the user is an admin
    -- 3. 'TEACHER_ADMIN' if the user is both a teacher and an admin
    -- 4. 'NEITHER' if the user is neither(this shouldnt happen unless a student/caretaker id is passed instead)
    function check_is_teacher_and_admin(pi_id sta_user.id%type) return sta_role.name%type;


    -- Function used on page 10 to determine whether the page should be read only or not based on the username and email
    -- Only Teachers associated with the selected student(associated as in the student is in the class of the teacher) may be able to edit that student
    -- And Ofcourse Admins can edit all the students with no restrictions
    function check_read_only( pi_username sta_user.email%type
                            , pi_clss_id sta_class.id%type
                            , pi_action varchar2
                            )return boolean;
end sta_rle;