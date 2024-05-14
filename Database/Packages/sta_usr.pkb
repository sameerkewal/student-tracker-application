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
                          )
      is
        l_tchr_id sta_user.id%type := pi_id;        
        l_courses apex_t_varchar2;

      begin
        -- The courses come in a colon seperated string from the checkbox group so we seperate them
        l_courses := apex_string.split(pi_courses, ':');

        if l_tchr_id is null then
          insert into sta_user
          ( first_name
          , last_name
          -- , date_of_birth
          , address1
          , address2
          , phone_number1
          , phone_number2
          , email
          , password
          )
          values
          (
            pi_first_name
          , pi_last_name
          -- , pi_date_of_birth
          , pi_address1
            , pi_address2
          , pi_phone_number1
          , pi_phone_number2
          , pi_email
          , pi_password
          )
          returning id into l_tchr_id;
          --
          -- Couple the teacher with the role
          --
          insert into sta_user_role
          ( rle_id
          , usr_id
          )
          values
          (
            pi_rle_id
          , l_tchr_id
          );
          --
          -- Couple the courses with the teacher(teacher === user)
          --
          for i in 1..l_courses.count loop
                insert into sta_course_teacher (crse_id, usr_id)
                values (l_courses(i), l_tchr_id);
          end loop;

        else
        --
        -- password check
        --
          update sta_user
          set first_name    = pi_first_name
            , last_name     = pi_last_name
            -- , date_of_birth = pi_date_of_birth
            , address1      = pi_address1
            , address2      = pi_address2
            , phone_number1 = pi_phone_number1
            , phone_number2 = pi_phone_number2
            , email         = pi_email
            , password      = case when pi_password is null then password else pi_password end
          where id = l_tchr_id;
            --
            -- Clear the courses from the coupled teacher
            --
            delete from sta_course_teacher
            where usr_id = l_tchr_id;
          --
          -- And couple the new selected ones
          --
          for i in 1..l_courses.count loop
                insert into sta_course_teacher (crse_id, usr_id)
                values (l_courses(i), l_tchr_id);
          end loop;
        end if;
      end p_upsert_tchr;

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
          , ctkr_id
          , clss_id
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
          , pi_ctkr_id
          , pi_clss_id
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
                          , pi_clss_id       sta_user.clss_id%type
                          , pi_rle_id        sta_role.id%type
                          )
    is
    begin
        if pi_rle_id = gc_sdnt_rle
        then
          -- p_upsert_stdnt( pi_id            => pi_id           
          --               , pi_first_name    => pi_first_name     
          --               , pi_last_name     => pi_last_name     
          --               , pi_date_of_birth => pi_date_of_birth 
          --               , pi_address1      => pi_address1      
          --               , pi_address2      => pi_address2      
          --               , pi_phone_number1 => pi_phone_number1 
          --               , pi_phone_number2 => pi_phone_number2 
          --               , pi_ctkr_id       => pi_ctkr_id      
          --               , pi_remarks       => pi_remarks
          --               , pi_clss_id       => pi_clss_id
          --               , pi_rle_id        => pi_rle_id      
          --               );
          null;
        elsif pi_rle_id = gc_tchr_rle
        then
          -- p_upsert_tchr(  pi_id             => pi_id            
          --               , pi_first_name     => pi_first_name    
          --               , pi_last_name      => pi_last_name     
          --               -- , pi_date_of_birth  => pi_date_of_birth 
          --               , pi_address1       => pi_address1      
          --               , pi_address2       => pi_address2      
          --               , pi_phone_number1  => pi_phone_number1 
          --               , pi_phone_number2  => pi_phone_number2 
          --               , pi_email          => pi_email         
          --               , pi_password       => pi_password
          --               , pi_rle_id         => pi_rle_id          
          --               );
          null;
        elsif pi_rle_id = gc_ctkr_rle
        then
          -- p_upsert_ctkr(  pi_id            => pi_id           
          --               , pi_first_name    => pi_first_name   
          --               , pi_last_name     => pi_last_name    
          --               , pi_address1      => pi_address1     
          --               , pi_address2      => pi_address2     
          --               , pi_phone_number1 => pi_phone_number1 
          --               , pi_phone_number2 => pi_phone_number2 
          --               , pi_remarks       => pi_remarks       
          --               , pi_rle_id        => pi_rle_id      
          --               );
          null;
        end if;
    end p_upsert_usr;

    procedure p_delete_usr(pi_id sta_user.id%type)
    is
    begin
      update sta_user set deleted_flg = true
      where  id = pi_id;
    end p_delete_usr;

    procedure hard_delete_usr(pi_id sta_user.id%type)
    is
    begin
      null;
    end;   



    end sta_usr;