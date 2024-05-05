CREATE OR REPLACE EDITIONABLE PACKAGE BODY "TEST" test
is
    procedure (pi_id number)
    is
    begin
        delete from sta_announcements where id = pi_id;
    end;
end test;
/