create unique index sta.sta_smsr_id1
    on sta.sta_semester (lower("NAME"))
/

create unique index sta.sta_smsr_ix2
    on sta.sta_semester (case "ACTIVE_IND" when 'Y' then 1 else null end)
/
