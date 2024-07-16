create or replace trigger sta_student_audit
  after insert or update or delete on sta_user
  for each row
    declare
    cursor c_get_clss
    is
        select name from sta_class where id = nvl(:new.clss_id, :old.clss_id);
    l_clss_name varchar2(4000);

  cursor c_get_ctkr_name
  is
        select first_name || ' ' || last_name from sta_vw_caretaker where id = nvl(:new.ctkr_id, :old.ctkr_id);
  l_ctkr_name varchar2(4000);

l_updated_or_deleted varchar2(20);
  begin

      open  c_get_clss;
      fetch c_get_clss into l_clss_name;
      close c_get_clss;

--       open  c_get_ctkr_name;
--       fetch c_get_ctkr_name into l_ctkr_name;
--       close c_get_ctkr_name;


      apex_debug.message('trg_clss_id ' || nvl(:new.clss_id, :old.clss_id));
      apex_debug.message('trg_ctkr_id ' || nvl(:new.ctkr_id, :old.ctkr_id));
      apex_debug.message('trg_registration_year ' || nvl(:new.registration_year, :old.registration_year));
      apex_debug.message('trg_in_schoolyear ' || nvl(:new.in_schoolyear, :old.in_schoolyear));

      if inserting and nvl(:new.clss_id, :old.clss_id) is not null
                   and nvl(:new.ctkr_id, :old.ctkr_id) is not null
                   and nvl(:new.registration_year, :old.registration_year) is not null
                   and nvl(:new.in_schoolyear, :old.in_schoolyear) is not null then
      insert into sta_student_audit
(
      voornaam           ,
      achternaam         ,
      geboortedaum       ,
      hoofd_adres        ,
      alternatief_adres  ,
      klas               ,
      in_schooljaar      ,
      ouder              ,
      geslacht           ,
      geslaagd           ,
      jaar_van_inschrijving,
      jaar_van_afschrijving,
      school_van_afkomst ,
      actie              ,
      actie_datum        ,
      gedaan_door        
      ) values (
      :new.first_name         ,
      :new.last_name          ,
      :new.date_of_birth      ,
      :new.address1           ,
      :new.address2           ,
      l_clss_name            ,
      :new.in_schoolyear      ,
      :new.ctkr_id            ,
      :new.gender             ,
      :new.graduated_flg      ,
      :new.registration_year  ,
      :new.deregistration_year,
      :new.origin_school      ,
      'Toegevoegd',
      sysdate,
      coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user)
      );
      elsif updating and nvl(:new.clss_id, :old.clss_id) is not null
                   and nvl(:new.ctkr_id, :old.ctkr_id) is not null
                   and nvl(:new.registration_year, :old.registration_year) is not null
                   and nvl(:new.in_schoolyear, :old.in_schoolyear) is not null then
      if :new.deleted_flg = 'Y' then
          l_updated_or_deleted := 'Verwijderd';
      else
          l_updated_or_deleted := 'Gewijzigd';
      end if;
      insert into sta_student_audit
(
      voornaam           ,
      achternaam         ,
      geboortedaum       ,
      hoofd_adres        ,
      alternatief_adres  ,
      klas               ,
      in_schooljaar      ,
      ouder              ,
      geslacht           ,
      geslaagd           ,
      jaar_van_inschrijving,
      jaar_van_afschrijving,
      school_van_afkomst ,
      actie              ,
      actie_datum        ,
      gedaan_door
      ) values (
      :new.first_name         ,
      :new.last_name          ,
      :new.date_of_birth      ,
      :new.address1           ,
      :new.address2           ,
      l_clss_name            ,
      :new.in_schoolyear      ,
      :new.ctkr_id            ,
      :new.gender             ,
      :new.graduated_flg      ,
      :new.registration_year  ,
      :new.deregistration_year,
      :new.origin_school      ,
      l_updated_or_deleted,
      sysdate,
      coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user)
      );
      elsif deleting and nvl(:new.clss_id, :old.clss_id) is not null
                   and nvl(:new.ctkr_id, :old.ctkr_id) is not null
                   and nvl(:new.registration_year, :old.registration_year) is not null
                   and nvl(:new.in_schoolyear, :old.in_schoolyear) is not null then
      insert into sta_student_audit
(
      voornaam           ,
      achternaam         ,
      geboortedaum       ,
      hoofd_adres        ,
      alternatief_adres  ,
      klas               ,
      in_schooljaar      ,
      ouder              ,
      geslacht           ,
      geslaagd           ,
      jaar_van_inschrijving,
      jaar_van_afschrijving,
      school_van_afkomst ,
      actie              ,
      actie_datum        ,
      gedaan_door
      ) values (
      :old.first_name         ,
      :old.last_name          ,
      :old.date_of_birth      ,
      :old.address1           ,
      :old.address2           ,
      l_clss_name            ,
      :old.in_schoolyear      ,
      :old.ctkr_id           ,
      :old.gender             ,
      :old.graduated_flg      ,
      :old.registration_year  ,
      :old.deregistration_year,
      :old.origin_school      ,
      'Verwijderd',
      sysdate,
      coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user)
      );
      end if;
  end;
