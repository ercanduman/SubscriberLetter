CREATE OR REPLACE PACKAGE BODY i2i_train.SubscriberLetter IS
	/**************************************************************************************
  * Purpose    : Her  abonenin doðum günü tarihinde, aboneye “iyiki doðdun” mektubu iletilmesi için gerekli abonelerin belirlenmesi 
                 ve mektup içeriði oluþturularak file yazýlmasý
  * -------------------------------------------------------------------------------------
  * History    :
   | Author        | Date                 | Purpose
   |-------        |-----------           |----------------------------------------------
   | Ercan Duman   | 08-Sept-2017         | Package creation.
  **************************************************************************************/

	TYPE t_Person IS RECORD(
		first_name subscribers.first_name%TYPE,
		last_name  subscribers.first_name%TYPE,
		birthdate  subscribers.birthdate%TYPE,
		msisdn     subscribers.msisdn%TYPE,
		address    subscribers.address%TYPE);

	TYPE t_TypeList IS TABLE OF t_Person;
	gt_SubscriberList t_TypeList;

	gs_FileSeparator i2i_train.subscriber_letter_config.file_separator%TYPE;
	gs_LetterData    i2i_train.subscriber_letter_config.letter_data%TYPE;
	gn_DayOffset     i2i_train.subscriber_letter_config.day_offset%TYPE;
	gs_FileAppendix  i2i_train.subscriber_letter_config.file_appendix%TYPE;

	PROCEDURE LoadGlobalConfigurations IS
	BEGIN
	
		SELECT file_separator, letter_data, day_offset, file_appendix
			INTO gs_FileSeparator, gs_LetterData, gn_DayOffset, gs_FileAppendix
			FROM i2i_train.subscriber_letter_config;
	
		dbms_output.put_line('INFO> gn_DayOffset: ' || gn_DayOffset);
	
	END LoadGlobalConfigurations;

	PROCEDURE i_SubscriberLetterLog(pis_LogData   IN OUT VARCHAR,
																	pis_LogMsisdn IN OUT i2i_train.subscriber_letter_log.msisdn%TYPE) IS
	BEGIN
		-- Insert all retrieved subsribers into log table
		INSERT INTO i2i_train.subscriber_letter_log
			(msisdn, isLetterSent, letter_sent_time, letter_text)
		VALUES
			(pis_LogMsisdn,
			 'X',
			 SYSDATE,
			 SUBSTR(pis_LogData, 4, LENGTH(pis_LogData)));
		COMMIT;
	
	END i_SubscriberLetterLog;

	PROCEDURE i_SubscriberWaLog(pid_ProcessStartDate IN i2i_train.subscriber_letter_wa_log.process_start_date%TYPE,
															pis_ProcessStatus    IN i2i_train.subscriber_letter_wa_log.status%TYPE,
															pis_ProcessRemark    IN i2i_train.subscriber_letter_wa_log.remark%TYPE,
															pin_SubscriberCount  IN i2i_train.subscriber_letter_wa_log.processed_subscriber_num%TYPE) IS
	BEGIN
		-- Insert the execution logs into WA log table
		INSERT INTO i2i_train.subscriber_letter_WA_log
			(log_id,
			 process_start_date,
			 process_end_date,
			 processed_subscriber_num,
			 status,
			 remark)
		VALUES
			(i2i_train.seq_subscriber_wa_id.nextval,
			 pid_ProcessStartDate,
			 SYSDATE,
			 pin_SubscriberCount,
			 pis_ProcessStatus,
			 'Procedure run successfully! ' || pis_ProcessRemark);
		COMMIT;
	
	END i_SubscriberWaLog;

	PROCEDURE GetSubscribers IS
	BEGIN
		gt_SubscriberList := t_TypeList();
	
		-- find all subscribers who has upcoming birthday in given days (gn_DayOffset)                   
		SELECT first_name, last_name, birthdate, msisdn, address
			BULK COLLECT
			INTO gt_SubscriberList
			FROM subscribers
		 WHERE to_char(BIRTHDATE, 'DDMM') =
					 to_char(SYSDATE + gn_DayOffset, 'DDMM');
	END GetSubscribers;

	PROCEDURE WriteData2File IS
	
		-- UTL_FILE variable
		vf_OutputFile UTL_FILE.FILE_TYPE;
	
		-- file name variable
		cs_Today VARCHAR(15);
	
		-- wa_log variables
		vd_ProcStartDate   DATE;
		vs_ProcStatus      VARCHAR(1) := 'S';
		vs_ProcRemark      VARCHAR(1000);
		vn_SubscriberCount NUMBER := 0;
	
		vs_LetterData VARCHAR(4000);
	
		NO_SUBS_FOUND EXCEPTION;
	BEGIN
		vd_ProcStartDate := SYSDATE;
	
		cs_Today := to_char(SYSDATE, 'DDMMYYYY');
	
		BEGIN
		
			GetSubscribers;
		
			-- If no subscriber found raise an error
			IF gt_SubscriberList.count = 0
			THEN
				RAISE NO_SUBS_FOUND;
			ELSE
				vn_SubscriberCount := gt_SubscriberList.count;
			END IF;
		
		EXCEPTION
			WHEN NO_SUBS_FOUND THEN
				vs_ProcStatus := 'F';
				vs_ProcRemark := 'No Subscriber has a birthday in next ' ||
												 gn_DayOffset ||
												 ' days. Please try another day to check! ';
			
			WHEN OTHERS THEN
				vs_ProcStatus := 'F';
				vs_ProcRemark := 'ERROR> An error occurred when retrieving subscribers from i2i_train.subscribers table! ';
				raise_application_error(-20001,
																vs_ProcRemark ||
																dbms_utility.format_error_backtrace ||
																SQLERRM);
			
		END;
	
		BEGIN
			-- Generate file name and open it
			vf_OutputFile := UTL_FILE.FOPEN('CTEST',
																			cs_Today || gs_FileAppendix,
																			'W');
		
		EXCEPTION
			WHEN OTHERS THEN
				vs_ProcStatus := 'F';
				vs_ProcRemark := 'ERROR> Cannot open file, please check privileges for user ' || USER || '! ';
				raise_application_error(-20001,
																vs_ProcRemark ||
																dbms_utility.format_error_backtrace ||
																SQLERRM);
		END;
	
		FOR i IN 1 .. gt_SubscriberList.count
		LOOP
		
			-- Create whole message text
			vs_LetterData := i || '. ' || gt_SubscriberList(i).msisdn ||
											 gs_FileSeparator || gt_SubscriberList(i).address ||
											 gs_FileSeparator || gt_SubscriberList(i).first_name || ' ' || gt_SubscriberList(i)
											.last_name || gs_FileSeparator ||
											 trunc((SYSDATE - gt_SubscriberList(i).birthdate) /
														 365.25) || gs_LetterData;
		
			i_SubscriberLetterLog(vs_LetterData, gt_SubscriberList(i).msisdn);
		
			-- Write data to file                       
			UTL_FILE.PUT_LINE(vf_OutputFile, vs_LetterData);
		
		END LOOP;
	
		-- Close the opened file after finish
		UTL_FILE.FCLOSE(vf_OutputFile);
	
		i_SubscriberWaLog(vd_ProcStartDate,
											vs_ProcStatus,
											vs_ProcRemark,
											vn_SubscriberCount);
	
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20001,
															'ERROR> An error occured... ' ||
															dbms_utility.format_error_backtrace ||
															SQLERRM);
		
	END WriteData2File;

	PROCEDURE StartToProcess IS
	BEGIN
		LoadGlobalConfigurations;
	
		WriteData2File;
	
		dbms_output.put_line('INFO> Run successfully!');
	END;

END SubscriberLetter;
/
