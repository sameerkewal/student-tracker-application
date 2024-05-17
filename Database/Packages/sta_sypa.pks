create or replace package sta_sypa
is
       function f_get_parameter(pi_parameter sta_system_parameter.parameter%type) return sta_system_parameter.value%type;
end sta_sypa;