************************************************************************
*     -------------------------------------
      SUBROUTINE TQASK(*)
*     -------------------------------------
*
*     (Purpose)
*        Read 'TQA' bank and fill the commons /SKQA/,/SKTA/
*
*     -->CHANGE:  Read 'RWANTI', fill commons /skqa/,/skta/,/sktqaz/,/skheada/
*        Only go back to TQA if RWANTI not there (to still handle MC)
*
*     (Input)
*        none
*
*     (Output)
*       
*     (Return)
*        Return 1 ; Data w/o 'TQA' bank
*       
*
*     (Creation Date and Author)
*       1994.11.02 ; First version by Koshio,Y
*	1996.03.30 ; Use dummy constants for anti- data -- Flanagan, J.
*	1996.07.18 ; Upgraded antical version from 5 to 8 
*                    (Give BADCAL tubes dummy calibrations instead
*                     of rejecting them.  Otherwise the same.) -- Flanagan, J.
*	1996.07.10 ; Added Version 9 (new OD timing since Run 2393) --Flanagan
*       1998.03.04 ; Added correct gain -- Kibayashi, A
*
************************************************************************

#include "skparm.h"
#include "sktq.h"
#include "skhead.h"
#include "zbs.h"
#include "apversion.h"

      PARAMETER(IBUFSZ = 15 + 2 * 2048 * 16)
      CHARACTER*32 CNAME
      INTEGER*4 IBUF(IBUFSZ)
      INTEGER*2 IBUFS(2 * IBUFSZ)
      EQUIVALENCE(IBUF(1), IBUFS(1))
      DIMENSION RBUF(20)
      dimension ihbuf(20)
      integer*2 ibufstmp(2)

      integer   obufsz
      parameter(obufsz = 16 * 2048)
      INTEGER*4 OBUF(3, OBUFSZ)
      INTEGER*2 OBUFS(6, OBUFSZ)
      real*4    robuf(3,obufsz)
      EQUIVALENCE(OBUF(1,1), OBUFS(1,1))
      EQUIVALENCE(OBUF(1,1), robuf(1,1))

      PARAMETER(ISZHD=1) 
      DIMENSION ITQARHD(ISZHD)
      dimension iahdhd(iszhd)

      INTEGER ENDIAN
      INTEGER*2 ENDIANS(2)
      EQUIVALENCE (ENDIAN,ENDIANS(1))
      INTEGER IDX_FLZ
      INTEGER IDX_CAB

      real tcnvsk_od, qcnvsk_od

C --- Initialization 

      DO 1 I=1,MAXPMA
         QASK(I) = 0.
         TASK(I) = 0.
 1    CONTINUE   
      
      CNAME = 'MCPARMCONV'
      CALL KZBLOC(CNAME,IPBANK)
      IF(IPBANK.EQ.0) THEN
         TCNVSK_OD = 10.
c         QCNVSK_OD = 10.
      ELSE
         CALL KZGET1(CNAME,0,NDATA,RBUF)
         TCNVSK_OD = RBUF(2)
c         QCNVSK_OD = RBUF(3)
      END IF

      if (sk_geometry.eq.1) then
c-A.K. factor of ~2 to match data
         
         if (sklibver.ge.4.73) then
            QCNVSK_OD = 13.34
         else
c K. S. Reproduce behavior for old apdetsim
            if (apdslibver.ge.4.00) then
               QCNVSK_OD = 13.34*1.9
            else
               qcnvsk_od = 5.5
            endif
         endif
      else 
         qcnvsk_od = 13.34
      endif

      nhitaz = 0
      NQASK = 0
      QASMSK = 0.
      QAMXSK = 0.
      TAMNSK = 100000.
      TAMXSK = -100000.

C --- Read TQA bank
c          ^^^--> RWANTI bank
c     CNAME = 'TQA'

      CNAME = 'RWANTI'
      CALL KZBLOC(CNAME,IPBANK)
      IF(IPBANK.LE.0) GOTO 900

      CALL KZGET0(CNAME,0,NDATA,IBUF)
      NHIT0 = IBUF(1)
      NWRD  = IBUF(2)

      CALL KZGET0(CNAME,1,NDATA,IBUF)

