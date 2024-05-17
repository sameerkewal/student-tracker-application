create or replace package sta_git
is
    --global variables

    function f_get_all_repos return varchar2;
    end sta_git;