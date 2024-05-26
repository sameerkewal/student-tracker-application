create or replace package body sta_usr
is
  --global variables
 gc_package        constant varchar2(128)   := $$plsql_unit|| '.';

 -- For apex_error.
 c_inline_with_field_and_notif  constant varchar2(40):='INLINE_WITH_FIELD_AND_NOTIFICATION';


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

  function f_get_usr_by_email(pi_email sta_user.email%type) return sta_user%rowtype
  is
    v_row sta_user%rowtype;
    cursor cur_row is
      select * from sta_user 
      where  lower(email) = lower(pi_email);
  begin
    open cur_row;
    fetch cur_row into v_row;
    close cur_row;
    return v_row;
  end f_get_usr_by_email;

    procedure p_upsert_tchr( pi_id            sta_user.id%type  
                           , pi_first_name    sta_user.first_name%type     
                           , pi_last_name     sta_user.last_name%type 
                           , pi_address1      sta_user.address1%type 
                           , pi_address2      sta_user.address2%type 
                           , pi_phone_number1 sta_user.phone_number1%type  
                           , pi_phone_number2 sta_user.phone_number2%type
                           , pi_email         sta_user.email%type 
                           , pi_password      sta_user.password%type
                           , pi_rle_id        sta_role.id%type
                           , pi_is_admin      boolean
                           , pi_courses       varchar2
                          )
      is
        l_tchr_id  sta_user.id%type := pi_id;        
        l_courses  apex_t_varchar2;
        l_salt     varchar2(64);
      begin
        -- The courses come in a colon seperated string from the checkbox group so we seperate them
        l_courses := apex_string.split(pi_courses, ':');

        if l_tchr_id is null then
          -- Generate salt
          l_salt := sta_app_security.f_generate_salt;

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
          , salt)
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
          , sta_app_security.f_hash_password(pi_password => trim(pi_password), pi_salt => l_salt)
          , l_salt
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

          -- User can be an admin as well as a teacher
          if pi_is_admin then
            insert into sta_user_role
            ( rle_id
            , usr_id
            )
            values
            (
              sta_rle.f_get_rle_id(pi_name => 'admin')
            , l_tchr_id
            );
          end if;

          --
          -- Couple the courses with the teacher(teacher === user)
          --
          for i in 1..l_courses.count loop
                insert into sta_course_teacher (crse_id, usr_id)
                values (l_courses(i), l_tchr_id);
          end loop;

        else
        --
        -- generate salt
        --
          if pi_password is not null then
            l_salt := sta_app_security.f_generate_salt;
          end if;
          
          update sta_user
          set first_name    = pi_first_name
            , last_name     = pi_last_name
            , address1      = pi_address1
            , address2      = pi_address2
            , phone_number1 = pi_phone_number1
            , phone_number2 = pi_phone_number2
            , email         = pi_email
            , password      = case when pi_password is null 
                                then password else sta_app_security.f_hash_password(pi_password => trim(pi_password), pi_salt => l_salt)
                              end
            , salt          = case when pi_password is null 
                                then salt else l_salt
                              end
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



          delete from sta_user_role
          where usr_id = l_tchr_id
          and rle_id   =  sta_rle.f_get_rle_id(pi_name => 'admin');

          if pi_is_admin then

            insert into sta_user_role
            ( usr_id
            , rle_id
            )values(
              l_tchr_id
            , sta_rle.f_get_rle_id(pi_name => 'admin')
            );
          end if;
        end if;
      end p_upsert_tchr;

      procedure upsert_remarks( pi_usr_id  sta_user.id%type
                             ,  pi_remarks clob 
                                )
       is
          l_remarks_count number;
          l_remarks_id    sta_student_remark.id%type;
          l_remarks_name  sta_student_remark.remark%type;
       begin
        -- Debug
        apex_debug.message(gc_package       || 'upsert_remarks');
        apex_debug.message('pi_usr_id => '  || pi_usr_id);
        -- Parse the JSON
        apex_json.parse(pi_remarks);
                    
        l_remarks_count := apex_json.get_count('remarks');
        for i in 1 .. l_remarks_count loop
          l_remarks_id   := apex_json.get_varchar2(p_path => 'remarks[%d].id', p0 => i);
          l_remarks_name := apex_json.get_varchar2(p_path => 'remarks[%d].name', p0 => i);

          -- Skip processing if both ID and Name are null
          -- I have heard before that using continue is a bad practice but this seems like the easiest way to skip iterations lmfao
          if l_remarks_id is null and l_remarks_name is null then
              continue;
          end if;


          merge into sta_student_remark a
          using (
                  select l_remarks_id   as id
                  ,      pi_usr_id      as usr_id     
                  ,      l_remarks_name as remark 
                  from   dual) b 
          on (a.id = b.id)
          when matched then
            update set a.remark = b.remark
          when not matched then
            insert (id, usr_id, remark) values (b.id, b.usr_id ,b.remark);
        
        end loop;               
      end upsert_remarks;

      procedure delete_single_remark(p_remark_id sta_student_remark.id%type)
      is
      begin
        delete from sta_student_remark
        where id = p_remark_id;
      end delete_single_remark;

    -- Deletes multiple remarks based on a colon seperated string
    -- Used on page 10
      procedure delete_multiple_remarks(p_remarks_to_delete varchar2)
      is
      begin
        for r in (select column_value from table(apex_string.split(p_remarks_to_delete, ':'))) loop
          delete_single_remark(p_remark_id => r.column_value);
        end loop;
      end delete_multiple_remarks;


    procedure p_upsert_stdnt( pi_id                  sta_user.id%type
                            , pi_first_name          sta_user.first_name%type 
                            , pi_last_name           sta_user.last_name%type  
                            , pi_date_of_birth       sta_user.date_of_birth%type  
                            , pi_address1            sta_user.address1%type  
                            , pi_address2            sta_user.address2%type  
                            , pi_ctkr_id             sta_user.ctkr_id%type
                            , pi_remarks             sta_user.remarks%type
                            , pi_remarks2            clob
                            , pi_clss_id             sta_user.clss_id%type
                            , pi_gender              sta_user.gender%type
                            , pi_registration_year   sta_user.registration_year%type
                            , pi_deregistration_year sta_user.deregistration_year%type
                            , pi_origin_school       sta_user.origin_school%type
                            , pi_rle_id              sta_role.id%type
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
          , ctkr_id
          , clss_id
          , remarks
          , gender
          , registration_year
          , deregistration_year
          , origin_school
          )
          values
          (
            pi_first_name
          , pi_last_name
          , pi_date_of_birth
          , pi_address1
          , pi_address2
          , pi_ctkr_id
          , pi_clss_id
          , pi_remarks
          , pi_gender
          , pi_registration_year
          , pi_deregistration_year
          , pi_origin_school
          )
          returning id into l_usr_id;

          upsert_remarks(pi_usr_id => l_usr_id, pi_remarks => pi_remarks2);

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
          set first_name          = pi_first_name
            , last_name           = pi_last_name
            , date_of_birth       = pi_date_of_birth
            , address1            = pi_address1
            , address2            = pi_address2
            , ctkr_id             = pi_ctkr_id
            , remarks             = pi_remarks
            , gender              = pi_gender 
            , registration_year   = pi_registration_year
            , deregistration_year = pi_deregistration_year
            , origin_school       = pi_origin_school
          where id = pi_id;

          upsert_remarks(pi_usr_id => pi_id, pi_remarks => pi_remarks2);

        end if;
      end p_upsert_stdnt;

      procedure p_upsert_ctkr( pi_id            sta_user.id%type
                             , pi_first_name    sta_user.first_name%type
                             , pi_last_name     sta_user.last_name%type
                             , pi_address1      sta_user.address1%type
                             , pi_address2      sta_user.address2%type
                             , pi_phone_number1 sta_user.phone_number1%type  
                             , pi_phone_number2 sta_user.phone_number2%type 
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
          )
          values
          (
            pi_first_name
          , pi_last_name
          , pi_address1
          , pi_address2
          , pi_phone_number1
          , pi_phone_number2
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
          where id = pi_id;

        end if;
      end p_upsert_ctkr;


    function f_get_user_role(pi_usr_id sta_user.id%type) return r_rle_tab pipelined
      is
        cursor c_get_usr_rle(b_usr_id sta_user.id%type)
        is
          select  usr_rle.rle_id
          from    sta_user      usr
          join    sta_user_role usr_rle on usr_rle.usr_id = usr.id
          where   usr.id = b_usr_id;
        
        l_result_rec t_rle_rec;
      begin 
      open c_get_usr_rle(b_usr_id => pi_usr_id);
        loop
          fetch c_get_usr_rle into l_result_rec;
          exit when c_get_usr_rle%notfound;
          --
          pipe row ( l_result_rec );
        end loop;
        close  c_get_usr_rle;
      exception
        when others then
          close c_get_usr_rle;
          raise;
      end f_get_user_role;

    
    procedure p_hard_delete_tchr(pi_id sta_user.id%type)
    is
      cursor c_tchr_chk(b_id sta_user.id%type)
      is
        select 1 from sta_vw_teacher
        where  id = b_id
        ;
    begin
      open c_tchr_chk(b_id => pi_id);
      if c_tchr_chk%notfound
      then
      close c_tchr_chk;
        raise_application_error(-20001, 'Teacher not found');
      end if;

      --fk
      delete from sta_course_teacher
      where  usr_id = pi_id
      ;

      -- fk
      delete from sta_user_role
      where  usr_id = pi_id
      ;

      -- so that fk constraint does not fire(this column is obv nullable, a class doesnt need a teacher to exist ig)
      update sta_class
      set    usr_id = null
      where  usr_id = pi_id
      ;

      -- Actual Delete 
      delete from sta_user
      where  id = pi_id
      ;

    end p_hard_delete_tchr;


    -- WIP
    procedure p_hard_delete_sdnt(pi_id sta_user.id%type)
    is
    begin
      delete from sta_user_role where usr_id = pi_id;
      delete from sta_user where id = pi_id;
    end;

    

    procedure p_soft_delete_usr(pi_id sta_user.id%type)
    is
    begin
      update sta_user
      set deleted_flg = true
      where id = pi_id;
    end p_soft_delete_usr;




    end sta_usr;