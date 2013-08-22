************************************************************************
*     -------------------------------------
      subroutine skbadch(nrunb, nsubb, ierr)
*     -------------------------------------
*
*     (Purpose)
*        Read badch information and fill it into COMMON/COMBAD/ and /COMBADA/
*
*     (Input)
*        NRUNB ; run number
*        NSUBB ; sub run number
*
*     (Output)
*        ierr  ; -1 : error
*        ierr  ;  0 : normal end  no modification
*        ierr  ;  1 : normal end  read only badch.XXXXXX
*        ierr  ;  2 : normal end  read only badch.XXXXXX.XXXXXX
*        ierr  ;  3 : normal end  read only /skam/const/badch.dat
*        ierr  ;  4 : normal end  read only badch2/badch.XXXXXX
*        ierr  ;  5 : normal end  read only badch2/badch.XXXX00.XXXX99
*        ierr  ;+10 : normal end  additional read /skam/const/badch.dat
*
*     (Creation Date and Author)
*       1995.01.10 : First version by T.Hayakawa
*       1996.05.25 : modified by Y.Takeuchi
*             o implement results from "badsel"
*             o support "imaskbadopt" (setted by subroutine skbadopt)
*       1996.08.07 ; modified by Y. Takeuchi
*             o support outer detector
*       1996.12.18 ; modified by Y. Takeuchi
*             o support ierr==4 mode
*       1997.05.26 ; modified by Y. Takeuchi
*             o support ierr==5 mode
*             o remove "skbadch_old"
*       1998.03.03 ; modified by Y. Takeuchi
*             o modify rgetv()?
*             o add /COMBAD0/
*       2006.06.30 ; modified by Y. Takeuchi
*             o for linux (tentative)
*
************************************************************************
      implicit none

#include "skparm.h"
#include "skbadc.h"
#include "skmisch.h"
c arg
      integer*4 nrunb, nsubb, ierr

c constant
      integer*4 LUNINB
      parameter(LUNINB=30)
      character*132 file_name,fname,f1,f2,f3,f4,f5,f6,f7,f8
      data file_name/'/skam/const/badch.dat'/
C      parameter(file_name = '/skam/const/badch.dat')
      integer MAXSUB
      parameter (MAXSUB = 10)
c      character*24 CHEAD2   /'/skam/const/badch/badch.'/
c      character*25 CHEAD3   /'/skam/const/badch2/badch.'/

      character*6  frun          ! run number for badch.XXXXXX
ccyt      character*13 frunn         ! run numbers for badch.XXXX00.XXXX99
      character*15 frunn         ! run numbers for badch.XXXX00.XXXX99
      character*13 fileno        ! run & sub # for badch.XXXXXX.XXXXXX
      integer NDATA,MAXBAD,MAXDAT
      parameter (NDATA  = 100)   ! number of runs in a combine2 file
      parameter (MAXDAT = 200)   ! number of max badch per channel per file
      parameter (MAXBAD = 300)   ! number of max badch per run ???

c local variable
      real*4    r1
      integer*4 ihndl, loglv
      integer*4 isq, i, j, i1
      integer*4 runmin, runmax
c      logical*4 ex
      integer*4 nrunsv, nsubsv     ! run and subrun # of current data array
      integer*4 nbadsv, nbadsva    ! total number of bad cable
      integer*4 icab
      integer*4 jj, iibad, nsub_sta, nsub_sto

      integer*2 icab1,nbadsv1,nbadsva1,jj1
      integer*2 iibad1(MAXDAT), nsub_sta1(MAXDAT), nsub_sto1(MAXDAT)
      integer*2 nrun_sta1(MAXDAT), nrun_sto1(MAXDAT)

cMFechner : allow longer file names
      character*256 badchfile

c*** initialize 1
      ierr = 0
      loglv = 5

c     Output for checks
      write(*,*) 'USING MODIFIED SKBADCH'

c*** check run number and sub run number
      if (imaskbadopt.eq.imaskbad .and. nrunb.eq.nrunsv 
     $     .and. nsubb.eq.nsubsv) return

