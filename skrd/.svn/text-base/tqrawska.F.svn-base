************************************************************************
*     -------------------------------------
      SUBROUTINE TQRAWSKA(*)
*     -------------------------------------
*
*     (Purpose)
*        Read 'TQA' bank and fill the commons /SKQA/,/SKTA/
*      
*     (Input)
*        none
*
*     (Output)
*       
*     (Return)
*        Return 1 ; Data w/o 'TQA' bank nor 'TQAZ' bank
*       
*
*     (Creation Date and Author)
*       2007.07.03 ; ported from tqrawsk.F by Y.Takeuchi
*           o for QB
*           o iand(), ishft() are used
*       2008.02.28 : ported from TQRAWSK.F, added ROOT I/O by y.takeuchi
*       2008.06.09 : Unified zbs and root by Y.Koshio
*       2008.07.14 : added skroot file with QB by Y.Takeuchi
*       2008.12.26 : added Q correction due to QTC multi-ch hit effect
*                               S.Nakayama/K.Okumura
************************************************************************
      implicit none

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"
#include "skveto.h"
#include "skcalib.h"
#include "sktabl.h"

#include "zbs.h"

      CHARACTER*32 CNAME
      INTEGER*4 IPBANK,NDATA,NHIT0,NWRD,NHIT,NHITV,IPOI
      INTEGER ISZHD,IERR,LDAT,NENT
      PARAMETER(ISZHD=3) 

**** For QB ****
      integer ihitz, i, icaba
      INTEGER ISZHDZ
      PARAMETER(ISZHDZ=7) 
      INTEGER ITQRHDZ(ISZHDZ)
      REAL RTQRHDZ(ISZHDZ)
      EQUIVALENCE(ITQRHDZ,RTQRHDZ)

      INTEGER IBUFZ(3,MAXPMA*30)
      REAL    RBUFZ(3,MAXPMA*30)
      EQUIVALENCE (IBUFZ(1,1),RBUFZ(1,1))

c*** QTC multi-ch-hit correction
      integer QBCH0,TMPHUT,TMPTKO,TMPSL
      integer NEXTCH1,NEXTCH2,QTCCH0,QTCCH1,QTCCH2
      integer NEXTCH,QTCCH
      real    Tdiff
      real    Qshift(30*MAXPMA)
      integer mhit(qb_od_offset+1:MAXPM4), ithit(50,qb_od_offset+1:MAXPM4)
      integer IHITQTC(3)
      real    TDIFQTC(3)
      integer ihit, IQCNT, IRANGE, exist_mhit
      real    PC


c**** for skroot + QB ****************************************
      if (SK_FILE_FORMAT.eq.1) goto 200  ! skroot format
c*************************************************************

c*** check TQA bank
      CNAME = 'TQA'
      CALL KZBLOC(CNAME,IPBANK)
      IF(IPBANK.LE.0) GOTO 998

c*** use original routine, if exist
      call TQASK(998)
      return 0

C --- w/o 'TQA' bank

 998  continue

**** For QB ****
      CNAME = 'TQAZ'
      CALL KZBLOC(CNAME,IPBANK)
      IF(IPBANK.LE.0) GOTO 999

 200  continue
c*** read TQAZ bank, then fill /SKTQAZ/
      call tqskaz


c*** QTC multi-ch-hit correction
      do i=1, 30*MAXPMA
         Qshift(i) = 0.
      enddo

c*** do not apply QTC multi-ch-hit correction to pedestal events
      if (iand(idtgsk,2**30).ne.0) goto 300

      do icaba = qb_od_offset+1, MAXPM4
         mhit(icaba)=0
      enddo
      do ihitz = 1, NHITAZ
         icaba = ICABAZ(ihitz)
         if ( icaba.gt.qb_od_offset .and. icaba.le.MAXPM4 ) then
            if ( mhit(icaba).le.49 ) then
               mhit(icaba) = mhit(icaba) + 1
               ithit(mhit(icaba),icaba) = ITASKZ(ihitz)
            endif
         endif
      enddo

      do ihitz = 1, NHITAZ
         if (ICABAZ(ihitz).eq.0) goto 400
c*** identify the other channels in the same QTC
         QBCH0  = NQBCH(ICABAZ(ihitz))
         TMPHUT = NQBHUT(ICABAZ(ihitz))
         TMPTKO = NQBTKO(ICABAZ(ihitz))
         TMPSL  = NQBSL(ICABAZ(ihitz))
         IF (mod(QBCH0, 3).EQ.0) THEN
            NEXTCH1 = NQBCAB(TMPHUT, TMPTKO, TMPSL, QBCH0+1)
            NEXTCH2 = NQBCAB(TMPHUT, TMPTKO, TMPSL, QBCH0+2)
            QTCCH0 = 2
            QTCCH1 = 1
            QTCCH2 = 0
         ELSE IF (mod(QBCH0, 3).EQ.1) THEN
            NEXTCH1 = NQBCAB(TMPHUT, TMPTKO, TMPSL, QBCH0-1)
            NEXTCH2 = NQBCAB(TMPHUT, TMPTKO, TMPSL, QBCH0+1)
            QTCCH0 = 1
            QTCCH1 = 2
            QTCCH2 = 0
         ELSE IF (mod(QBCH0, 3).EQ.2) THEN
            NEXTCH1 = NQBCAB(TMPHUT, TMPTKO, TMPSL, QBCH0-2)
            NEXTCH2 = NQBCAB(TMPHUT, TMPTKO, TMPSL, QBCH0-1)
            QTCCH0 = 0
            QTCCH1 = 2
            QTCCH2 = 1
         ENDIF

