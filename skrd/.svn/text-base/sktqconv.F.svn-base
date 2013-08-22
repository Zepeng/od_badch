************************************************************************
*     ------------------------------------------
      SUBROUTINE SKTQCONV(ICAB, IAB, IT, IQ, T, Q)
*     ------------------------------------------
*
*     (Purpose)
*
*     (Input)
*
*       ICAB : cable number (1-MAXPMV)
*       IAB  : A-ch or B-ch (A = 1,  B = 2)
*       IT   : TAC count (0-4095)
*       IQ   : QAC count (0-4095)
*
*     (Output)
*       
*       T    : T (nsec)
*       Q    : Q (p.e.)
*
*     (Creation Date and Author)
*       1995.10.05 ; First version by Y.Takeuchi
*            11.07 ;      modified by Y.Koshio
*            12.21 ;      modified by Y.Takeuchi
*               o support calibration version information
*               o support ZEBRA format data file (ATMTQ)
*       1996  1.25 ;      modified by Y.Takeuchi
*               o support negative hit
*             2.06 ;      modified by Y.Takeuchi
*               o support temporary TQMAP
*             2.28 ;      modified by Y.Takeuchi
*               o support temporary PMT gain
*             6.21 ;      modified by Y.Takeuchi
*               o support new TQ-map format (version 3)
*             8.08 ;      modified by Y.Koshio
*               o support conversion pC -> p.e.
*             8.13 ;      modified by Y.Takeuchi
*               o avoid T=0 at high-Q value 
*       1997  4.25 ;      modified by Y.Takeuchi
*               o support VETO channels
*       2003  4.22 ;      modified by Y.Koshio
*               o support SK2
*       2006 12. 4 ;      modified by Y.Koshio
*               o support SK3
*
************************************************************************
      IMPLICIT NONE

#include "skparm.h"
#include "skhead.h"
#include "skveto.h"
#include "skcalib.h"
#include "skpdst.h"

#include "skmisch.h"

      integer ISKBIT
      COMMON /SKOPT/ISKBIT
      real tlincorsk

      REAL PC2PE_SK1, PC2PE_SK2, PC2PE_SK3, PC2PE
      PARAMETER (PC2PE_SK1 = 2.055, PC2PE_SK2 = 2.297, PC2PE_SK3 = 2.243)
      DATA PC2PE/0./
      SAVE PC2PE

      INTEGER ICAB, IAB, IT, IQ
      REAL T, Q, qcor
      REAL T1, Q1, X
      INTEGER I, ISTA, IMIN
      INTEGER MA_ATMTQ1, MA_ATMTQ_LAST, MA_PGAIN1, MA_PGAIN_LAST
      INTEGER MA_TQMAP1, MA_TQMAP_LAST
      INTEGER MI_ATMTQ1, MI_ATMTQ_LAST, MI_PGAIN1, MI_PGAIN_LAST
      INTEGER MI_TQMAP1, MI_TQMAP_LAST, NRUNSK_LAST
      DATA MA_ATMTQ_LAST /-1/
      DATA MA_TQMAP_LAST /-1/
      DATA MA_PGAIN_LAST /-1/
      DATA MI_ATMTQ_LAST /-1/
      DATA MI_TQMAP_LAST /-1/
      DATA MI_PGAIN_LAST /-1/
      SAVE NRUNSK_LAST

      IF (NRUNSK .NE. NRUNSK_LAST) THEN
         NRUNSK_LAST = NRUNSK

C*** set PC2PE
         IF(NRUNSK.lt.20000) then ! for SK1
            PC2PE=PC2PE_SK1
         else if(NRUNSK.lt.30000) then ! for SK2
            PC2PE=PC2PE_SK2
         else                   ! for SK3
            PC2PE=PC2PE_SK3
         endif
C
C*** set calibration table versions from run number
         CALL SKCALTABVER(NRUNSK, MA_ATMTQ1, MI_ATMTQ1, 
     $        MA_TQMAP1, MI_TQMAP1, MA_PGAIN1, MI_PGAIN1)

         WRITE(6,10) NRUNSK, MA_ATMTQ1, MI_ATMTQ1, 
     $        MA_TQMAP1, MI_TQMAP1, MA_PGAIN1, MI_PGAIN1
 10      FORMAT(1X, 'sktqconv: nrunsk=', I6, 
     $        '  table version = ', 3(I2.2,'.',I2.2,' '))
