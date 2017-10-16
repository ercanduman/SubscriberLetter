-- configuration table
create table i2i_train.subscriber_letter_config (
  file_separator varchar2(5),
  letter_data varchar2(200), 
  day_offset number,
  file_appendix varchar (20)
);

--table comment
comment on table i2i_train.subscriber_letter_config is 'Configuration table stores all values fýr running procedure';

--column comments
comment on column i2i_train.subscriber_letter_config.file_separator is 'file_separator attribute defines the character value that wanted to put between text of message.';
comment on column i2i_train.subscriber_letter_config.letter_data is 'letter_data attribute defines the greeting message that wanted to add after age.';
comment on column i2i_train.subscriber_letter_config.day_offset is 'day_offset attribute defines the days wanted to check for upcoming birthdays.';
comment on column i2i_train.subscriber_letter_config.file_appendix is 'file_appendix attribute defines the extra text which will be added to end of created file (i.e. 20092017_mektup.txt -> _mektup.txt is the appendix part )';


