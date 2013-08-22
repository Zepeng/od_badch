************************************************************************
*     -------------------------------------
      subroutine skdark(nrun, ierr)
*     -------------------------------------
*
*     (Purpose)
*        Read dark rate information and fill them into COMMON/COMDARK/
*
*     (Input)
*        NRUN ; run number
*
*     (Output)
*        ierr  ; -1 : error
*        ierr  ;  0 : normal end
*
*     (Creation Date and Author)
*       2009.03.09 : First version by Y. Takeuchi
*
************************************************************************
      implicit none

#include "skparm.h"
#include "skbadc.h"
#include "skmisch.h"
c arg
      integer nrun, ierr

c local variable
      character*200 fname
      character*6   frun
      integer i, skdark_read, loglv

c*** initialize 1
      ierr = 0
      loglv = 5

c*** check run number
      if (nrun .eq. nrun_dark) return

c*** initialize 2
      call lbfset0(dark_rate, MAXPM)
      nrun_dark = 0
      nsub_dark = 0
      nfill_dark = 0
      dark_ave = 0.0

c*** check nrun
      if (nrun.le.0) then
         ierr = -1
         return
      endif

      do i=1,maxpm
         if(imis(i).ne.0) ibad(i) = -1
      enddo

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c*** read dark rate info. from darkr/darkr.XXXXXX.root
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c*** check darkr file
      write(frun, 10) nrun
 10   format(I6.6)
      call findconsts(fname,'darkr.'//frun//'.root',
     $     'darkr/darkr.'//frun//'.root',loglv)

      if (fname(1:1).eq.' ') then
         goto 700
      endif

c*** read dark rate file 
      fname = fname(1:lnblnk(fname))//' '
      ierr = skdark_read(fname, nrun_dark, nsub_dark, nfill_dark,
     $     dark_ave, dark_rate, dark_rate_od, dark_rate_od_subped)

      if (ierr.eq.0) then
c*** normal end
         return
      endif

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c*** read dark rate info. from darkr/darkr.XXXXXX
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c*** check darkr file
 700  continue
      call findconsts(fname,'darkr.'//frun,'darkr/darkr.'//frun,loglv)

      if (fname(1:1).eq.' ') then
         ierr = -1
         return
      endif

c*** read dark rate file 
      open(99, file=fname, status='old', form='formatted')
      read(99,*,err=800,end=800) nrun_dark, nsub_dark, nfill_dark, 
     $     dark_ave

c*** inner detector
      do i = 1, maxpm
         read(99,*,err=800,end=800) dark_rate(i)
      enddo

c*** outer detector
      do i = 1, maxpma
         read(99,*,err=800,end=800) dark_rate_od(i), dark_rate_od_subped(i)
      enddo

c*** normal end
      close(99)
      return

c*** error end
 800  continue
      close(99)
      nrun_dark = 0
      print *,'ERROR in darkr file: nrun=', nrun
      ierr = -1
      RETURN

      END
