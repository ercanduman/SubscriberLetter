create table i2i_train.subscribers (
    subscriber_id number primary key,
    first_name varchar2(50) not null, 
    last_name varchar2(50),      
    birthdate date not null,
    msisdn varchar(13),
    address varchar2(100)
);

--table comment
comment on table i2i_train.subscribers is 'Subscriber table stores all subscribers information such as first name, last name, birthdate, phone number(msisdn) and address.';

--column comments
comment on column i2i_train.subscribers.subscriber_id is 'subscriber_id attribute defines unique identifier of subscriber.';
comment on column i2i_train.subscribers.first_name is 'first_name attribute defines first name of subscriber.';
comment on column i2i_train.subscribers.last_name is 'last_name attribute defines last name of subscriber.';
comment on column i2i_train.subscribers.birthdate is 'birthdate attribute defines the birth date of subscriber, in format of DD/MM/YYYY';
comment on column i2i_train.subscribers.msisdn is 'msisdn attribute defines the phone number (msisdn) of subscriber.';
comment on column i2i_train.subscribers.address is 'address attribute defines the address details of subscriber.';

--index
create index i2i_train.i_subscriber_birthdate on subscribers(birthdate);

--instead of writing subscriber_id values one by one, a sequence created
CREATE sequence i2i_train.seq_subs_id start with 1 increment by 1 cache 100 order nocycle;


