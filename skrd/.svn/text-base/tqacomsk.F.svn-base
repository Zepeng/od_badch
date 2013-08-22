************************************************************************
*     -------------------------------------
      SUBROUTINE TQACOM()
*     -------------------------------------
*
*     (Purpose)
*        Fill /SKQA/,/SKTA/ commons from /SKTQAZ/
*
*     (Input)
*        none
*
*     (Output)
*       
*     (Return)
*       
*
*     (Creation Date and Author)
*       1996.03.31	Created, J.Flanagan
*     
************************************************************************

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"

      integer i

      
      DO 10 I=1,NHIT0

         ICAB = MOD(ICABBF(I), 2**16)

         IF(BTEST(ISKBIT,31-25).AND.IBAD(ICAB).NE.0) GOTO 10

         NQISK = NQISK + 1
         IHCAB(NQISK)   = ICAB

         IAB(ICAB)  = ICABBF(I)/2**16 + 1
         TISK(ICAB) = TBUF(I)
         QISK(ICAB) = QBUF(I)

         IF(QISK(ICAB).GE.DTHRSK) QISMSK = QISMSK+QISK(ICAB)
         IF(QISK(ICAB).GT.QIMXSK) THEN
            QIMXSK = QISK(ICAB)
            MXQISK = ICAB
         END IF
         IF(TISK(ICAB).LT.TIMNSK) THEN
            TIMNSK = TISK(ICAB)
            MNTISK = ICAB
         END IF
         IF(TISK(ICAB).GT.TIMXSK) THEN
            TIMXSK = TISK(ICAB)
            MXTISK = ICAB
         END IF   

 10   CONTINUE

      return
      end
