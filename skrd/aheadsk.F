************************************************************************
*     -------------------------------------
      SUBROUTINE AHEADSK(*)
*     -------------------------------------
*
*     (Purpose)
*        Read 'AHEADER' bank and fill the common /SKHEAD/
*
*     (Input)
*        none
*
*     (Output)
*       
*     (Return)
*        Return 1 ; Data w/o 'AHEADER' bank
*       
*
*     (Creation Date and Author)
*     1996.03.30 ; Created -- Flanagan, J.
*
************************************************************************
      implicit none
#include "skhead.h"
c---------------------------------------------- constant
      integer   IDIM
      PARAMETER(IDIM = 1000)

c---------------------------------------------- local variable
      integer IDATA(IDIM)
      integer IPBANK,NDATA0,NDATA1
      integer nrunsv/-1/

c---------------------------------------------- program

      CALL KZBLOC('AHEADER',IPBANK)
      IF(IPBANK.LE.0)THEN !-------------------- w/o 'AHEADER' bank
c         if(nrunsk.ge.1000) print *,"cannot find aheader ",nevsk
         RETURN 1
      endif

      CALL KZGET0('AHEADER',0,NDATA0,IDATA)
      CALL KZGET0('AHEADER',1,NDATA1,IDATA)

      IF(NDATA0.GT.IDIM.OR.NDATA1.GT.IDIM) THEN
         WRITE(6,*) '# of KZGET data is grater than array size'
         WRITE(6,*) 'Stop in AHEADSK'
         STOP
      ENDIF

      LTCGPS   = IDATA(1)
      NSGPS    = IDATA(2)
      NUSGPS   = IDATA(3)
      LTCTRG   = IDATA(4)
      LTCBIP   = IDATA(5)
      ITDCT0(1)= IDATA(6)
      ITDCT0(2)= IDATA(7)
      ITDCT0(3)= IDATA(8)
      ITDCT0(4)= IDATA(9)
      IFFSCC   = IDATA(10)
      ICALVA   = idata(11)

      if(NRUNSK.ne.nrunsv)then
         nrunsv=NRUNSK
         if (icalva .eq. 0) then
            write(6,*) '****************************************'
            write(6,*) '*    Warning:  Bad antipmtmap!         *'
            write(6,*) '*    Please reprocess raw data with    *'
            write(6,*) '*    sklib_3.1 or greater.             *'
            write(6,*) '****************************************'
         else if ((icalva .eq. 1) .or.
     +	          (icalva .eq. 3) .or.
     +	          (icalva .eq. 6)) then
            write(6,*) '****************************************'
            write(6,*) '* Warning:  Time offsets in anti bad   *'
            write(6,*) '*           for multi-hit events!      *'
            write(6,*) '*          (first event should be ok). *'
            write(6,*) '****************************************'
         endif
      endif

      RETURN
      END
