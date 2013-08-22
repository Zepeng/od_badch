************************************************************************
*     -------------------------------------
      SUBROUTINE SKQCORRATE
*     -------------------------------------
*
*     (Purpose)
*        Correct QISK by using trigger rate & tdiff function
*        (this correction is needed for ATM board electronics)
*
*     (Input)
*        none
*
*     (Output)
*        none
*       
*     (Creation Date and Author)
*       2007. 9. 10 ; first version by C.Ishihara
*       2008. 8. 19 ; added new correction in case of high rate  
*                     by C.Ishihara
*
*     
************************************************************************

      IMPLICIT NONE

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"
#include "sktabl.h"

      integer   I,ICAB
      integer   iclkpre(3), iclkpre_he(3), run, nrun, event
      integer   trgflg, icall, iseg
      real      rate, trgrate, ftdif, frate, nrate
      real*8    tdiff, tdiff_he, offset
      real*8    diftevsk
      INTEGER*4 NT48PRE(3)
      INTEGER*4 NT48PREZ(3,8)
      INTEGER*4 NT48PREJ(3)

      CHARACTER*32 SKPATH
      CHARACTER*80 CONSTS
      character*100 trgratefile, findfname

      COMMON /PREVTIM/NT48PRE,NT48PREZ,NT48PREJ

#ifdef SKAM_PRO_CONST
      CONSTS = SKAM_PRO_CONST
      SKPATH = ' '
#else
      CONSTS = '/skam/const'
      SKPATH = 'SKPATH'
#endif
#ifdef SKPATH_ENV
      SKPATH = SKPATH_ENV
#endif


      if(icall.eq.0) then
       print *, 'Apply charge correction with trigger rate & tdiff'
       icall = 1         
      endif     

c ---Read trigger rate for each run from trigger rate table
      if(nrunsk.ne.run)then
         trgflg = 0

         if(SK_GEOMETRY==1) then
            findfname = 'trigger_rate_sk1.dat'
         elseif(SK_GEOMETRY==2) then
            findfname = 'trigger_rate_sk2.dat'
         elseif(SK_GEOMETRY==3) then
            findfname = 'trigger_rate_sk3.dat'
         else
            print*, 'skqcorrate: No trigger-rate file!'
            stop
         endif

         call findfile(trgratefile,findfname,SKPATH,CONSTS)
         
         open(unit=10,file=trgratefile,status='old',err=90)            
 15      read(10,*,err=95,end=20)nrun,nrate
         
c     --If this run has trigger rate
         if(nrunsk == nrun)then
            trgrate = nrate
            
c       --2kHz correction in case of high rate 
            if(trgrate .gt. 2000.)then
               trgrate = 2000.
            endif

            trgflg = 1
            goto 30
         endif

         goto 15
 20      continue

 30      continue
         close (10)

         if(trgflg.eq.0)then
            print *,'skqcorrate: not apply charge corr.; no trginfo'
         endif

         run = nrunsk

      endif


c ---Read time deffernce from previous event
      if(nrunsk.ne.run.or.nevsk.ne.event)then
         
         event = nevsk
         call RDEVINFO(iseg)
         iclkpre(1) = NT48PRE(1)
         iclkpre(2) = NT48PRE(2)
         iclkpre(3) = NT48PRE(3)
         
         tdiff=diftevsk(iclkpre)/1000.0
         
         if(iseg.ge.2)then
            
            iclkpre_he(1) = NT48PREZ(1,2)
            iclkpre_he(2) = NT48PREZ(2,2)
            iclkpre_he(3) = NT48PREZ(3,2)
            
            tdiff_he=diftevsk(iclkpre_he)/1000.0
            
         else
c       --If there are no info of HE event
            iclkpre_he(1) = iclkpre(1)
            iclkpre_he(2) = iclkpre(2)
            iclkpre_he(3) = iclkpre(3)

            tdiff_he=diftevsk(iclkpre_he)/1000.0
            
         endif
         
