************************************************************************
*     -------------------------------------
      SUBROUTINE TQSKAZ(*)
*     -------------------------------------
*
*     (Purpose)
*        Read 'TQAZ' bank and fill the commons /SKTQAZ/
*
*     (Input)
*        none
*
*     (Output)
*       
*     (Return)
*        Return 1 ; Data w/o 'TQAZ' bank
*       
*
*     (Creation Date and Author)
*       2007.06.25 ; First version by Y.Koshio
*       2007.07.04 ; modified by Y.Takeuchi
*           o fill flag 
*           o iand(), ishft() are used
************************************************************************
      implicit none

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"

      CHARACTER*32 CNAME
      CHARACTER*80 fname
      INTEGER IPBANK, NDATA, IBUF0(maxhwsk*3), IBUF(MAXPMA*20)
      integer nhit, nevhw, isegm, ihw
      integer ihit,istr1,istr2

c*** arrays for skroot rfm file 
c*** MAXPM*10 is tentative. need to consider to use "malloc()", etc. (y.t.)
      integer nhwt,hwtrgid(MAXHWSK)
      integer od_nhits(MAXHWSK), od_cable(MAXHWSK,MAXPMA*10)
      integer od_t(MAXHWSK,MAXPMA*10), od_q(MAXHWSK,MAXPMA*10)

      integer status

c*** check file format
      if (SK_FILE_FORMAT.eq.1) goto 200  ! skroot format

c*** initialize
      call lbfset0(ibuf0,maxhwsk*3)
      call lbfset0(ibuf,maxpma*10)

c*** check TQAZ bank
      CNAME = 'TQAZ'
      CALL KZBLOC(CNAME,IPBANK)
      IF(IPBANK.LE.0) GOTO 998

c*** read # of events
      CALL KZGET0(CNAME,0,NDATA,IBUF0)
      if(NDATA.ne.NUMHWSK*3) then
         print*,'tqskaz : #of HW trgs are strange ',nevsk,ndata,numhwsk,nevhwsk
         print*,'call Koshio'
         stop
      endif

      do ihw = 1, NUMHWSK
         nhit  = IBUF0((ihw-1)*3+1)
         nevhw = ishft(iand(IBUF0(ihw*3),2**17-1), 15)
c         print*,'tqskaz ',nhit,it0sk,nevhw,ibuf0(ihw*3)

         isegm = (ihw-1)*2+1
         CALL KZGET0(CNAME,isegm,NDATA,IBUF)
         if(NDATA.ne.nhit*2) then
            if(NDATA.eq.2.and.nhit.eq.0) then
c               print*,'No OD hit in run#',nrunsk,' event#',nevsk,' seg#',isegm
               goto 101
            else
               print*,'hen in tqskaz ',isegm, NDATA, nhit
               print*,'call Koshio'
               stop
            endif
         endif
         do ihit = 1,nhit
            NHITAZ = NHITAZ + 1

c*** check length
            if (nhitaz.gt.maxpma*30) then 
               write(fname,8) nrunsk,nsubsk,nevsk
 8             format('./tqskaz.debug.',i6.6,'.',i6.6,'.',i12.12,'.log')
               write(0,*) '**************************************'
               write(0,*) ' Warning in tqskaz.F'
               write(0,*) ' Num. of hits in gate is too much'
               write(0,*) ' written in ',fname
               write(0,*) '**************************************'
               open(98,file=fname)
               write(98,*) 'Warning : exceed the array in tqskaz'
               close(98)
               NHITAZ = maxpma*30
               goto 102
            endif

            istr1 = ishft(IBUF(ihit*2-1), -16)
            istr2 = iand(IBUF(ihit*2-1), 2**16-1)
            ICABAZ(NHITAZ) = istr2
            istr1 = ishft(IBUF(ihit*2), -16)
            istr2 = iand(IBUF(ihit*2), 2**16-1)
            ITASKZ(NHITAZ) = istr1 + nevhw - it0sk
            IQASKZ(NHITAZ) = istr2
            ITASKZ_raw(NHITAZ) = ITASKZ(NHITAZ)
            IQASKZ_raw(NHITAZ) = IQASKZ(NHITAZ)
