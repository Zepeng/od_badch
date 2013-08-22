************************************************************************
*     -------------------------------------
      SUBROUTINE TQVREALSK(*)
*     -------------------------------------
*
*     (Purpose)
*        Read 'VETO' bank and fill the commons /SKTV/,/SKQV/,/SKCHNLV/
*
*     (Input)
*        none
*
*     (Output)
*       
*     (Return)
*        Return 1 ; Data w/o 'VETO' bank
*       
*
*     (Creation Date and Author)
* 	1997.3.  J.Kameda
*     
************************************************************************

      IMPLICIT NONE

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"
#include "skbadc.h"
#include "skveto.h"

      INTEGER ISKBIT
      COMMON /SKOPT/ISKBIT

      INTEGER MAXVETO
      PARAMETER(MAXVETO=12000-MAXPM)

      INTEGER IPBANK,NDATA,NENT,I,LDAT

      INTEGER ICABBF(MAXVETO),ICAB
      REAL TBUF(MAXVETO), QBUF(MAXVETO)

      INTEGER IBUF(10)
      REAL RBUF(10)
      EQUIVALENCE(IBUF,RBUF)

      INTEGER NHIT0

#include "zbs.h"
      INTEGER IBUFF(3,MAXVETO)
      REAL    RBUFF(3,MAXVETO)
      EQUIVALENCE (IBUFF(1,1),RBUFF(1,1))

      INTEGER IFMOD
      REAL CONVF
C ---

      CALL KZBLOC('VETO',IPBANK)
      IF(IPBANK.LE.0) GOTO 999

         CALL KZGET1('VETO',0,NDATA,IBUF)
         
      NHIT0 = IBUF(1)
      CONVF = 1.

C ---


         IF (NHIT0.NE.0) THEN

            CALL KZLDAT('VETO',LDAT)
            nent = 3*NHIT0
            CALL LBFCOPY(IZBS(LDAT+NDATA+1),ibuff,nent)
         END IF
         do 888 i=1,NHIT0
            icabbf(i)=ibuff(1,i)
            tbuf(i)=rbuff(2,i)
            qbuf(i)=rbuff(3,i)
  
 888     continue


      NQVSK = 0
      QVSMSK =0.
      DO 10 I=1,NHIT0

         ICAB = MOD(ICABBF(I), 2**16)

c         IF(BTEST(ISKBIT,31-25).AND.IBAD(ICAB).NE.0) GOTO 10


         NQVSK = NQVSK + 1
         IHCABV(NQVSK)   = ICAB

         IABV(ICAB)  = ICABBF(I)/2**16 + 1
         TVSK(ICAB) = TBUF(I)
         QVSK(ICAB) = QBUF(I)/CONVF

         IF(QVSK(ICAB).GE.DTHRSK) QVSMSK = QVSMSK+QVSK(ICAB)
         IF(QVSK(ICAB).GT.QVMXSK) THEN
            QVMXSK = QVSK(ICAB)
            MXQVSK = ICAB
         END IF
         IF(TVSK(ICAB).LT.TVMNSK) THEN
            TVMNSK = TVSK(ICAB)
            MNTVSK = ICAB
         END IF
         IF(TVSK(ICAB).GT.TVMXSK) THEN
            TVMXSK = TVSK(ICAB)
            MXTVSK = ICAB
         END IF   
 10   CONTINUE

C ---

      RETURN

C --- w/o 'VETO' bank

 999  Continue

C ---    print *,'No Veto bank'

      RETURN 1

      END





