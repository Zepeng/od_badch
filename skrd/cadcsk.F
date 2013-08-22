************************************************************************
*     -------------------------------------
      SUBROUTINE CADCSK(*)
*     -------------------------------------
*
*     (Purpose)
*        Read NEXT 'PDST' bank and fill the commons /SKPDST/,/SKTEMP/
*
*     (Input)
*        none
*
*     (Output)
*       
*     (Return)
*        Return 1 ; Data w/o 'PDST' bank
*       
*
*     (Creation Date and Author)
*       1992.08.27 ; First version by K.S.Hirata
*
************************************************************************

#include "skparm.h"
#include "skcadc.h"

      CHARACTER*32 CNAME

      INTEGER*4 IBUF(100)

C --- Initialization 

      DO 3 I=1,16
         IADC(I)=0
 3    CONTINUE

C ---

C      write(*,*) "SEARCHING CADC"
      CNAME = 'CADC'
      CALL KZBLOC(CNAME,IPBANK)
      IF(IPBANK.LE.0) RETURN 1

C      write(*,*) "FOUND CADC"
      CALL KZGET1(CNAME,0,NDATA,IBUF)
      NUMWD  = IBUF(1)

C ---
      CALL KZGET1(CNAME,1,NDATA,IBUF)
      IF (NUMWD.ne.16) then
        write(*,*) "ERROR!! NUMWD=",NUMWD
        stop
      ENDIF
      DO 100 I=1,NUMWD
         IADC(I)=IBUF(I)
         if (IADC(I).ne.0) write(*,*) "IADC(",I,")=",IADC(I)
 100  CONTINUE
      RETURN 0

      END