c
c     Test byte order and if necessary swap i*2 words in 
c         the equivalenced array
c
      endians(1) = 0
      endians(2) = 1

      if (endian.ne.1) then
c        Intel and DEC Alpha

c   t0 values
          ibufstmp(1) = ibufs(25)
          ibufstmp(2) = ibufs(26)
          ibufs(25)=ibufstmp(2)
          ibufs(26)=ibufstmp(1)
          ibufstmp(1) = ibufs(27)
          ibufstmp(2) = ibufs(28)
          ibufs(27)=ibufstmp(2)
          ibufs(28)=ibufstmp(1)

c   PMT data array
          do j=31,ndata*2-1,2        
            ibufstmp(1) = ibufs(j)
            ibufstmp(2) = ibufs(j+1)
            ibufs(j)=ibufstmp(2)
            ibufs(j+1)=ibufstmp(1)
          enddo
      endif

c
c     Extract header information into /SKHEADA/
c
      ltcgps    = ibuf(7)   
      nsgps     = ibuf(9)   
      nusgps    = ibuf(10)  
      ltctrg    = ibuf(11)  
      ltcbip    = ibuf(12)  
      itdct0(1) = ibufs(25) 
      itdct0(2) = ibufs(26) 
      itdct0(3) = ibufs(27) 
      itdct0(4) = ibufs(28) 
      iffscc    = ibuf(15)  
c
c     Dummy calibration is version 0:
c
c      if (nrunsk .lt. 1239) then
c         icalva = 6
c      else if (nrunsk .lt. 1619) then
c         icalva = 7
c      else if (nrunsk .lt. 2393) then
c         icalva = 8
c      else if (nrunsk .lt. 2800) then
c         icalva = 9
c      else
c         icalva = 10
c      endif
	
      call tqaver(nrunsk, icalva, ierr)
      if (ierr .ne. 0) then
         print *,'Error finding anti-counter calib version!'
         goto 998
      endif

      call odmapver(nrunsk, imapa, ierr)
      if (ierr .ne. 0) then
         print *,'Error finding anti-counter map version!'
         goto 998
      endif

c
c     Create 'AHEADER' bank
c
      ihbuf(1)  = ltcgps   
      ihbuf(2)  = nsgps    
      ihbuf(3)  = nusgps   
      ihbuf(4)  = ltctrg   
      ihbuf(5)  = ltcbip   
      ihbuf(6)  = itdct0(1)
      ihbuf(7)  = itdct0(2)
      ihbuf(8)  = itdct0(3)
      ihbuf(9)  = itdct0(4)
      ihbuf(10) = iffscc   
      ihbuf(11) = icalva

      ndata = 11

      iahdhd(1) = ndata
      CALL KZBCR0('AHEADER', IERR)
      CALL KZREP0('AHEADER', 0, 'I', iszhd, iahdhd)
      CALL KZREP0('AHEADER', 1, 'I', ndata, ihbuf)
c
c
c --- Fill the commons /SKQA/,/SKTA/,/SKTQAZ/
c
      call cvanti(ibuf, obuf, nrhit, icalva, imapa, ierr)
      if (ierr .ne. 0) then
         print *,'Error converting Anti data!'
         goto 998
      endif

      if (endian.eq.1) then
c        SUN convention
         idx_flz = 1
         idx_cab = 2
      else
c        Intel and DEC Alpha convention
         idx_flz = 2
         idx_cab = 1
      endif
      nhitaz = nrhit
      do 200 i = 1,nrhit
         ihtflz(i) = obufs(idx_flz,i)
         icabaz(i) = obufs(idx_cab,i)
         taskz(i)  = robuf(2,i)
         qaskz(i)  = robuf(3,i)
 200  continue

      call sktqacom()
