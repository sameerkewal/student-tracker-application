create or replace package body sta_sypa
is
       function f_get_parameter(pi_parameter sta_system_parameter.parameter%type) return sta_system_parameter.value%type
       is
          cursor c_get_parameter(b_parameter sta_system_parameter.parameter%type)
          is
           select value from sta_system_parameter sypa
           where  lower(parameter) = lower(b_parameter);

         l_value sta_system_parameter.value%type;
       begin
           open  c_get_parameter(b_parameter => pi_parameter);
           fetch c_get_parameter into l_value;
           close c_get_parameter;

           return l_value;
       end f_get_parameter;
end sta_sypa;