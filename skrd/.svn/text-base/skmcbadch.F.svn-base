      subroutine skmcbadch(iyear,iphase,irun,isub)

*
* give a run number for using badch table for MC
* SKOPTN(27) needed
* 1998.Mar.27 Created by Y.Itow
* input : iyear / year number of atmpd MC ( = NSUBSK)
* output: iphase / phase for badch table , if not exist =-1
*       : irun, isub / run  and subrun number to be used for badch table
*
* 1999.NOV.3 : badch run assignment
*      -> skopenf(72)/getenv BADCNT_FILE/assign internaly
*
* 2007.SEP.13 : modified for SK2,SK3 by C.Ishihara
*               if iyear=nsubsk=0, MC badch is used as
*                        run# 2892  for SK-I
*                        run# 21926 for SK-II
*                        run# 31800 for SK-III
*
* 2008.DEC.24 : update/modification for SK3,SK4 by C.I.
*

* BADCH sample run number
*
* 1  2508 1996-8-11 
C* 2  2596 1996-8-23
* 2  3033 1996-11-1 
C* 4  3397 1997-1-15 
* 3  3573 1997-2-15
C* 6  4192 1997-6-5
* 4  4534 1997-8-7
C* 8  4857 1997-10-1
* 5  5318 1997-12-4 
C*10  5720 1998-3-26
*6  5905 1998-6-10
C*12  6103 1998-8-10
*7  6281 1998-10-21 
C*14  6533 1998-11-28 
*8  6898 1999-2-1
C*16  7074 1999-3-12
*9  7312 1999-5-9  
C*18  7460 1999-6-30
*10  7820 1999-9-7
C*20  7940 1999-10-10

      implicit none

#include "skhead.h"
      
      integer ifirst /0/
      save ifirst
      integer ifound 
      integer iphase,iyear,irun,isub
      integer nphase,nyear
      integer maxnphase
      parameter (maxnphase = 10)
      integer nrunbad(maxnphase)

c --sk1
      integer nrunbad1(maxnphase)
      data nrunbad1 /
     + 2508, 3033,  3573, 4534,  5318, 
     + 5905, 6281, 6898, 7312, 7820/
c --sk2
      integer nrunbad2(maxnphase)
      data nrunbad2 /
     + 21993, 22488, 23214, 23658, 24008, 
     + 24402, 24730, 24954, 25256, 25621/
c --sk3
      integer nrunbad3(maxnphase)
      data nrunbad3 /
     + 31615, 31855, 32067, 32378, 32963,
     + 33201, 33578, 34027, 34378, 35164/
c --sk4
      integer nrunbad4(maxnphase)
      data nrunbad4 /
     + 62361, 62361, 62361, 62361, 62361,
     + 62361, 62361, 62361, 62361, 62361/

      integer nsubbad(1:maxnphase)
      data nsubbad /1,1,1,1,1,1,1,1,1,1/
      save nrunbad,nsubbad

      integer maxsub,numsub
      parameter (maxsub = 100)
      integer iphasebuf(2,maxsub)
      save iphasebuf
      
      integer lbank
      integer lunbadcnt /72/
      save lunbadcnt

      integer maxnbuf,nd
      parameter (maxnbuf=8)
      integer ibuf(maxnbuf)
      integer ibnkdate
      integer iarr1(3),iarr2(3),ierr

      character*128 cnt_badch

      integer i,itmp

      integer weallcount/0/
      save weallcount

c --input runnum
      
      if(SK_GEOMETRY.eq.1) then
         call UCOPY(nrunbad1,nrunbad,maxnphase)
      elseif(SK_GEOMETRY.eq.2) then
         call UCOPY(nrunbad2,nrunbad,maxnphase)
      elseif(SK_GEOMETRY.eq.3) then
         call UCOPY(nrunbad3,nrunbad,maxnphase)
      elseif(SK_GEOMETRY.eq.4) then
         call UCOPY(nrunbad4,nrunbad,maxnphase)
      else
         write(*,*) 'skmcbadch.F: SK_GEOMETRY =',SK_GEOMETRY,
     &                    ' is not supported yet'
      endif

c KS Jan 2000
c Set year for case of nsubsk(=iyear)=0 or nsubsk>maxsub

c      if (iyear.eq.0) then
c         iyear = mod(weallcount,maxsub)
c         weallcount=weallcount+1
c      endif

      if (iyear.gt.maxsub) then
         iyear = mod(iyear,maxsub)
      endif

c  check badrun inf exists ?
      call kzbloc('APBADCHINF',lbank)
