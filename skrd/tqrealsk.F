************************************************************************
*     -------------------------------------
      SUBROUTINE TQREALSK(*)
*     -------------------------------------
*
*     (Purpose)
*        Read 'TQREAL' bank and fill the commons /SKQ/,/SKT/,/SKCHNL/
*
*     (Input)
*        none
*
*     (Output)
*       
*     (Return)
*        Return 1 ; Data w/o 'TQREAL' bank
*       
*
*     (Creation Date and Author)
*       1995.10.14 ; First version by Y.Koshio
*       2007.07.03 ; modified by Y.Koshio/Y.Takeuchi
*           o for QB
*       2007.9     ; M Fechner -  ROOT Input 
*       2008.02.28 ; ported from TQREALSK.F, merged QB & ROOT by Y.Takeuchi
*       2008.06.09 ; Unified zbs and root by Y.Koshio
*       2008.07.09 ; modified by y.takeuchi
*        o added badch mask for QB
*        o added filing to *_raw parameter for QB
*     
************************************************************************

      IMPLICIT NONE

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"
#include "skbadc.h"
#include "skveto.h"
#include "sktrighit.h"

      integer status

      INTEGER ISKBIT
      COMMON /SKOPT/ISKBIT

      INTEGER IPBANK,NDATA,NENT,I,LDAT, icab

      INTEGER IBUF(10)
      REAL RBUF(10)
      EQUIVALENCE(IBUF,RBUF)

      INTEGER NHIT0

#include "zbs.h"
      INTEGER IBUFF(3,MAXPM)
      REAL    RBUFF(3,MAXPM)
      EQUIVALENCE (IBUFF(1,1),RBUFF(1,1))

      INTEGER IFMOD
      REAL CONVF


**** For QB ****
      INTEGER IBUFZ(3,MAXPM*30)
      REAL    RBUFZ(3,MAXPM*30)
      EQUIVALENCE (IBUFZ(1,1),RBUFZ(1,1))
****************

cc --- for PC2PE
      INTEGER NRUNSK_LAST
      REAL PC2PE_SK1, PC2PE_SK2, PC2PE_SK3, PC2PE_SK4, PC2PE
      PARAMETER (PC2PE_SK1 = 2.055, PC2PE_SK2 = 2.297, PC2PE_SK3 = 2.243,
     &     PC2PE_SK4 = 2.645)
      DATA PC2PE/0./
      SAVE PC2PE, NRUNSK_LAST

c*** local variables (not used, for now)
      integer tqreal_ver, qbconst_ver, tqmap_ver, pgain_ver

C*** set PC2PE
      IF (NRUNSK .NE. NRUNSK_LAST) THEN
         NRUNSK_LAST = NRUNSK

         IF(NRUNSK.lt.20000) then ! for SK1
            PC2PE=PC2PE_SK1
         else if(NRUNSK.lt.30000) then ! for SK2
            PC2PE=PC2PE_SK2
         else if(NRUNSK.lt.60000) then ! for SK3
            PC2PE=PC2PE_SK3
         else                   ! for SK4
            PC2PE=PC2PE_SK4
         endif
      ENDIF

C ---

      if (SK_FILE_FORMAT .eq. 1 ) then ! root

c*** read an event if positive LUN
         if (nqiskz.eq.0) then 
            call skroot_get_tqreal(root_id,status,nqisk_raw,pc2pe_raw,
     $           tqreal_ver, qbconst_ver, tqmap_ver, pgain_ver, it0xsk,
     $           icabbf_raw,qbuf_raw,tbuf_raw)
            NTRIGSK = (it0xsk-it0sk)/count_per_nsec/10 ! 20090403 added by y.t.
         endif

c*** copy to memory
         pc2pe  = pc2pe_raw
         NQISKZ = NQISK_raw
         do i=1,NQISKZ
