-- Run as sys

create user sta_test identified by sta_test;
grant execute on dbms_crypto to sta_test;