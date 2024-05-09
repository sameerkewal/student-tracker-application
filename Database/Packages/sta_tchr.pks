create or replace package sta_tchr
is
--global variables


    function f_get_tchr(p_id sta_teacher.id%type) return sta_teacher%rowtype;

    procedure p_add_tchr         ( pi_id           sta_teacher.id%type
                                 , pi_first_name   sta_teacher.first_name%type
                                 , pi_last_name    sta_teacher.last_name%type
                                 , pi_middle_name  sta_teacher.middle_name%type
                                 , pi_phone_number1 sta_teacher.phone_number1%type
                                 , pi_phone_number2 sta_teacher.phone_number2%type
                                 , pi_address1     sta_teacher.address1%type
                                 , pi_address2     sta_teacher.address2%type
                                 , pi_remarks      sta_teacher.remarks%type
                                 , pi_courses      varchar2
                                 );


    procedure p_delete_tchr(pi_id sta_teacher.id%type);
    end sta_tchr;