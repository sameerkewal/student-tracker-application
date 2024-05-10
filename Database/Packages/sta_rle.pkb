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
    end sta_rle;