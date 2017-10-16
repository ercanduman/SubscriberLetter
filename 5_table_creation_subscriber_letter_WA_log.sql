--wa log table
CREATE table i2i_train.subscriber_letter_WA_log(
                  log_id                 NUMBER NOT NULL primary key,
                  process_start_date     DATE,
                  process_end_date       DATE,
                  processed_subscriber_num    NUMBER,
                  status                 VARCHAR2(1),
                  remark                 VARCHAR2(4000)
                  );
                  
-- table comment
COMMENT ON TABLE i2i_train.subscriber_letter_WA_log IS 'Log table stores log information about procedure execution.';

COMMENT ON column i2i_train.subscriber_letter_WA_log.log_id IS 'log_id attribute defines the unique identifier of subscriber_letter_wa_log'; 
COMMENT ON column i2i_train.subscriber_letter_WA_log.process_start_date IS 'process_start_date attribute stores start date of procedure execution.'; 
COMMENT ON column i2i_train.subscriber_letter_WA_log.process_end_date IS 'process_end_date attribute stores end date of procedure execution..'; 
COMMENT ON column i2i_train.subscriber_letter_WA_log.processed_subscriber_num IS 'processed_subscriber_num attribute defines the number of subscribers handled in execution.';
COMMENT ON column i2i_train.subscriber_letter_WA_log.status IS 'status attribute defines the status of procedure whether it worked successfully (S) or failed (F)'; 
COMMENT ON column i2i_train.subscriber_letter_WA_log.remark IS 'remark attribute defines the result message (remark) of procedure execution.';

--index
CREATE INDEX i2i_train.i_subscriber_wa_log_id ON i2i_train.subscriber_letter_WA_log(log_id);

--instead of writing seq_subscriber_wa_id values one by one, a sequence created
CREATE sequence i2i_train.seq_subscriber_wa_id START WITH 1 increment BY 1 cache 100 ORDER nocycle;
