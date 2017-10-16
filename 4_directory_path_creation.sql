--writing results to a file with path (works only on sys user) 
CREATE OR REPLACE DIRECTORY CTEST AS 'C:\Users\7380\Desktop\Agile-dosyalar\PLSQL_TRAIN\wa';
GRANT READ ON DIRECTORY CTEST TO PUBLIC;
GRANT EXECUTE ON UTL_FILE TO PUBLIC;
GRANT EXECUTE ON SYS.utl_file TO i2i_train;
GRANT READ, WRITE ON DIRECTORY CTEST TO i2i_train;

--SELECT * FROM all_directories;
