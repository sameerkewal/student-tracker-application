create or replace package sta_error_handler is


function error_handler 
   (p_error in apex_error.t_error
   ) return apex_error.t_error_result
;    


end sta_error_handler;