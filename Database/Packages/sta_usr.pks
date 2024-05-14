create or replace package sta_usr
is
    --global variables
    gc_tchr_rle constant sta_role.id%type := sta_rle.f_get_rle_id('teacher');
    gc_sdnt_rle constant sta_role.id%type := sta_rle.f_get_rle_id('student');
    gc_ctkr_rle constant sta_role.id%type := sta_rle.f_get_rle_id('caretaker');
    gc_admin_rle constant sta_role.id%type := sta_rle.f_get_rle_id('admin');

    function f_get_usr(pi_id sta_user.id%type) return sta_user%rowtype;
    procedure p_delete_usr(pi_id sta_user.id%type);

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
                          , pi_clss_id       sta_user.clss_id%type
                          , pi_rle_id        sta_role.id%type
                        );


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

      
    procedure p_upsert_stdnt( pi_id            sta_user.id%type
                            , pi_first_name    sta_user.first_name%type 
                            , pi_last_name     sta_user.last_name%type  
                            , pi_date_of_birth sta_user.date_of_birth%type  
                            , pi_address1      sta_user.address1%type  
                            , pi_address2      sta_user.address2%type  
                            , pi_phone_number1 sta_user.phone_number1%type  
                            , pi_ctkr_id       sta_user.ctkr_id%type
                            , pi_remarks       sta_user.remarks%type
                            , pi_clss_id       sta_user.clss_id%type
                            , pi_rle_id        sta_role.id%type
                            );
    procedure p_upsert_ctkr(   pi_id            sta_user.id%type
                             , pi_first_name    sta_user.first_name%type
                             , pi_last_name     sta_user.last_name%type
                             , pi_address1      sta_user.address1%type
                             , pi_address2      sta_user.address2%type
                             , pi_phone_number1 sta_user.phone_number1%type  
                             , pi_phone_number2 sta_user.phone_number2%type 
                             , pi_remarks       sta_user.remarks%type 
                             , pi_rle_id        sta_role.id%type
                             );

    procedure hard_delete_usr(pi_id sta_user.id%type);   

    end sta_usr;