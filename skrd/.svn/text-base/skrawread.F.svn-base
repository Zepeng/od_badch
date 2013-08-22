************************************************************************
*     -------------------------------------
      SUBROUTINE SKRAWREAD(ILUN,*,*,*,*)
*     -------------------------------------
*
*     (Purpose)
*        Read data in the banks and fill them into commons.
*
*     (Input)
*        LUN ; Logical Unit #
*
*     (Output)
*       
*     (Return)
*        Return 1 ; Read Error
*               2 ; End of File
*               3 ; Data 'PDST' bank
*               4 ; Data 'RUNINF' bank
*
*     (Creation Date and Author)
*       1995.11.07 ; First version by Y.Koshio
*       1996.03.30 ; Modified by J.Flanagan to add new anti banks + commons
*       1996.08.10 : Modified by M. Oketa  for SN watch
*	1997.03.   ; Modified for Veto counter
*       2007.07.03 ; modified by Y.Koshio/Y.Takeuchi
*           o for QB
*       2008.02.28 ; ported from SKRAWREAD.F, added ROOT I/O by Y.Takeuchi
*       2008.04.30 ; Modified by Y.Koshio/Y.Takeuchi
*           o added SK_GEOMETRY=4 and skip memory initialize for SK=1,2,3
*       2008.06.09 ; Unified zbs and root by Y.Koshio
*
************************************************************************

      implicit none

#include "skhead.h"
#include "skparm.h"
#include "sktq.h"
#include "skveto.h"

      integer lun, ilun, ierr, i, ipbank, ipbank1, ipbank2, ipbank3

      real ICHK(MAXPM,2),ICHKV(MAXPM+1:12000,2)
      COMMON /SKRDLC/ICHK
      COMMON /SKRDLCV/ICHKV

C ---

 2    continue

C read next event, if ILUN is a positive number

      LUN = ILUN
      IERR = 0

      if(SK_FILE_FORMAT.eq.0) then ! ZBS format

c-----if LUN<0 only fill common without reading next event
         IF (LUN.GT.0) THEN
            CALL KZECLR
            CALL KZREAD(LUN,IERR)
            IF(IERR.EQ.1) GOTO 1001
            IF(IERR.EQ.2) GOTO 999
         ENDIF

      else                      ! root format
c*** save LUN
         if (ilun.gt.0) then
            root_id = ILUN
         else
            root_id = -ILUN
         endif
c advance one entry in the tree 
c if not, keep the same position (allows reloading of the same event)
         if (ilun.gt.0) call skroot_next_entry(ilun,ierr)
c end of file
         if (ierr .ne. 0 ) return 2
      endif

C --- Initialization 
 
*** Inner

      NQISK = 0
      QISMSK = 0.
      QIMXSK = 0.
      TIMNSK = 100000.
      TIMXSK = -100000.
         
      CALL LBFSET0(ICHK,MAXPM*2)
      CALL LBFSET0(IAB,MAXPM)
      CALL LBFSET0(QISK,MAXPM)
      CALL LBFSET0(TISK,MAXPM)
      CALL LBFSET0(IQABSK,MAXPM*2)
      CALL LBFSET0(ITABSK,MAXPM*2)

*** Outer

*** Veto

      NQVSK = 0
      QVSMSK = 0.
      QVMXSK = 0.
      TVMNSK = 100000.
      TVMXSK = -100000.
      
      do 22 i = MAXPM+1,12000
         ICHKV(i,1) = 0
         ICHKV(i,2) = 0
         IABV(i) = 0
         QVSK(i) = 0.0
         TVSK(i) = 0.0
         IQABSKV(i,1) = 0
         ITABSKV(i,1) = 0
         IQABSKV(i,2) = 0
         ITABSKV(i,2) = 0
 22   Continue

      CALL HEADSK(*995)

      if(NRUNSK.gt.0 .and. NRUNSK.lt.20000) then
         SK_GEOMETRY=1
      else if(NRUNSK.lt.30000) then
         SK_GEOMETRY=2
      else if(NRUNSK.lt.40000) then
         SK_GEOMETRY=3
      else
         SK_GEOMETRY=4
      endif
      CALL GEOSET
      if(nevsk.le.0) return

c**** for non-ATM ******************************************
      if(SK_GEOMETRY.ge.4) goto 200
c***********************************************************

      if(SK_FILE_FORMAT.ne.0) then ! non-ZBS format
         write(6,*) 'raw data in SK-1,2,3 should be ZBS format'
         stop
      endif

C --- Read 'HEADER' bank and fill the common /SKHEAD/
  
