************************************************************************
*     -------------------------------------
      SUBROUTINE SKQCOR
*     -------------------------------------
*
*     (Purpose)
*        Correct q variance depending on t
*        Correct gain difference using Xe calibration results
*        Correct non-linearity of q using laser calibration results
*
*     (Input)
*        none
*
*     (Output)
*        none
*       
*     (Creation Date and Author)
*       1998. 9. 6 ; First version by Y.Koshio
*       2000. 8. 24; non-linearity correction was added by M.Shiozawa
*       2000.10. 5 ; New gain table by Xe was added by M.Shiozawa
*       2003. 4. 22; Main part is moved to skqcorcab.F and this skqcor.F
*                    is modified to call skqcorcab for all cables.
*                    by M.Shiozawa
*     
************************************************************************

      IMPLICIT NONE

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"
#include "sktabl.h"

      INTEGER I,ICAB
      Real corqisk

      QISMSK =0.
      QIMXSK =0.
      DO 10 I=1,NQISK
         ICAB = IHCAB(I)
         Call skqcorcab(icab,tisk(icab),qisk(icab),corqisk)
         qisk(icab) = corqisk

         IF(QISK(ICAB).GE.0     ) QISMSK = QISMSK+QISK(ICAB)
         IF(QISK(ICAB).GT.QIMXSK) THEN
            QIMXSK = QISK(ICAB)
            MXQISK = ICAB
         END IF

 10   CONTINUE

      RETURN
      END
