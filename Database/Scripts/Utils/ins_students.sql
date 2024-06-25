declare
   l_remarks_tab sta_usr.t_usr_rmk_tab := sta_usr.t_usr_rmk_tab();
begin
    for i in 1..5 loop
    sta_usr.p_upsert_stdnt( pi_id                 => null
                        , pi_first_name           => 'Sameer 2024/2025'
                        , pi_last_name            => 'Number: ' || i
                        , pi_date_of_birth        => to_date('10-03-2002', 'dd-mm-yyyy')
                        , pi_address1             => 'Anamoesstraat ' || i
                        , pi_address2             => null
                        , pi_ctkr_id              => 661
                        , pi_remarks              => l_remarks_tab
                        , pi_clss_id              => 242
                        , pi_in_schoolyear        => '2024/2025'
                        , pi_gender               => 'M'
                        , pi_registration_year    => '2023/2024'
                        , pi_deregistration_year  => null
                        , pi_origin_school        => null
                        , pi_rle_id               => sta_rle.f_get_rle_id('student')
                        );
    end loop;
end;
/


select  *
from    sta_class;