C
C*** set ATM TQ table
 20      FORMAT(1X, 'sktqconv: setting ',A5,' version ',
     $        I2.2, '.', I2.2,' ...')
         IF (MA_ATMTQ1 .NE. MA_ATMTQ_LAST .OR. 
     $       MI_ATMTQ1 .NE. MI_ATMTQ_LAST) THEN
            WRITE(6,20) 'ATMTQ', MA_ATMTQ1, 0
            CALL SKCALTABSET_ATMTQ(MA_ATMTQ1, 0, ISTA)
            WRITE(6,*) 'finish!'
            IF (MI_ATMTQ1 .GT. 0) THEN
               WRITE(6,20) 'ATMTQ', MA_ATMTQ1, MI_ATMTQ1
               CALL SKCALTABSET_ATMTQ(MA_ATMTQ1, MI_ATMTQ1, ISTA)
               WRITE(6,*) 'finish!'
            ENDIF
         ENDIF
         MA_ATMTQ_LAST = MA_ATMTQ1
         MI_ATMTQ_LAST = MI_ATMTQ1

C
C*** set TQ-map
         IF (MA_TQMAP1 .NE. MA_TQMAP_LAST .OR. 
     $       MI_TQMAP1 .NE. MI_TQMAP_LAST) THEN
            WRITE(6,20) 'TQMAP', MA_TQMAP1, 0
            CALL SKCALTABSET_TQMAP(MA_TQMAP1, 0, ISTA)
            WRITE(6,*) 'finish!'
            IF (MI_TQMAP1 .GT. 0) THEN
               WRITE(6,20) 'TQMAP', MA_TQMAP1, MI_TQMAP1
               CALL SKCALTABSET_TQMAP(MA_TQMAP1, MI_TQMAP1, ISTA)
               WRITE(6,*) 'finish!'
            ENDIF
         ENDIF
         MA_TQMAP_LAST = MA_TQMAP1
         MI_TQMAP_LAST = MI_TQMAP1
C
C*** set PMT gain table
         IF (MA_PGAIN1 .NE. MA_PGAIN_LAST .OR. 
     $       MI_PGAIN1 .NE. MI_PGAIN_LAST) THEN
            WRITE(6,20) 'PGAIN', MA_PGAIN1, 0
            CALL SKCALTABSET_PGAIN(MA_PGAIN1, 0, ISTA)
            WRITE(6,*) 'finish!'
            IF (MI_PGAIN1 .GT. 0) THEN
               WRITE(6,20) 'PGAIN', MA_PGAIN1, MI_PGAIN1
               CALL SKCALTABSET_PGAIN(MA_PGAIN1, MI_PGAIN1, ISTA)
               WRITE(6,*) 'finish!'
            ENDIF
         ENDIF
         MA_PGAIN_LAST = MA_PGAIN1
         MI_PGAIN_LAST = MI_PGAIN1

      ENDIF
C
CCCCCCCCCCCCCCCCCCCCC
C*** ATMTQ 
CCCCCCCCCCCCCCCCCCCCC
C********************** FOR VETO *************************
C     CORRECTION OF PEDESTAL DIFFERENCE
      IF (ICAB.GT.MAXPM) THEN
         T1 = FLOAT(IT*10 - IPDSTTV(ICAB,IAB))/10.0
         Q1 = FLOAT(IQ*10 - IPDSTQV(ICAB,IAB))/10.0
      ELSE
         T1 = FLOAT(IT*10 - IPDSTT(ICAB,IAB))/10.0
         Q1 = FLOAT(IQ*10 - IPDSTQ(ICAB,IAB))/10.0
      ENDIF
C*********************************************************
C
C*** CHECK RANGE
      IF (T1.LT.XT(1) .OR. T1.GT.XT(NXT)) THEN
         WRITE(0,*) 'sktqconv: NRUNSK,NEVSK,ICAB,IAB,IT,T1,T = ',
     $        NRUNSK,NEVSK,ICAB,IAB,IT,T1,T
      ENDIF
      IF (Q1.LT.XQ(1) .OR. Q1.GT.XQ(NXQ)) THEN
         WRITE(0,*) 'sktqconv: NRUNSK,NEVSK,ICAB,IAB,IQ,Q1,Q = ',
     $        NRUNSK,NEVSK,ICAB,IAB,IQ,Q1,Q
      ENDIF