c         print *, 'tdiff_he, tdiff (usec):', tdiff_he, tdiff
      endif
      
      
c ---Start charge correction

c      if(icall.eq.0) then         
c       print *, '/----- charge correction fanc -------------------'
c       print *, '|frate=(0.0013)**2*(qisk)**(1./2.)*trgrate'
c       print *, '|ftdif=(qisk)**(-2.)*0.0004*exp(-tdiff_he/10000.)'
c       print *, '|offset=0.041*(qisk)**(1./4.)'
c       print *, '|corqisk=QISK - sqrt(frate + ftdif) + offset'
c       print *, '\------------------------------------------------'
c       icall = 1         
c      endif     
 
c  --If trigger rate table does not have trigger info (trgflg=0)
      if(trgflg.eq.0) goto 60

      
c  --If trigger rate table have trigger info (trgflg=1)

      QISMSK =0.
      QIMXSK =0.

      DO 50 I=1,NQISK
         ICAB = IHCAB(I)
    
         if(QISK(ICAB)>0) then
            
            frate = (0.0013)**2*(QISK(ICAB))**(1./2.)*trgrate
            ftdif = (QISK(ICAB))**(-2.)*0.0004*exp(-tdiff_he/10000.)
            offset = 0.041*(QISK(ICAB))**(1./4.)
                        
            QISK(ICAB) = QISK(ICAB) - sqrt(frate + ftdif) + offset

         endif         
      
         IF(QISK(ICAB).GE.0     ) QISMSK = QISMSK+QISK(ICAB)
         IF(QISK(ICAB).GT.QIMXSK) THEN
            QIMXSK = QISK(ICAB)
            MXQISK = ICAB
         END IF
         
 50   CONTINUE

 60   CONTINUE
      RETURN

 90   CONTINUE
      write(6,*)'skqcorrate: cannot find ', findfname
      stop

 95   CONTINUE
      write(6,*)'skqcorrate: read error in ', trgratefile
      stop


      END
      


C=================================

      SUBROUTINE RDEVINFO(NSEGM)

      IMPLICIT NONE
      
      INTEGER*4 ISTAT,I,J
      INTEGER*4 NDATA,IDATA(512), NSEGM

C------------------------------------
      INTEGER*4 NT48PRE(3)
      INTEGER*4 NT48PREZ(3,8)
      INTEGER*4 NT48PREJ(3)

      COMMON /PREVTIM/NT48PRE,NT48PREZ,NT48PREJ
C------------------------------------

      CALL KZBLOC('EVINFO',ISTAT)

      IF (ISTAT.EQ.0) THEN
         write(*,*) '**** RDEVINFO : No evinfo bank ****'
         goto 6000
      else
         call kznseg('EVINFO',NDATA)
         NSEGM = NDATA
C     write(*,*) "Number of segments:",NDATA


C-- length of each segment
         call kzget0('EVINFO',0,NDATA,IDATA)
C     
C--   Normal
C     
         call kzget0('EVINFO',1,NDATA,IDATA)
         DO 5010 I=1,3
            NT48PRE(I)=IDATA(I)
 5010    continue
         
C--   if there are no HE trig info, skip
         
         if (NSEGM.eq.1)then
            DO 5011 J=0,7
               DO 5012 I=1,3
                  NT48PREZ(I,J+1)=0
 5012          continue
 5011       CONTINUE
            
            goto 5070
         endif
         
C     
C--   Each trigger ID
C     
         call kzget0('EVINFO',2,NDATA,IDATA)
         DO 5050 J=0,7
            DO 5030 I=1,3
               NT48PREZ(I,J+1)=IDATA(J*3+I)
 5030       continue
            
 5050    CONTINUE
         
C     
C--   Previous rejected event
C     
         call kzget0('EVINFO',3,NDATA,IDATA)
         DO 5060 I=1,3
            NT48PREJ(I)=IDATA(I)
 5060    continue
         
 5070    continue

      endif      
      RETURN

      
 6000 continue
      stop
      
      END
