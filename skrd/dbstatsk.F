************************************************************************
*     -------------------------------------
      SUBROUTINE DBSTATSK(*)
*     -------------------------------------
*
*     (Purpose)
*        Read NEXT 'DBSTAT' bank
*
*     (Input)
*        none
*
*     (Output)
*       
*     (Return)
*        Return 1 ; Data w/o 'DBSTAT' bank
*       
*
*     (Creation Date and Author)
*       2008.12.09 ; First version by Y.Hayato
*
************************************************************************
      IMPLICIT NONE

#include "skhead.h"
#include "skparm.h"
#include "skdbstat.h"

      CHARACTER*32 CNAME

      INTEGER*4 IBUF(MAXDBSDLEN)

      integer*4 I,IPBANK,NDATA,IERR

C --- Initialization 

      IDBSRUN   = 0
      IDBSCTR32 = 0
      IDBSID    = 0

      IDBSDLEN  =0

      DO 10 I=1,MAXDBSDLEN
         IDBSDATA(I)=0
 10   continue

C ---
      if (SK_FILE_FORMAT.eq.1) then ! skroot
         
         call skroot_get_dbstat(
     $        root_id, ierr, 
     $        idbsrun, idbsctr32, idbsid,
     $        idbsdlen,idbsdata);

      else                      ! ZBS


C      write(*,*) "SEARCHING DBSTAT"
      CNAME = 'DBSTAT'
      CALL KZBLOC(CNAME,IPBANK)
      IF(IPBANK.LE.0) RETURN 1

C      write(*,*) "FOUND DBSTAT"
      CALL KZGET0(CNAME,1,NDATA,IBUF)
      IDBSRUN   = IBUF(1)
      IDBSCTR32 = IBUF(2)
      IDBSID    = IBUF(3)

C ---
      CALL KZGET0(CNAME,2,IDBSDLEN,IBUF)

      DO 100 I=1,IDBSDLEN
         IDBSDATA(I)=IBUF(I)
 100  CONTINUE
      RETURN 0

      endif

      END
