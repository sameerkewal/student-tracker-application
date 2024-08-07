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

  function f_get_usr_id_by_email(pi_email sta_user.email%type) return sta_user.id%type
  is
      l_usr_id sta_user.id%type;
      cursor c_usr_id(b_email sta_user.email%type)
      is
        select id
        from   sta_user
        where lower(email) = lower(pi_email)
        ;
  begin
      open  c_usr_id(b_email => pi_email);
      fetch c_usr_id into l_usr_id;
      close c_usr_id;

      return l_usr_id;
  end f_get_usr_id_by_email;


  function f_get_name_by_email(pi_email sta_user.email%type) return varchar2
  is
      l_usr_name varchar2(180);
      cursor c_get_name(b_email sta_user.email%type)
      is
      select first_name || ' ' || last_name
      from sta_user
      where lower(email) = lower(b_email);
  begin
      open  c_get_name(b_email => pi_email);
      fetch c_get_name into l_usr_name;
      close c_get_name;
      return l_usr_name;
  end f_get_name_by_email;





  function is_sdnt_uk( pi_id         in sta_user.id%type
                     , pi_first_name in sta_user.first_name%type
                     , pi_last_name  in sta_user.last_name%type
                     , pi_address1   in sta_user.address1%type 
                     )return boolean
  is
    cursor c_uk_student_chk(b_first_name sta_user.first_name%type
                           ,b_last_name  sta_user.last_name%type
                           ,b_address1   sta_user.address1%type
                           ,b_id         sta_user.id%type
                           )
    is
        select  1 
        from    sta_vw_student sdnt
        where   lower(first_name) = lower(b_first_name)
        and     lower(last_name)  = lower(b_last_name)
        and     lower(address1)   = lower(b_address1)
        and     (b_id is null or sdnt.id != b_id);    
    l_rslt_uk_student_chk number;
  begin

     --Unique Student chk
    open c_uk_student_chk(b_first_name  => pi_first_name 
                          ,b_last_name  => pi_last_name
                          ,b_address1   => pi_address1
                          ,b_id         => pi_id
                          );
    fetch c_uk_student_chk into l_rslt_uk_student_chk;
    close c_uk_student_chk;
     if l_rslt_uk_student_chk = 1 then
      return false;
    else
      return true;
    end if;
  end;

    procedure p_log_tchr_action( pi_id                  sta_user.id%type
                               , pi_first_name          sta_user.first_name%type
                               , pi_last_name           sta_user.last_name%type
                               , pi_address1            sta_user.address1%type
                               , pi_address2            sta_user.address2%type
                               , pi_phone_number1       sta_user.phone_number1%type
                               , pi_phone_number2       sta_user.phone_number2%type
                               , pi_email               sta_user.email%type
                               , pi_password            sta_user.password%type
                               , pi_rle_id              sta_role.id%type
                               , pi_is_admin            boolean
                               , pi_crse_clss_tchr_tab  sta_crse_clss_tchr.t_crse_clss_tchr_tab
                               , pi_actie               varchar2
                               )
    is
