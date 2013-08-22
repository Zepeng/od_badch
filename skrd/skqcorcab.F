************************************************************************
*     ------------------------------------------------
      SUBROUTINE SKQCORCAB(icabx,tiskx,qiskx,corqiskx)
*     ------------------------------------------------
*
*     (Purpose)
*        Correct q variance depending on t
*        Correct gain difference using Xe calibration results
*        Correct non-linearity of q using laser calibration results
*
*     (Input)
*        icabx : cable number which cahrge is converted
*        tiskx : time (ns) of the cable
*        qiskx : charge (pe) of the cable
*
*     (Output)
*        corqiskx : correcterd charge (pe)
*       
*     (Creation Date and Author)
*       1998. 9. 6 ; First version by Y.Koshio
*       2000. 8. 24; non-linearity correction was added by M.Shiozawa
*       2000.10. 5 ; New gain table by Xe was added by M.Shiozawa
*       2003. 4. 22; skqcor.F --> skqcorcab.F
*                    skqcorcab.F needs a cable number as a argument
*                    and make correction for the cable.  
*                    This modification is for tqreal.   by Shiozawa
*       2004. 5. 8 ; for very large/small tiskx(nsec) or qiskx(p.e.),
*                    no correction is performed and corqiskx = qiskx.
*                    (Shiozawa)
*
************************************************************************

      IMPLICIT NONE

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"
#include "sktabl.h"

      Integer icabx
      Real tiskx,qiskx,corqiskx
#define VERYLARGE 10000.
#define VERYSMALL -10000.

      integer   LUN1P
      parameter(LUN1P=97)
      integer icall/0/, icall0/0/
      Integer xe_version, max_xe_version
      Parameter (max_xe_version=3)
      real crrct(2, MAXPM, max_xe_version)
      CHARACTER*256 fname

      INTEGER I,ICAB,ECH
      Real expd

      Integer nonl_version, max_nonl_version
      Parameter (max_nonl_version=3)
      Real lina(24,max_nonl_version), linb(24,max_nonl_version)
      Data lina/2.820585, 1.935316, 3.307956, 2.973618
     &     ,2.641590, 4.372097, 4.939591, 6.619491
     &     ,6.427417, 8.631392, 8.885310, 6.485860
     &     ,6.432410, 9.469652, 8.764217, 8.720687
     &     ,8.468705, 8.676966, 9.679013, 11.68744
     &     ,11.42880, 11.61258, 12.74421, 12.28232
     &     ,4.885776, 3.855526, 3.505988, 2.579370 
     &     ,4.612409, 4.646358, 3.906902, 3.788463
     &     ,4.179245, 5.291492, 4.856154, 3.712203
     &     ,4.976830, 6.119330, 5.455532, 4.975433
     &     ,5.145122, 5.715034, 5.021689, 6.334858
     &     ,6.238665, 6.509541, 6.375751, 5.899015
     &     ,4.014579, 3.472000, 3.394938, 3.462477
     &     ,3.759099, 4.884716, 5.666197, 5.154084
     &     ,6.959638, 7.154318, 8.166720, 6.596726
     &     ,4.793890, 7.450676, 5.619954, 7.037961
     &     ,6.562368, 7.208336, 9.527865, 10.72140
     &     ,12.24645, 11.72933, 12.17498, 12.99248/

      Data linb/-0.1716259, -0.1716044, -0.2038244, -0.2332517
     &     ,-0.2016418, -0.1806587, -0.2008912, -0.2324301
     &     ,-0.1726444, -0.1818579, -0.1807659, -0.2053629
     &     ,-0.2228679, -0.2408079, -0.2867078, -0.1982551
     &     ,-0.2933990, -0.2533523, -0.2198582, -0.2041969
     &     ,-0.1897645, -0.2068044, -0.1941809, -0.1887791
     &     ,-0.1432683, -0.1234641, -0.1286979, -0.1938456
     &     ,-0.1422247, -0.1258750, -0.1633619, -0.1529461
     &     ,-0.1633503, -0.1507674, -0.1620054, -0.1639978
     &     ,-0.1877769, -0.1800239, -0.2167046, -0.1374212
     &     ,-0.1917947, -0.1736273, -0.1964585, -0.1687133
     &     ,-0.2010306, -0.1878234, -0.1836140, -0.1660614
     &     ,-0.0820159, -0.0758864, -0.0745786, -0.0892687
     &     ,-0.0783134, -0.0817101, -0.0934131, -0.0929425
     &     ,-0.0964026, -0.0942736, -0.1035720, -0.0948396
     &     ,-0.0998444, -0.1177324, -0.1089337, -0.0951446
     &     ,-0.1121942, -0.1156588, -0.1169513, -0.1183514
     &     ,-0.1174660, -0.1179406, -0.1187605, -0.1243460/


