create or replace package body sta_rle
is
--global variables


    function f_get_rle(pi_id sta_role.id%type)return sta_role%rowtype
    is
        v_row sta_role%rowtype;
        cursor cur_row is
          select * from sta_role
          where
            id = pi_id;
    begin
        open cur_row;
        fetch cur_row into v_row;
        close cur_row;
        return v_row;
    end f_get_rle;

    function f_get_rle_id(pi_name sta_role.name%type)return sta_role.id%type
    is
      l_id sta_role.id%type;
      cursor cur_row is
        select id from sta_role
        where
        lower(name) = lower(pi_name);
    begin
      open cur_row;
      fetch cur_row into l_id;
      close cur_row;
      return l_id;
    end f_get_rle_id;

    procedure p_add_rle( pi_id sta_role.id%type
                       , pi_name sta_role.name%type
                       , pi_description sta_role.description%type
                       )
    is
    begin
        null;
    end;

    
    function is_tchr_also_admin(pi_id sta_user.id%type)return boolean
    is
        cursor c_tchr_and_admin_chk(b_id sta_user.id%type)
        is
            with w_usr_rle as (
                                select  rle_id,
                                        rle.name
                                from    sta_user_role usr_rle
                                join    sta_role      rle on usr_rle.rle_id = rle.id
                                where   usr_rle.usr_id = b_id
                              )
            select case 
                    when count(case when lower(name) = 'teacher' then 1 end) > 0
                    and  count(case when lower(name) = 'admin' then 1 end) > 0
                    then 'Y' else 'N' end as rslt
            from w_usr_rle;
      l_result varchar2(1);
    begin
      open   c_tchr_and_admin_chk(b_id => pi_id);
      fetch  c_tchr_and_admin_chk into l_result;
      close  c_tchr_and_admin_chk;
      return case when l_result = 'Y' then true else false end;      
    end is_tchr_also_admin;

    function check_is_teacher_and_admin(pi_id sta_user.id%type) return sta_role.name%type
    is
      l_tchr_result varchar2(1) := 'N';
      l_admin_result varchar2(1) := 'N';
    begin
      for r in (select rle_id from table (sta_usr.f_get_user_role(pi_usr_id => pi_id)))
      loop
          if lower(sta_rle.f_get_rle(pi_id => r.rle_id).name) = lower('teacher') then
              l_tchr_result := 'Y';
          end if;

          if lower(sta_rle.f_get_rle(pi_id => r.rle_id).name) = lower('admin') or lower(sta_rle.f_get_rle(pi_id => r.rle_id).name) = lower('Super Admin') then
              l_admin_result := 'Y';
          end if;

          -- dbms_output.put_line('l_tchr_result: ' || l_tchr_result || ' l_admin_result: ' || l_admin_result);
      end loop;

    case 
        when l_tchr_result = 'Y' and l_admin_result = 'Y' then
            return 'TEACHER_ADMIN';
        when l_tchr_result = 'N' and l_admin_result = 'Y' then
            return 'ADMIN';
        when l_tchr_result = 'Y' and l_admin_result = 'N' then
            return 'TEACHER';
        when l_tchr_result = 'N' and l_admin_result = 'N' then
            return 'NEITHER';
        else 
            return 'UNKNOWN';
    end case;
end check_is_teacher_and_admin;

    function check_read_only( pi_username sta_user.email%type
                            , pi_clss_id sta_class.id%type
                            , pi_action varchar2 default null
                            )return boolean
    is
      l_user sta_user%rowtype := sta_usr.f_get_usr_by_email(pi_email => pi_username);
      l_rslt sta_role.name%type  := sta_rle.check_is_teacher_and_admin(pi_id => l_user.id);


    cursor c_chk_clss_tchr(b_usr_id sta_user.email%type, b_clss_id sta_class.id%type)
        is select 1 from sta_vw_student sdnt
        where sdnt.clss_id = (
                               select  clss.id 
                               from    sta_class clss
                               where   clss.id     = b_clss_id
                               and     clss.usr_id = b_usr_id
                            );
    l_cur_rslt number;  
    begin
      case

        -- If we are creating a new user do not restrict anything
        when pi_action = 'I' then
          return false;
        

        when l_rslt = 'ADMIN' or l_rslt = 'TEACHER_ADMIN' then
          return false;
        when l_rslt = 'TEACHER' then
          open c_chk_clss_tchr(b_usr_id => l_user.id, b_clss_id => pi_clss_id);
          fetch c_chk_clss_tchr into l_cur_rslt;
          close c_chk_clss_tchr;

          if l_cur_rslt = 1 then
            return false;
          else
            return true;
          end if;
      end case;
   
  end check_read_only;







end sta_rle;