ccyt  20080930 all the hits in SK-1,2,3 are in_gate & 1.3usec 
ccyt  original definition of upper 16bit in SK-1,2,3 is chA(=0) or chB(=1)
ccyt  chA or chB is not use in the ofl files. so, overide it, tentatively.
            if (SK_GEOMETRY.ge.4) then
               IHTIFLZ(i) = ishft(icabbf_raw(i), -16)
            else
               IHTIFLZ(i) = 3   ! = in_gate & 1.3micro sec
            endif
            ICABIZ(i)  = iand(icabbf_raw(i), 2**16-1)
            tiskz(i)   = tbuf_raw(i) -(it0xsk-it0sk)/count_per_nsec
            qiskz(i)   = qbuf_raw(i)
         enddo

         NQISK = 0
         QISMSK = 0.
         NQVSK = 0
         QVSMSK = 0.
         NTGSK = 0

         do i=1,NQISKZ

            if(iand(IHTIFLZ(I),1).eq.1) then ! 1.3usec events
               icab = icabiz(i)

               if(icab.ge.1 .and.icab.le.MAXPM) then
                  IF(BTEST(ISKBIT,31-25).AND.IBAD(ICAB).NE.0) GOTO 120 ! skip badch
                  NQISK = NQISK + 1
                  ihcab(NQISK) = icab
                  iab(icab) = 1           ! always =1 for QB
                  TISK(icab) = tiskz(i)
                  QISK(icab) = qiskz(i)

                  IF(QISK(ICAB).GE.DTHRSK) QISMSK = QISMSK+QISK(ICAB)
                  IF(QISK(ICAB).GT.QIMXSK) THEN
                     QIMXSK = QISK(ICAB)
                     MXQISK = ICAB
                  END IF
                  IF(TISK(ICAB).LT.TIMNSK) THEN
                     TIMNSK = TISK(ICAB)
                     MNTISK = ICAB
                  END IF
                  IF(TISK(ICAB).GT.TIMXSK) THEN
                     TIMXSK = TISK(ICAB)
                     MXTISK = ICAB
                  END IF

               else if (icab.gt.MAXPM .and.icab.le.12000) then
                  NQVSK = NQVSK + 1
                  ihcabv(NQVSK) = icab
                  iabv(icab) = 1 ! always =1 for QB
                  TVSK(icab) = tiskz(i)
                  QVSK(icab) = qiskz(i)

                  IF(QVSK(ICAB).GE.DTHRSK) QVSMSK = QVSMSK+QVSK(ICAB)
                  IF(QVSK(ICAB).GT.QVMXSK) THEN
                     QVMXSK = QVSK(ICAB)
                     MXQVSK = ICAB
                  END IF
                  IF(TVSK(ICAB).LT.TVMNSK) THEN
                     TVMNSK = TVSK(ICAB)
                     MNTVSK = ICAB
                  END IF
                  IF(TVSK(ICAB).GT.TVMXSK) THEN
                     TVMXSK = TVSK(ICAB)
                     MXTVSK = ICAB
                  END IF
               endif
            endif

            if(icabiz(i).ge.15001.and.icabiz(i).le.15024) then
               NTGSK = NTGSK + 1
               if(NTGSK.gt.MXTGSK) then
                  write(6,*) 'Error in tqrealsk'
                  write(6,*) 'call koshio'
                  stop
               endif
               ICABTG(NTGSK) = icabiz(i)
               TTGSK(NTGSK) = tiskz(i)
               QTGSK(NTGSK) = qiskz(i)
            endif

 120        continue
         enddo
         return         ! normal end for skroot qb

      else                      ! ZBS
         CALL KZBLOC('TQREAL',IPBANK)
         IF(IPBANK.LE.0) GOTO 999

         if(nrunsk.le.244.and.(MDRNSK.ne.0.and.MDRNSK.ne.999999)) then
            CALL KZGET0('TQREAL',0,NDATA,IBUF)
         else 
            CALL KZGET1('TQREAL',0,NDATA,IBUF)
         endif
ccccccccccccccccccccccccccccccccccc
c*** tqreal bank ver.2 is for QB
         if(ibuf(3).eq.2) goto 998
ccccccccccccccccccccccccccccccccccc
      endif

      NHIT0 = IBUF(1)
      nqisk_raw = NHIT0
      pc2pe_raw = pc2pe
      CONVF = 1.
      IF(NDATA.EQ.1) THEN
         IF(IFMOD.NE.999) THEN
            WRITE(6,*) ' '
            WRITE(6,*) '********************************************'
            WRITE(6,*) '* This data is Q unit -> pC....            *'
            WRITE(6,*) '* Now converted to p.e.                    *'
            WRITE(6,*) '* Please TQREAL again using new version.   *'
            WRITE(6,*) '********************************************'
            WRITE(6,*) ' '
            IFMOD=999
         ENDIF
         if(PC2PE.eq.0.) then
            write(6,*) 'Error: PC2PE equal zero in tqrealsk by Koshio'
            stop
         else
            CONVF = PC2PE
         endif

      ENDIF
C ---
C M Fechner : normal behaviour when mode!=1, read the zebra bank
C if mode == 1, icabbf, t/qbuf have already been filled above
      if (SK_FILE_FORMAT .ne. 1) then ! ZBS

         if(nrunsk.le.244.and.(MDRNSK.ne.0.and.MDRNSK.ne.999999)) then
            CALL KZGET0('TQREAL', 1, NDATA, ICABBF_RAW)
            CALL KZGET0('TQREAL', 2, NDATA, TBUF_RAW)
            CALL KZGET0('TQREAL', 3, NDATA, QBUF_RAW)
         else
            IF (NHIT0.NE.0) THEN
               CALL KZLDAT('TQREAL',LDAT)
               nent = 3*nhit0
               CALL LBFCOPY(IZBS(LDAT+NDATA+1),ibuff,nent)
            END IF
            do 888 i=1,nhit0
               icabbf_raw(i)=ibuff(1,i)
               tbuf_raw(i)=rbuff(2,i)
               qbuf_raw(i)=rbuff(3,i)
 888        continue
         endif
      endif

      NQISK = 0
      QISMSK =0.
      DO 10 I=1,NHIT0

         ICAB = iand(ICABBF_RAW(I), 2**16-1)

         IF(BTEST(ISKBIT,31-25).AND.IBAD(ICAB).NE.0) GOTO 10

         NQISK = NQISK + 1
         IHCAB(NQISK)   = ICAB

         IAB(ICAB)  = ishft(ICABBF_RAW(I),-16) + 1
         TISK(ICAB) = TBUF_RAW(I)
         QISK(ICAB) = QBUF_RAW(I)/CONVF

         IF(QISK(ICAB).GE.DTHRSK) QISMSK = QISMSK+QISK(ICAB)
         IF(QISK(ICAB).GT.QIMXSK) THEN
            QIMXSK = QISK(ICAB)
            MXQISK = ICAB
         END IF
         IF(TISK(ICAB).LT.TIMNSK) THEN
            TIMNSK = TISK(ICAB)
            MNTISK = ICAB
         END IF
         IF(TISK(ICAB).GT.TIMXSK) THEN
            TIMXSK = TISK(ICAB)
            MXTISK = ICAB
         END IF   

 10   CONTINUE

