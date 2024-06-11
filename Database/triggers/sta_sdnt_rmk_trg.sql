create or replace trigger sta_sdnt_rmk_trg
before insert or update
on sta_student_remark
referencing for each row
begin

  if inserting then :new.created_date := sysdate;
    :new.created_by := coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user);
    :new.modified_date := sysdate;
    :new.modified_by := coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user);
  elsif updating then
 -- set values
    :new.modified_date := sysdate;
    :new.modified_by := coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user);
  end if;
end sta_sdnt_rmk_trg;
/