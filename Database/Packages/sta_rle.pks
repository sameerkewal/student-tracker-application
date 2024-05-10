create or replace package sta_rle
is
--global variables


    function f_get_rle(pi_id sta_role.id%type)return sta_role%rowtype;

    function f_get_rle_id(pi_name sta_role.name%type)return sta_role.id%type;

    procedure p_add_rle( pi_id sta_role.id%type
                       , pi_name sta_role.name%type
                       , pi_description sta_role.description%type
                       );
    end sta_rle;