C ---

      RETURN

**** For QB ****

 998  continue

      NQISKZ = IBUF(1)
      IT0XSK = IBUF(7) ! 20080728 added by y.t.
      NTRIGSK= (it0xsk-it0sk)/count_per_nsec/10 ! 20090403 added by y.t.

      IF (NQISKZ.NE.0) THEN
         CALL KZLDAT('TQREAL',LDAT)
         nent = 3*NQISKZ
         CALL LBFCOPY(IZBS(LDAT+NDATA+1),ibufz,nent)
      END IF

      NQISK = 0
      QISMSK =0.
      nqisk_raw = nqiskz
      pc2pe_raw = pc2pe

      NQVSK = 0
      QVSMSK =0.

      NTGSK = 0                 ! for triger hit

      do i=1,NQISKZ
         icabiz(i)  = iand(ibufz(1,i),2**16-1)

         IHTIFLZ(I) = ishft(ibufz(1,i), -16)
         tiskz(i)   = rbufz(2,i) -(it0xsk-it0sk)/count_per_nsec
         qiskz(i)   = rbufz(3,i)

c*** store same info. (w/o badch mask)               
         icabbf_raw(i) = ICABIZ(i) + (IHTIFLZ(i) * 2**16)
         tbuf_raw(i) = rbufz(2,i) ! time=0 = it0sk
         qbuf_raw(i) = qiskz(i)

         if(iand(IHTIFLZ(I),1).eq.1) then   ! 1.3usec events

            icab = icabiz(i)

            if(icab.ge.1 .and.icab.le.MAXPM) then
               IF(BTEST(ISKBIT,31-25).AND.IBAD(ICAB).NE.0) GOTO 20 ! skip badch

               NQISK = NQISK + 1
               ihcab(NQISK) = icab
               iab(icab) = 1    ! always =1 for QB
               TISK(icab) = tiskz(i)
               QISK(icab) = qiskz(i)

               IF(QISK(ICAB).GE.DTHRSK) QISMSK = QISMSK+QISK(ICAB)
               IF(QISK(ICAB).GT.QIMXSK) THEN
                  QIMXSK = QISK(ICAB)
                  MXQISK = ICAB
               END IF
               IF(TISK(ICAB).LT.TIMNSK) THEN
                  TIMNSK = TISK(ICAB)
                  MNTISK = ICAB
               END IF
               IF(TISK(ICAB).GT.TIMXSK) THEN
                  TIMXSK = TISK(ICAB)
                  MXTISK = ICAB
               END IF

            elseif (icab.gt.MAXPM .and.icab.le.12000) then  ! VETO & calib
               NQVSK = NQVSK + 1
               ihcabv(NQVSK) = icab
               iabv(icab) = 1    ! always =1 for QB
               TVSK(icab) = tiskz(i)
               QVSK(icab) = qiskz(i)

c               write(*,*) nqvsk,ihcabv(nqvsk),tvsk(icab),qvsk(icab)

               IF(QVSK(ICAB).GE.DTHRSK) QVSMSK = QVSMSK+QVSK(ICAB)
               IF(QVSK(ICAB).GT.QVMXSK) THEN
                  QVMXSK = QVSK(ICAB)
                  MXQVSK = ICAB
               END IF
               IF(TVSK(ICAB).LT.TVMNSK) THEN
                  TVMNSK = TVSK(ICAB)
                  MNTVSK = ICAB
               END IF
               IF(TVSK(ICAB).GT.TVMXSK) THEN
                  TVMXSK = TVSK(ICAB)
                  MXTVSK = ICAB
               END IF
            endif

         endif

         if(icabiz(i).ge.15001.and.icabiz(i).le.15024) then ! for trigger hit
            NTGSK = NTGSK + 1
            if(NTGSK.gt.MXTGSK) then
               write(6,*) 'Error in tqrealsk'
               write(6,*) 'call koshio'
               stop
            endif
            ICABTG(NTGSK) = icabiz(i)
            TTGSK(NTGSK) = tiskz(i)
            QTGSK(NTGSK) = qiskz(i)
         endif


 20      continue
      enddo

      RETURN

C --- w/o 'TQREAL' bank

 999  RETURN 1

      END
