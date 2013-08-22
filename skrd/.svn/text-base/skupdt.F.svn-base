************************************************************************
*     -----------------
      SUBROUTINE SKUPDT
*     -----------------
*
*     (Purpose)
*        Read data in the banks of current event 
*                         and fill them into commons.
*        (for Not compiling constant file)
*
*     (Input)
*
*     (Output)
*       
*     (Creation Date and Author)
*       1996.01.12 ; First version by Y.Koshio
*
*
************************************************************************

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"

      COMMON /SKOPT/ISKBIT
      COMMON /SKRDLC/ICHK(MAXPM,2)

C --- Read 'HEADER' bank and fill the common /SKHEAD/

      IF(BTEST(ISKBIT,31-31)) THEN
         CALL HEADSK(*995)

C --- Initialization 

         NQISK = 0
         QISMSK = 0.
         QIMXSK = 0.
         TIMNSK = 100000.
         TIMXSK = -100000.
         
         DO 1 I=1,MAXPM
            ICHK(I,1) = 0
            ICHK(I,2) = 0
            QISK(I) = 0.
            TISK(I) = 0.
            IAB(I) = 0
            IQABSK(I,1) = 0
            IQABSK(I,2) = 0
            ITABSK(I,1) = 0
            IQABSK(I,2) = 0
 1       CONTINUE   
         
         IF(BTEST(ISKBIT,31-26)) THEN
            IF(NRUNSK.NE.NRUNPRV) THEN
               CALL SKBADCH(NRUNSK,IERR)
               NRUNPRV=NRUNSK
            ENDIF
         ENDIF

      ELSE
         WRITE(6,*) 'Please set option 31'
         STOP
      ENDIF

C --- Read 'TQ' bank and fill the commons /SKCHNL/

      IF(BTEST(ISKBIT,31-29)) CALL TQSK(*200)

C --- Read 'TQREAL'(if it exist) bank 
C          and fill the data to commons /SKQ/,/SKT/

      IF(BTEST(ISKBIT,31-30)) THEN
         CALL TQREALSK(*100)
         GOTO 200

 100     CONTINUE

         CALL KZBLOC('TQ',IPBANK)
         IF(IPBANK.LE.0) GOTO 200
         
C --- Fill the data to commons /SKQ/,/SKT/ in case NOT exist 'TQREAL' bank

         CALL CMTQSK

C --- Make 'TQREAL' bank

         CALL SKMKTQREAL

C --- Read 'TQA' bank and fill the commons /SKQA/,/SKTA/

      ENDIF

 200  CONTINUE
      CALL TQASK(*997)

C ---

      RETURN

C --- w/o 'HEADER' bank

C --- READ 'PDST' bank and fill the commons /SKPDHD/,/SKTEMP/,/SKPDST/

 995  CONTINUE
      CALL KZBLOC('PDST',IPBANK)
      IF(IPBANK.LE.0) GOTO 998

      RETURN

C --- w/o 'TQ' or 'TQA' bank

 997  CALL MSGOUT
      RETURN

C --- w/o 'HEADER' bank and 'PDST' bank

 998  WRITE(6,*) 'ERORR; There is no HEADER nor PDST bank'
      STOP

      END