C --- Read 'TQ' bank and fill the commons /SKQ/,/SKT/,/SKCHNL/
C          and make 'TQREAL' bank
C     and make 'VETO' bank,fill the common /SKQV/ /SKTV/,/SKCHNLV/


      CALL KZBLOC('TQREAL',IPBANK)
      IF(IPBANK.GT.0) CALL KZBDEL('TQREAL')
      CALL KZBLOC('VETO',IPBANK)      
      IF(IPBANK.GT.0) CALL KZBDEL('VETO')

      CALL TQRAWSK(*997)

C --- Read 'RWANTI' or 'TQA' bank and fill the commons /SKQA/,/SKTA/,
c     /SKTQAZ/,/SKHEADA/ and make 'TQAREAL' and 'AHEADER' banks:

      CALL KZBLOC('AHEADER',IPBANK)
      IF(IPBANK.GT.0) CALL KZBDEL('AHEADER')

      CALL KZBLOC('TQAREAL',IPBANK)
      IF(IPBANK.GT.0) CALL KZBDEL('TQAREAL')

      CALL TQASK(*997)

C ---

      RETURN

c*** for QB
 200  continue

ccccccccccccccccccccccccccccccccccccccc
c*** try to read PEDESTAL bank for QB
      CALL PDSTSK(*100)
 100  continue
ccccccccccccccccccccccccccccccccccccccc

**** Initialize For QBEE

*** Inner
      NQISKZ = 0
      CALL LBFSET0(IHTIFLZ,MAXPM*30)

*** Outer
      NHITAZ = 0
      CALL LBFSET0(IHTFLZ,MAXPMA*30)

      if(SK_FILE_FORMAT.eq.0) then ! ZBS format

C --- Read 'TQ' bank and fill the commons /SKQ/,/SKT/,/SKCHNL/
C          and make 'TQREAL' bank
C     and make 'VETO' bank,fill the common /SKQV/ /SKTV/,/SKCHNLV/

         CALL KZBLOC('TQREAL',IPBANK)
         IF(IPBANK.GT.0) CALL KZBDEL('TQREAL')
         CALL KZBLOC('VETO',IPBANK)      
         IF(IPBANK.GT.0) CALL KZBDEL('VETO')

         CALL TQRAWSK(*997)

C --- Read 'RWANTI' or 'TQA' bank and fill the commons /SKQA/,/SKTA/,
c     /SKTQAZ/,/SKHEADA/ and make 'TQAREAL' and 'AHEADER' banks:

         CALL KZBLOC('AHEADER',IPBANK)
         IF(IPBANK.GT.0) CALL KZBDEL('AHEADER')
         CALL KZBLOC('TQAREAL',IPBANK)
         IF(IPBANK.GT.0) CALL KZBDEL('TQAREAL')

         CALL TQRAWSKA(*997)   
      
      else                      ! root format

         CALL TQRAWSK(*997)
         CALL TQRAWSKA(*997)

      endif

C ---

      RETURN

C --- w/o 'HEADER' bank

C --- READ 'PDST' bank and fill the commons /SKPDHD/,/SKTEMP/,/SKPDST/

 995  Continue
      CALL PDSTSK(*998)

      RETURN 3

C --- w/o 'TQ' or 'TQA' bank

 997  CALL MSGOUT
 
      RETURN

C --- Read Error

 999  CALL MSGOUT
      RETURN 1

C --- End of File

 1001 RETURN 2

C --- w/o 'HEADER' bank and 'PDST' bank

 998  CONTINUE

      if(SK_FILE_FORMAT.eq.0) then ! ZBS format
         CALL KZBLOC('RUNINF',IPBANK)
         IF(IPBANK.LE.0) then
            CALL KZBLOC('MISMATCHED',IPBANK1)
            CALL KZBLOC('SPACERS',IPBANK2)
            CALL KZBLOC('QBEESTAT',IPBANK3)
            IF(IPBANK1.LE.0.and.IPBANK2.LE.0.and.IPBANK3.LE.0) GOTO 996
         ENDIF
      else                      ! root format
         write(6,*) 'There are no HEADER nor PEDESTAL in root'
         stop
      endif

c*** read runinf
      if (ipbank.ne.0) call runinfsk

      RETURN 4

 996  CONTINUE
      WRITE(6,*) 'ERROR; There is no HEADER nor PDST bank in zbs'
      STOP

      END

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE SKCRAWREAD(ILUN,IERR)
c     Call SKREAD so that it can be used from C.
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call SKRAWREAD(ILUN,*100,*200,*300,*400)

      IERR = 0
      RETURN

 100  CONTINUE
      IERR = 1
      RETURN

 200  CONTINUE
      IERR = 2
      RETURN

 300  CONTINUE
      IERR = 3
      RETURN


 400  CONTINUE
      IERR = 4
      RETURN

      END
