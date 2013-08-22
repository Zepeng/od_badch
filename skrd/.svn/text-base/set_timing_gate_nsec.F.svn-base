************************************************************************
*     -------------------------------------
      SUBROUTINE SET_TIMING_GATE_NSEC(rshift)
*     -------------------------------------
*
*     (Purpose)
*        set timing gate for TISK, QISK, TASK, QASK, etc.
*        set IT0XSK
*        TQREALINFO branch(TQREAL bank), TQAREALINFO branch(TQAREAL bank)
*        are needed.
*
*        NOTE: assume original T0 timing: tisk=1000.0(nsec)   
*
*     (Input)
*        rshift: amount of relative timing shift from original in nsec 
*
*     (Output)
*        written to common 
*       
*     (Return)
*        none:
*       
*     (Creation Date and Author)
*       2009.01.14 ; ported from set_timing_gate.F by Y.Takeuchi
*
************************************************************************
      implicit none

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"

#include "zbs.h"

      integer i, icab, ishift
      real    rshift

c*** for ZBS
      INTEGER IPBANK, NDATA, IBUF(10), LDAT, NENT
      REAL RBUF(10)
      EQUIVALENCE(IBUF, RBUF)
 
      INTEGER ISZHDZ
      PARAMETER(ISZHDZ=7) 
      INTEGER IBUFZ(3,MAXPM*30)
      REAL    RBUFZ(3,MAXPM*30)
      EQUIVALENCE (IBUFZ(1,1),RBUFZ(1,1))

c*** set timing gates
      call  SET_TIMING_GATE_NSEC_ID(rshift)
      call  SET_TIMING_GATE_NSEC_OD(rshift)
      call  SET_TIMING_GATE_NSEC_VETO(rshift) ! should be called after ID

c*** set IT0XSK
      ishift = rshift*count_per_nsec
      IT0XSK = IT0SK + ishift
      NTRIGSK= (it0xsk-it0sk)/count_per_nsec/10 ! 20090403 added by y.t.

c*** store results in tqreal bank/branch
cccccccccccccccccccccccccccccccccccccccccccccccccccc
      if (SK_FILE_FORMAT .eq. 0 ) then ! zbs
cccccccccccccccccccccccccccccccccccccccccccccccccccc

c*** refill tqreal bank, if exist
         CALL KZBLOC('TQREAL',IPBANK)
         IF(IPBANK.LE.0) GOTO 100
         CALL KZGET1('TQREAL',0,NDATA,IBUF)
         if(ibuf(3).lt.2) then
            print *, 'set_timing_gate: cannot be used for TQREAL ver.1'
            stop
         endif

c*** replace IT0XSK         
         IBUF(7) = IT0XSK
         CALL KZREP1('TQREAL',0,ndata,ibuf)

c*** refill common (is this ok?? 20080728 y.t.)
         IF (NQISKZ.gt.0) THEN
            do i = 1, NQISK_raw
               IBUFZ(1,i) = icabbf_raw(i)
               RBUFZ(2,i) = tbuf_raw(i)
               RBUFZ(3,i) = qbuf_raw(i)
            enddo
            CALL KZLDAT('TQREAL',LDAT)
            nent = 3*nqisk_raw
            CALL LBFCOPY(IBUFZ,IZBS(LDAT+ISZHDZ+1),nent)
         END IF

 100     continue
c*** refill tqareal bank, if exist
         CALL KZBLOC('TQAREAL',IPBANK)
         IF(IPBANK.LE.0) GOTO 200
         CALL KZGET1('TQAREAL',0,NDATA,IBUF)
         if(ibuf(3).lt.2) then
            print *, 'set_timing_gate: cannot be used for TQAREAL ver.1'
            stop
         endif

c*** replace IT0XSK         
         IBUF(7) = IT0XSK
         CALL KZREP1('TQAREAL',0,ndata,ibuf)

c*** refill common (is this ok?? 20080728 y.t.)
         IF (NHITAZ_raw.gt.0) THEN
            do i = 1, NHITAZ_raw
               IBUFZ(1,i) = icabaz_raw(i)
               RBUFZ(2,i) = TASKZ_raw(i)
               RBUFZ(3,i) = QASKZ_raw(i)
            enddo
            CALL KZLDAT('TQAREAL',LDAT)
            nent = 3*nhitaz_raw
            CALL LBFCOPY(IBUFZ,IZBS(LDAT+ISZHDZ+1),nent)
         END IF

 200     continue

      endif

cc      print *, 'set_timing_gate: ',it0sk,it0,id_start,id_end,od_start,od_end

      return
      end
************************************************************************
*     -------------------------------------
      SUBROUTINE SET_TIMING_GATE_NSEC_ID(rshift)
*     -------------------------------------
*
*     (Purpose)
*        set timing gate for TISK, QISK, etc.
*
*     (Input)
*        rshift: amount of relative timing shift from original in nsec 
*
*     (Output)
*        written to common 
*       
*     (Return)
*        none:
*       
*     (Creation Date and Author)
*       2009.01.14 ; ported from set_timing_gate.F by Y.Takeuchi
*
************************************************************************
      implicit none

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"

      integer i, ishift
      real    rshift, id_start, id_end, t0

      t0 = 1000.0  ! assume original T0 = 1000.0(nsec)
      ishift = rshift*count_per_nsec ! to adjust with IT0XSK 
      id_start = SKGATE_START_COUNT/count_per_nsec + t0
      id_end   = SKGATE_END_COUNT  /count_per_nsec + t0

      if (nqiskz.gt.0) then
