create or replace package body sta_usr
is

  --global variables


  function f_get_usr(pi_id sta_user.id%type)return sta_user%rowtype
    is
      v_row sta_user%rowtype;
      cursor cur_row is
        select * from sta_user
        where
        id = pi_id;
    begin
      open cur_row;
      fetch cur_row into v_row;
      close cur_row;
      return v_row;
    end f_get_usr
    ;

    procedure p_upsert_tchr( pi_id           sta_user.id%type  
                           , pi_first_name    sta_user.first_name%type     
                           , pi_last_name     sta_user.last_name%type 
                           , pi_date_of_birth sta_user.date_of_birth%type 
                           , pi_address1      sta_user.address1%type 
                           , pi_address2      sta_user.address2%type 
                           , pi_phone_number1 sta_user.phone_number1%type  
                           , pi_phone_number2 sta_user.phone_number2%type
                           , pi_email         sta_user.email%type 
                           , pi_password      sta_user.password%type
                           , pi_rle_id        sta_role.id%type
                          )
      is
      begin
        null;
      end p_upsert_tchr;

    procedure p_upsert_stdnt( pi_id            sta_user.id%type
                            , pi_first_name    sta_user.first_name%type 
                            , pi_last_name     sta_user.last_name%type  
                            , pi_date_of_birth sta_user.date_of_birth%type  
                            , pi_address1      sta_user.address1%type  
                            , pi_address2      sta_user.address2%type  
                            , pi_phone_number1 sta_user.phone_number1%type  
                            , pi_phone_number2 sta_user.phone_number2%type  
                            , pi_ctkr_id       sta_user.ctkr_id%type  
                            , pi_remarks       sta_user.remarks%type
                            , pi_class         sta_user.clss_id%type
                            , pi_rle_id        sta_role.id%type
                            )
      is
        l_usr_id sta_user.id%type;
      begin
        if pi_id is null then
          insert into sta_user
          ( first_name
          , last_name
          , date_of_birth
          , address1
          , address2
          , phone_number1
          , phone_number2
          , ctkr_id
          , remarks
          )
          values
          (
            pi_first_name
          , pi_last_name
          , pi_date_of_birth
          , pi_address1
          , pi_address2
          , pi_phone_number1
          , pi_phone_number2
          , pi_ctkr_id
          , pi_remarks
          )
          returning id into l_usr_id;

         insert into sta_user_role
         ( rle_id
         , usr_id
         )
         values
         ( pi_rle_id
         , l_usr_id
         );


        else
          update sta_user
          set first_name    = pi_first_name
            , last_name     = pi_last_name
            , date_of_birth = pi_date_of_birth
            , address1      = pi_address1
            , address2      = pi_address2
            , phone_number1 = pi_phone_number1
            , phone_number2 = pi_phone_number2
            , ctkr_id       = pi_ctkr_id
            , remarks       = pi_remarks
          where id = pi_id;
        end if;
      end p_upsert_stdnt;

      procedure p_upsert_ctkr( pi_id            sta_user.id%type
                             , pi_first_name    sta_user.first_name%type
                             , pi_last_name     sta_user.last_name%type
                             , pi_address1      sta_user.address1%type
                             , pi_address2      sta_user.address2%type
                             , pi_phone_number1 sta_user.phone_number1%type  
                             , pi_phone_number2 sta_user.phone_number2%type 
                             , pi_remarks       sta_user.remarks%type 
                             , pi_rle_id        sta_role.id%type
                             )
      is
        l_usr_id sta_user.id%type;
      begin
        if pi_id is null then
          insert into sta_user
          ( first_name
          , last_name
          , address1
          , address2
          , phone_number1
          , phone_number2
          , remarks
          )
          values
          (
            pi_first_name
          , pi_last_name
          , pi_address1
          , pi_address2
          , pi_phone_number1
          , pi_phone_number2
          , pi_remarks
          )
          returning id into l_usr_id;

        insert into sta_user_role
        ( rle_id
        , usr_id
        )
        values
        ( pi_rle_id
        , l_usr_id
        );

        else
          update sta_user
          set first_name    = pi_first_name
            , last_name     = pi_last_name
            , address1      = pi_address1
            , address2      = pi_address2
            , phone_number1 = pi_phone_number1
            , phone_number2 = pi_phone_number2
            , remarks       = pi_remarks
          where id = pi_id;

        end if;
      end p_upsert_ctkr;


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
                          , pi_rle_id        sta_role.id%type
                          )
    is
    begin
        if pi_rle_id = gc_sdnt_rle
        then
          p_upsert_stdnt( pi_id            => pi_id           
                        , pi_first_name    => pi_first_name     
                        , pi_last_name     => pi_last_name     
                        , pi_date_of_birth => pi_date_of_birth 
                        , pi_address1      => pi_address1      
                        , pi_address2      => pi_address2      
                        , pi_phone_number1 => pi_phone_number1 
                        , pi_phone_number2 => pi_phone_number2 
                        , pi_ctkr_id       => pi_ctkr_id      
                        , pi_remarks       => pi_remarks
                        , pi_rle_id        => pi_rle_id      
                        );
        elsif pi_rle_id = gc_tchr_rle
        then
          p_upsert_tchr(  pi_id             => pi_id            
                        , pi_first_name     => pi_first_name    
                        , pi_last_name      => pi_last_name     
                        , pi_date_of_birth  => pi_date_of_birth 
                        , pi_address1       => pi_address1      
                        , pi_address2       => pi_address2      
                        , pi_phone_number1  => pi_phone_number1 
                        , pi_phone_number2  => pi_phone_number2 
                        , pi_email          => pi_email         
                        , pi_password       => pi_password
                        , pi_rle_id         => pi_rle_id          
                        );
        elsif pi_rle_id = gc_ctkr_rle
        then
          p_upsert_ctkr(  pi_id            => pi_id           
                        , pi_first_name    => pi_first_name   
                        , pi_last_name     => pi_last_name    
                        , pi_address1      => pi_address1     
                        , pi_address2      => pi_address2     
                        , pi_phone_number1 => pi_phone_number1 
                        , pi_phone_number2 => pi_phone_number2 
                        , pi_remarks       => pi_remarks       
                        , pi_rle_id        => pi_rle_id      
                        );
        end if;
    end p_upsert_usr;

    procedure p_delete_usr(pi_id sta_user.id%type)
    is
    begin
      update sta_user set deleted_flg = true;
    end p_delete_usr;


    end sta_usr;