C
C*** T
C
      IMIN = NXT/2
      IF (T1 .LE. XT(IMIN)) THEN
         IMIN = 1
      ENDIF
      DO 100 I = IMIN, NXT
         IF (T1 .LE. XT(I)) GOTO 110
 100  CONTINUE
 110  CONTINUE

      T = (T_ATM(ICAB,I,IAB)-T_ATM(ICAB,I-1,IAB))
     $     / (XT(I)-XT(I-1))
     $     * (T1 - XT(I)) + T_ATM(ICAB,I,IAB)

CC      print *, i,t1,xt(i),xt(i-1),t_atm(icab,i,iab),t_atm(icab,i-1,iab)
CC     $     ,t

C
C*** Q
      IMIN = NXQ/2
      IF (Q1 .LE. XQ(IMIN)) THEN
         IMIN = 1
      ENDIF
      DO 200 I = IMIN, NXQ
         IF (Q1 .LE. XQ(I)) GOTO 210
 200  CONTINUE
 210  CONTINUE
      
      Q = (Q_ATM(ICAB,I,IAB)-Q_ATM(ICAB,I-1,IAB))
     $     / (XQ(I)-XQ(I-1))
     $     * (Q1 - XQ(I)) + Q_ATM(ICAB,I,IAB)
         
CC      print *, i,q1,xq(i),xq(i-1),q_atm(icab,i,iab),q_atm(icab,i-1,iab)
CC     $     ,q

C********************** FOR VETO *************************
      IF (ICAB.GT.MAXPM) THEN
         T = T
         Q = Q 
         RETURN
      ENDIF
C*********************************************************
C
CCCCCCCCCCCCCCCCCCCCC
C*** TQMAP 
CCCCCCCCCCCCCCCCCCCCC
      IF (MA_TQMAP1 .GE. 3) THEN
ccc x-axis = Q(pc)
         IF (Q .GE. 10.) THEN
            X = LOG10(Q) * 50. + 1
         ELSE
            X = Q * 5. + 1
         ENDIF
      ELSE
ccc x-axis = Q1(ATM count)
         IF (Q1 .GT. 50.) THEN
            X = LOG10(Q1)*50.-34.
         ELSE
            X = Q1
         ENDIF
      ENDIF

      I = INT(X)
      IF (I .LE. 1) THEN
         T = TQMAP(ICAB,1,IAB) - T
         IF (TQMAP(ICAB,1,IAB).LT.0.01) THEN
            T = -1000.
         ENDIF
      ELSE IF (I .GT. NXTQ) THEN
         T = TQMAP(ICAB,NXTQ,IAB) - T
         IF (TQMAP(ICAB,NXTQ,IAB).LT.0.01) THEN
            T = -1000.
         ENDIF
      ELSE 
         T = (TQMAP(ICAB,I,IAB)-TQMAP(ICAB,I-1,IAB))
     $           * (X - FLOAT(I)) + TQMAP(ICAB,I,IAB) - T
         IF (TQMAP(ICAB,I,IAB).LT.0.01 .OR. 
     $           TQMAP(ICAB,I-1,IAB).LT.0.01) THEN
            T = -1000.
         ENDIF
      ENDIF

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      T = T + 1000.
      IF(BTEST(ISKBIT,31-15)) THEN
         T = T + TLINCORSK(T,icab,IAB)
      ENDIF
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
      if(NRUNSK.ge.30000) then ! for SK3 offset correction
         CALL skqcoroff(icab,iab,q,qcor)
         q = qcor
      endif

CCCCCCCCCCCCCCCCCCCCC
C*** PMT GAIN 
CCCCCCCCCCCCCCCCCCCCC
      if(PC2PE.eq.0.) then
         write(6,*) 'Error: PC2PE equal zero in sktqconv by Koshio'
         stop
      else
         Q = Q / PC2PE
      endif

      IF(nrunsk.ge.20000) then ! for SK2 and SK3
         CALL skqcorcab(icab,t,q,qcor)
         q = qcor
         Q = Q / PGAIN(ICAB)
      endif

      RETURN
      END
