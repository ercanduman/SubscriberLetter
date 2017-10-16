--spec
CREATE OR REPLACE PACKAGE i2i_train.SubscriberLetter IS

	/**************************************************************************************
  * Purpose    : Her  abonenin do�um g�n� tarihinde, aboneye �iyiki do�dun� mektubu iletilmesi i�in gerekli abonelerin belirlenmesi 
                 ve mektup i�eri�i olu�turularak file yaz�lmas�
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
