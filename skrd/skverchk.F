***********************************************************************
*     -------------------------------------
      SUBROUTINE skverchk
*     -------------------------------------
*
*     (Purpose)
*         Check the skversion between from original MCHEAD bank and
*         SK_GEOMETRY value, and if they mis-match,
*         change the value in bank.
*
*     (Input)
*
*     (Output)
*       
*     (Return)
*
*     (Creation Date and Author)
*       2003.04.29 ; First version by Y.Koshio
*
************************************************************************

      implicit none

#include "skhead.h"

      integer ipbank,ndata,idata(20),ierr

      call kzbloc('MCHEAD',ipbank)
      if(ipbank.eq.0) return

      CALL KZGET1('MCHEAD',0,NDATA,IDATA)
      IF (NDATA.EQ.0) then
         write(6,*) 'MCHEAD bank is strange.. call Koshio'
         stop
      endif

      if(SK_GEOMETRY.eq.IDATA(1)) then
         if(SK_GEOMETRY.gt.1) then
            write(6,*) 'Error in skverchk.F'
            write(6,*) 'Do you really want to run apdetsim or ledetsim for SK2 MC?'
            write(6,*) 'If so, ask Koshio'
            stop
         else if(SK_GEOMETRY.lt.1) then
            write(6,*) 'skverchk : SET SK_GEOMETRY in skhead.h !'
            write(6,*) 'If you want to make vector file, please set any positive value.'
            write(6,*) 'Even in that case, when you run skdetsim, it is automatically re-written'
            stop
         endif

      else
         if(SK_GEOMETRY.le.0) then
            write(6,*) 'skverchk : SET SK_GEOMETRY in skhead.h !'
            write(6,*) 'If you want to make vector file, please set any positive value.'
            write(6,*) 'Even in that case, when you run skdetsim, it is automatically re-written'
            stop
         endif

      endif

      IDATA(1) = SK_GEOMETRY+1000
      call kzbdel('MCHEAD')
      CALL KZBCR1('MCHEAD',NDATA,'-I',0,0,' ',IERR)       
      IF (IERR.NE.0) GOTO 1000
      CALL KZREP1('MCHEAD',0,NDATA,IDATA)      

      RETURN
C     
C     ++ ERROR MESSAGE
C     
 1000 WRITE(6,900)
  900 FORMAT(' *** ERROR *** ( MCHEAD BANK CREATION IN skverchk )')
      stop

      END