c*** check if the other channel hit or not
         IHITQTC(QTCCH0+1) = 1
         IHITQTC(QTCCH1+1) = 0
         IHITQTC(QTCCH2+1) = 0
         TDIFQTC(QTCCH0+1) = 0.
         TDIFQTC(QTCCH1+1) = -1000000.
         TDIFQTC(QTCCH2+1) = -1000000.
         exist_mhit=0
         do i=1,2
            if ( i.eq.1 ) then
               NEXTCH = NEXTCH1
               QTCCH  = QTCCH1
            endif
            if ( i.eq.2 ) then
               NEXTCH = NEXTCH2
               QTCCH  = QTCCH2
            endif
            if ( mhit(NEXTCH).gt.0 ) then
               do ihit=1, mhit(NEXTCH)
                  tdiff = ( ithit(ihit,NEXTCH) -  ITASKZ(ihitz) ) / 1.92
                  if ( tdiff.gt.-900. .and. tdiff.lt.400. ) then
                     IHITQTC(QTCCH+1) = 1
                     TDIFQTC(QTCCH+1) = tdiff
                     exist_mhit = exist_mhit + 1
                  endif
               enddo
            endif
         enddo

c*** calc drift due to multi-hit
         if ( exist_mhit.eq.0 ) then
            Qshift(ihitz) = 0.
         else
            CALL SKTQCONV_QB(ICABAZ(ihitz), 0, 
     $           ITASKZ(ihitz), IQASKZ(ihitz), 0., -1,
     $           TASKZ(ihitz),  QASKZ(ihitz))
            PC = QASKZ(ihitz)
            call SKQDIV(IQASKZ(ihitz), IQCNT, IRANGE)
            call skqtcmhit_corr(QTCCH0, IRANGE, PC,
     $           IHITQTC, TDIFQTC, Qshift(ihitz))
            Qshift(ihitz) = -Qshift(ihitz)
         endif

 400     continue
      enddo
 300  continue


c***  for TQAREAL 
      NHITAZ_raw = NHITAZ
      do ihitz = 1, NHITAZ

c*** real T/Q
cccc T0 is already subtracted from ITISKZ   17-JUL-2007 y.t.
c         CALL SKTQCONV_QB(ICABAZ(ihitz), IT0SK, 
c     $        ITASKZ(ihitz), IQASKZ(ihitz),
c     $        TASKZ(ihitz),  QASKZ(ihitz))
CKO         CALL SKTQCONV_QB(ICABAZ(ihitz), 0, 
CKO     $        ITASKZ(ihitz), IQASKZ(ihitz),
CKO     $        TASKZ(ihitz),  QASKZ(ihitz))
         CALL SKTQCONV_QB(ICABAZ(ihitz), 0, 
     $        ITASKZ(ihitz), IQASKZ(ihitz), Qshift(ihitz), 0,
     $        TASKZ(ihitz),  QASKZ(ihitz))

c         print *,'tqrawska:',nhitaz,ihitz,ICABAZ(ihitz), IT0SK, 
c     $        ITASKZ(ihitz), IQASKZ(ihitz),
c     $        TASKZ(ihitz),  QASKZ(ihitz),IHTFLZ(ihitz)

         IBUFZ(1,ihitz) = ICABAZ(ihitz) + (IHTFLZ(ihitz) * 2**16)
         RBUFZ(2,ihitz) = TASKZ(ihitz)
         RBUFZ(3,ihitz) = QASKZ(ihitz)

c*** store same info. (w/o badch mask)               
         icabaz_raw(ihitz) = ICABAZ(ihitz) + (IHTFLZ(ihitz) * 2**16)
         taskz_raw(ihitz) = taskz(ihitz)
         qaskz_raw(ihitz) = qaskz(ihitz)

      enddo

c*** fill common
      call sktqacom()

      if(SK_FILE_FORMAT.eq.0) then ! ZBS format
* Create TQAREAL bank ver.2, then fill data
         ITQRHDZ(1) = NHITAZ
         RTQRHDZ(2) = 0.0       ! pc2pe for OD??
         ITQRHDZ(3) = 2         ! version2 is for QB
         ITQRHDZ(4) = MA_QBCONST*1000 + MI_QBCONST
         ITQRHDZ(5) = 0
         ITQRHDZ(6) = 0 
         ITQRHDZ(7) = IT0XSK  ! 20080728 y.t. to keep T0 for this tqreal

         CALL KZBCR1('TQAREAL',ISZHDZ,'1I 1F 5I',NHITAZ,3,'1I 2F',IERR) 
         CALL KZREP1('TQAREAL',0,ISZHDZ,ITQRHDZ)
         IF (NHITAZ.NE.0) THEN
            CALL KZLDAT('TQAREAL',LDAT)
            nent = 3*nhitaz
            CALL LBFCOPY(IBUFZ,IZBS(LDAT+ISZHDZ+1),nent)
         END IF
      else  ! skroot

      endif

C ---
      RETURN

C --- w/o 'TAQ' nor 'TQAZ' bank

 999  RETURN 1
      END

