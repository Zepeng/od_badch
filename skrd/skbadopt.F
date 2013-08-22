************************************************************************
*     -------------------------------------
      SUBROUTINE SKBADOPT(IMASK)
*     -------------------------------------
*
*     (Purpose)
*        Set read out option for badch()
*
*     (Input)
*        IMASK ; what kind of badch are masked (for badch.XXXXXX)
*                  -1: mask only "badch.00*"
*                   0: mask all badch
*                2**0: use  only "badch.dat"
*                2**1: mask criterion 1  inner dead 1
*                2**2: mask criterion 2  inner dead 2
*                2**3: mask criterion 3  inner noisy
*                2**4: mask criterion 4  outer 
*
*     (Output)
*
*     (Creation Date and Author)
*       1996.05.25 : First version by Y.Takeuchi
*       1996.08.07 ; modified by Y. Takeuchi
*           o add outer detector comments
*       1996.12.18 ; modified by Y. Takeuchi
*           o add comment for IMASK = -1
*
************************************************************************
      IMPLICIT NONE

#include "skparm.h"
#include "skbadc.h"

      INTEGER IMASK

      IMASKBADOPT = IMASK

      RETURN
      END
