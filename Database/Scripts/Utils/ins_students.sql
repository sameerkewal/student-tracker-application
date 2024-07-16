DECLARE
    TYPE name_gender_rec IS RECORD (
        first_name VARCHAR2(50),
        last_name  VARCHAR2(50),
        gender     CHAR(1)
    );
    TYPE name_gender_tab IS TABLE OF name_gender_rec INDEX BY PLS_INTEGER;
   l_remarks_tab sta_usr.t_usr_rmk_tab := sta_usr.t_usr_rmk_tab();


    l_names name_gender_tab := name_gender_tab();

    l_random_gender CHAR(1);
BEGIN
    -- Predefined names and genders
    l_names(1) := name_gender_rec('John', 'Doe', NULL);
    l_names(2) := name_gender_rec('Sarah', 'Lee', NULL);
    l_names(3) := name_gender_rec('Lily', 'Ki', NULL);
    l_names(4) := name_gender_rec('Jasmine', 'De Vries', NULL);
    l_names(5) := name_gender_rec('Shane', 'Doe', NULL);
    l_names(6) := name_gender_rec('Taylor', 'Carpenter', NULL);
    l_names(7) := name_gender_rec('Sabrina', 'Swift', NULL);
    l_names(8) := name_gender_rec('Mickey', 'Mouse', NULL);
    l_names(9) := name_gender_rec('Donald', 'Duck', NULL);
    l_names(10) := name_gender_rec('Goofy', 'Dog', NULL);

    FOR i IN 1..10 LOOP
        -- Generate random gender
        IF DBMS_RANDOM.VALUE(0, 1) < 0.5 THEN
            l_random_gender := 'M';
        ELSE
            l_random_gender := 'F';
        END IF;

        -- Update the gender in the record
        l_names(i).gender := l_random_gender;

        -- Call the procedure
        sta_usr.p_upsert_stdnt(
            pi_id                => NULL,
            pi_first_name        => l_names(i).first_name,
            pi_last_name         => l_names(i).last_name,
            pi_date_of_birth     => TO_DATE('10-03-2002', 'DD-MM-YYYY'),
            pi_address1          => 'Anamoesstraat ' || TO_CHAR(i),
            pi_address2          => NULL,
            pi_ctkr_id           => 162,
            pi_remarks           => l_remarks_tab,
            pi_clss_id           => 28,
            pi_in_schoolyear     => '2023/2024',
            pi_gender            => l_names(i).gender,
            pi_registration_year => '2023/2024',
            pi_deregistration_year => NULL,
            pi_origin_school     => NULL,
            pi_rle_id            => sta_rle.f_get_rle_id('student'),
            pi_graduated_flg     => 'N'
        );
    END LOOP;
END;

;