c*** clear iab(1:MAXPM) to choose only the earliest hits
         do i = 1,maxpm
            iab(i) = 0
         enddo
         
c*** bad channel mask will be removed         
         nqiskz = nqisk_raw
         do i = 1, nqisk_raw
            itiskz(i)  = itiskz_raw(i)
            iqiskz(i)  = iqiskz_raw(i)
            tiskz(i)   = tbuf_raw(i) - rshift
            qiskz(i)   = qbuf_raw(i)
            ICABIZ(i)  = iand(icabbf_raw(i), 2**16-1)
            IHTIFLZ(i) = ishft(icabbf_raw(i), -16)
            if (icabiz(i).ge.1.and.icabiz(i).le.MAXPM) then
               IHTIFLZ(i) = iand(IHTIFLZ(i),2**16-2) ! make 0bit = 0
               if(iand(IHTIFLZ(i),2).eq.2 .and.
     $              iab(icabiz(i)).eq.0.and.
     $              TISKZ(i).ge.id_start .and. 
     $              TISKZ(i).le.id_end) then
c***  In 1.3usec & in-gate
                  IHTIFLZ(i) = IHTIFLZ(i) + 1 ! 0bit
                  iab(icabiz(i)) = 1
               endif
               icabbf_raw(i) = ICABIZ(i) + (IHTIFLZ(i) * 2**16)
            endif
         enddo
      endif

      return
      end

************************************************************************
*     -------------------------------------
      SUBROUTINE SET_TIMING_GATE_NSEC_OD(rshift)
*     -------------------------------------
*
*     (Purpose)
*        set timing gate for TASK, QASK, etc.
*
*     (Input)
*        rshift: amount of relative timing shift from original in nsec 
*
*     (Output)
*        written to common 
*       
*     (Return)
*        none:
*       
*     (Creation Date and Author)
*       2009.01.14 ; ported from set_timing_gate.F by Y.Takeuchi
*
************************************************************************
      implicit none

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"
#include "skbadc.h"

      integer i, ishift
      real    rshift, od_start, od_end, t0
      integer nhitaztmp, icaba, j
      INTEGER ISKBIT
      COMMON /SKOPT/ISKBIT

      t0 = 1000.0  ! assume original T0 = 1000.0(nsec)
      ishift = rshift*count_per_nsec ! to adjust with IT0XSK 
      od_start = SKGATE_START_COUNT/count_per_nsec + t0
      od_end   = SKGATE_END_COUNT  /count_per_nsec + t0

c*** bad channel mask will be removed         
      NHITAZ = nhitaz_raw
      do i = 1, nhitaz_raw
         itaskz(i) = itaskz_raw(i)
         iqaskz(i) = iqaskz_raw(i)
         taskz(i)  = taskz_raw(i) - rshift 
         qaskz(i)  = qaskz_raw(i) 
         icabaz(i) = iand(icabaz_raw(i),2**16-1)
         IHTFLZ(I) = ishft(icabaz_raw(i), -16)

         IHTFLZ(i) = iand(IHTFLZ(i),2**16-2) ! make 0bit = 0
         if (iand(IHTFLZ(i),2).eq.2 .and.
     $        TASKZ(i).ge.od_start .and. 
     $        TASKZ(i).le.od_end) then
c***  In 1.3usec & in-gate
            IHTFLZ(i) = IHTFLZ(i) + 1 ! 0bit
         endif
         icabaz_raw(i) = ICABAZ(i) + (IHTFLZ(i) * 2**16)
      enddo

      return
      end

************************************************************************
*     -------------------------------------
      SUBROUTINE SET_TIMING_GATE_NSEC_VETO(rshift)
*     -------------------------------------
*
*     (Purpose)
*        set timing gate for TVSK, QVSK, etc.
*
*     (Input)
*        rshift: amount of relative timing shift from original in nsec 
*
*     (Output)
*        written to common 
*       
*     (Return)
*        none:
*       
*     (Creation Date and Author)
*       2009.01.14 ; ported from set_timing_gate.F by Y.Takeuchi
*
************************************************************************
      implicit none

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"
#include "skveto.h"

      integer i, ishift
      real    rshift, id_start, id_end, t0

      t0 = 1000.0  ! assume original T0 = 1000.0(nsec)
      ishift = rshift*count_per_nsec ! to adjust with IT0XSK 
      id_start = SKGATE_START_COUNT/count_per_nsec + t0
      id_end   = SKGATE_END_COUNT  /count_per_nsec + t0

      if (nqiskz.gt.0) then
c*** clear iabv(MAXPM+1,MAXPMV) to choose only the earliest hits
         do i = maxpm+1,maxpmv
            iabv(i) = 0
         enddo
         
         do i = 1, nqiskz
            if (icabiz(i).ge.MAXPM+1 .and. icabiz(i).le.MAXPMV) then
               IHTIFLZ(i) = iand(IHTIFLZ(i),2**16-2) ! make 0bit = 0
               if(iand(IHTIFLZ(i),2).eq.2 .and.
     $              iabv(icabiz(i)).eq.0.and.
     $              TISKZ(i).ge.id_start .and. 
     $              TISKZ(i).le.id_end) then
c***  In 1.3usec & in-gate
                  IHTIFLZ(i) = IHTIFLZ(i) + 1 ! 0bit
                  iabv(icabiz(i)) = 1
               endif
               icabbf_raw(i) = ICABIZ(i) + (IHTIFLZ(i) * 2**16)
            endif
         enddo
      endif

      return
      end
