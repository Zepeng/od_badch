************************************************************************
*     ------------------
      SUBROUTINE CMTQSK
*     ------------------
*
*     (Purpose)
*        Fill the commons /SKQ/,/SKT/,/SKCHNL/
*
*     (Input)
*        ICHK(ICAB,IABC) ; Flag. w data    (=1)
*                                w/o data  (=0)
*
*     (Output)
*       
*       
*
*     (Creation Date and Author)
*       1992.08.28 ; First version by K.S.Hirata
*
************************************************************************

      implicit none

#include "skparm.h"
#include "sktq.h"
#include "skbadc.h"

#include "skhead.h"
#include "skpdst.h"

      INTEGER ISKBIT
      COMMON /SKOPT/ISKBIT

      CHARACTER*32 CNAME
      INTEGER ICHK,IFMOD,IPBANK,NDATA,i
      REAL    QPDST,RBUF(20)
      COMMON/SKRDLC/ICHK(MAXPM,2)
      save ifmod

      Real satmean,satsigma,offset
      Data satmean/247.4/, satsigma/7.662/
      Parameter (offset=300.)

C --- define the conversion parameter

      CNAME = 'MCPARMCONV'
      CALL KZBLOC(CNAME,IPBANK)
      IF(IPBANK.EQ.0) THEN
         TCNVSK = 2.5
         QCNVSK = 5.5
c        DTHRSK = 0.2
      ELSE
         CALL KZGET1(CNAME,0,NDATA,RBUF)
         TCNVSK = RBUF(2)
         QCNVSK = RBUF(3)
c        DTHRSK = RBUF(6)
      END IF

C --- Initialize

      NQISK = 0
      QISMSK = 0.
      QIMXSK = 0.
      TIMNSK = 100000.
      TIMXSK = -100000.

      IF(IFMOD.NE.999) THEN
         IF(MDRNSK.gt.0.and.mdrnsk.lt.1000) then
            WRITE(6,*) ' '
            WRITE(6,*) '********************************************'
            WRITE(6,*) '* This conversion constant is not acurate, *'
            WRITE(6,*) '* so please use SKRAWREAD                  *'
            WRITE(6,*) '********************************************'
            WRITE(6,*) ' '
            IFMOD = 999
         endif
      ENDIF

C --- Put the data to common variables

      DO 10 I=1,MAXPM

         IF(ICHK(I,1).EQ.0 .AND. ICHK(I,2).EQ.0) GOTO 10

         IF(ICHK(I,1).EQ.1 .AND. ICHK(I,2).EQ.1) THEN
            IAB(I) = 1
            IF(ITABSK(I,1).GT.ITABSK(I,2)) IAB(I) = 2
         ELSE IF(ICHK(I,1).EQ.1 .AND. ICHK(I,2).EQ.0) THEN   
            IAB(I) = 1
         ELSE IF(ICHK(I,1).EQ.0 .AND. ICHK(I,2).EQ.1) THEN
            IAB(I) = 2
         END IF

         IF(BTEST(ISKBIT,31-25).AND.IBAD(I).NE.0
     &        .and. SK_GEOMETRY.ge.3) GOTO 10

         NQISK = NQISK+1
         IHCAB(NQISK) = I
         
C --   M.C. data
         IF(MDRNSK.EQ.0) THEN
            QPDST = 1000.

C --   Real data
         ELSE
            IF(IPDSTQ(I,IAB(I)).NE.0) THEN
               QPDST = FLOAT(IPDSTQ(I,IAB(I)))/100.
            ELSE
               QPDST = 1000.
            ENDIF
         ENDIF

         TISK(I) = FLOAT(4095-ITABSK(I,IAB(I)))/TCNVSK+offset
         QISK(I) = (FLOAT(IQABSK(I,IAB(I))) - QPDST) / QCNVSK

**** satilation
CMS         if(QISK(I).ge.250.) qisk(i)=250.
CMS midified by M.Shiozawa(Sep.-10-96)
         if (QISK(I).ge.230.) then
            Call rdmin(real(i)**3.1415)
            Call rngausk(satmean,satsigma,qisk(i))
         Endif

ccc         TISK(I) = FLOAT(ITABSK(I,IAB(I)))/TCNVSK 
ccc         QISK(I) = FLOAT(IQABSK(I,IAB(I)))/QCNVSK 

         IF(QISK(I).GE.DTHRSK) QISMSK = QISMSK+QISK(I)

         IF(QISK(I).GT.QIMXSK) THEN
            QIMXSK = QISK(I)
            MXQISK = I
         END IF

         IF(TISK(I).LT.TIMNSK) THEN
            TIMNSK = TISK(I)
            MNTISK = I
         END IF

         IF(TISK(I).GT.TIMXSK) THEN
            TIMXSK = TISK(I)
            MXTISK = I
         END IF   

 10      CONTINUE


C ---

      RETURN
      END