c************************************************************
c*** special treatment for the old runs (old badch format)
c      if (nrunb.lt.2435) then
c         call skbadch_old(nrunb, nsubb, ierr)
c         return
c      endif
c************************************************************

c*** fill /combad0/ *****************************************
      call skbadch00(nrunb, nsubb)
c************************************************************

c*** initialize 2
      nbad = 0
      nbada = 0
      call lbfset0(ibad, MAXPM)
      call lbfset0(isqbad, MAXNBD)
      call lbfset0(ibada, MAXPMA)
      call lbfset0(isqbada, MAXNBDA)

c*** check nrun
      if (nrunb.le.0) return

c*** fill -1 to PMT on missing position at SK-II
      call skmisch
      do i=1,maxpm
         if(imis(i).ne.0) ibad(i) = -1
      enddo

      if (imaskbadopt.eq.1) goto 2000

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c*** read badch info. from badch2/badch.XXXXXX
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c*** check badch file
      write(frun, 10) nrunb
c      inquire(file=CHEAD3//frun, exist=ex)
c      if (.not.ex) goto 800

      call findconsts(badchfile,'badch.'//frun,'badch2/badch.'//frun,LOGLV)
      if (badchfile(1:1).eq.' ') goto 800

c*** read badch file 
c      open(99, file=CHEAD3//frun, status='old', form='formatted')
      open(99, file=badchfile, status='old', form='formatted')
      read(99,*,err=800,end=800) nrunsv, nbadsv, nbadsva
c*** inner detector
      nbad = 0
      do 310 i = 1, nbadsv
         jj = 1
         read(99,*,err=800,end=800) icab, jj, iibad, nsub_sta, nsub_sto
         if (nsubb.ge.nsub_sta .and. nsubb.le.nsub_sto) then
            if (imaskbadopt.ne.0 .and. imaskbadopt.ne.-1) then
               if (.not.btest(imaskbadopt, iibad)) goto 310
            endif
            nbad = nbad + 1
            ibad(icab) = iibad
            if (nbad.le.MAXNBD) then
               isqbad(nbad)=icab
            endif
         endif

         do 300 j = 2, jj
            read(99,*,err=800,end=800) icab, jj, iibad, nsub_sta, nsub_sto
            if (nsubb.ge.nsub_sta .and. nsubb.le.nsub_sto) then
               if (imaskbadopt.ne.0 .and. imaskbadopt.ne.-1) then
                  if (.not.btest(imaskbadopt, iibad)) goto 300
               endif
               nbad = nbad + 1
               ibad(icab) = iibad
               if (nbad.le.MAXNBD) then
                  isqbad(nbad)=icab
               endif
            endif
 300     continue
 310  continue

c*** outer detector
      nbada = 0
      if (imaskbadopt.ne.0 .and. imaskbadopt.ne.-1 
     $     .and. (.not.btest(imaskbadopt,4))) goto 335
      do 330 i = 1, nbadsva
         jj = 1
         read(99,*,err=800,end=800) icab, jj, iibad, nsub_sta, nsub_sto
         if (nsubb.ge.nsub_sta .and. nsubb.le.nsub_sto) then
            nbada = nbada + 1
            ibada(icab) = iibad
            if (nbada.le.MAXNBDA) then
               isqbada(nbada)=icab
            endif
         endif
         do 320 j = 2, jj
            read(99,*,err=800,end=800) icab, jj, iibad, nsub_sta, nsub_sto
            if (nsubb.ge.nsub_sta .and. nsubb.le.nsub_sto) then
               nbada = nbada + 1
               ibada(icab) = iibad
               if (nbada.le.MAXNBDA) then
                  isqbada(nbada)=icab
               endif
            endif
 320     continue
 330  continue
 335  continue
      close(99)

c*** read both badch information
      ierr = 4
      if (imaskbadopt.eq.0) goto 3000
      if (btest(imaskbadopt,0)) goto 3000

c*** normal end
      imaskbad = imaskbadopt
      nrunsv = nrunb
      nsubsv = nsubb
      RETURN

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c*** read badch info. from badch2/badch.XXXX00.XXXX99 (combine2)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
 800  continue

c*** check badch file
      i = nrunb - mod(nrunb, NDATA)
      write(frunn, 411) i, i+NDATA-1
ccyt 411  format(i6.6, '.', i6.6)
 411  format(i6.6, '.', i6.6,'.t')

c      inquire(file=CHEAD3//frunn, exist=ex)
c      if (.not.ex) goto 900

      call findconsts(badchfile,'badch.'//frunn,'badch2/badch.'//frunn,LOGLV)

      if (badchfile(1:1).eq.' ') goto 900

c*** read badch file 
c      open(99, file=CHEAD3//frunn, status='old', form='unformatted')
ccyt      open(99, file=badchfile, status='old', form='unformatted')
      open(99, file=badchfile, status='old', form='formatted')
ccyt      read(99) i, j, nbadsv1, nbadsva1
      read(99,*,err=900,end=900) i, j, nbadsv1, nbadsva1

c*** inner detector
      nbad = 0
      do 410 i = 1, nbadsv1
ccyt         read(99,err=900) icab1, jj1, (iibad1(j),
         read(99,*,err=900,end=900) icab1, jj1, (iibad1(j),
     $        nrun_sta1(j), nsub_sta1(j),
     $        nrun_sto1(j), nsub_sto1(j), j=1, jj1)
         if (jj1.gt.MAXDAT) goto 900

         do 440 j = 1, jj1
            if (nrun_sta1(j).lt.nrunb 
     $           .or. (nrun_sta1(j).eq.nrunb .and. 
     $                 nsub_sta1(j).le.nsubb)) then
               if (nrun_sto1(j).gt.nrunb 
     $              .or. (nrun_sto1(j).eq.nrunb .and. 
     $                    nsub_sto1(j).ge.nsubb)) then
                  if (imaskbadopt.ne.0 .and. imaskbadopt.ne.-1) then
                     if (.not.btest(imaskbadopt, iibad1(j))) goto 410
                  endif
                  nbad = nbad + 1
                  ibad(icab1) = iibad1(j)
                  if (nbad.le.MAXNBD) then
                     isqbad(nbad)=icab1
                  endif
               endif
            endif
 440     continue
 410  continue

c*** outer detector
      nbada = 0
      if (imaskbadopt.ne.0 .and. imaskbadopt.ne.-1 
     $     .and. (.not.btest(imaskbadopt,4))) goto 435
      do 430 i = 1, nbadsva1
ccyt         read(99,err=900) icab1, jj1, (iibad1(j),
         read(99,*,err=900,end=900) icab1, jj1, (iibad1(j),
     $        nrun_sta1(j), nsub_sta1(j),
     $        nrun_sto1(j), nsub_sto1(j), j=1, jj1)
         if (jj1.gt.MAXDAT) goto 900

         do 420 j = 1, jj1
            if (nrun_sta1(j).lt.nrunb 
     $           .or. (nrun_sta1(j).eq.nrunb .and. 
     $                 nsub_sta1(j).le.nsubb)) then
               if (nrun_sto1(j).gt.nrunb 
     $              .or. (nrun_sto1(j).eq.nrunb .and. 
     $                    nsub_sto1(j).ge.nsubb)) then
                  nbada = nbada + 1
                  ibada(icab1) = iibad1(j)
                  if (nbada.le.MAXNBDA) then
                     isqbada(nbada)=icab1
                  endif
               endif
            endif
 420     continue
 430  continue
 435  continue
      close(99)

c*** read both badch information
      ierr = 5
      if (imaskbadopt.eq.0) goto 3000
      if (btest(imaskbadopt,0)) goto 3000

c*** normal end
      imaskbad = imaskbadopt
      nrunsv = nrunb
      nsubsv = nsubb
      RETURN

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c*** read badch info. from badch.XXXXXX
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
 900  continue

c*** check badch file
      write(frun, 10) nrunb
 10   format(I6.6)
c      inquire(file=CHEAD2//frun, exist=ex)
cc      write(*,*) 'checking ', CHEAD2//frun, ' = ', ex
c      if (.not.ex) goto 1000

      call findconsts(badchfile,'badch.'//frun,'badch/badch.'//frun,LOGLV)

      if (badchfile(1:1).eq.' ') goto 1000


c*** read badch file 
c      open(99, file=CHEAD2//frun, status='old', form='formatted')
      open(99, file=badchfile, status='old', form='formatted')
      read(99,*,err=1000,end=1000) nrunsv, nbadsv, nbadsva
c*** inner detector
      nbad = 0
      do 110 i = 1, nbadsv
         jj = 1
         read(99,*,err=1000,end=1000) icab, jj, iibad, nsub_sta, nsub_sto
         if (nsubb.ge.nsub_sta .and. nsubb.le.nsub_sto) then
            if (imaskbadopt.ne.0 .and. imaskbadopt.ne.-1) then
               if (.not.btest(imaskbadopt, iibad)) goto 110
            endif
            nbad = nbad + 1
            ibad(icab) = iibad
            if (nbad.le.MAXNBD) then
               isqbad(nbad)=icab
            endif
         endif

         do 100 j = 2, jj
            read(99,*,err=1000,end=1000) icab, jj, iibad, nsub_sta, nsub_sto
            if (nsubb.ge.nsub_sta .and. nsubb.le.nsub_sto) then
               if (imaskbadopt.ne.0 .and. imaskbadopt.ne.-1) then
                  if (.not.btest(imaskbadopt, iibad)) goto 100
               endif
               nbad = nbad + 1
               ibad(icab) = iibad
               if (nbad.le.MAXNBD) then
                  isqbad(nbad)=icab
               endif
            endif
 100     continue
 110  continue

c*** outer detector
      nbada = 0
      if (imaskbadopt.ne.0 .and. imaskbadopt.ne.-1 
     $     .and. (.not.btest(imaskbadopt,4))) goto 135
      do 130 i = 1, nbadsva
         jj = 1
         read(99,*,err=1000,end=1000) icab, jj, iibad, nsub_sta, nsub_sto
         if (nsubb.ge.nsub_sta .and. nsubb.le.nsub_sto) then
            nbada = nbada + 1
            ibada(icab) = iibad
            if (nbada.le.MAXNBDA) then
               isqbada(nbada)=icab
            endif
         endif
         do 120 j = 2, jj
            read(99,*,err=1000,end=1000) icab, jj, iibad, nsub_sta, nsub_sto
            if (nsubb.ge.nsub_sta .and. nsubb.le.nsub_sto) then
               nbada = nbada + 1
               ibada(icab) = iibad
               if (nbada.le.MAXNBDA) then
                  isqbada(nbada)=icab
               endif
            endif
 120     continue
 130  continue
 135  continue
      close(99)

c*** read both badch information
      ierr = 1
      if (imaskbadopt.eq.0) goto 3000
      if (btest(imaskbadopt,0)) goto 3000

c*** normal end
      imaskbad = imaskbadopt
      nrunsv = nrunb
      nsubsv = nsubb
      RETURN

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c*** read badch info. from badch.XXXXXX.XXXXXX
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
 1000 continue

c*** check badch file
      write(fileno, 20) nrunb, nsubb
 20   format(I6.6, '.', I6.6)
c      inquire(file=CHEAD2//fileno, exist=ex)
cc      write(*,*) 'checking ', CHEAD2//fileno, ' = ', ex
c      if (.not.ex) goto 2000

      call findconsts(badchfile,'badch.'//fileno,'badch/badch.'//fileno,LOGLV)

ccyt 2008/10/30 to load badch.dat 
ccyt      if (badchfile(1:1).eq.' ') goto 5000
      if (badchfile(1:1).eq.' ') then
         if (imaskbadopt.eq.0 .or. btest(imaskbadopt,0)) then
            print *, 'No bad channel file for ', fileno
            goto 3000
         else
            goto 5000
         endif
      endif

c*** read badch data
c      open(99, file=CHEAD2//fileno,
c     $     status='old', form='formatted')
      open(99, file=badchfile,
     $     status='old', form='formatted')

cc modified for SK-IV
cc      read(99,*,err=5000,end=5000) nrunsv, i1, i1, nbadsv, nbadsva
cc      read(99,*,err=5000,end=5000) i1
cc      read(99,*,err=5000,end=5000) r1

      read(99,*,err=5000,end=5000) nrunsv,i1,i1,nbadsv,nbadsva,
     $     r1,r1,r1,r1,r1,i1,i1,r1,r1,r1,r1
      read(99,*,err=5000,end=5000) i1,i1,i1,i1,i1,i1,i1,i1,i1,
     $     i1,i1,i1,i1,i1

c*** inner detector
      nbad = 0
      do 210 i = 1, nbadsv
         read(99,*,err=5000,end=5000) icab, iibad
         if (imaskbadopt.ne.0 .and. imaskbadopt.ne.-1) then
            if (.not.btest(imaskbadopt, iibad)) goto 210
         endif
         nbad = nbad + 1
         ibad(icab) = iibad
         if (nbad.le.MAXNBD) then
            isqbad(nbad)=icab
         endif
 210  continue
c*** outer detector
      nbada = 0
      if (imaskbadopt.ne.0 .and. imaskbadopt.ne.-1 
     $     .and. (.not.btest(imaskbadopt,4))) goto 225
      iibad = 4   ! fixed for OD
      do 220 i = 1, nbadsva
         read(99,*,err=5000,end=5000)  icab
         nbada = nbada + 1
         ibada(icab) = iibad
         if (nbada.le.MAXNBDA) then
            isqbada(nbada)=icab
         endif
 220  continue
 225  continue
      close(99)

c*** read both badch information
      ierr = 2
      if (imaskbadopt.eq.0) goto 3000
      if (btest(imaskbadopt,0)) goto 3000

c*** normal end
      imaskbad = imaskbadopt
      nrunsv = nrunb
      nsubsv = nsubb
      RETURN

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c**** read badch info. from "/skam/pro/const/badch.dat"
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
 2000 continue
      nbad = 0
      nbada = 0

      call rgetv(LUNINB,1,fname,f1,f2,f3,f4,f5,f6,f7,f8)
      if(fname.eq.' ') then
cc         write(6,'(A,A)')'Bad Channel file is :',file_name
         call findconsts(file_name,'bad channel','badch.dat',LOGLV)
         call set_rflist(LUNINB,file_name,'LOCAL',' ',
     &        'RED',' ',' ','form=formatted',' ',' ')
      else
cc         write(6,*) 'Bad Channel file is as follows;',fname
      endif
      call skopenf(LUNINB,1,'f',ihndl)
      if(ihndl.lt.0)then
         write(*,*)'error in badch.F:ihndle = ',ihndl
         ierr = ihndl
         return
      endif

 1    continue
         read(LUNINB,*,ERR=5000,end=5000) isq
         if(isq.lt.0)goto 2
 50      continue
            read(LUNINB,*,end=5000,err=5000)runmin,runmax
            if(runmin.lt.0)goto 51
            if(nrunb.ge.runmin .AND. nrunb.le.runmax
     &           .and. ibad(isq).eq.0) then
               nbad = nbad+1
               ibad(isq)=99
               if(nbad.le.MAXNBD)then
                  isqbad(nbad)=isq
               endif
            endif
         goto 50
 51      continue            
      goto 1

 2    continue
      call skclosef(LUNINB)

      ierr = 3
      imaskbad = 1
      nrunsv = nrunb
      nsubsv = nsubb
      RETURN

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c**** read badch info. from "/skam/pro/const/badch.dat" (check extra)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
 3000 continue
      call rgetv(LUNINB,1,fname,f1,f2,f3,f4,f5,f6,f7,f8)
      if(fname.eq.' ') then
cc         write(6,'(A,A)')'Bad Channel file is :',file_name
         call findconsts(file_name,'bad channel','badch.dat',LOGLV)
         call set_rflist(LUNINB,file_name,'LOCAL',' ',
     &        'RED',' ',' ','form=formatted',' ',' ')
      else
cc         write(6,*) 'Bad Channel file is as follows;',fname
      endif
      call skopenf(LUNINB,1,'f',ihndl)
      if(ihndl.lt.0)then
         write(*,*)'error in skbadch.F:ihndle = ',ihndl
         ierr = ihndl
         return
      endif

 3001 continue
         read(LUNINB,*,ERR=5000,end=5000) isq
         if(isq.lt.0)goto 3002
 3050    continue
            read(LUNINB,*,err=5000,end=5000)runmin,runmax
            if(runmin.lt.0)goto 3051
            if(nrunb.ge.runmin .AND. nrunb.le.runmax
     $           .and. ibad(isq).eq.0) then
               nbad = nbad+1
               ibad(isq)=99
               if(nbad.le.MAXNBD)then
                  isqbad(nbad)=isq
               endif
            endif
            goto 3050
 3051       continue            
      goto 3001

 3002 continue
      call skclosef(LUNINB)

      ierr = ierr + 10
      imaskbad = imaskbadopt
      nrunsv = nrunb
      nsubsv = nsubb
      RETURN

 5000 CONTINUE
      print *,'ERROR in bad channel file'
      ierr = -1
      RETURN

      END

************************************************************************
*     -------------------------------------
      subroutine skbadch00(nrunb, nsubb)
*     -------------------------------------
*
*     (Purpose)
*        Read badch information and fill it into COMMON/COMBAD0/
*
*     (Input)
*        NRUNB ; run number
*        NSUBB ; sub run number
*
*     (Creation Date and Author)
*       1998.03.03 ; first version by Y.Takeuchi
************************************************************************
      implicit none

#include "skparm.h"
#include "skbadc.h"
#include "skmisch.h"
c arg
      integer*4 nrunb, nsubb, ierr

c constant
      integer*4 LUNINB
      parameter(LUNINB=30)
      character*132 file_name,fname,f1,f2,f3,f4,f5,f6,f7,f8
      data file_name /'/skam/const/badch.dat'/
C      parameter(file_name = '/skam/const/badch.dat')
      integer MAXSUB
      parameter (MAXSUB = 10)
c      character*24 CHEAD2   /'/skam/const/badch/badch.'/
c      character*25 CHEAD3   /'/skam/const/badch2/badch.'/

      character*6  frun          ! run number for badch.XXXXXX
ccyt      character*13 frunn         ! run numbers for badch.XXXX00.XXXX99
      character*15 frunn         ! run numbers for badch.XXXX00.XXXX99
      character*13 fileno        ! run & sub # for badch.XXXXXX.XXXXXX
      integer NDATA,MAXBAD,MAXDAT
      parameter (NDATA  = 100)   ! number of runs in a combine2 file
      parameter (MAXDAT = 200)   ! number of max badch per channel per file
      parameter (MAXBAD = 300)   ! number of max badch per run ???

c local variable
      real*4    r1
      integer*4 ihndl, loglv
      integer*4 isq, i, j, i1
      integer*4 runmin, runmax
c      logical*4 ex
      integer*4 nrunsv             ! run and subrun # of current data array
      integer*4 nbadsv, nbadsva    ! total number of bad cable
      integer*4 icab
      integer*4 jj, iibad, nsub_sta, nsub_sto

      integer*2 icab1,nbadsv1,nbadsva1,jj1
      integer*2 iibad1(MAXDAT), nsub_sta1(MAXDAT), nsub_sto1(MAXDAT)
      integer*2 nrun_sta1(MAXDAT), nrun_sto1(MAXDAT)

cMFechner : allow longer file names
      character*256 badchfile

c*** initialize
      nbad0 = 0
      loglv = 5
      call lbfset0(ibad0, MAXPM)
      call lbfset0(isqbad0, MAXNBD)

c*** fill -1 to PMT on missing position at SK-II
      call skmisch
      do i=1,maxpm
         if(imis(i).ne.0) ibad0(i) = -1
      enddo

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c*** read badch info. from badch2/badch.XXXXXX
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c*** check badch file
      write(frun, 10) nrunb
c      inquire(file=CHEAD3//frun, exist=ex)
c      if (.not.ex) goto 800

      call findconsts(badchfile,'badch.'//frun,'badch2/badch.'//frun,LOGLV)

      if (badchfile(1:1).eq.' ') goto 800



c*** read badch file 
c      open(99, file=CHEAD3//frun, status='old', form='formatted')
      open(99, file=badchfile, status='old', form='formatted')
      read(99,*,err=800,end=800) nrunsv, nbadsv, nbadsva
c*** inner detector
      nbad0 = 0
      do 310 i = 1, nbadsv
         jj = 1
         read(99,*,err=800,end=800) icab, jj, iibad, nsub_sta, nsub_sto
         if (nsubb.ge.nsub_sta .and. nsubb.le.nsub_sto) then
            nbad0 = nbad0 + 1
            ibad0(icab) = iibad
            if (nbad0.le.MAXNBD) then
               isqbad0(nbad0)=icab
            endif
         endif

         do 300 j = 2, jj
            read(99,*,err=800,end=800) icab, jj, iibad, nsub_sta, nsub_sto
            if (nsubb.ge.nsub_sta .and. nsubb.le.nsub_sto) then
               nbad0 = nbad0 + 1
               ibad0(icab) = iibad
               if (nbad0.le.MAXNBD) then
                  isqbad0(nbad0)=icab
               endif
            endif
 300     continue
 310  continue
      close(99)

c*** read both badch information
      goto 3000

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c*** read badch info. from badch2/badch.XXXX00.XXXX99 (combine2)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
 800  continue

c*** check badch file
      i = nrunb - mod(nrunb, NDATA)
      write(frunn, 411) i, i+NDATA-1
ccyt 411  format(i6.6, '.', i6.6)
 411  format(i6.6, '.', i6.6,'.t')


c      inquire(file=CHEAD3//frunn, exist=ex)
c      if (.not.ex) goto 900

      call findconsts(badchfile,'badch.'//frunn,'badch2/badch.'//frunn,LOGLV)

      if (badchfile(1:1).eq.' ') goto 900


c*** read badch file 
c      open(99, file=CHEAD3//frunn, status='old', form='unformatted')
ccyt      open(99, file=badchfile, status='old', form='unformatted')
      open(99, file=badchfile, status='old', form='formatted')
ccyt      read(99) i, j, nbadsv1, nbadsva1
      read(99,*,err=900,end=900) i, j, nbadsv1, nbadsva1


c*** inner detector
      nbad0 = 0
      do 410 i = 1, nbadsv1
ccyt         read(99,err=900) icab1, jj1, (iibad1(j),
         read(99,*,err=900,end=900) icab1, jj1, (iibad1(j),
     $        nrun_sta1(j), nsub_sta1(j),
     $        nrun_sto1(j), nsub_sto1(j), j=1, jj1)
         if (jj1.gt.MAXDAT) goto 900

         do 440 j = 1, jj1
            if (nrun_sta1(j).lt.nrunb 
     $           .or. (nrun_sta1(j).eq.nrunb .and. 
     $                 nsub_sta1(j).le.nsubb)) then
               if (nrun_sto1(j).gt.nrunb 
     $              .or. (nrun_sto1(j).eq.nrunb .and. 
     $                    nsub_sto1(j).ge.nsubb)) then
                  nbad0 = nbad0 + 1
                  ibad0(icab1) = iibad1(j)
                  if (nbad0.le.MAXNBD) then
                     isqbad0(nbad0)=icab1
                  endif
               endif
            endif
 440     continue
 410  continue
      close(99)



c*** read both badch information
      goto 3000

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c*** read badch info. from badch.XXXXXX
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
 900  continue


c*** check badch file
      write(frun, 10) nrunb
 10   format(I6.6)
c      inquire(file=CHEAD2//frun, exist=ex)
cc      write(*,*) 'checking ', CHEAD2//frun, ' = ', ex
c      if (.not.ex) goto 1000


      call findconsts(badchfile,'badch.'//frun,'badch/badch.'//frun,LOGLV)

      if (badchfile(1:1).eq.' ') goto 1000

c*** read badch file 
c      open(99, file=CHEAD2//frun, status='old', form='formatted')
      open(99, file=badchfile, status='old', form='formatted')
      read(99,*,err=1000,end=1000) nrunsv, nbadsv, nbadsva
c*** inner detector
      nbad0 = 0
      do 110 i = 1, nbadsv
         jj = 1
         read(99,*,err=1000,end=1000) icab, jj, iibad, nsub_sta, nsub_sto
         if (nsubb.ge.nsub_sta .and. nsubb.le.nsub_sto) then
            nbad0 = nbad0 + 1
            ibad0(icab) = iibad
            if (nbad0.le.MAXNBD) then
               isqbad0(nbad0)=icab
            endif
         endif

         do 100 j = 2, jj
            read(99,*,err=1000,end=1000) icab, jj, iibad, nsub_sta, nsub_sto
            if (nsubb.ge.nsub_sta .and. nsubb.le.nsub_sto) then
               nbad0 = nbad0 + 1
               ibad0(icab) = iibad
               if (nbad0.le.MAXNBD) then
                  isqbad0(nbad0)=icab
               endif
            endif
 100     continue
 110  continue
      close(99)


c*** read both badch information
      goto 3000

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c*** read badch info. from badch.XXXXXX.XXXXXX
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
 1000 continue


c*** check badch file
      write(fileno, 20) nrunb, nsubb
 20   format(I6.6, '.', I6.6)
c      inquire(file=CHEAD2//fileno, exist=ex)
cc      write(*,*) 'checking ', CHEAD2//fileno, ' = ', ex
c      if (.not.ex) goto 3000

      call findconsts(badchfile,'badch.'//fileno,'badch/badch.'//fileno,LOGLV)


      if (badchfile(1:1).eq.' ') goto 3000


c*** read badch data
c      open(99, file=CHEAD2//fileno,
c     $     status='old', form='formatted')
      open(99, file=badchfile,
     $     status='old', form='formatted')

cc modified for SK-IV
cc      read(99,*,err=3000,end=3000) nrunsv, i1, i1, nbadsv, nbadsva
cc      read(99,*,err=3000,end=3000) i1
cc      read(99,*,err=3000,end=3000) r1

      read(99,*,err=3000,end=3000) nrunsv,i1,i1,nbadsv,nbadsva,
     $     r1,r1,r1,r1,r1,i1,i1,r1,r1,r1,r1
      read(99,*,err=3000,end=3000) i1,i1,i1,i1,i1,i1,i1,i1,i1,
     $     i1,i1,i1,i1,i1

c*** inner detector
      nbad0 = 0
      do 210 i = 1, nbadsv
         read(99,*,err=3000,end=3000) icab, iibad
         nbad0 = nbad0 + 1
         ibad0(icab) = iibad
         if (nbad0.le.MAXNBD) then
            isqbad0(nbad0)=icab
         endif
 210  continue
      close(99)

c*** read both badch information
      goto 3000


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c**** read badch info. from "/skam/pro/const/badch.dat" (check extra)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
 3000 continue
      call rgetv(LUNINB,1,fname,f1,f2,f3,f4,f5,f6,f7,f8)
      if(fname.eq.' ') then
cc         write(6,'(A,A)')'Bad Channel file is :',file_name
         call findconsts(file_name,'bad channel','badch.dat',LOGLV)
         call set_rflist(LUNINB,file_name,'LOCAL',' ',
     &        'RED',' ',' ','form=formatted',' ',' ')
      else
cc         write(6,*) 'Bad Channel file is as follows;',fname
      endif
      call skopenf(LUNINB,1,'f',ihndl)
      if(ihndl.lt.0)then
         write(*,*)'error in skbadch.F:ihndle = ',ihndl
         ierr = ihndl
         return
      endif

 3001 continue
         read(LUNINB,*,ERR=5000,end=5000) isq
         if(isq.lt.0)goto 3002
 3050    continue
            read(LUNINB,*,err=5000,end=5000)runmin,runmax
            if(runmin.lt.0)goto 3051
            if(nrunb.ge.runmin .AND. nrunb.le.runmax
     $           .and. ibad0(isq).eq.0) then
               nbad0 = nbad0+1
               ibad0(isq)=99
               if(nbad0.le.MAXNBD)then
                  isqbad0(nbad0)=isq
               endif
            endif
            goto 3050
 3051       continue            
      goto 3001

 3002 continue
      call skclosef(LUNINB)

      RETURN

 5000 CONTINUE
      print *,'ERROR in bad channel file'
      ierr = -1
      RETURN

      END