--         pragma autonomous_transaction;
        cursor c_get_crse(b_id in sta_course.id%type)
        is
            select name
            from   sta_course
            where  id = b_id
        ;

        cursor c_get_clss(b_ids in varchar2)
        is
            select  listagg(name, ', ') within group (order by name asc)
            from    sta_class
            where   id in (select column_value from table(apex_string.split(b_ids, ':')));

        cursor c_crse_clss is
        with w_crse_clss as(
                            select crse.name  as crse_name
                            ,      listagg(clss.name, ', ') within group (order by crse.name) as clsses
                            from   sta_course_class_teacher crse_clss_tchr
                            join   sta_class clss          on crse_clss_tchr.clss_id = clss.id
                            join   sta_course crse         on crse_clss_tchr.crse_id = crse.id
                            where  crse_clss_tchr.usr_id = pi_id
                            group by crse.name
                          )
        select listagg(crse_name || ' - ' || clsses, ' ') within group(order by crse_name asc)
        from w_crse_clss
        ;


        l_crse               varchar2(4000);
        l_clss               varchar2(4000);
        l_crse_clss          varchar2(4000);
        l_tchr               sta_user%rowtype;

    begin
      for i in 1..pi_crse_clss_tchr_tab.count loop
        open  c_get_crse(b_id => pi_crse_clss_tchr_tab(i).crse_id);
        fetch c_get_crse into l_crse;
        close c_get_crse;

        open  c_get_clss(b_ids => pi_crse_clss_tchr_tab(i).classes_ids);
        fetch c_get_clss into l_clss;
        close c_get_clss;

        l_crse_clss := l_crse_clss || chr(13) || l_crse || ' - '|| l_clss;
      end loop;

      if  pi_actie = 'Toegevoegd' then

          insert into sta_teacher_audit
              ( voornaam
              , achternaam
              , hoofd_adres
              , alternatief_adres
              , hoofd_telefoonnummer
              , alternatief_telefoonnummer
              , email
              , is_admin
              , password
              , courses
              , actie
              , actie_datum
              , gedaan_door
              )
          values ( pi_first_name
                 , pi_last_name
                 , pi_address1
                 , pi_address2
                 , pi_phone_number1
                 , pi_phone_number2
                 , pi_email
                 , pi_is_admin
                 , null
                 , l_crse_clss
                 , pi_actie
                 , sysdate
                 , coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user)
                 );
      elsif pi_actie = 'Gewijzigd' then
           open  c_crse_clss;
           fetch c_crse_clss into l_crse_clss;
           close c_crse_clss;

            insert into sta_teacher_audit
              ( voornaam
              , achternaam
              , hoofd_adres
              , alternatief_adres
              , hoofd_telefoonnummer
              , alternatief_telefoonnummer
              , email
              , is_admin
              , password
              , courses
              , actie
              , actie_datum
              , gedaan_door
              )
          values ( pi_first_name
                 , pi_last_name
                 , pi_address1
                 , pi_address2
                 , pi_phone_number1
                 , pi_phone_number2
                 , pi_email
                 , pi_is_admin
                 , null
                 , l_crse_clss
                 , pi_actie
                 , sysdate
                 , coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user)
                 );
      else
           l_tchr := f_get_usr(pi_id);
           open  c_crse_clss;
           fetch c_crse_clss into l_crse_clss;
           close c_crse_clss;

            insert into sta_teacher_audit
              ( voornaam
              , achternaam
              , hoofd_adres
              , alternatief_adres
              , hoofd_telefoonnummer
              , alternatief_telefoonnummer
              , email
              , is_admin
              , password
              , courses
              , actie
              , actie_datum
              , gedaan_door
              )
          values ( l_tchr.first_name
                 , l_tchr.last_name
                 , l_tchr.address1
                 , l_tchr.address2
                 , l_tchr.phone_number1
                 , l_tchr.phone_number2
                 , l_tchr.email
                 , case when sta_rle.check_is_teacher_and_admin(pi_id) = 'TEACHER_ADMIN' then 'TRUE' else 'FALSE' end
                 , null
                 , l_crse_clss
                 , pi_actie
                 , sysdate
                 , coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user)
                 );
      end if;
      commit;
      exception
        when others then
        -- Handle any exceptions here
        rollback;
        raise;
    end p_log_tchr_action;

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
                           , pi_crse_clss_tchr_tab  sta_crse_clss_tchr.t_crse_clss_tchr_tab
                          )
      is
        l_tchr_id  sta_user.id%type := pi_id;        
        l_courses  apex_t_varchar2;
        l_salt     varchar2(64);
      begin
        


          -- DO pw check first
        if l_tchr_id is null then
           if not sta_app_security.f_password_chk(pi_password=> pi_password) then
            return;
           end if;
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
          -- Couple the courses and class with the teacher(teacher === user)
          --
          sta_crse_clss_tchr.upsert_crse_clss_tchr( pi_usr_id             => l_tchr_id
                                                  , pi_crse_clss_tchr_tab => pi_crse_clss_tchr_tab
                                                  );


           p_log_tchr_action(pi_id                => pi_id
                          , pi_first_name         => pi_first_name
                          , pi_last_name          => pi_last_name
                          , pi_address1           => pi_address1
                          , pi_address2           => pi_address2
                          , pi_phone_number1      => pi_phone_number1
                          , pi_phone_number2      => pi_phone_number2
                          , pi_email              => pi_email
                          , pi_password           => pi_password
                          , pi_rle_id             => pi_rle_id
                          , pi_is_admin           => pi_is_admin
                          , pi_crse_clss_tchr_tab => pi_crse_clss_tchr_tab
                          , pi_actie              => 'Toegevoegd'
           );

        else
        --
        -- generate salt but only if password meets requirements
        --
          if  pi_password is not null and sta_app_security.f_password_chk(pi_password => pi_password) then
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
          -- Update sta_course_class_teacher
          sta_crse_clss_tchr.upsert_crse_clss_tchr( pi_usr_id             => l_tchr_id
                                                  , pi_crse_clss_tchr_tab => pi_crse_clss_tchr_tab
                                                  );
          --
          -- Clear current roles first
          delete from sta_user_role
          where usr_id = l_tchr_id
          and rle_id   =  sta_rle.f_get_rle_id(pi_name => 'admin');

          -- Same as insert, teacher can also be an admin
          if pi_is_admin then
            insert into sta_user_role
            ( usr_id
            , rle_id
            )values(
              l_tchr_id
            , sta_rle.f_get_rle_id(pi_name => 'admin')
            );
          end if;

          p_log_tchr_action(pi_id                => pi_id
               , pi_first_name         => pi_first_name
               , pi_last_name          => pi_last_name
               , pi_address1           => pi_address1
               , pi_address2           => pi_address2
               , pi_phone_number1      => pi_phone_number1
               , pi_phone_number2      => pi_phone_number2
               , pi_email              => pi_email
               , pi_password           => pi_password
               , pi_rle_id             => pi_rle_id
               , pi_is_admin           => pi_is_admin
               , pi_crse_clss_tchr_tab => pi_crse_clss_tchr_tab
               , pi_actie              => 'Gewijzigd'
           );
        end if;
      end p_upsert_tchr;

     procedure delete_single_remark(pi_remark_id sta_student_remark.id%type)
     is
     begin
         delete from sta_student_remark
         where id = pi_remark_id;
     end delete_single_remark;

      procedure upsert_remarks( pi_usr_id  sta_user.id%type
                             ,  pi_remarks t_usr_rmk_tab
                                )
       is
       begin
        -- Debug
        apex_debug.message(gc_package       || 'upsert_remarks');
        apex_debug.message('pi_usr_id => '  || pi_usr_id);

        for i in 1..pi_remarks.count loop
            case pi_remarks(i).action
                when 'C' then
                    insert into sta_student_remark (usr_id, remark) values (pi_usr_id, pi_remarks(i).remark);
                when 'U' then
                    update sta_student_remark
                    set usr_id =  pi_usr_id,
                        remark = pi_remarks(i).remark
                    where id = pi_remarks(i).id ;
                when 'D' then
                    delete_single_remark(pi_remark_id => pi_remarks(i).id);
            end case;
        end loop;
      end upsert_remarks;



    -- Deletes multiple remarks based on a colon seperated string
    -- Used on page 10
      procedure delete_multiple_remarks(p_remarks_to_delete varchar2)
      is
      begin
        for r in (select column_value from table(apex_string.split(p_remarks_to_delete, ':'))) loop
          delete_single_remark(pi_remark_id => r.column_value);
        end loop;
      end delete_multiple_remarks;
      
      



    procedure p_upsert_stdnt( pi_id                  sta_user.id%type
                            , pi_first_name          sta_user.first_name%type 
                            , pi_last_name           sta_user.last_name%type  
                            , pi_date_of_birth       sta_user.date_of_birth%type  
                            , pi_address1            sta_user.address1%type  
                            , pi_address2            sta_user.address2%type  
                            , pi_ctkr_id             sta_user.ctkr_id%type
                            , pi_remarks             t_usr_rmk_tab
                            , pi_clss_id             sta_user.clss_id%type
                            , pi_in_schoolyear       sta_user.in_schoolyear%type
                            , pi_gender              sta_user.gender%type
                            , pi_registration_year   sta_user.registration_year%type
                            , pi_deregistration_year sta_user.deregistration_year%type
                            , pi_origin_school       sta_user.origin_school%type
                            , pi_graduated_flg       sta_user.graduated_flg%type
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
          , in_schoolyear
          , gender
          , registration_year
          , deregistration_year
          , origin_school
          , graduated_flg
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
          , pi_in_schoolyear
          , pi_gender
          , pi_registration_year
          , pi_deregistration_year
          , pi_origin_school
          , pi_graduated_flg
          )
          returning id into l_usr_id;

          upsert_remarks(pi_usr_id => l_usr_id, pi_remarks => pi_remarks);

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
            , clss_id             = pi_clss_id
            , in_schoolyear       = pi_in_schoolyear
            , gender              = pi_gender
            , registration_year   = pi_registration_year
            , deregistration_year = pi_deregistration_year
            , origin_school       = pi_origin_school
            , graduated_flg       = pi_graduated_flg
          where id = pi_id;

          upsert_remarks(pi_usr_id => pi_id, pi_remarks => pi_remarks);

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
      delete from sta_course_class_teacher
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
      delete from sta_student_remark where usr_id = pi_id;
      delete from sta_user where id = pi_id;
    end;

    procedure p_hard_delete_ctkr(pi_id sta_user.id%type)
    is
    begin
        delete from sta_user_role where usr_id = pi_id;
        delete from sta_user where id = pi_id;
    end;

    procedure p_soft_delete_tchr(pi_id sta_user.id%type)
    is
        -- Empty so we dont get reference to uninitialized collection error
        l_crse_clss_tchr_tab sta_crse_clss_tchr.t_crse_clss_tchr_tab := sta_crse_clss_tchr.t_crse_clss_tchr_tab();
    begin

      update sta_user
      set deleted_flg = 'Y'
      where id = pi_id;

      p_log_tchr_action(pi_id                => pi_id
                     , pi_first_name         => null
                     , pi_last_name          => null
                     , pi_address1           => null
                     , pi_address2           => null
                     , pi_phone_number1      => null
                     , pi_phone_number2      => null
                     , pi_email              => null
                     , pi_password           => null
                     , pi_rle_id             => null
                     , pi_is_admin           => null
                     , pi_crse_clss_tchr_tab => l_crse_clss_tchr_tab
                     , pi_actie              => 'Verwijderd'
                    );
    end p_soft_delete_tchr;


    --Used For students
    procedure p_soft_delete_usr(pi_id sta_user.id%type)
    is
    begin
      update sta_user
      set deleted_flg = 'Y'
      where id = pi_id;
    end p_soft_delete_usr;




    end sta_usr;