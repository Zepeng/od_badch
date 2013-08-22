************************************************************************
*     -------------------------------------
      SUBROUTINE TQSKZ(*)
*     -------------------------------------
*
*     (Purpose)
*        Read 'TQZ' bank and fill the commons /SKTQZ/
*
*     (Input)
*        none
*
*     (Output)
*       
*     (Return)
*        Return 1 ; Data w/o 'TQZ' bank
*       
*
*     (Creation Date and Author)
*       2007.06.25 ; First version by Y.Koshio
*       2007.07.03 ; modified by Y.Takeuchi
*           o fill flag 
*           o iand(), ishft() are used
************************************************************************
      implicit none

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"

      CHARACTER*32 CNAME
      CHARACTER*80 fname
      INTEGER IPBANK, NDATA, IBUF0(maxhwsk*3), IBUF(MAXPM*20)
      integer nhit, nevhw, isegm, ihw
      integer ihit,istr1,istr2

c*** arrays for skroot rfm file 
c*** MAXPM*10 is tentative. need to consider to use "malloc()", etc. (y.t.)
      integer nhwt,hwtrgid(MAXHWSK)
      integer id_nhits(MAXHWSK), id_cable(MAXHWSK,MAXPM*10) 
      integer id_t(MAXHWSK,MAXPM*10), id_q(MAXHWSK,MAXPM*10)

      integer status

c*** check file format
      if (SK_FILE_FORMAT.eq.1) goto 200  ! skroot format

c*** initialize
      call lbfset0(ibuf0,maxhwsk*3)
      call lbfset0(ibuf,maxpm*10)

c*** check TQZ bank
      CNAME = 'TQZ'
      CALL KZBLOC(CNAME,IPBANK)
      IF(IPBANK.LE.0) GOTO 998

c*** read # of events
      CALL KZGET0(CNAME,0,NDATA,IBUF0)
      if(NDATA.ne.NUMHWSK*3) then
         print*,'tqskz : #of HW trgs are strange ',nevsk,ndata,numhwsk,nevhwsk
         print*,'call Koshio'
         stop
      endif

      do ihw = 1, NUMHWSK
         nhit  = IBUF0((ihw-1)*3+1)
         nevhw = ishft(iand(IBUF0(ihw*3),2**17-1), 15)
         hwsk(ihw) = nevhw
c         print*,'tqskz ',ihw,nhit,it0sk,nevhw,ibuf0(ihw*3)

         isegm = (ihw-1)*2+1
         CALL KZGET0(CNAME,isegm,NDATA,IBUF)
         if(NDATA.ne.nhit*2) then
            if (idtgsk.ne.4) then
               if(NDATA.eq.2.and.nhit.eq.0) then
c*** this may occur for SLE only triggered events. (y.t.)
                  print*,'tqskz: No ID hit in run#',nrunsk,' event#',nevsk,' ihw#', ihw, idtgsk
                  goto 101
               else
                  print*,'hen in tqskz ',isegm, NDATA, nhit
                  print*,'call Koshio'
                  stop
               endif
            endif
         endif
         do ihit = 1,nhit
            NQISKZ = NQISKZ + 1

c*** check length
            if (nqiskz.gt.maxpm*30) then 
               write(fname,8) nrunsk,nsubsk,nevsk
 8             format('./tqskz.debug.',i6.6,'.',i6.6,'.',i12.12,'.log')
               write(0,*) '**************************************'
               write(0,*) ' Warning in tqskz.F'
               write(0,*) ' Num. of hits in gate is too much'
               write(0,*) ' written in ',fname
               write(0,*) '**************************************'
               open(98,file=fname)
               write(98,*) 'Warning : exceed the array in tqskz'
               close(98)
               nqiskz = maxpm*30
               goto 102
            endif

            istr1 = ishft(IBUF(ihit*2-1), -16)
            istr2 = iand(IBUF(ihit*2-1), 2**16-1)
            ICABIZ(NQISKZ) = istr2
            istr1 = ishft(IBUF(ihit*2), -16)
            istr2 = iand(IBUF(ihit*2), 2**16-1)
            ITISKZ(NQISKZ) = istr1 + nevhw - it0sk
            IQISKZ(NQISKZ) = istr2
            ITISKZ_raw(NQISKZ) = ITISKZ(NQISKZ)
            IQISKZ_raw(NQISKZ) = IQISKZ(NQISKZ)

cc            print*,'HW',ihw,nqiskz,icabiz(nqiskz),itiskz(nqiskz),
cc     &           iqiskz(nqiskz),  nevhw, it0sk

c*** set flag
            IHTIFLZ(nqiskz) = iand(IQISKZ(nqiskz), 63488) ! select 15-11bit
            IHTIFLZ(nqiskz) = ishft(IHTIFLZ(nqiskz), -10) ! 15-11bit -> 5-1bit
            IHTIFLZ(nqiskz) = IHTIFLZ(nqiskz) + (ihw-1)*64 ! set 11-6bit 
            icabbf_raw(nqiskz) = ICABIZ(nqiskz) + (IHTIFLZ(nqiskz) * 2**16)

c            print *, IQISKZ(IHIT), IHTIFLZ(IHIT),ITISKZ(IHIT),
c     $           id_start, id_end
         enddo

 101     continue

      enddo

