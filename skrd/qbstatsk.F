************************************************************************
*     -------------------------------------
      SUBROUTINE QBSTATSK(*)
*     -------------------------------------
*
*     (Purpose)
*        Read NEXT 'QBEESTAT' bank
*
*     (Input)
*        none
*
*     (Output)
*       
*     (Return)
*        Return 1 ; Data w/o 'QBEESTAT' bank
*       
*
*     (Creation Date and Author)
*       2008.12.09 ; First version by Y.Hayato
*
************************************************************************
      IMPLICIT NONE

#include "skhead.h"
#include "skparm.h"
#include "skqbstat.h"

      CHARACTER*32 CNAME

      INTEGER*4 IBUF(MAXQBSDLEN)

      integer*4 I,IPBANK,NDATA,IERR

C --- Initialization 

      IQBSRUN   = 0
      IQBSCTR32 = 0
      IQBSID    = 0

      IQBSDLEN  =0

      DO 10 I=1,MAXQBSDLEN
         IQBSDATA(I)=0
 10   continue

C ---
      if (SK_FILE_FORMAT.eq.1) then ! skroot
         
         call skroot_get_qbeestat(root_id, ierr, 
     $        iqbsrun, iqbsctr32, iqbsid,
     $        iqbsdlen,iqbsdata);

      else                      ! ZBS


C      write(*,*) "SEARCHING QBEESTAT"
      CNAME = 'QBEESTAT'
      CALL KZBLOC(CNAME,IPBANK)
      IF(IPBANK.LE.0) RETURN 1

C      write(*,*) "FOUND QBEESTAT"
      CALL KZGET0(CNAME,1,NDATA,IBUF)
      IQBSRUN   = IBUF(1)
      IQBSCTR32 = IBUF(2)
      IQBSID    = IBUF(3)

C ---
      CALL KZGET0(CNAME,2,IQBSDLEN,IBUF)

      DO 100 I=1,IQBSDLEN
         IQBSDATA(I)=IBUF(I)
 100  CONTINUE
      RETURN 0

      endif

      END
