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
     if l_rslt_uk_student_chk = 1 then
      return false;
    else
      return true;
    end if;
    close c_uk_student_chk;    
  end;

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
      
      
      procedure p_upsert_sdtnt_wrapper( pi_id                   in  sta_user.id%type                   
                                      , pi_first_name           in  sta_user.first_name%type           
                                      , pi_last_name            in  sta_user.last_name%type            
                                      , pi_date_of_birth        in  sta_user.date_of_birth%type        
                                      , pi_address1             in  sta_user.address1%type             
                                      , pi_address2             in  sta_user.address1%type             
                                      , pi_ctkr_id              in  sta_user.ctkr_id%type              
                                      , pi_remarks              in  sta_user.remarks%type              
                                      , pi_remarks2             in  sta_student_remark.remark%type     
                                      , pi_clss_id              in  sta_user.clss_id%type              
                                      , pi_gender               in  sta_user.gender%type               
                                      , pi_registration_year    in  sta_user.registration_year%type    
                                      , pi_deregistration_year  in  sta_user.deregistration_year%type  
                                      , pi_origin_school        in  sta_user.origin_school%type        
                                      , pi_del_rmk              in  varchar2  
                                      , po_json_obj             out json_object_t                  
    )
    is
        l_json_obj   json_object_t  := json_object_t();
        l_errors_arr json_array_t   := json_array_t();
    begin
        -- Checks
        if pi_first_name is null then
        l_errors_arr.append(new json_object_t('{"msg": "Voornaam mag niet leeg zijn.", "item": "P10_VOORNAAM"}'));
     end if;

     if pi_last_name is null then
        l_errors_arr.append(new json_object_t('{"msg": "Achternaam mag niet leeg zijn.", "item": "P10_ACHTERNAAM"}'));
     end if;
     if pi_date_of_birth is null then
        l_errors_arr.append(new json_object_t('{"msg": "Geboortedatum mag niet leeg zijn.", "item": "P10_GEBOORTEDATUM"}'));
     end if;
     if pi_clss_id is null then
        l_errors_arr.append(new json_object_t('{"msg": "Klas mag niet leeg zijn.", "item": "P10_KLAS"}'));
     end if;
     if pi_gender is null then
        l_errors_arr.append(new json_object_t('{"msg": "Geslacht mag niet leeg zijn.", "item": "P10_GESLACHT"}'));
     end if;
     if pi_address1 is null then
        l_errors_arr.append(new json_object_t('{"msg": "Hoofd adres mag niet leeg zijn.", "item": "P10_HOOFD_ADRES"}'));

     end if;
     if pi_ctkr_id is null then
        l_errors_arr.append(new json_object_t('{"msg": "Ouder/Verzorger mag niet leeg zijn.", "item": "P10_CARETAKER"}'));
     end if;

     if pi_registration_year is null then
        l_errors_arr.append(new json_object_t('{"msg": "Jaar van inschrijving mag niet leeg zijn.", "item": "P10_JAAR_VAN_INSCHRIJVING"}'));
     end if;

     --Unique Student chk
    if is_sdnt_uk( pi_id         => pi_id
                 , pi_first_name => pi_first_name
                 , pi_last_name  => pi_last_name
                 , pi_address1   => pi_address1
                 )  = false then
        l_errors_arr.append(new json_object_t('{"msg": "Er bestaat al een student met het ingevulde naam en hoofdadres. Voer unieke waarden in.", "item": "P10_ACHTERNAAM"}'));
    end if;

    if l_errors_arr.get_size() > 0 then
        -- Return Error
        l_json_obj.put('errors', l_errors_arr);
        po_json_obj := l_json_obj;
    else
        --Actual Insert
        sta_usr.p_upsert_stdnt( pi_id                   => pi_id                 
                              , pi_first_name           => pi_first_name         
                              , pi_last_name            => pi_last_name          
                              , pi_date_of_birth        => pi_date_of_birth      
                              , pi_address1             => pi_address1           
                              , pi_address2             => pi_address2           
                              , pi_ctkr_id              => pi_ctkr_id            
                              , pi_remarks              => null            
                              , pi_clss_id              => pi_clss_id
                              , pi_gender               => pi_gender             
                              , pi_registration_year    => pi_registration_year  
                              , pi_deregistration_year  => pi_deregistration_year
                              , pi_origin_school        => pi_origin_school      
                              , pi_rle_id               => sta_rle.f_get_rle_id('student')
                              );

        --del rmk
        if pi_del_rmk is not null then
            sta_usr.delete_multiple_remarks(p_remarks_to_delete => pi_del_rmk);
        end if;
        

        if pi_id is null then
            -- l_json_obj.put('message', 'Student successvol toegevoegd');
            l_json_obj.put('action', 'I');
        else
            -- l_json_obj.put('message', 'Student successvol gewijzigd');
            l_json_obj.put('action', 'U');

        end if;

        -- Return Success
        po_json_obj := l_json_obj;

    end if;
    end p_upsert_sdtnt_wrapper;


    procedure p_upsert_stdnt( pi_id                  sta_user.id%type
                            , pi_first_name          sta_user.first_name%type 
                            , pi_last_name           sta_user.last_name%type  
                            , pi_date_of_birth       sta_user.date_of_birth%type  
                            , pi_address1            sta_user.address1%type  
                            , pi_address2            sta_user.address2%type  
                            , pi_ctkr_id             sta_user.ctkr_id%type
                            , pi_remarks             t_usr_rmk_tab
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
          , pi_gender
          , pi_registration_year
          , pi_deregistration_year
          , pi_origin_school
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
            , gender              = pi_gender
            , registration_year   = pi_registration_year
            , deregistration_year = pi_deregistration_year
            , origin_school       = pi_origin_school
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

    

    procedure p_soft_delete_usr(pi_id sta_user.id%type)
    is
    begin
      update sta_user
      set deleted_flg = true
      where id = pi_id;
    end p_soft_delete_usr;




    end sta_usr;