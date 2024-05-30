create unique index sta_smsr_id1
    on sta_semester (lower("NAME"))
/


create unique index sta_smsr_ix2 on sta_semester
    (case when active_ind = true then 1 else null end);