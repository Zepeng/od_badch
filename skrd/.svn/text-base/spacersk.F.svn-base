************************************************************************
*     -------------------------------------
      SUBROUTINE SPACERSK(*)
*     -------------------------------------
*
*     (Purpose)
*        Read NEXT 'SPACER' bank
*
*     (Input)
*        none
*
*     (Output)
*       
*     (Return)
*        Return 1 ; Data w/o 'SPACERS' bank
*       
*
*     (Creation Date and Author)
*       2008.12.09 ; First version by Y.Hayato
*
************************************************************************

#include "skhead.h"
#include "skparm.h"
#include "skspacer.h"

      CHARACTER*32 CNAME

      INTEGER*4 IBUF(MAXSPCDLEN)

C --- Initialization 

      ISPCRUN   = 0
      ISPCCTR32 = 0
      ISPCID    = 0

      ISPCDLEN  =0

      DO 10 I=1,MAXSPCDLEN
         ISPCDATA(I)=0
 10   continue

C ---
      if (SK_FILE_FORMAT.eq.1) then ! skroot
         
         call skroot_get_spacers(root_id, ierr, 
     $        ispcrun, ispcctr32, ispcid,
     $        ispcdlen,ispcdata);

      else                      ! ZBS


C      write(*,*) "SEARCHING SPACERS"
      CNAME = 'SPACERS'
      CALL KZBLOC(CNAME,IPBANK)
      IF(IPBANK.LE.0) RETURN 1

C      write(*,*) "FOUND SPACERS"
      CALL KZGET0(CNAME,1,NDATA,IBUF)
      ISPCRUN   = IBUF(1)
      ISPCCTR32 = IBUF(2)
      ISPCID    = IBUF(3)

C ---
      CALL KZGET0(CNAME,2,ISPCDLEN,IBUF)

      DO 100 I=1,ISPCDLEN
         ISPCDATA(I)=IBUF(I)
 100  CONTINUE
      RETURN 0

      endif

      END