c ----------------------------------------
c if no bank and 1st event, read from file
c ----------------------------------------
      if (lbank.le.0) then
c---------------------------------------------------
c if first time , set phase list (from file or mod)
c---------------------------------------------------         
         if(ifirst.eq.0)then            

            if(iyear.eq.0)goto 90

            numsub = 0
            call skopenf(lunbadcnt,1,'f',ierr)
            if(ierr.lt.0)then
               write(6,*)'SKMCBADCH-W-read from BADCNT_FILE'//cnt_badch
               call getenv('BADCNT_FILE',cnt_badch)
               open(unit=lunbadcnt,file=cnt_badch,status='old',
     $err=91919)               
            else
               write(6,*)' %SKMCBADCH-W-read from LUN=72'
            endif
C-------------------------------            
CCC read badch controle file
C-------------------------------      
 98         continue
              read(lunbadcnt,*,end=99,err=99)nyear,nphase
              if(numsub.ge.maxsub)goto 99
              numsub = numsub + 1
              iphasebuf(1,numsub) = nyear
              iphasebuf(2,numsub) = nphase
            goto 98
 99         continue
            close(lunbadcnt)
            goto 90
c== jump to endif (normal case)
91919 continue
c== if file not found, use mod      
            write(6,*)' %SKMCBADCH-W-no APBADCHINF:using mod'
            numsub = maxsub
            do i=1,numsub
               iphasebuf(1,i)=i

               itmp=mod(i,maxnphase)

c               if(itmp.eq.0)itmp=itmp+1
               if(itmp.eq.0)itmp=10

               iphasebuf(2,i)=itmp
            enddo

 90         continue
            ifirst = 1
         endif
        
c-----------------------------
c search in iphasebuf to find iphase, irun,isub 
c------------------------------
         ifound = 0

         if (iyear.eq.0) then   ! if nsubsk==0, use fixed nrun
            if(SK_GEOMETRY.eq.1)then
               irun = 2892
               isub = 1
            elseif(SK_GEOMETRY.eq.2)then
               irun = 21926
               isub = 1
            elseif(SK_GEOMETRY.eq.3)then
               irun = 31800
               isub = 1
            elseif(SK_GEOMETRY.eq.4)then
               irun = 62361
               isub = 1
            else
               write(*,*), 'skmcbadch.F: SK_GEOMETRY =',SK_GEOMETRY,
     &                    ' is not supported yet'
            endif  
            iphase = 999

            ifound = 1            

         else
            do i=1, numsub
               nyear = iphasebuf(1,i)
               if(nyear.eq.iyear)then
                  nphase = iphasebuf(2,i)
                  if(nphase.gt.0.and.nphase.le.maxnphase)then
                     iphase = nphase
                     irun = nrunbad(nphase)
                     isub = nsubbad(nphase)
                     ifound = 1
                     goto 97
                  endif
               endif
            enddo
         endif

 97      continue
        
c ----------------------------------------
c Create APBADCHINF bank
c ----------------------------------------
         if(ifound.eq.1)then
            call idate(iarr1)
            call itime(iarr2)
            ibnkdate=iarr1(2)*10**8+iarr1(1)*10**6+iarr2(1)*10**4
     +     +iarr2(2)*10**2+(iarr1(3)-1990)
            ibuf(1) = irun
            ibuf(2) = isub
            ibuf(3) = iphase
            ibuf(4) = ibnkdate
            call kzbcr1('APBADCHINF',maxnbuf,'-I',0,0,' ',ierr)
            if(ierr.ne.0)stop 'SKMCBADCH-I-cannot create bank'
            call kzrep1('APBADCHINF',0,maxnbuf,ibuf)
         else
            write(6,*)'SKMCBADCH-W-not found in  table:nyr=',iyear
            iphase = -1
            return
         endif
      else
c ----------------------------------------
c if bank,exists read from bank                  
c ----------------------------------------
C        write(6,*)' %SKREAD-I-badch info is read'//
C     +'from APBADCHINF'
        call vzero(ibuf,maxnbuf)
        call kzget1('APBADCHINF',0,nd,ibuf)
        irun = ibuf(1)
        isub = ibuf(2)
        iphase = ibuf(3)
        ibnkdate = ibuf(4)
        if(nd.ge.maxnbuf)then
C          write(6,*)'APBADCHINF-I-nd:',nd,' nphase=',iphase,
C     +' nrun=',irun,' nsub=',isub,' is used for BADCH'
        else
          write(6,*) 'SKMCBADCH-F-someting wrong in nd=',nd
          stop
        endif
      endif

      return
      
      end
