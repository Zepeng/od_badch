************************************************************************
*     -------------------------------------
      SUBROUTINE SKCHKVETO
*     -------------------------------------
*
*     (Purpose)
*        check whether veto counters' signal are in criteria or not
*     (Input) 
*        NONE
*     (Output)
*        IHITV(4)   ;  Veto counter flag(see skveto.h)
*               IHITV(i) corresponds to each veto counter (1-4)
*                                                            
*     (Creation Date and Author)
*	1997.05.   ; J.Kameda 
************************************************************************
      implicit NONE

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"
#include "skveto.h"

      Integer i,j
      real rtupper(4),rtlower(4)
      real rqlower(4)

      real rtupper_sk4(4),rtlower_sk4(4)
      real rqlower_sk4(4)

      real itupper(4),itlower(4)
      real iqlower(4)
      real  pdstt(4,2),pdstq(4,2)
      real q(4),t(4)

c--------      set criteria     ---------

       DATA rtupper/1025.0,1045.0,1045.0,1045.0/
       DATA rtlower/940.0,965.0,965.0,965.0/
       DATA itupper/510.0,580.0,580.0,580.0/
       DATA itlower/310.0,380.0,380.0,380.0/

       DATA rqlower/144.0,144.0,144.0,144.0/
       DATA iqlower/900.0,900.0,900.0,900.0/

       DATA rtupper_sk4/1015.0,980.0,980.0,980.0/
       DATA rtlower_sk4/930.0,900.0,900.0,900.0/
       DATA rqlower_sk4/144.0,144.0,144.0,144.0/

c -------     set pedestal      ---------
       pdstt(1,1) = 2685.0
       pdstt(1,2) = 2709.0
       pdstt(2,1) = 2746.0
       pdstt(2,2) = 2717.0
       pdstt(3,1) = 2735.0
       pdstt(3,2) = 2718.0
       pdstt(4,1) = 2753.0
       pdstt(4,2) = 2699.0

       pdstq(1,1) = 783.0
       pdstq(1,2) = 816.0
       pdstq(2,1) = 780.0
       pdstq(2,2) = 785.0
       pdstq(3,1) = 783.0
       pdstq(3,2) = 793.0
       pdstq(4,1) = 796.0
       pdstq(4,2) = 814.0

cc -------  initialization ---------------
       IHITV(1) = 0
       IHITV(2) = 0
       IHITV(3) = 0
       IHITV(4) = 0
cc ----------------------------------------

       if (nrunsk.lt.3575) goto 110
       if (nrunsk.le.4112) goto 105 

cc --------     for run# > # 4113 ---------

       if ((SK_GEOMETRY .ge. 1) .and. (SK_GEOMETRY .le. 3)) then

        do 20 i = 1,4
         if ((QVSK(11150+i).ge.rqlower(i)).and.(TVSK(11150+i).
     &  le.rtupper(i)).and.(TVSK(11150+i).ge.rtlower(i))) then
         IHITV(i) = 1 
         endif
 20      continue        

       elseif (SK_GEOMETRY .eq. 4) then

        do 21 i = 1,4
         if ((QVSK(11150+i).ge.rqlower_sk4(i)).and.(TVSK(11150+i).
     &  le.rtupper_sk4(i)).and.(TVSK(11150+i).ge.rtlower_sk4(i))) then
         IHITV(i) = 1 
         endif
 21      continue        

       else
         write(*,*) 'SKCHKVETO: Not Supported SK_GEOMETRY:',SK_GEOMETRY
       endif

        RETURN
       
 105     continue

c --------     for  run# =< #4112 ----------
        if (IPDSTTV(11151,1).ne.0) then
         do 30 j = 1,4
c          print *,'skchkveto No1'
           pdstt(j,1) = IPDSTTV(11150+j,1)/10
           pdstq(j,1) = IPDSTQV(11150+j,1)/10
           pdstt(j,2) = IPDSTTV(11150+j,2)/10
           pdstq(j,2) = IPDSTQV(11150+j,2)/10
 30    continue
        endif

       do 40 i = 1,4
            q(i) = IQABSKV(11150+i,IABV(11150+i))
     &     - pdstq(i,IABV(11150+i))
            t(i) = ITABSKV(11150+i,IABV(11150+i))
     &     - pdstt(i,IABV(11150+i))
 40    continue


       do 50 i = 1,4
         if ((q(i).ge.iqlower(i)).and.(t(i).le.itupper(i))
     &   .and.(t(i).ge.itlower(i))) then
          IHITV(i) = 1
         endif
 50     continue 

 110    continue

        RETURN
        END





















