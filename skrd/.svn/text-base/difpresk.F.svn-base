************************************************************************
*     ----------------------
      REAL FUNCTION DIFPRESK()
*     ----------------------
*
*     (Purpose)
*       Calc DIFFERETIAL TIME OF EACH EVENT
*
*     (Input)
*       ICLKOLD(3) : OLD 48bit clock
*       ICLKNEW(3) : NEW 48bit clock      
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
      integer IBUF(3)
      REAL*8 RT48CLK,PRECLK
      
      CALL KZBLOC('EVINFO',IPBANK)
      IF(IPBANK.LE.0) GOTO 100
      CALL KZGET0('EVINFO',0,NDATA,IBUF) 
      CALL KZGET0('EVINFO',1,NDATA,IBUF)
      IF (NDATA.EQ.0 .OR. (IBUF(1).EQ.0 .AND.
     &    IBUF(2).EQ.0 .AND. IBUF(3).EQ.0)) GO TO 100

      PRECLK = (DFLOAT(IBUF(3))+DFLOAT(IBUF(2))*6.5536D4
     &     +DFLOAT(IBUF(1))*4.294967296D9)*2.0D1

      RT48CLK = (DFLOAT(NT48SK(3))+DFLOAT(NT48SK(2))*6.5536D4
     &     +DFLOAT(NT48SK(1))*4.294967296D9)*2.0D1

 100  DIFPRESK = SNGL(RT48CLK-PRECLK)
C      write(6,*) rt48clk,preclk,ibuf,nt48sk
      RETURN
      END
      

