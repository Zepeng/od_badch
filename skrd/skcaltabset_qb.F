C====================================================================
C
      SUBROUTINE SKCALTABSET_QB(ihut, itko, ima, qbserial, ista)
C
C     Read and set calibration data for a QB
C
C     <<Input>>
C         ihut     : Hut #   
C         itko     : TKO BOX #
C         ima      : TKO MA #
C         qbserial : QB serial # 
C
C     <<Output>>
C         ISTA  :  status  (normal = 0,  error = -1)
C     
C      07-JUL-2007 written by Y.Takeuchi
C      13-JUL-2007 modified by Y.Takeuchi
C         o read from memory
C
C===================================================================
      IMPLICIT NONE
#include "skparm.h"
#include "skpdst.h"
#include "sktabl.h"
#include "skcalib.h"

      integer j
      integer IHUT, ITKO, IMA, qbserial, ista, icab
      CHARACTER*200 fname, fname2

c*** QB calibration parameters
      integer  ch0, range0, ii

c*** check only QB channel=0
      ista = 0
      if (ihut.ge.0.and.ihut.le.MAXHUT .and.
     $     itko.ge.1.and.itko.le.MAXTKOBOX .and.
     $     ima.ge.1.and.ima.le.MAXTKOMA) then
         icab = NQBCAB(ihut,itko,ima,0)
         if (qb_serialnum0(icab) .eq. qbserial) return
      else
         print *, 'skcaltabset_qb: argument error!'
         ista = -1
         return
      endif

c*** check CAL mode (1 or 2, for now)
      if (IQBCALMODE.lt.1 .or. IQBCALMODE.gt.2) then
         print *, 'skcaltabset_qb: CAL mode error! ', IQBCALMODE
         stop
      endif

c*** search QB calibration table in memory
      ii = -1
      do j = 1, MAXQB
         if (qqb_serialnum0(j).eq.qbserial) then
            ii = j
         endif
      enddo
      if (ii.lt.0) then
         print *,'skcaltabset_qb: error cannot find serial=',qbserial
         stop
      endif

c*** set QB connection table
      NQBSERIAL(ihut,itko,ima) = qbserial

c*** set QB calib table
      do ch0 = 0, 23
         icab = NQBCAB(ihut,itko,ima,ch0)
         if (icab.ge.1 .and. icab.le.MAXPM4) then
            do range0 = -1, 2
               qb_serialnum0(icab)        = qqb_serialnum0(ii)       
               qb_ch0(icab)               = ch0              
               qb_ped0mean(icab,range0,IQBCALMODE)   
     $              = qqb_ped0mean(ii,ch0,range0,IQBCALMODE)
               qb_cal0mean(icab,range0,IQBCALMODE)   
     $              = qqb_cal0mean(ii,ch0,range0,IQBCALMODE)
               qb_cntmin(icab,range0)     = qqb_cntmin(ii,ch0,range0)    
               qb_cntmax(icab,range0)     = qqb_cntmax(ii,ch0,range0)    
               qb_a0(icab,range0)         = qqb_a0(ii,ch0,range0)        
               qb_a1(icab,range0)         = qqb_a1(ii,ch0,range0)        
               qb_a2(icab,range0)         = qqb_a2(ii,ch0,range0)        
               qb_a3(icab,range0)         = qqb_a3(ii,ch0,range0)        
               qb_a4(icab,range0)         = qqb_a4(ii,ch0,range0)        
               qb_a5(icab,range0)         = qqb_a5(ii,ch0,range0)        
               qb_dsc0preamp(icab,range0) = qqb_dsc0preamp(ii,ch0,range0)
               qb_dsc0gain(icab,range0)   = qqb_dsc0gain(ii,ch0,range0)  
               qb_dsc0range(icab,range0)  = qqb_dsc0range(ii,ch0,range0) 
               qb_dsc0cnt(icab,range0)    = qqb_dsc0cnt(ii,ch0,range0)   
               qb_dsca0(icab,range0)      = qqb_dsca0(ii,ch0,range0)     
               qb_dsca1(icab,range0)      = qqb_dsca1(ii,ch0,range0)     
               qb_chg0i3(icab,range0)     = qqb_chg0i3(ii,ch0,range0)    
               qb_chg0comp1(icab,range0)  = qqb_chg0comp1(ii,ch0,range0) 
               qb_chga0(icab,range0)      = qqb_chga0(ii,ch0,range0)     
               qb_chga1(icab,range0)      = qqb_chga1(ii,ch0,range0)     
            enddo
         endif
      enddo

      return
      end