C ---

      if (icall.eq.0) then
         WRITE(6,*) ' '
         WRITE(6,*) '************************************************'
         WRITE(6,*) '* SUBROUTINE SKQCOR ;                          *'
         WRITE(6,*) '* Q is corrected, the correction depends on PMT*'
         WRITE(6,*) '* channel number, T of the channel, and ATM    *'
         WRITE(6,*) '* channel number.                              *'
         WRITE(6,*) '*  2006/10/27 coeff. by T.Tanaka, S. Moriyama  *'
         WRITE(6,*) '*  2006/12/13 SK3 final non lin table          *'
         WRITE(6,*) '* This should be called for both lowe/atmpd.   *'
         WRITE(6,*) '************************************************'
         WRITE(6,*) ' '
         icall = 1
         Call skcontabrd
         call findconsts(fname,'Gain correction table (1/3)',
     &        'xecorr.dat',2)
         open(LUN1P,file=fname, status='old',ERR = 9999) 
         do 11 i=1, MAXPM
            read(LUN1P,*,ERR=9998,END=9998)crrct(1,i,1),crrct(2,i,1)
 11      continue
         close(LUN1P)
         write(6,*)'skqcor: read correction constants from ',fname
         call findconsts(fname,'Gain correction table (2/3)',
     &        'xecorr_2.dat',2)
         open(LUN1P,file=fname, status='old',ERR = 9999) 
         do 12 i=1, MAXPM
            read(LUN1P,*,ERR=9998,END=9998)crrct(1,i,2),crrct(2,i,2)
 12      continue
         close(LUN1P)
         write(6,*)'skqcor: read correction constants from ',fname
         call findconsts(fname,'Gain correction table (3/3)',
     &        'xecorr_3.dat',2)
         open(LUN1P,file=fname, status='old',ERR = 9999) 
         do 13 i=1, MAXPM
            read(LUN1P,*,ERR=9998,END=9998)crrct(1,i,3),crrct(2,i,3)
 13      continue
         close(LUN1P)
         write(6,*)'skqcor: read correction constants from ',fname
      endif

      If (icabx.le.0 .or. icabx.gt.maxpm) then
         write(6,*)'skqcorcab: bad cable number argument ',icabx
         return
      Endif



C     check qiskx, tiskx
      If (tiskx .gt. VERYLARGE .or. tiskx .lt. VERYSMALL
     &     .or. qiskx .gt. VERYLARGE .or. qiskx .lt. VERYSMALL ) then
         corqiskx = qiskx
         print *, 'skqcorcab: too large/small qisk or tisk.
     &         cab,tisk,qisk= ',icabx,tiskx,qiskx
         return
      Endif


C     correction start!
      CORQISKX = QISKX


      if(mdrnsk.ne.0) then
         If (nrunsk.lt.8926) then
C     SK-I
            xe_version = 1
            nonl_version = 1
         Else if (nrunsk.lt.20000) then
C     SK-I
            xe_version = 2
            nonl_version = 1
         Else if (nrunsk.lt.30000) then
C     SK-II
            xe_version = 3
            nonl_version = 2
         Else
C     SK-III
            xe_version = 3
            nonl_version = 3
         Endif
         IF (CRRCT(IAB(ICABX),ICABX,xe_version).GT.0.0) THEN
C               If (icabx.eq.1) then
C                  print *, 'gain correction: '
C     &                 ,QISK(ICABX),'-->'
C     &                 ,QISK(ICABX)
C     &                 /CRRCT(IAB(ICABX),ICABX,xe_version)
C     &                 ,1.0/CRRCT(IAB(ICABX),ICABX,xe_version)
C     &                 ,CRRCT(IAB(ICABX),ICABX,xe_version)
C               Endif
            CORQISKX = 
     &           CORQISKX/CRRCT(IAB(ICABX),ICABX,xe_version)
         ENDIF
      endif

C     correct q variance depend on t
C     parameter    error (CL 68%)
C     0.1949E-3 +- 0.0201E-3
      if(mdrnsk.ne.0)
     &     CORQISKX = CORQISKX + (0.1949E-3)*(TISKX-1043.0)


C     added by M.Shiozawa  25-Aug.-2000
C     correct non-linearity of q depending on ATM channel number.
C     correction is done as a function of ATM channel number from
C     ch 0 (0-A) to ch23 (11-B).
C     
C     (obs-expd)/expd * 100. (%) = lina(ch)*exp(linb(ch)*expd)
C
C     following approximation is used.
C     expd = obs/[lina(ch)/100*exp(linb(ch)*expd)+1]
C          ~ obs/[lina(ch)/100*exp(linb(ch)*obs)+1]
C
C     updated for SK-II new correction table made by Moriyama
C     coded by M.Shiozawa 17-Apr.-2003
      If (mdrnsk.ne.0) then
         If (natmch(icabx).lt.0.or.natmch(icabx).gt.23) then
            print *, 'wrong atm channel number, icabx,natmch='
     &           ,icabx,natmch(icabx)
            Return
         Endif
         ech = natmch(icabx)+1 + (iab(icabx)-1)*12
         expd = 
     &        corqiskx/(lina(ech,nonl_version)/100.
     &        *exp(linb(ech,nonl_version)*corqiskx)+1)
C
C     following calculations are omitted due to small effect(<~0.2%) 
C     
C     expd = qisk(icab)/(lina(ech)/100.*exp(linb(ech)*expd)+1)
C     print *, 'nonlin:         ',expd
C     expd = qisk(icab)/(lina(ech)/100.*exp(linb(ech)*expd)+1)
C     print *, 'nonlin:         ',expd

         corqiskx = expd
         If (icall0.eq.0) then
            Do icall0=1,24
               print *, "ch, lina, linb="
     &              ,icall0
     &              ,lina(icall0,nonl_version)
     &              ,linb(icall0,nonl_version)
            Enddo
            icall0=1
         endif
      Endif

      RETURN

 9999 continue
      write(6,*)'skqcorcab: cannot find ', fname
      stop
 9998 continue
      write(6,*)'skqcorcab: read error in skqcrrct'
      stop

      END
