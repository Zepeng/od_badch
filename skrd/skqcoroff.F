************************************************************************
*     ------------------------------------------------
      SUBROUTINE SKQCOROFF(icabx,iabx,qiskx,corqiskx)
*     ------------------------------------------------
*
*     (Purpose)
*        Correct Q offset
*
*     (Input)
*        icabx : cable number which cahrge is converted
*        iabx  : ATM a-ch or b-ch
*        qiskx : charge (pC) of the cable
*
*     (Output)
*        corqiskx : correcterd charge (pC)
*       
*     (Creation Date and Author)
*       2006.12. 2 ; First version by Y.Koshio
*
************************************************************************

      IMPLICIT NONE

#include "skparm.h"
#include "sktabl.h"

      integer flag_intersec/0/
      save flag_intersec
      real inters1(0:11),inters2(0:11),inters
      data inters1/0.323492,0.318955,0.352765,0.297369,0.367727,0.335668,
     &     0.225933,0.291156,0.239403,0.348716,0.218473,0.259113/
      data inters2/0.388013,0.313697,0.316507,0.341356,0.242315,0.254130,
     &     0.151147,0.167679,0.118978,0.145231,0.142939,0.114005/

      Integer icabx,iabx
      Real qiskx,corqiskx

      if(flag_intersec.eq.0) then
         flag_intersec = 1
         WRITE(6,*) '*******************************************'
         WRITE(6,*) '*  2006/11/25 offset correction by Koshio *'
         WRITE(6,*) '*******************************************'
         call skcontabrd
      endif

      inters = 0.
      if(iabx.eq.1) inters = inters1(NATMCH(icabx))
      if(iabx.eq.2) inters = inters2(NATMCH(icabx))
      if(inters.le.0.05) then
         WRITE(6,*) 'offset correction is wrong'
         WRITE(6,*) 'call koshio'
         stop
      endif
      corqiskx = qiskx - inters

      return
      end
