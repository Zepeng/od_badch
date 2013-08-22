************************************************************************
*     -------------------------------------
      SUBROUTINE DELETE_OUTSIDE_HITS()
*     -------------------------------------
*
*     (Purpose)
*        to remove hits outside 1.3microsec
*        modify only TQREAL and TQAREAL
*
*     (Input)
*        from common
*
*     (Output)
*        written to common 
*       
*     (Return)
*        none:
*       
*     (Creation Date and Author)
*       2008.09.18 ; First version by Y.Takeuchi
*
************************************************************************
      implicit none

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"
#include "skcalib.h"

#include "zbs.h"

      integer i, ierr

c*** for ZBS
      INTEGER IPBANK, NDATA, IBUF(10), LDAT, NENT
      REAL RBUF(10)
      EQUIVALENCE(IBUF, RBUF)
 
      INTEGER ISZHDZ
      PARAMETER(ISZHDZ=7) 
      INTEGER ITQRHDZ(ISZHDZ)
      REAL RTQRHDZ(ISZHDZ)
      EQUIVALENCE(ITQRHDZ,RTQRHDZ)

      INTEGER IBUFZ(3,MAXPM*30)
      REAL    RBUFZ(3,MAXPM*30)
      EQUIVALENCE (IBUFZ(1,1),RBUFZ(1,1))

c*** delete outside 1.3microsec hits
      call  DELETE_OUTSIDE_HITS_ID()
      call  DELETE_OUTSIDE_HITS_OD()

c*** store results in tqreal bank/branch
      if (SK_FILE_FORMAT .eq. 0 ) then ! zbs

c*** delete TQREAL if exist
         CALL KZBLOC('TQREAL',IPBANK)
         IF(IPBANK.GT.0) CALL KZBDEL('TQREAL')

c*** prepare c/t/q array
         do i = 1, nqisk_raw
            IBUFZ(1,i) = icabbf_raw(i)
            RBUFZ(2,i) = tbuf_raw(i)
            RBUFZ(3,i) = qbuf_raw(i)
         enddo

c*** Create TQREAL bank ver.2, then fill data (copied from tqrawsk.F)
         ITQRHDZ(1) = nqisk_raw
         RTQRHDZ(2) = PC2PE_raw
         ITQRHDZ(3) = 2
         ITQRHDZ(4) = MA_QBCONST*1000 + MI_QBCONST
         ITQRHDZ(5) = MA_TQMAP*1000 + MI_TQMAP
         ITQRHDZ(6) = MA_PGAIN*1000 + MI_PGAIN
         ITQRHDZ(7) = IT0XSK

         CALL KZBCR1('TQREAL',ISZHDZ,'1I 1F 5I',nqisk_raw,3,'1I 2F',IERR) 
         CALL KZREP1('TQREAL',0,ISZHDZ,ITQRHDZ)
         IF (nqisk_raw.NE.0) THEN
            CALL KZLDAT('TQREAL',LDAT)
            nent = 3*nqisk_raw
            CALL LBFCOPY(IBUFZ,IZBS(LDAT+ISZHDZ+1),nent)
         END IF

c*** delete TQAREAL if exist
         CALL KZBLOC('TQAREAL',IPBANK)
         IF(IPBANK.GT.0) CALL KZBDEL('TQAREAL')

c*** prepare c/t/q array
         do i = 1, nhitaz_raw
            IBUFZ(1,i) = icabaz_raw(i)
            RBUFZ(2,i) = taskz_raw(i)
            RBUFZ(3,i) = qaskz_raw(i)
         enddo

c*** Create TQAREAL bank ver.2, then fill data (copied from tqrawsk.F)
         ITQRHDZ(1) = nhitaz_raw
         RTQRHDZ(2) = 0.0       ! pc2pe for OD??
         ITQRHDZ(3) = 2         ! version2 is for QB
         ITQRHDZ(4) = MA_QBCONST*1000 + MI_QBCONST
         ITQRHDZ(5) = 0
         ITQRHDZ(6) = 0
         ITQRHDZ(7) = IT0XSK

         CALL KZBCR1('TQAREAL',ISZHDZ,'1I 1F 5I',nhitaz_raw,3,'1I 2F',IERR)
         CALL KZREP1('TQAREAL',0,ISZHDZ,ITQRHDZ)
         IF (nhitaz_raw.NE.0) THEN
            CALL KZLDAT('TQAREAL',LDAT)
            nent = 3*nhitaz_raw
            CALL LBFCOPY(IBUFZ,IZBS(LDAT+ISZHDZ+1),nent)
         END IF

      endif 
         
c*** do nothing for skroot 
c*** common/RAWTQINFO/ should be alrady modified

      return
      end

************************************************************************
      SUBROUTINE DELETE_OUTSIDE_HITS_ID()
************************************************************************
      implicit none

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"

      integer i, j

c      print *, 'delete_outside_hits_id1: ', nqiskz, nqisk_raw

c*** for I/O (without badch mask)
      j = 0
      do i = 1, nqisk_raw
         if (btest(icabbf_raw(i),16)) then ! = In 1.3usec flag
            j = j + 1
            tbuf_raw(j)   = tbuf_raw(i)
            qbuf_raw(j)   = qbuf_raw(i)
            icabbf_raw(j) = icabbf_raw(i)
            itiskz_raw(j) = itiskz_raw(i)
            iqiskz_raw(j) = iqiskz_raw(i)
         endif
      enddo
      do i = j + 1, nqisk_raw
         tbuf_raw(i)   = 0
         qbuf_raw(i)   = 0
         icabbf_raw(i) = 0
c*** fixed bug 2011/04/15 by y.takeuchi
c         itiskz_raw(j) = 0
c         iqiskz_raw(j) = 0
         itiskz_raw(i) = 0
         iqiskz_raw(i) = 0
      enddo
      nqisk_raw = j
      
c      print *, 'delete_outside_hits_id2: ', nqiskz, nqisk_raw

      return
      end

************************************************************************
      SUBROUTINE DELETE_OUTSIDE_HITS_OD()
************************************************************************
      implicit none

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"

      integer i, j

c      print *, 'delete_outside_hits_od1: ', nhitaz, nhitaz_raw

c*** for I/O (without badch mask)
      j = 0
      do i = 1, nhitaz_raw
         if (btest(icabaz_raw(i),16)) then ! = In 1.3usec flag
            j = j + 1
            taskz_raw(j)  = taskz_raw(i)
            qaskz_raw(j)  = qaskz_raw(i)
            icabaz_raw(j) = icabaz_raw(i)
            itaskz_raw(j) = itaskz_raw(i)
            iqaskz_raw(j) = iqaskz_raw(i)
         endif
      enddo
      do i = j + 1, nhitaz_raw
         taskz_raw(i)  = 0
         qaskz_raw(i)  = 0
         icabaz_raw(i) = 0
c*** fixed bug 2011/04/15 by y.takeuchi
c         itaskz_raw(j) = 0
c         iqaskz_raw(j) = 0
         itaskz_raw(i) = 0
         iqaskz_raw(i) = 0
      enddo
      nhitaz_raw = j
      
c      print *, 'delete_outside_hits_od2: ', nhitaz, nhitaz_raw

      return
      end


