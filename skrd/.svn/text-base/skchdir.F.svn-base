************************************************************************
*     ---------------------------------
      SUBROUTINE SKCHDIR(DIR,TH,PH,GDIR)
*     ---------------------------------
*
*     (Purpose)
*       CAL. DIRECTION OF GAMMA
*
*     (Input)
*       TH  ; THE ANGLE BETWEEN DIR & GDIR
*       PH  : ANGLE PHI
*       DIR ; DIRECTION OF INPUT CHARGED PARTICLE
*
*     (Output)
*       GDIR ; DIRECTION OF OUTPUT GAMMA
*      
*     (Creation Date and Author)
*       1980.08.26 ; by K.Arisaka
*       1996.02.15 ; K.Kaneyuki   CHDIR -> SKCHDIR
*
*     (Comment)
*     
************************************************************************
C     
      DIMENSION DIR(3),GDIR(3)
      SINT=SIN(TH)
      COST=COS(TH)
C     
      C=COS(PH)
      S=SIN(PH)
      X1=SINT*C
      Y1=SINT*S
      Z1=COST
C     
      IF(ABS(DIR(1)).LT.1.E-5 .AND. ABS(DIR(2)).LT.1.E-5) GO TO 10
      RDIR=DIR(1)**2+DIR(2)**2+DIR(3)**2
      RDIR=SQRT(RDIR)
      COSA=DIR(3)/RDIR
      SINA=SQRT(1.-COSA**2)
      IF(SINA.LT.1.E-10) GO TO 10
      COSB=DIR(1)/RDIR/SINA
      SINB=DIR(2)/RDIR/SINA
C     
      X2=X1*COSA+Z1*SINA
      Y2=Y1
      Z2=-X1*SINA+Z1*COSA
C     
      GDIR(1)=X2*COSB-Y2*SINB
      GDIR(2)=X2*SINB+Y2*COSB
      GDIR(3)=Z2
C     
      RETURN
C     
   10 IF(DIR(3).LT.0.) GO TO 20
      GDIR(1)=X1
      GDIR(2)=Y1
      GDIR(3)=Z1
      RETURN
C     
   20 GDIR(1)=-X1
      GDIR(2)=-Y1
      GDIR(3)=-Z1
      RETURN
      END
