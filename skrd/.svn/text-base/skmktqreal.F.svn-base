************************************************************************
*     -------------------------------------
      SUBROUTINE SKMKTQREAL
*     -------------------------------------
*
*     (Purpose)
*        Make 'TQREAL' bank
*
*     (Creation Date and Author)
*       1995.11.04 ; First version by Y.Koshio
*
************************************************************************

#include "skparm.h"
#include "sktq.h"

      DIMENSION ICABBF(MAXPM), TBUF(MAXPM), QBUF(MAXPM)
* Header size of segment number 0 of TQREAL bank
      PARAMETER(ISZHD=1) 
      DIMENSION ITQRHD(ISZHD)

      NENT = 0
      DO 10 I=1,MAXPM
        IF (IAB(I).EQ.1) THEN
           NENT = NENT + 1
           ICABBF(NENT) = I
           TBUF(NENT) = TISK(I)
           QBUF(NENT) = QISK(I)
        ELSE IF(IAB(I).EQ.2) THEN
           NENT = NENT + 1
           ICABBF(NENT) = 2**16 + I
           TBUF(NENT) = TISK(I)
           QBUF(NENT) = QISK(I)
        END IF
 10   CONTINUE

* Create TQREAL bank and fill data

      CALL KZBCR0('TQREAL', IERR)
      ITQRHD(1) = NENT
      CALL KZREP0('TQREAL', 0, 'I', ISZHD, ITQRHD)
      IF (NENT.NE.0) THEN
         CALL KZREP0('TQREAL', 1, 'I', NENT, ICABBF)
         CALL KZREP0('TQREAL', 2, 'F', NENT, TBUF)
         CALL KZREP0('TQREAL', 3, 'F', NENT, QBUF)
      END IF
      
      RETURN
      END
