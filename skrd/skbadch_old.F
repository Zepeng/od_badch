************************************************************************
*     -------------------------------------
      subroutine skbadch_old(nrunb, nsubb, ierr)
*     -------------------------------------
*
*     (Purpose)
*        Read badch information and fill it into COMMON/COMBAD/
*
*     (Input)
*        NRUNB ; run number
*        NSUBB ; sub run number
*
*     (Output)
*        ierr  ; -1 : error
*        ierr  ;  1 : normal end  badch.XXXXXX
*        ierr  ;  2 : normal end  badch.XXXXXX.XXXXXX
*        ierr  ;  3 : normal end  /skam/pro/const/badch.dat
*        ierr  ;  4 : normal end  read badch.* and /skam/const/badch.dat
*
*     (Creation Date and Author)
*       1995.01.10 : First version by T.Hayakawa
*       1996.05.25 : modified by Y.Takeuchi
*             o implement results from "badsel"
*             o support "imaskbadopt" (setted by subroutine skbadopt)
*       1996.12.18 ; modified by Y. Takeuchi
*             o support ierr==4 mode
*
************************************************************************
      implicit none

#include "skparm.h"
#include "skbadc.h"
c arg
      integer*4 nrunb, nsubb, ierr

c constant
      integer*4 LUNINB
      parameter(LUNINB=30)
      character*80 file_name,fname,f1,f2,f3,f4,f5,f6,f7
      parameter(file_name = '/skam/const/badch.dat')
      integer MAXSUB
      parameter (MAXSUB = 10)
      character*24 CHEAD2   /'/skam/const/badch/badch.'/
      character*6  frun          ! run number for badch.XXXXXX
      character*13 fileno        ! run & sub # for badch.XXXXXX.XXXXXX

c local variable
      real*4    r1
      integer*4 ihndl
      integer*4 isq, i, j, i1
      integer*4 runmin, runmax
      logical*4 ex
      integer*4 nrunsv, nsubsv   ! run and subrun # of current data array
      integer*4 nbadsv           ! total number of bad cable
      integer*4 icab
      integer*4 jj
      integer*4 iibad
      integer*4 nsub_sta
      integer*4 nsub_sto

cc *** This commonn add by Y.I.  1997.Mar.19
cc *** for the consistency of nrunsv nsubsv between skbadch and skbadch_old
      common/skbadch_nrun_com/nrunsv,nsubsv

c*** initialize 1
      ierr = 0

c*** check run number and sub run number
      if (imaskbadopt.eq.imaskbad .and. nrunb.eq.nrunsv 
     $     .and. nsubb.eq.nsubsv) return

c*** initialize 2
      nbad = 0
      call lbfset0(ibad, MAXPM)
      call lbfset0(isqbad, MAXNBD)

c*** check nrun
      if (nrunb.le.0) return
      if (imaskbadopt.eq.1) goto 2000

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c*** read badch info. from badch.XXXXXX
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c*** check badch file
      write(frun, 10) nrunb
 10   format(I6.6)
      inquire(file=CHEAD2//frun, exist=ex)
cc      write(*,*) 'checking ', CHEAD2//frun, ' = ', ex
      if (.not.ex) goto 1000

c*** read badch file
      open(99, file=CHEAD2//frun, status='old', form='formatted')
      read(99,*,err=2000) nrunsv, nbadsv
      do 110 i = 1, nbadsv
         jj = 1
         read(99,*,err=2000) icab, jj, iibad, nsub_sta, nsub_sto
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
            read(99,*,err=2000) icab, jj, iibad, nsub_sta, nsub_sto
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
      close(99)

c*** read both badch information
      if (imaskbadopt.eq.0) goto 3000

c*** normal end
      ierr = 1
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
      inquire(file=CHEAD2//fileno, exist=ex)
cc      write(*,*) 'checking ', CHEAD2//fileno, ' = ', ex
      if (.not.ex) goto 2000

c*** read badch data
      open(99, file=CHEAD2//fileno,
     $     status='old', form='formatted')
      read(99,*,err=2000) nrunsv, i1, i1, nbad
      read(99,*,err=2000) i1
      read(99,*,err=2000) r1
      do 210 i = 1, nbad
         read(99,*,err=2000) j, ibad(j)
         if (i .le. MAXNBD) then
            isqbad(i) = j
         endif
 210  continue
      close(99)

c*** read both badch information
      if (imaskbadopt.eq.0) goto 3000

c*** normal end
      ierr = 2
      imaskbad = imaskbadopt
      nrunsv = nrunb
      nsubsv = nsubb
      RETURN

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c**** read badch info. from "/skam/pro/const/badch.dat"
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
 2000 continue

      call rgetv(LUNINB,1,fname,f1,f2,f3,f4,f5,f6,f7)
      if(fname.eq.' ') then
cc         write(6,'(A,A)')'Bad Channel file is :',file_name
         call set_rflist(LUNINB,file_name,'LOCAL',' ',
     &        'RED',' ',' ','form=formatted',' ')
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
         read(LUNINB,*,ERR=5000) isq
         if(isq.lt.0)goto 2
 50      continue
            read(LUNINB,*)runmin,runmax
            if(runmin.lt.0)goto 51
            if(nrunb.ge.runmin .AND. nrunb.le.runmax)then
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
      call rgetv(LUNINB,1,fname,f1,f2,f3,f4,f5,f6,f7)
      if(fname.eq.' ') then
cc         write(6,'(A,A)')'Bad Channel file is :',file_name
         call set_rflist(LUNINB,file_name,'LOCAL',' ',
     &        'RED',' ',' ','form=formatted',' ')
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
         read(LUNINB,*,ERR=5000) isq
         if(isq.lt.0)goto 3002
 3050    continue
            read(LUNINB,*)runmin,runmax
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

      ierr = 4
      imaskbad = imaskbadopt
      nrunsv = nrunb
      nsubsv = nsubb
      RETURN

 5000 CONTINUE
      print *,'ERROR in bad channel file'
      ierr = -1
      RETURN

      END
