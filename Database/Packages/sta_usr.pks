create or replace package sta_usr
is
    --global variables
    gc_tchr_rle constant sta_role.name%type := 'teacher';
    gc_sdnt_rle constant sta_role.name%type := 'student';
    gc_ctkr_rle constant sta_role.name%type := 'caretaker';
    gc_ctkr_rle constant sta_role.name%type := 'admin';

    function f_get_usr(pi_id sta_user.id%type)return sta_user%rowtype;


    procedure p_upsert_usr( pi_id            sta_user.id%type
                          , pi_first_name    sta_user.first_name%type
                          , pi_last_name     sta_user.last_name%type
                          , pi_date_of_birth sta_user.date_of_birth%type
                          , pi_address1      sta_user.address1%type
                          , pi_address2      sta_user.address2%type
                          , pi_phone_number1 sta_user.phone_number1%type
                          , pi_phone_number2 sta_user.phone_number2%type
                          , pi_email         sta_user.email%type
                          , pi_password      sta_user.password%type
                          , pi_ctkr_id       sta_user.ctkr_id%type
                          , pi_remarks       sta_user.remarks%type
                          , pi_rle_id          sta_role.id%type
                        );
    end sta_usr;