c            print*,'HW',ihw,nhitaz,icabaz(nhitaz),itaskz(nhitaz),
c     &           iqaskz(nhitaz),  nevhw, it0sk

c*** set flag
            IHTFLZ(nhitaz) = iand(IQASKZ(nhitaz), 63488) ! select 15-11bit
            IHTFLZ(nhitaz) = ishft(IHTFLZ(nhitaz), -10) ! 15-11bit -> 5-1bit
            IHTFLZ(nhitaz) = IHTFLZ(nhitaz) + (ihw-1)*64 ! set 11-6bit 
            icabaz_raw(nhitaz) = ICABAZ(nhitaz) + (IHTFLZ(nhitaz) * 2**16)

c            print *, IQASKZ(IHIT), IHTFLZ(IHIT),ITASKZ(IHIT),
c     $           od_start, od_end

         enddo

 101     continue

      enddo

c*** set timing gate
 102  continue
      nhitaz_raw = nhitaz
      call set_timing_gate_od(it0xsk)

c*** normal end (zbs)
      RETURN

c***************************************************************************
c*** for skroot file
c***************************************************************************
 200  continue
c*** initialize
      call lbfset0(hwtrgid,  MAXHWSK)
c      call lbfset0(od_nhits, MAXHWSK)
c      call lbfset0(od_cable, maxpma*MAXHWSK*10)
c      call lbfset0(od_t,     maxpma*MAXHWSK*10)
c      call lbfset0(od_q,     maxpma*MAXHWSK*10)

c*** get OD TQ
      call skroot_get_odtq(root_id,status,nhwt,hwtrgid,
     $     od_nhits, od_cable, od_t, od_q)

      if(nhwt.ne.NUMHWSK) then
         print*,'tqskaz : #of HW trgs are strange ',nevsk,nhwt,numhwsk,nevhwsk
         print*,'call Koshio'
         stop
      endif

      do ihw = 1, NUMHWSK
         nevhw = ishft(iand(hwtrgid(ihw),2**17-1), 15)
         do ihit = 1, od_nhits(ihw)
            NHITAZ = NHITAZ + 1

c*** check length
            if (nhitaz.gt.maxpma*30) then 
               write(fname,8) nrunsk,nsubsk,nevsk
               write(0,*) '**************************************'
               write(0,*) ' Warning in tqskaz.F'
               write(0,*) ' Num. of hits in gate is too much'
               write(0,*) ' written in ',fname
               write(0,*) '**************************************'
               open(98,file=fname)
               write(98,*) 'Warning : exceed the array in tqskaz'
               close(98)
               NHITAZ = maxpma*30
               goto 202
            endif

            ICABAZ(NHITAZ) = od_cable(ihw,ihit)
            ITASKZ(NHITAZ) = od_t(ihw,ihit) + nevhw - it0sk
            IQASKZ(NHITAZ) = od_q(ihw,ihit)
            ITASKZ_raw(NHITAZ) = ITASKZ(NHITAZ)
            IQASKZ_raw(NHITAZ) = IQASKZ(NHITAZ)

c            print*,'HW',ihw,nhitaz,icabaz(nhitaz),itaskz(nhitaz),
c     &           iqaskz(nhitaz),  nevhw, it0sk

c*** set flag
            IHTFLZ(nhitaz) = iand(IQASKZ(nhitaz), 63488) ! select 15-11bit
            IHTFLZ(nhitaz) = ishft(IHTFLZ(nhitaz), -10) ! 15-11bit -> 5-1bit
            IHTFLZ(nhitaz) = IHTFLZ(nhitaz) + (ihw-1)*64 ! set 11-6bit 
            icabaz_raw(nhitaz) = ICABAZ(nhitaz) + (IHTFLZ(nhitaz) * 2**16)

cc            print *, IQASKZ(IHIT), IHTFLZ(IHIT),ITASKZ(IHIT),
cc     $           od_start, od_end

         enddo

 201     continue

      enddo

c*** set timing gate
 202  continue
      nhitaz_raw = nhitaz
      call set_timing_gate_od(it0xsk)

c*** normal end (skroot)
      RETURN

C --- w/o 'TQ' bank

 998  RETURN 1

      END
