--remove package
DROP PACKAGE i2i_train.subscriber_letter; 

-- remove tables
drop table i2i_train.subscribers;
drop sequence i2i_train.seq_subs_id;
drop table i2i_train.subscriber_letter_config;
drop table  i2i_train.subscriber_letter_log;
drop table i2i_train.subscriber_letter_WA_log;
drop sequence i2i_train.seq_subscriber_wa_id;