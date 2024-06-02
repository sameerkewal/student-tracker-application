-- Start spooling
SPOOL my_output_file.log

-- Your SQL script files
@STA_ANNOUNCEMENT.sql
@STA_AUTHORIZATION.sql
@STA_PRIVILEGE.sql
@STA_AUTHORIZATION_PRIVILEGE.sql
@STA_GRADE.sql
@STA_COURSE.sql
@STA_CLASS.sql
@STA_COURSE_GRADE.sql
@STA_ROLE.sql
@STA_ROLE_PRIVILEGE.sql
@STA_SEMESTER.sql
@STA_SYSTEM_PARAMETER.sql
@STA_TEST.sql
@STA_USER.sql
@STA_COURSE_CLASS_TEACHER.sql
@STA_STUDENT_REMARK.sql
@STA_STUDENT_TEST.sql
@STA_USER_ROLE.sql

-- Stop spooling
SPOOL OFF