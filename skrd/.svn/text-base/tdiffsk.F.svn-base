      SUBROUTINE tdiffsk(IERR)

      IMPLICIT NONE
C------------------------------------------------------------------------
C
C--  For SK1 to 3
C     
C--   set previous T0 and 48bit clk.
C--   set Real TDIFF   (micro sec.)
C
C   
C--  For SK4 :
C
C--   set previous T0 and 48bit clk.
C--   set Integer TDIFF(TRG counter + TDC count)
C--   set Real TDIFF   (micro sec.)
C--   check errors
c--             if there are no errors,      return 0
C--             if this event is overlapped, return one of the trigger ID
C--             if there is no prev_t0 info, return -1
C
C------------------------------------------------------------------------
#include "skhead.h"
#include "skruninf.h"
#include "skprevt0.h"

      INTEGER*4    IERR

      INTEGER*4    IT0,iendtdc,iendctr

      INTEGER*4    I,J,IPBANK
      CHARACTER*32 CNAME

      INTEGER*4   NDATA,IBUF(1024)

      REAL*8      RT48CLK, PRECLK

      ierr     = 0
      iovlperr = 0

      do 10 I=0,31
         iprev_ctr32(i)=0
         iprev_tdc(i)=0
         do 20 j=1,3
            iprev_clk48(j,i)=0
 20      continue
         
         idiff_ctr32(i)    =0
         idiff_tdc(i)      =0
         rtdiff(i)         =0.E0

 10   continue

      tdiffmin = 1.D12
      mintrgid = -1

      if (nrunsk.ge.60000) then
         goto 4000
      endif

C------------------- for SK 1,2,3 ------------------------      
      RT48CLK = (DFLOAT(NT48SK(3))+DFLOAT(NT48SK(2))*6.5536D4
     $     +DFLOAT(NT48SK(1))*4.294967296D9)*2.0D1

      CALL KZBLOC('EVINFO',IPBANK)
      IF(IPBANK.LE.0) GOTO 9999
      CALL KZGET0('EVINFO',0,NDATA,IBUF)
      CALL KZGET0('EVINFO',1,NDATA,IBUF)

      IF (NDATA.EQ.0 .OR. (IBUF(1).EQ.0 .AND.
     $     IBUF(2).EQ.0 .AND. IBUF(3).EQ.0)) GO TO 9999
      
      do 30 J=1,3
         iprev_clk48(j,0)=IBUF(j)
 30   continue
      PRECLK =(DFLOAT(ibuf(3))
     $       + DFLOAT(IBUF(2))*6.5536D4
     $       + DFLOAT(IBUF(1))*4.294967296D9)*2.0D1
      rtdiff(0) = (RT48CLK-PRECLK)/1000.0D0

      CALL KZGET0('EVINFO',2,NDATA,IBUF)
      if (NDATA.LT.24) then
         mintrgid = 0
         tdiffmin = rtdiff(0)
         goto 60
      endif

      do 40 I=0,7
         do 50 J=1,3
            iprev_clk48(j,i)=IBUF(j+i*3)
 50      continue
         PRECLK =(DFLOAT(ibuf(3+i*3))
     $          + DFLOAT(IBUF(2+i*3))*6.5536D4
     $          + DFLOAT(IBUF(1+i*3))*4.294967296D9)*2.0D1
         rtdiff(i) = (RT48CLK-PRECLK)/1000.0D0
         
         if (rtdiff(i).ge.0.D0) then
            if (i.ne.2) then
               if (tdiffmin.gt.rtdiff(i)) then
                  mintrgid = i
                  tdiffmin = REAL(rtdiff(i))
               endif
            endif
         endif
 40   continue

 60   continue
      ierr     = 0
      iovlperr = 0
      goto 1010
      
C -------------------for SK 4 ----------------------------
 4000 continue
c*** for skroot files (32 is defined in DataDefinitions.h)

      if (SK_FILE_FORMAT.eq.0) then  
c*** ZBS
         CNAME='PREVT0'

         call kzbloc(CNAME,IPBANK)
         if (IPBANK.le.0) goto 9999

         call kzget0(CNAME,2,NDATA,IBUF)

         DO 100 I=0,31
            iprev_ctr32(I)=IBUF(I*5+1)
            iprev_tdc(I)   =IAND((IBUF(I*5+2)),32767)
 100     continue

      else if (SK_FILE_FORMAT.eq.1) then  
c*** SKROOT
         call skroot_get_prevt0(root_id, ierr, iprev_ctr32,
     $        iprev_tdc, iprev_clk48)

         DO I=0,31
            iprev_tdc(I)=IAND(iprev_tdc(i),32767)
         enddo
      else
         print *,'chk_tdiff: Not supported format=', SK_FILE_FORMAT
         stop
      endif


      IT0=IAND(IT0SK,32767)

      DO 1000 I=0,31
         
         if ((iprev_ctr32(i).eq.0).and.(iprev_tdc(i).eq.0)) then
            idiff_ctr32(I) = 32767*65536+65535
            idiff_tdc(I)   = 32767
            goto 950
         endif
         
         iendtdc = iprev_tdc(i)   + softtrg_post_t0(i)
         iendctr = iprev_ctr32(i) + (iendtdc / 32768)
         iendtdc = iendtdc - (iendtdc / 32768)*32768

         if (iand(ifevsk,2**9).eq.0) then
            if (iendctr.gt.NEVHWSK) then
               IERR=I
            else if (iendctr.eq.NEVHWSK) then
               if (iendtdc.gt.IT0) then
                  IERR=I
               endif
            endif
         endif
         
         idiff_ctr32(I) = NEVHWSK - iprev_ctr32(I)
         idiff_tdc(I)   = IT0     - iprev_tdc(I)

 950     IF (Idiff_tdc(I).lt.0) then
            idiff_ctr32(I)=idiff_ctr32(I)-1
            idiff_tdc(I)  =idiff_tdc(I)+32768
         endif
         
         RTDIFF(I)
     $        =REAL(idiff_ctr32(I))*(256./15.)
     $        +REAL(idiff_tdc(I))/(1920.)

         if (((i.ne.2).and.(i.le.7)).or.
     $        (i.eq.28).or.(i.eq.29)) then
            if (rtdiff(i).ge.0.D0) then
               if (tdiffmin.gt.rtdiff(i)) then
                  mintrgid = i
                  tdiffmin = REAL(rtdiff(i))
               endif
            endif
         endif

 1000 continue
      
 1010 continue
      
      iovlperr = ierr
      return

C-- no PREVT0 BANK -> IERR=-1
 9999 IERR = -1
      iovlperr = ierr
      return
      
      end
      