c
c     Create 'TQAREAL' bank and fill with data
c
      itqarhd(1) = nhitaz
      CALL KZBCR1('TQAREAL',ISZHD,'1I',NHITAZ,3,'1I 2F',IERR) 
      CALL KZREP1('TQAREAL',0,ISZHD,ITQARHD)
      IF (NHITAZ.GT.0) THEN
         CALL KZLDAT('TQAREAL',LDAT)
         nent = 3*nhitaz
         CALL LBFCOPY(OBUF,IZBS(LDAT+ISZHD+1),nent)
      END IF

      RETURN

c
c     No RWANTI bank?  Try TQA:
c
 900  continue

      CNAME = 'TQA'
      CALL KZBLOC(CNAME,IPBANK)
      IF(IPBANK.LE.0) GOTO 998

      CALL KZGET0(CNAME,0,NDATA,IBUF)
      NHIT0 = IBUF(1)
      NWRD  = IBUF(2)

      CALL KZGET0(CNAME,1,NDATA,IBUF)

      NHIT = 0
      IPOI = 0
 100  IPOI = IPOI+1
      IF(IPOI.GT.NWRD) GOTO 30

      IF(BTEST(IBUF(IPOI),15)) THEN
         ICAB = MOD(IBUF(IPOI),2**15)
         IPOI = IPOI+1
      ELSE
         ISTR1 = IBUF(IPOI)/2**16
         IF(BTEST(ISTR1,14)) ICAB = ICAB+1
      END IF   

      ISTR1 = IBUF(IPOI)/2**16
C     ISTR2 = MOD(IBUF(IPOI),2**16)
C     Workaround of Absoft f77 MOD bug for negative numerator
      ISTR2 = IBUF(IPOI) - INT(IBUF(IPOI)/2**16)*2**16
      
C      IT = MOD(ISTR1,2**12)
C      IQ = MOD(ISTR2,2**12)
      IT = ISTR1
      IQ = ISTR2
C      write(*,*) "IBUF(IPOI)=",IBUF(IPOI)
C      write(*,*) "IT=",IT
C      write(*,*) "IQ=",IQ
C      IF (IT.lt.0) IT=IT+65536
      IF (IQ.lt.0) IQ=-IQ
C      write(*,*) "IT=",IT
C      write(*,*) "IQ=",IQ

      IF(ICAB.LT.1 .OR. ICAB.GT.MAXPMA) GOTO 100

      NHIT = NHIT+1

C --- Fill the commons /SKQA/,/SKTA/

      NQASK = NQASK+1

      TASK(ICAB) = FLOAT(IT)/TCNVSK_OD 
      QASK(ICAB) = FLOAT(IQ)/QCNVSK_OD 

C      write(*,*) "QASK(",ICAB,")=",QASK(ICAB),
C     $           "TASK(",ICAB,")=",TASK(ICAB)

C      write(*,*) "QASK(",ICAB,")=",QASK(ICAB)
      QASMSK = QASMSK+QASK(ICAB)
C      write(*,*) "QASMSK=",QASMSK

      IF(QASK(ICAB).GT.QAMXSK) THEN
         QAMXSK = QASK(ICAB)
c-a.k. q was devided by factor of ~2 in qcnvsk, multiply it back
         if (apdslibver.ge.4.00.and.sk_geometry.eq.1) then
            qamxsk = qamxsk*1.9
         endif
         MXQASK = ICAB
      END IF

      IF(TASK(ICAB).LT.TAMNSK) THEN
         TAMNSK = TASK(ICAB)
         MNTASK = ICAB
      END IF

      IF(TASK(ICAB).GT.TAMXSK) THEN
         TAMXSK = TASK(ICAB)
         MXTASK = ICAB
      END IF

C -- COPY TO TQAZ
      NHITAZ=NQASK

      IHTFLZ(NQASK)=0
      ICABAZ(NQASK)=ICAB+20000
      TASKZ(NQASK)=TASK(ICAB)
      QASKZ(NQASK)=QASK(ICAB)

      GOTO 100

      
 30   CONTINUE
      IF(NHIT .NE. NHIT0) CALL MSGOUT

      RETURN

C --- w/o 'TQA' bank

 998  RETURN 1

      END



