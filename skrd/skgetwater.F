C
      subroutine skgetwater
C
C     read a summary file of water job and
C     put the results(transparency and PMT gain)
C     into commons.
C
C     defined by Masato Shiozawa  Sep.-3-96
C
C     modify a little by Y.Itow 1997.04.28
C                include 'xxx' -> include "xxx"
C                integer flag -> logical*4 flag
C
C     modified for handling several version MC event
C     by Masato Shiozawa  May-7-97
C
C     New waterjob results are used.  Constant file is changed from
C     water.ave6 to water.ave7.
C     by Masato Shiozawa  Sep-7-2000
C
C     skwatergain of data is divided by 0.98 to adjust energy scale.
C     by Masato Shiozawa  Oct-21-2002
C
C     The factor 0.98 for skwatergain of data is not applied for SK-IV
C     by Masato Shiozawa  Mar.-3-2009
C
c   "darkgain(mean)" is introduced by Mine on 14 Dec., 2009
c    "water.ave7" -> "water.ave8" by Mine on 24 Dec., 2009
C      
c   "darkgain(peak)" is introduced by Mine on 03 April, 2009
c     water.ave8 -> water.ave9, DARKGAINNORM updated
C      
c     water.ave9 -> water.ave10 by Mine (May.12, 2011)
C      
C
      implicit none
      Integer lenchr
#include "skparm.h"
#include "skhead.h"
#include "sktq.h"
#include "skwaterlen.h"
#include "apversion.h"

C      Character*6 runnum
      Integer runnum
      Integer event,event2
      Character*9 datestring
      Real fdate,constant(3),trans(3)
      Integer date(3)

      Integer maxentry, entry, maxentry_mc, entry_mc
      Parameter (maxentry=16384)
      Parameter (maxentry_mc=32)
      Data entry/0/, entry_mc/0/
      Integer wtrunnum(maxentry)
      Real wttrans(maxentry), wtgain(maxentry)
      Integer wtrunnum_mc(maxentry_mc)
      Real wttrans_mc(maxentry_mc), wtgain_mc(maxentry_mc)
      Integer pre_runnum, pre_runmode
      Real pre_mcversion
      Data pre_runnum/-1/, pre_runmode/-1/, pre_mcversion/-1./


      Integer i
      Integer lun
      Data lun/98/
CCC      Integer flag
      logical flag
      Integer icall
      Data icall/0/
      Real factor
      Data factor/0.98/
C factor for charge scale correction for SK1,2,3  -by C.Ishihara
      Real corfactor(3)
      Data corfactor/1.018,1.008, 0.97/

      real petrack,cpetrack,ratio_small,ratio_large,darkgain

csm This norm. factor is to adjust <darkgain(peak)> in April,2009
csm  to <darkgain(mean)> in April, 2009 in default water.ave8
      real DARKGAINNORM
      parameter (DARKGAINNORM = 460.734)

csm increased from 100 to 200 to read darkgain
      Character*200 a
      Character*256 summary_file
C      Data summary_file/'/home/atmpd/www/water.sum'/
C      Data summary_file/'/skam/const/water.sum'/
C      Data summary_file/'/home/atmpd/www/water.ave6'/

C      summary_file = '/home/atmpd/www/watter.ave6'
C      summary_file = '/skam/const/water.ave6'
C      summary_file = '/u/bill3/casper/skroot/skam/new/lib/water.ave6'

      If (icall.eq.0) then
         icall=1
         entry = 0

         call findconsts(summary_file,'water attenuation water.ave10',
     &        'water.ave10',0)
#ifndef pgf77
         Inquire(file=summary_file(1:lenchr(summary_file))
     &        , exist=flag) 
#else
         Inquire(file=summary_file(1:lenchr(summary_file)))
#endif
         If (.not.flag) then
            write(6,*)'skgetwater: cannot find water attenuation file'
            stop
         Endif

         Open(lun,file=summary_file(1:lenchr(summary_file))
     &        ,form='formatted',status='old')
         write(6,*)'skgetwater: reading water file ',
     &        summary_file(1:lenchr(summary_file))

 20      Read(lun,'(a)',end=200, err=2000) a
         If (a(1:1).eq.'#') Goto 20
         Read(a,100) runnum,datestring,fdate,event2
     &        ,event
     &        ,constant(1),trans(1)
     &        ,constant(2),trans(2)
     &        ,constant(3),trans(3)
     &        ,petrack,cpetrack
     &        ,ratio_small,ratio_large,darkgain
