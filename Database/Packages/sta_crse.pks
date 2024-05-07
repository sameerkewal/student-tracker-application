create or replace package sta_crse
is
    --global variables
      function read_row (p_id in sta_course.id%type /*pk*/ ) return sta_course%rowtype;

    procedure p_upsert_course( pi_id           sta_course.id%type
                             , pi_name         sta_course.name%type
                             , pi_description  sta_course.description%type
                             , pi_grades       varchar2);
    end sta_crse;

