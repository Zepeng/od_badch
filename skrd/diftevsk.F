************************************************************************
*     ---------------------------------------
      REAL FUNCTION DIFTEVSK(ICLKOLD)
*     ---------------------------------------
*
*     (Purpose)
*       Calc DIFFERETIAL TIME OF EACH EVENT
*
*     (Input)
*       ICLKOLD(3) : OLD 48bit clock
*
*     (Output)
*       DIFTEVSK : Differential time ( n sec )
*      
*     (Creation Date and Author)
*       1996.02.13 ; K.Kaneyuki   
*
*     (Comment)
*
************************************************************************
#include "skhead.h"
      REAL*8 RT48CLK,PRECLK
      INTEGER ICLKOLD(3)

      PRECLK = (DFLOAT(ICLKOLD(3))+DFLOAT(ICLKOLD(2))*6.5536D4
     &     +DFLOAT(ICLKOLD(1))*4.294967296D9)*2.0D1

      RT48CLK = (DFLOAT(NT48SK(3))+DFLOAT(NT48SK(2))*6.5536D4
     &     +DFLOAT(NT48SK(1))*4.294967296D9)*2.0D1

 805  CONTINUE

      DIFTEVSK=RT48CLK-PRECLK
      RETURN
      END
      