c*** set timing gate
 102  continue
      nqisk_raw = nqiskz
      call set_timing_gate_id(it0xsk)
      call set_timing_gate_veto(it0xsk) ! 20090115 added by y.t.

c*** normal end (ZBS)
      RETURN

c***************************************************************************
c*** for skroot file
c***************************************************************************
 200  continue

c*** initialize
      call lbfset0(hwtrgid,  MAXHWSK)
c      call lbfset0(id_nhits, MAXHWSK)
c      call lbfset0(id_cable, maxpm*MAXHWSK*10)
c      call lbfset0(id_t,     maxpm*MAXHWSK*10)
c      call lbfset0(id_q,     maxpm*MAXHWSK*10)

c      call lbfset0(od_nhits, MAXHWSK)
c      call lbfset0(od_cable, maxpm*MAXHWSK*10)
c      call lbfset0(od_t,     maxpm*MAXHWSK*10)
c      call lbfset0(od_q,     maxpm*MAXHWSK*10)

c*** get ID TQ & OD TQ
      call skroot_get_idtq(root_id,status,nhwt,hwtrgid,
     $     id_nhits, id_cable, id_t, id_q)

c      print *, '--id--', nhwt, '----' 
c      print *, (hwtrgid(status),status=1,10)
c      print *, (id_nhits(status),status=1,10)
c      print *, id_cable(1,1), id_cable(2,1), id_cable(3,1)
c      print *, id_t(1,1), id_t(2,1), id_t(3,1)
c      print *, id_q(1,1), id_q(2,1), id_q(3,1)

c      call skroot_get_odtq(root_id,status,nhwt,hwtrgid,
c     $     od_nhits, od_cable, od_t, od_q)

c      print *, '--od--', nhwt, '----'
c      print *, (hwtrgid(status),status=1,10)
c      print *, (od_nhits(status),status=1,10)
c      print *, od_cable(1,1), od_cable(2,1), od_cable(3,1)
c      print *, od_t(1,1), od_t(2,1), od_t(3,1)
c      print *, od_q(1,1), od_q(2,1), od_q(3,1)

      if(nhwt.ne.NUMHWSK) then
         print*,'tqskz : #of HW trgs are strange ',nevsk,nhwt,numhwsk,nevhwsk
         print*,'call Koshio'
         stop
      endif

      do ihw = 1, NUMHWSK
         nevhw = ishft(iand(hwtrgid(ihw),2**17-1), 15)
         hwsk(ihw) = nevhw
c         print*,'tqskz(root) ',ihw,nhit,it0sk,nevhw,ibuf0(ihw*3)

         if(id_nhits(ihw).eq.0.and.idtgsk.ne.4) then
c*** this may occur for SLE only triggered events. (y.t.)
            print*,'tqskz: No ID hit in run#',nrunsk,' event#',nevsk,' ihw#', ihw, idtgsk
            goto 201
         endif

         do ihit = 1, id_nhits(ihw)
            NQISKZ = NQISKZ + 1

c*** check length
            if (nqiskz.gt.maxpm*30) then 
               write(fname,8) nrunsk,nsubsk,nevsk
               write(0,*) '**************************************'
               write(0,*) ' Warning in tqskz.F'
               write(0,*) ' Num. of hits in gate is too much'
               write(0,*) ' written in ',fname
               write(0,*) '**************************************'
               open(98,file=fname)
               write(98,*) 'Warning : exceed the array in tqskz'
               close(98)
               nqiskz = maxpm*30
               goto 202
            endif

            ICABIZ(NQISKZ) = id_cable(ihw,ihit)
            ITISKZ(NQISKZ) = id_t(ihw,ihit) + nevhw - it0sk
            IQISKZ(NQISKZ) = id_q(ihw,ihit)
            ITISKZ_raw(NQISKZ) = ITISKZ(NQISKZ)
            IQISKZ_raw(NQISKZ) = IQISKZ(NQISKZ)

cc            print*,'HW',ihw,nqiskz,icabiz(nqiskz),itiskz(nqiskz),
cc     &           iqiskz(nqiskz),  nevhw, it0sk

c*** set flag
            IHTIFLZ(nqiskz) = iand(IQISKZ(nqiskz), 63488) ! select 15-11bit
            IHTIFLZ(nqiskz) = ishft(IHTIFLZ(nqiskz), -10) ! 15-11bit -> 5-1bit
            IHTIFLZ(nqiskz) = IHTIFLZ(nqiskz) + (ihw-1)*64 ! set 11-6bit 
            icabbf_raw(nqiskz) = ICABIZ(nqiskz) + (IHTIFLZ(nqiskz) * 2**16)

cc            print *, IQISKZ(IHIT), IHTIFLZ(IHIT),ITISKZ(IHIT),
cc     $           id_start, id_end

         enddo

 201     continue

      enddo

c*** set timing gate
 202  continue
      nqisk_raw = nqiskz
      call set_timing_gate_id(it0xsk)
      call set_timing_gate_veto(it0xsk) ! 20090115 added by y.t.

c*** normal end (skroot)
      RETURN

C --- w/o 'TQ' bank

 998  RETURN 1

      END
