************************************************************************
*     -------------------------------------
      SUBROUTINE SKMKHEADA
*     -------------------------------------
*
*     (Purpose)
*        Make 'HEADA' bank
*
*     (Creation Date and Author)
*       1995.11.04 ; First version by Y.Koshio
*
************************************************************************

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"

      DIMENSION ICABBF(MAXPM), TBUF(MAXPM), QBUF(MAXPM)
* Header size of segment number 0 of HEADA bank
      PARAMETER(ISZHD=1) 
      DIMENSION ITQRHD(ISZHD)

#include "zbs.h"
      INTEGER IBUFF(3,MAXPM)
      REAL    RBUFF(3,MAXPM)
      EQUIVALENCE (IBUFF(1,1),RBUFF(1,1))

      NENT = 0
      DO 10 I=1,MAXPM
        IF (IAB(I).EQ.1) THEN
           NENT = NENT + 1
           if(nrunsk.le.244) then
              ICABBF(NENT) = I
              TBUF(NENT) = TISK(I)
              QBUF(NENT) = QISK(I)
           else
              IBUFF(1,NENT) = I
              RBUFF(2,NENT) = TISK(I)
              RBUFF(3,NENT) = QISK(I)
           endif
        ELSE IF(IAB(I).EQ.2) THEN
           NENT = NENT + 1
           if(nrunsk.le.244) then
              ICABBF(NENT) = 2**16 + I
              TBUF(NENT) = TISK(I)
              QBUF(NENT) = QISK(I)
           else
              IBUFF(1,NENT) = 2**16 + I
              RBUFF(2,NENT) = TISK(I)
              RBUFF(3,NENT) = QISK(I)
           endif
        END IF
 10   CONTINUE

* Create HEADA bank and fill data

      ITQRHD(1) = NENT
      if(nrunsk.le.244) then
         CALL KZBCR0('HEADA', IERR)
         CALL KZREP0('HEADA', 0, 'I', ISZHD, ITQRHD)
         IF (NENT.NE.0) THEN
            CALL KZREP0('HEADA', 1, 'I', NENT, ICABBF)
            CALL KZREP0('HEADA', 2, 'F', NENT, TBUF)
            CALL KZREP0('HEADA', 3, 'F', NENT, QBUF)
         END IF
      else
         CALL KZBCR1('HEADA',ISZHD,'1I',nent,3,'1I 2I',IERR) 
         CALL KZREP1('HEADA',0,ISZHD,ITQRHD)
         IF (NENT.NE.0) THEN
            CALL KZLDAT('HEADA',LDAT)
            nent = 3*nent
            CALL LBFCOPY(IBUFF,IZBS(LDAT+ISZHD+1),nent)
         END IF
      endif
      
      RETURN
      END
