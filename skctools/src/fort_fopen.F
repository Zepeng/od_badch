      subroutine fort_fopen(lun,fname,ftype, lmode)

#include "skhead.h"

      integer lun,lenchr
      character*(*) fname
      character*1   ftype
      integer lmode

!     lmode = {0,1} == {read, write} 
      print *, ' given fname: ',fname(1:lenchr(fname))
      if ( lmode .eq.0 ) then
         if (fname(1:5) .eq. '/disk') then
            call set_rflist(lun,fname(1:lenchr(fname)),'DISK',' ','RED',
     &           ' ',' ','recl=5670 status=old',' ',' ')
            print *, 'open as DISK: ', fname(1:lenchr(fname))
         else
            call set_rflist(lun,fname(1:lenchr(fname)),'LOCAL',' ',
     &           'RED',' ',' ','recl=5670 status=old',' ',' ')
            print *, 'open as LOCAL: ', fname(1:lenchr(fname))
         endif
      else
         if (fname(1:5) .eq. '/disk') then
            call set_rflist(lun,fname(1:lenchr(fname)),'DISK',' ','WRT',
     &           ' ',' ','recl=5670 status=unknown',' ',' ')
            print *, 'open as DISK: ', fname(1:lenchr(fname))
         else
            call set_rflist(lun,fname(1:lenchr(fname)),'LOCAL',' ',
     &           'WRT',' ',' ','recl=5670 status=unknown',' ',' ')
            print *, 'open as LOCAL: ', fname(1:lenchr(fname))
         endif
      endif ! end of lmode check

      
      CALL SKOPENF(LUN, 1 , ftype, IRET)
      IF (IRET.lt.0) THEN
        write(*,*) "reformat:***ERROR*** CAN NOT OPEN OUTPUT FILE ***"
        call exit(150)
      ENDIF
      call reset_rflist()
       
      return
      end

