SELECT * FROM subscribers a;
SELECT * FROM i2i_train.subscriber_letter_config a;
SELECT * FROM i2i_train.subscriber_letter_log;
SELECT * FROM subscriber_letter_WA_log;


-- change variables on config table to check the difference
SELECT rowid, a.* FROM subscribers a;
SELECT rowid, a.* FROM i2i_train.subscriber_letter_config a;


