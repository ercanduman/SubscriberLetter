--log table
CREATE TABLE i2i_train.subscriber_letter_log(
    msisdn    VARCHAR2(13),
    isLetterSent VARCHAR2(1) default null,
    letter_sent_time date,
    letter_text varchar2(500)
);


-- table comment
comment on table i2i_train.subscriber_letter_log is 'Log table stores all values when procedure run.';

-- index
create index i2i_train.i_subscriber_letter_log_msisdn on subscriber_letter_log(msisdn);

--column comments
comment on column i2i_train.subscriber_letter_log.msisdn is 'msisdn attribute defines the phone number (msisdn) of subscriber.';
comment on column i2i_train.subscriber_letter_log.isLetterSent is 'isLetterSent attribute defines the boolean value of whether greeting message sent to subscriber or not.';
comment on column i2i_train.subscriber_letter_log.letter_sent_time is 'letter_sent_time attribute defines the time of greeting message sent.';
comment on column i2i_train.subscriber_letter_log.letter_text is 'letter_text attribute defines the greeting message for sending to subscribers.';
