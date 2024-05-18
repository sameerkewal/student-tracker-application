create or replace package sta_usr
is
    --global variables
    gc_tchr_rle constant  sta_role.id%type := sta_rle.f_get_rle_id('teacher');
    gc_sdnt_rle constant  sta_role.id%type := sta_rle.f_get_rle_id('student');
    gc_ctkr_rle constant  sta_role.id%type := sta_rle.f_get_rle_id('caretaker');
    gc_admin_rle constant sta_role.id%type := sta_rle.f_get_rle_id('admin');

    type t_rle_rec is record( rle_id sta_user_role.rle_id%type);
    type r_rle_tab is table of t_rle_rec;

    function f_get_usr(pi_id sta_user.id%type) return sta_user%rowtype;
    procedure p_delete_usr(pi_id sta_user.id%type);

    procedure p_upsert_tchr( pi_id            sta_user.id%type  
                           , pi_first_name    sta_user.first_name%type     
                           , pi_last_name     sta_user.last_name%type 
                          --  , pi_date_of_birth sta_user.date_of_birth%type ??? not sure
                           , pi_address1      sta_user.address1%type 
                           , pi_address2      sta_user.address2%type 
                           , pi_phone_number1 sta_user.phone_number1%type  
                           , pi_phone_number2 sta_user.phone_number2%type
                           , pi_email         sta_user.email%type 
                           , pi_password      sta_user.password%type
                           , pi_rle_id        sta_role.id%type
                           , pi_courses       varchar2
                          );

      
    procedure p_upsert_stdnt( pi_id                  sta_user.id%type
                            , pi_first_name          sta_user.first_name%type 
                            , pi_last_name           sta_user.last_name%type  
                            , pi_date_of_birth       sta_user.date_of_birth%type  
                            , pi_address1            sta_user.address1%type  
                            , pi_address2            sta_user.address2%type  
                            , pi_phone_number1       sta_user.phone_number1%type  
                            , pi_ctkr_id             sta_user.ctkr_id%type
                            , pi_remarks             sta_user.remarks%type
                            , pi_clss_id             sta_user.clss_id%type
                            , pi_gender              sta_user.gender%type
                            , pi_registration_year   sta_user.registration_year%type
                            , pi_deregistration_year sta_user.deregistration_year%type
                            , pi_origin_school       sta_user.origin_school%type
                            , pi_rle_id              sta_role.id%type
                            );

    procedure p_upsert_ctkr(   pi_id            sta_user.id%type
                             , pi_first_name    sta_user.first_name%type
                             , pi_last_name     sta_user.last_name%type
                             , pi_address1      sta_user.address1%type
                             , pi_address2      sta_user.address2%type
                             , pi_phone_number1 sta_user.phone_number1%type  
                             , pi_phone_number2 sta_user.phone_number2%type 
                             , pi_rle_id        sta_role.id%type
                             );

    procedure p_hard_delete_tchr(pi_id sta_user.id%type);   
    function f_get_user_role(pi_usr_id sta_user.id%type) return r_rle_tab pipelined;


    end sta_usr;