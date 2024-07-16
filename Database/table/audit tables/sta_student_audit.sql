create table sta_student_audit
(
    voornaam              varchar2(4000),
    achternaam            varchar2(4000),
    geboortedaum          date,
    hoofd_adres           varchar2(4000),
    alternatief_adres     varchar2(4000),
    klas                  varchar2(4000),
    in_schooljaar         varchar2(4000),
    ouder                 varchar2(4000),
    geslacht              varchar2(4000),
    geslaagd              varchar2(4000),
    jaar_van_inschrijving varchar2(4000),
    jaar_van_afschrijving varchar2(4000),
    school_van_afkomst    varchar2(4000),
    actie                 varchar2(20),
    actie_datum           date,
    gedaan_door           varchar2(4000)
);