--spec
CREATE OR REPLACE PACKAGE i2i_train.SubscriberLetter IS

	/**************************************************************************************
  * Purpose    : Her  abonenin doðum günü tarihinde, aboneye “iyiki doðdun” mektubu iletilmesi için gerekli abonelerin belirlenmesi 
                 ve mektup içeriði oluþturularak file yazýlmasý
  * Notes      : 
  * -------------------------------------------------------------------------------------
  * History    :
   | Author        | Date                 | Purpose
   |-------        |-----------           |----------------------------------------------
   | Ercan Duman   | 08-Sept-2017         | Package creation.
  **************************************************************************************/

	PROCEDURE StartToProcess;

END SubscriberLetter;
/