csm         write(6,100) runnum,datestring,date(3),date(1),fdate,event2
csm     &        ,event
csm     &        ,constant(1),trans(1)
csm     &        ,constant(2),trans(2)
csm     &        ,constant(3),trans(3)
csm     &        ,petrack,cpetrack
csm     &        ,ratio_small,ratio_large,darkgain
 100     Format(i6.6,1x,a9,1x,f6.1,2x,i3,1x,i3,5x
     &        ,f5.1,1x,f7.1,3x,f5.1,1x,f7.1,3x,f5.1,1x,f7.1
     &        ,2x,f5.2,1x,f5.2,2x,f7.5,1x,f7.5,1x,f7.5)
         if (runnum.le.100) then
C     monte carlo
            If (entry_mc.lt.maxentry_mc) then
               entry_mc = entry_mc + 1
               wtrunnum_mc(entry_mc) = runnum
               wttrans_mc(entry_mc) = trans(3)
               if(runnum.lt.81) then
                  wtgain_mc(entry_mc) = constant(3)/700.
               else
                  wtgain_mc(entry_mc) = darkgain*DARKGAINNORM/700.
               endif
csm               write(6,*) 'wtgain_mc:',
csm     +              runnum,constant(3)/700., wtgain_mc(entry_mc)
            Endif
         Else
C     real data
            If (entry.lt.maxentry) then
               entry = entry + 1
               wtrunnum(entry) = runnum
               wttrans(entry) = trans(3)
               If (runnum.gt.100 .and. runnum.le.39999) then
C     for SK-I, II, III data
                  wtgain(entry) = constant(3)/700./factor
               Else if (runnum.ge.60000) then
csm                  wtgain(entry) = constant(3)/700.
csm  for SK4 data
                  wtgain(entry) = darkgain*DARKGAINNORM/700.
               Else
                  print *, 'skgetwater: read invarid run number = ',runnum
                  stop
               Endif
csm               write(6,*) 'wtgain:',
csm     +              runnum,constant(3)/700., wtgain(entry)
            Endif
         Endif

         Goto 20
 200     Close(lun)
      Endif

C     select value
      If (nrunsk.ne.pre_runnum.or.mdrnsk.ne.pre_runmode
     &     .or.(mdrnsk.eq.0.and.apdslibver.ne.pre_mcversion)) then
         If (mdrnsk.eq.0) then
C     monte carlo
            Do 76 i=1,maxentry_mc
C               modified to compensate rounding error  (K.Okumura)
C               ex. ifix(6.09999*10.)->60
C               If (wtrunnum_mc(i).eq.ifix(apdslibver*10.)) then
               If (wtrunnum_mc(i).eq.nint(apdslibver*10.)) then
                  skwaterlen = wttrans_mc(i)
                  skwatergain = wtgain_mc(i)
                  write(*,*) 'skgetwater: using MC run # '
     &                 ,wtrunnum_mc(i)
                  Goto 299
               Endif
 76         Continue
            skwaterlen = wttrans_mc(1)
            skwatergain = wtgain_mc(1)
 299        Continue
         Else
C     real data
            Do 77 i=1,maxentry
               If (wtrunnum(i).ge.nrunsk) then
                  skwaterlen = wttrans(i)
                  skwatergain = wtgain(i)
                  Goto 300
               Endif
 77         Continue
            skwaterlen = wttrans(entry)
            skwatergain = wtgain(entry)
 300        Continue

            if(sk_geometry.le.3)then
C               print *, 'skgetwater: skwatergain corrected for energy scale' !C.Ishihara
               skwatergain = skwatergain*corfactor(sk_geometry)
            endif

         Endif

         pre_runnum = nrunsk
         pre_runmode = mdrnsk
         pre_mcversion = apdslibver

         write(6,*) 'nrunsk skwaterlen skwatergain:', 
     +        nrunsk,skwaterlen,skwatergain


      Endif

      Return

 2000 continue
      print *, 'skgetwater: failed to read waterjob file('
     &     , summary_file(1:lenchr(summary_file))
     &     , ')'

      Stop

      End
