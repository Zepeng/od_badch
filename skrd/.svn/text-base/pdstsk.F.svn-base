************************************************************************
*     -------------------------------------
      SUBROUTINE PDSTSK(*)
*     -------------------------------------
*
*     (Purpose)
*        Read NEXT 'PDST' bank and fill the commons /SKPDST/,/SKTEMP/
*                  'SPDST'                          /SKPDSTV/
*
*        Read 'PEDESTAL' for QB
*
*
*     (Input)
*        none
*
*     (Output)
*       
*     (Return)
*        Return 0 ; Data with 'PDST' or 'SPDST' or 'CADC' or 'PEDESTAL'
*        Return 1 ; Data w/o 'PDST' nor 'SPDST' nor 'CADC' nor 'PEDESTAL'
*
*     (Creation Date and Author)
*       1992.08.27 ; First version by K.S.Hirata
*       1996.08.10 ; SPDST added by K.Inoue
*       1997.03.   : support VETO counter pedestal
*       2006.11.28 : IBUF(12001*5) -> IBUF(12002*5) by Hayato/Takeuchi
*       2007.07.02 : modified by y.takeuchi
*         o added PEDESTAL bank for QB 
*       2007.07.18 : modified by y.takeuchi
*         o load QBCONST file, if needed
*         o added dummy address for QB test bench data
*         o comment out checking pedestal bank
*         o use 40000 if nrunsk=0 (tentative)
*       2008.02.28 : ported from PDSTSK.F, added ROOT I/O by y.takeuchi
*       2008.06.09 : Unified zbs and root by Y.Koshio
*       2012.02.14 : IBUF(12002*5) ->  IBUF(13200*7), rvw 
************************************************************************
      implicit none

#include "skparm.h"
#include "skhead.h"
#include "sktabl.h"
#include "skpdst.h"
#include "skcadc.h"
#include "skveto.h"
#include "skcalib.h"

      CHARACTER*32 CNAME

      integer i, j, iexpd, npdwrd, ncbl, numwd, ipbank, ndata, ntpwrd
      integer address, header, serial, temp, dac_volt, ctr_gain
      integer ihut, itko, ima, icab, k, ista, calmode, ima1

      ! In SK-IV+, 11146 ID Tubes, 1885 OD Tubes, Trigger Cables 
      ! etc. all with Ped and Cal data -> expand buffer (need 13186 minimum)
      INTEGER*4 IBUF(13200*7)
      INTEGER*4 INITFL
      DATA INITFL /0/
      SAVE INITFL

      INTEGER MA_QBCONST1, MA_PGAIN1, MA_TQMAP1
      INTEGER MI_QBCONST1, MI_PGAIN1, MI_TQMAP1

      integer status

      integer nped, ped_cable(MAXPM4), ped_t(3,MAXPM4), ped_q(3,MAXPM4) 
      integer ncal, cal_cable(MAXPM4), cal_t(3,MAXPM4), cal_q(3,MAXPM4) 
      integer nqb,  qb_address(MAXQB), qb_header(MAXQB),
     $     qb_serial_id(MAXQB), qb_temp(MAXQB)

C --- Initialization 

      IF (INITFL.NE.9999) THEN
        DO 1 I=1,MAXPM
           IPDSTT(I,1)=0
           IPDSTQ(I,1)=0
           IPDSTTS(I,1)=0
           IPDSTQS(I,1)=0
 1      CONTINUE

        DO 11 I=MAXPM+1,12000
           IPDSTTV(I,1)=0
           IPDSTQV(I,1)=0
           IPDSTTSV(I,1)=0
           IPDSTQSV(I,1)=0
 11     Continue
   
      INITFL = 9999
      ENDIF
         
      DO 2 I=1,48
         ITEMPER(I)=0
 2    CONTINUE

      DO 3 I=1,16
         IADC(I)=0
 3    CONTINUE

c**** for non-ATM ******************************************
      if(SK_GEOMETRY.ge.4) then
         if (SK_FILE_FORMAT.eq.0) goto 995  ! ZBS format
         if (SK_FILE_FORMAT.eq.1) goto 997  ! skroot
      endif
c***********************************************************
      if(SK_FILE_FORMAT.ne.0) then ! non-ZBS format
         write(6,*) 'ped data in SK-1,2,3 should be ZBS format:',
     $        SK_GEOMETRY
         stop
      endif

      IEXPD = 1
      CNAME = 'PDST'
      CALL KZBLOC(CNAME,IPBANK)
      IF(IPBANK.LE.0) GOTO 998

      IEXPD = 0
      CALL KZGET0(CNAME,0,NDATA,IBUF)
      NTPWRD  = IBUF(4)
      NPDWRD  = IBUF(5)

      write(*,*) "CHKECKING PDST BANK"

C ---
      CALL KZGET0(CNAME,1,NDATA,IBUF)

      NRUNPD=IBUF(2)
      NSRUNPD=IBUF(3)
      NEVNTPD=IBUF(4)         
      NDATEPD(1)=IBUF(5)/10000
      NDATEPD(2)=IBUF(5)/100-NDATEPD(1)*100
      NDATEPD(3)=IBUF(5)-NDATEPD(2)*100-NDATEPD(1)*10000
      NTIMEPD(1)=IBUF(6)/10000
      NTIMEPD(2)=IBUF(6)/100-NTIMEPD(1)*100
      NTIMEPD(3)=IBUF(6)-NTIMEPD(2)*100-NTIMEPD(1)*10000
      NSERVPD=IBUF(8)
      NSCANPD=IBUF(10)
      NBITPD =IBUF(11)
C      DO 3 I=1,6
C        NTKOST(I)=IBUF(11+I)
C 3    CONTINUE

      CALL KZGET0(CNAME,2,NDATA,IBUF)

      DO 4 I=1,48
        ITEMPER(I)=IBUF(I+1)
 4    CONTINUE


      CALL KZGET0(CNAME,3,NDATA,IBUF)

      DO 5 I=1,NDATA/5
C        IF(I.GT.MAXPM) GOTO 5
        IF(I.GT.12000) GOTO 5
        NCBL=IBUF((I-1)*5+1)
        IF ((NCBL.GT.12000).OR.(NCBL.LT.1)) GOTO 5
        
        IF (     (MOD(IBUF((I-1)*5+2),2**16).EQ.0)
     &       .AND.(MOD(IBUF((I-1)*5+3),2**16).EQ.0)
     &       .AND.(MOD(IBUF((I-1)*5+4),2**16).EQ.0)
     &       .AND.(MOD(IBUF((I-1)*5+5),2**16).EQ.0))
     &   GOTO 5

        IF ((NCBL.LE.MAXPM)) then

        IPDSTTS(NCBL,1)=    IBUF((I-1)*5+2)/(2**16)
        IPDSTT(NCBL,1) =MOD(IBUF((I-1)*5+2),2**16)
        IPDSTQS(NCBL,1)=    IBUF((I-1)*5+3)/(2**16)
        IPDSTQ(NCBL,1) =MOD(IBUF((I-1)*5+3),2**16)
        IPDSTTS(NCBL,2)=    IBUF((I-1)*5+4)/(2**16)
        IPDSTT(NCBL,2) =MOD(IBUF((I-1)*5+4),2**16)
        IPDSTQS(NCBL,2)=    IBUF((I-1)*5+5)/(2**16)
        IPDSTQ(NCBL,2) =MOD(IBUF((I-1)*5+5),2**16)

         else

        IPDSTTSV(NCBL,1)=    IBUF((I-1)*5+2)/(2**16)
        IPDSTTV(NCBL,1) =MOD(IBUF((I-1)*5+2),2**16)
        IPDSTQSV(NCBL,1)=    IBUF((I-1)*5+3)/(2**16)
        IPDSTQV(NCBL,1) =MOD(IBUF((I-1)*5+3),2**16)
        IPDSTTSV(NCBL,2)=    IBUF((I-1)*5+4)/(2**16)
        IPDSTTV(NCBL,2) =MOD(IBUF((I-1)*5+4),2**16)
        IPDSTQSV(NCBL,2)=    IBUF((I-1)*5+5)/(2**16)
        IPDSTQV(NCBL,2) =MOD(IBUF((I-1)*5+5),2**16)
        
         endif

c        write(*,*) "PEDESTAL_T(",I,",A)=",IPDSTT(I,1)
c        write(*,*) "PEDESTAL_Q(",I,",A)=",IPDSTQ(I,1)
c        write(*,*) "PEDESTAL_T(",I,",B)=",IPDSTT(I,2)
c        write(*,*) "PEDESTAL_Q(",I,",B)=",IPDSTQ(I,2)

 5     CONTINUE
         
C     ---
         
      RETURN

C --- w/o 'PDST' bank

C 998  RETURN 1
 998  CONTINUE

      IEXPD = 1
      CNAME = 'SPDST'
      CALL KZBLOC(CNAME,IPBANK)
      IF(IPBANK.LE.0) GOTO 999

      IEXPD = 0
      CALL KZGET0(CNAME,0,NDATA,IBUF)
      NTPWRD  = IBUF(4)
      NPDWRD  = IBUF(5)

      write(*,*) "CHKECKING SPDST BANK"

C ---
      CALL KZGET0(CNAME,1,NDATA,IBUF)

      NRUNPD=IBUF(2)
      NSRUNPD=IBUF(3)
      NEVNTPD=IBUF(4)         
      NDATEPD(1)=IBUF(5)/10000
      NDATEPD(2)=IBUF(5)/100-NDATEPD(1)*100
      NDATEPD(3)=IBUF(5)-NDATEPD(2)*100-NDATEPD(1)*10000
      NTIMEPD(1)=IBUF(6)/10000
      NTIMEPD(2)=IBUF(6)/100-NTIMEPD(1)*100
      NTIMEPD(3)=IBUF(6)-NTIMEPD(2)*100-NTIMEPD(1)*10000
      NSERVPD=IBUF(8)
      NSCANPD=IBUF(10)
      NBITPD =IBUF(11)

      CALL KZGET0(CNAME,2,NDATA,IBUF)

      DO 44 I=1,48
        ITEMPER(I)=IBUF(I+1)
 44   CONTINUE


      CALL KZGET0(CNAME,3,NDATA,IBUF)

      DO 55 I=1,NDATA/3
        IF(I.GT.MAXPM) GOTO 55
        NCBL=IBUF((I-1)*3+1)
        IF ((NCBL.GT.MAXPM).OR.(NCBL.LT.1)) GOTO 55
        IF (IBUF((I-1)*3+2).GE.0) THEN
           IPDSTT(NCBL,1) =    IBUF((I-1)*3+2)/2**16
           IPDSTQ(NCBL,1) =MOD(IBUF((I-1)*3+2),2**16)
        ELSE
           IPDSTT(NCBL,1) =    IBUF((I-1)*3+2)/2**16+65536
           IPDSTQ(NCBL,1) =MOD(IBUF((I-1)*3+2),2**16)+65536
        ENDIF

        IF (IBUF((I-1)*3+3).GE.0) THEN
           IPDSTT(NCBL,2) =    IBUF((I-1)*3+3)/2**16
           IPDSTQ(NCBL,2) =MOD(IBUF((I-1)*3+3),2**16)
        ELSE
           IPDSTT(NCBL,2) =    IBUF((I-1)*3+3)/2**16+65536
           IPDSTQ(NCBL,2) =MOD(IBUF((I-1)*3+3),2**16)+65536
        ENDIF
c        write(*,*) "PEDESTAL_T(",I,",A)=",IPDSTT(I,1)
c        write(*,*) "PEDESTAL_Q(",I,",A)=",IPDSTQ(I,1)
c        write(*,*) "PEDESTAL_T(",I,",B)=",IPDSTT(I,2)
c        write(*,*) "PEDESTAL_Q(",I,",B)=",IPDSTQ(I,2)

 55    CONTINUE
         
C     ---
         
      RETURN

C --- w/o 'SPDST' bank

 999  CONTINUE
 
      IEXPD = 1
C      write(*,*) "SEARCHING CADC"
      CNAME = 'CADC'	
      CALL KZBLOC(CNAME,IPBANK)
c      IF(IPBANK.LE.0) RETURN IEXPD
      IF(IPBANK.LE.0) goto 995  ! the data may be QB

      IEXPD = 0
C     write(*,*) "FOUND CADC"
      CALL KZGET1(CNAME,0,NDATA,IBUF)
      NUMWD  = IBUF(1)

C ---
      CALL KZGET1(CNAME,1,NDATA,IBUF)
      IF (NUMWD.ne.16) then
        write(*,*) "ERROR!! NUMWD=",NUMWD
        stop
      ENDIF
      DO 100 I=1,NUMWD
         IADC(I)=IBUF(I)
 100  CONTINUE
      RETURN 0

c**** from here, for QB ******************************************
 995  continue

      IEXPD = 1
      CNAME = 'PEDESTAL'
      CALL KZBLOC(CNAME,IPBANK)
      IF(IPBANK.LE.0) RETURN IEXPD  ! iexpd=1 no PDST nor PEDESTAL

      IEXPD = 0
      CALL KZGET0(CNAME,0,NDATA,IBUF)

ccyt      write(*,*) "CHECKING PEDESTAL BANK"
ccyt     $     ,ibuf(2), ibuf(3), ibuf(4), ibuf(5), ibuf(6), ibuf(7)

C ---
      CALL KZGET0(CNAME,1,NDATA,IBUF)
      NRUNPD=IBUF(2)
      NSRUNPD=IBUF(3)
      NEVNTPD=IBUF(4)         
      NDATEPD(1)=IBUF(5)/10000
      NDATEPD(2)=IBUF(5)/100-NDATEPD(1)*100
      NDATEPD(3)=IBUF(5)-NDATEPD(2)*100-NDATEPD(1)*10000
      NTIMEPD(1)=IBUF(6)/10000
      NTIMEPD(2)=IBUF(6)/100-NTIMEPD(1)*100
      NTIMEPD(3)=IBUF(6)-NTIMEPD(2)*100-NTIMEPD(1)*10000
      NSERVPD=IBUF(8)
      NSCANPD=IBUF(10)
      NBITPD =IBUF(11)

      CALL KZGET0(CNAME,2,NDATA,IBUF)
      DO  I=1,48
        ITEMPER(I)=IBUF(I+1)
      enddo

c 5th seg.:  Cal. Config.
      CALL KZGET0(CNAME,5,NDATA,IBUF)
      DO I=1,NDATA/2
         j = i*2-1
         address  = iand(IBUF(j), 4095)  ! address is lower 12bit
         header   = ishft(IBUF(j), -16)
         dac_volt = iand(IBUF(j+1), 65535)
         ctr_gain = ishft(IBUF(j+1), -16)

c*** decode address
         ima  = iand(address, 31)
         itko = iand(ishft(address-ima, -5), 15)
         ihut = iand(ishft(address-ima-itko*32, -9), 7)

ccyt         if(ima.eq.0.and.itko.eq.0.and.ihut.eq.0) return

c*** check address range         
         if (ihut.lt.0 .or. ihut.gt.maxhut .or.
     $        itko.lt.1 .or. itko.gt.MAXTKOBOX .or.
     $        ima.lt.1 .or. ima.gt.MAXTKOMA) then
c*** skip error check, for now (16-JUL-2007 y.t.)
c            print *, 'pdstsk: address error2: ', ihut, itko, ima
c            stop
         endif
c*** do nothing, for now         
      enddo

c*** 7th segment: CAL table (need calmode)
      CALL KZGET0(CNAME,7,NDATA,IBUF)

c*** obtain cal mode from the 1st cable (upper 16bit)
cc      calmode = ishft(IBUF(1), -16)
      calmode = iand(ishft(IBUF(1), -16), 15) ! need to mask upper 12bit
      if (calmode.ne.IQBCALMODE) then
         IQBCALMODE = calmode
         print *, 'pdstsk: set CAL mode = ', IQBCALMODE 
c*** clear QB connection table to reload it
         do ihut = 0, MAXHUT
            do itko = 1, MAXTKOBOX
               do ima = 1, MAXTKOMA
                  NQBSERIAL(ihut,itko,ima) = 0
               enddo
            enddo
         enddo
      endif

      DO I=1,NDATA/7
         NCBL    = iand(IBUF((I-1)*7+1),2**16-1)
         IF ((NCBL.GT.MAXPM4).OR.(NCBL.LT.0)) then
            print *, 'pdstsk: error invalid cable2 = ', ncbl
            stop
         else IF (NCBL.eq.0) then
!           these should now be suppressed in the reformatter, rvw 20120214 
            print *, 'pdstsk: error invalid cable2 = ', ncbl, i 
!!!!            stop
         else
            IQBCALTs(ncbl,-1,calmode) = ishft(IBUF((I-1)*7+2), -20) 
            IQBCALTs(ncbl,0,calmode)  = ishft(IBUF((I-1)*7+2), -20) 
            IQBCALQs(ncbl,-1,calmode) = ishft(IBUF((I-1)*7+3), -16)  
            IQBCALQs(ncbl,0,calmode)  = ishft(IBUF((I-1)*7+3), -16) 
            IQBCALTs(ncbl,1,calmode)  = ishft(IBUF((I-1)*7+4), -20) 
            IQBCALQs(ncbl,1,calmode)  = ishft(IBUF((I-1)*7+5), -16) 
            IQBCALTs(ncbl,2,calmode)  = ishft(IBUF((I-1)*7+6), -20) 
            IQBCALQs(ncbl,2,calmode)  = ishft(IBUF((I-1)*7+7), -16) 
            
            IQBCALT(ncbl,-1,calmode) = iand(IBUF((I-1)*7+2), 2**20-1) 
            IQBCALT(ncbl,0,calmode)  = iand(IBUF((I-1)*7+2), 2**20-1)  
            IQBCALQ(ncbl,-1,calmode) = iand(IBUF((I-1)*7+3), 2**16-1)  
            IQBCALQ(ncbl,0,calmode)  = iand(IBUF((I-1)*7+3), 2**16-1)  
            IQBCALT(ncbl,1,calmode)  = iand(IBUF((I-1)*7+4), 2**20-1) 
            IQBCALQ(ncbl,1,calmode)  = iand(IBUF((I-1)*7+5), 2**16-1) 
            IQBCALT(ncbl,2,calmode)  = iand(IBUF((I-1)*7+6), 2**20-1) 
            IQBCALQ(ncbl,2,calmode)  = iand(IBUF((I-1)*7+7), 2**16-1) 

c            print *, i, ndata/7,ncbl, IQBCALQ(ncbl,0,calmode), 
c     $        IQBCALQ(ncbl,1,calmode), 
c     $        IQBCALQ(ncbl,2,calmode), IQBCALQs(ncbl,0,calmode), 
c     $        IQBCALQs(ncbl,1,calmode), 
c     $        IQBCALQs(ncbl,2,calmode) 
         endif

      enddo

c 4th seg.:  QBEE Config.
      CALL KZGET0(CNAME,4,NDATA,IBUF)
      DO I=1,NDATA/2
         j = i*2-1
         address = iand(IBUF(j), 4095)  ! address is lower 12bit
         header  = ishft(IBUF(j), -16)
         serial  = iand(IBUF(j+1), 65535)
         temp    = ishft(IBUF(j+1), -16)

c*** decode address
         ima  = iand(address, 31)
         itko = iand(ishft(address-ima, -5), 15)
         ihut = iand(ishft(address-ima-itko*32, -9), 7)

c*** check address range         
         if (ihut.eq.0 .and. itko.eq.0 .and. ima.eq. 0) then
cc do nothing            
         else if (ihut.lt.0 .or. ihut.gt.maxhut .or.
     $           itko.lt.1 .or. itko.gt.MAXTKOBOX .or.
     $           ima.lt.1 .or. ima.gt.MAXTKOMA) then
            print *, 'pdstsk: address error1: ', ihut, itko, ima
            stop
         else
c*** prepare QB calibration tables
            if (NQBSERIAL(ihut,itko,ima).ne.serial) then
c               print 200, ihut,itko,ima, NQBSERIAL(ihut,itko,ima),
c     $              serial, nrunpd, nrunsk, nsubsk, nevsk
 200           format('pdstsk: QB at ',3(i2,1x),'from ',i5,' to ',i5,1x,
     $              ' ',i6,1x,i6,1x,i4,1x,i10)
c***  load QB calib table from file
               if (ma_qbconst.eq.0 .and. mi_qbconst.eq.0) then
                  if (nrunsk.gt.0) then
                     CALL SKCALTABVER(NRUNSK, MA_QBCONST1, MI_QBCONST1, 
     $                    MA_TQMAP1, MI_TQMAP1, MA_PGAIN1, MI_PGAIN1)
                  else
c*** obtain run number from this event
                     print *,'pdstsk: nrunsk=0 use nrunpd=',nrunpd
                     CALL SKCALTABVER(nrunpd, MA_QBCONST1, MI_QBCONST1, 
     $                    MA_TQMAP1, MI_TQMAP1, MA_PGAIN1, MI_PGAIN1)
                  endif
                  CALL SKCALTABSET_QBCONST(MA_QBCONST1, 0, ISTA)
                  IF (MI_QBCONST1 .GT. 0) THEN
                     CALL SKCALTABSET_QBCONST(MA_QBCONST1, MI_QBCONST1, ISTA)
                  ENDIF
               endif
c*** copy QB calib table from memory
               call skcaltabset_qb(ihut, itko, ima, serial, ista) 
               if (ista.ne.0) then
                  print *, 'pdstsk: error skcaltabset'
                  stop
               endif
            endif
c*** copy QB temperature
            IQBTEMP(ihut, itko, ima) = temp
         endif

c         print *, i, j, address, ihut, itko, ima, serial, header, temp

      enddo

c*** seg.3: pedestal table (need calmode)
      CALL KZGET0(CNAME,3,NDATA,IBUF)
      DO I=1,NDATA/7

cc upper 16 bits contain hit averaging information starting run 60301
cc         NCBL=IBUF((I-1)*7+1)
         NCBL=iand(IBUF((I-1)*7+1), 65535)

         IF (NCBL.eq.0) then
cc do nothing
         else IF ((NCBL.GT.MAXPM4).OR.(NCBL.LT.1)) then
            print *, 'pdstsk: error invalid cable = ', ncbl
            stop
         else
            IQBPDSTTs(ncbl,-1,calmode) = ishft(IBUF((I-1)*7+2), -20) 
            IQBPDSTTs(ncbl,0,calmode)  = ishft(IBUF((I-1)*7+2), -20) 
            IQBPDSTQs(ncbl,-1,calmode) = ishft(IBUF((I-1)*7+3), -16)  
            IQBPDSTQs(ncbl,0,calmode)  = ishft(IBUF((I-1)*7+3), -16) 
            IQBPDSTTs(ncbl,1,calmode)  = ishft(IBUF((I-1)*7+4), -20) 
            IQBPDSTQs(ncbl,1,calmode)  = ishft(IBUF((I-1)*7+5), -16) 
            IQBPDSTTs(ncbl,2,calmode)  = ishft(IBUF((I-1)*7+6), -20) 
            IQBPDSTQs(ncbl,2,calmode)  = ishft(IBUF((I-1)*7+7), -16) 

            IQBPDSTT(ncbl,-1,calmode) = iand(IBUF((I-1)*7+2), 2**20-1) 
            IQBPDSTT(ncbl,0,calmode)  = iand(IBUF((I-1)*7+2), 2**20-1)  
            IQBPDSTQ(ncbl,-1,calmode) = iand(IBUF((I-1)*7+3), 2**16-1)  
            IQBPDSTQ(ncbl,0,calmode)  = iand(IBUF((I-1)*7+3), 2**16-1)  
            IQBPDSTT(ncbl,1,calmode)  = iand(IBUF((I-1)*7+4), 2**20-1) 
            IQBPDSTQ(ncbl,1,calmode)  = iand(IBUF((I-1)*7+5), 2**16-1) 
            IQBPDSTT(ncbl,2,calmode)  = iand(IBUF((I-1)*7+6), 2**20-1) 
            IQBPDSTQ(ncbl,2,calmode)  = iand(IBUF((I-1)*7+7), 2**16-1) 

c            if (IQBPDSTQ(ncbl,0,1).gt.0)
c     $        print *, i, ndata/7,ncbl, IQBPDSTQ(ncbl,0,1), IQBPDSTQ(ncbl,1,1), 
c     $        IQBPDSTQ(ncbl,2,1), IQBPDSTQs(ncbl,0,1), IQBPDSTQs(ncbl,1,1), 
c     $        IQBPDSTQs(ncbl,2,1),
c     $        nqbhut(ncbl),nqbtko(ncbl),nqbsl(ncbl)
         endif

      enddo


C     ---
         
ccyt  normal return for QB

      RETURN 0

c**** from here, for QB skroot ******************************************
 997  continue

      call skroot_get_pedestal(root_id, status, nrunpd,
     $     nped, ped_cable, ped_t, ped_q, 
     $     ncal, cal_cable, cal_t, cal_q,
     $     nqb,  qb_address, qb_header, qb_serial_id, qb_temp)

c*** read CAL table ***************************
      if (ncal.gt.0) then
c***  obtain cal mode from the 1st cable (upper 16bit)
cc         calmode = ishft(cal_cable(1), -16)
         calmode = iand(ishft(cal_cable(1),-16),15) ! need to mask upper 12bit
         if (calmode.ne.IQBCALMODE) then
            IQBCALMODE = calmode
            print *, 'pdstsk: set CAL mode = ', IQBCALMODE 
c***  clear QB connection table to reload it
            do ihut = 0, MAXHUT
               do itko = 1, MAXTKOBOX
                  do ima = 1, MAXTKOMA
                     NQBSERIAL(ihut,itko,ima) = 0
                  enddo
               enddo
            enddo
         endif

         do i = 1, ncal
            ncbl = iand(cal_cable(i),2**16-1)
            
            if ((NCBL.GT.MAXPM4).OR.(NCBL.LT.1)) then
               print *, 'pdstsk: error invalid cable = ', ncbl
               stop
            else
               IQBCALTs(ncbl,-1,calmode) = ishft(cal_t(1,i), -20) 
               IQBCALTs(ncbl,0,calmode)  = ishft(cal_t(1,i), -20) 
               IQBCALQs(ncbl,-1,calmode) = ishft(cal_q(1,i), -16)  
               IQBCALQs(ncbl,0,calmode)  = ishft(cal_q(1,i), -16) 
               IQBCALTs(ncbl,1,calmode)  = ishft(cal_t(2,i), -20) 
               IQBCALQs(ncbl,1,calmode)  = ishft(cal_q(2,i), -16) 
               IQBCALTs(ncbl,2,calmode)  = ishft(cal_t(3,i), -20) 
               IQBCALQs(ncbl,2,calmode)  = ishft(cal_q(3,i), -16) 

               IQBCALT(ncbl,-1,calmode) = iand(cal_t(1,i), 2**20-1) 
               IQBCALT(ncbl,0,calmode)  = iand(cal_t(1,i), 2**20-1)  
               IQBCALQ(ncbl,-1,calmode) = iand(cal_q(1,i), 2**16-1)  
               IQBCALQ(ncbl,0,calmode)  = iand(cal_q(1,i), 2**16-1)  
               IQBCALT(ncbl,1,calmode)  = iand(cal_t(2,i), 2**20-1) 
               IQBCALQ(ncbl,1,calmode)  = iand(cal_q(2,i), 2**16-1) 
               IQBCALT(ncbl,2,calmode)  = iand(cal_t(3,i), 2**20-1) 
               IQBCALQ(ncbl,2,calmode)  = iand(cal_q(3,i), 2**16-1) 
            endif

         enddo
      endif

c*** read QB config ***************************
      do i = 1, nqb
         address = qb_address(i)
         header  = qb_header(i)
         serial  = qb_serial_id(i)
         temp    = qb_temp(i)

c*** decode address
         ima  = iand(address, 31)
         itko = iand(ishft(address-ima, -5), 15)
         ihut = iand(ishft(address-ima-itko*32, -9), 7)

c*** check address range         
         if (ihut.eq.0 .and. itko.eq.0 .and. ima.eq. 0) then
cc do nothing            
         else if (ihut.lt.0 .or. ihut.gt.maxhut .or.
     $           itko.lt.1 .or. itko.gt.MAXTKOBOX .or.
     $           ima.lt.1 .or. ima.gt.MAXTKOMA) then
            print *, 'pdstsk: address error1: ', ihut, itko, ima
            stop
         else
c*** prepare QB calibration tables
            if (NQBSERIAL(ihut,itko,ima).ne.serial) then
c               print 200, ihut,itko,ima, NQBSERIAL(ihut,itko,ima),
c     $              serial, nrunpd, nrunsk, nsubsk, nevsk
c***  load QB calib table from file
               if (ma_qbconst.eq.0 .and. mi_qbconst.eq.0) then
                  if (nrunsk.gt.0) then
                     CALL SKCALTABVER(NRUNSK, MA_QBCONST1, MI_QBCONST1, 
     $                    MA_TQMAP1, MI_TQMAP1, MA_PGAIN1, MI_PGAIN1)
                  else
c*** obtain run number from this event
                     print *,'pdstsk: nrunsk=0 use nrunpd=',nrunpd
                     CALL SKCALTABVER(nrunpd, MA_QBCONST1, MI_QBCONST1, 
     $                    MA_TQMAP1, MI_TQMAP1, MA_PGAIN1, MI_PGAIN1)
                  endif
                  CALL SKCALTABSET_QBCONST(MA_QBCONST1, 0, ISTA)
                  IF (MI_QBCONST1 .GT. 0) THEN
                     CALL SKCALTABSET_QBCONST(MA_QBCONST1, MI_QBCONST1, ISTA)
                  ENDIF
               endif
c*** copy QB calib table from memory
               call skcaltabset_qb(ihut, itko, ima, serial, ista) 
               if (ista.ne.0) then
                  print *, 'pdstsk: error skcaltabset'
                  stop
               endif
            endif
c*** copy QB temperature
            IQBTEMP(ihut, itko, ima) = temp
         endif

c         print *, i, j, address, ihut, itko, ima, serial, header, temp

      enddo

c*** read PED table ***************************
      do i = 1, nped
         ncbl = iand(ped_cable(i),2**16-1)
            
         if ((NCBL.GT.MAXPM4).OR.(NCBL.LT.1)) then
            print *, 'pdstsk: error invalid cable = ', ncbl
            stop
         else
            IQBPDSTTs(ncbl,-1,calmode) = ishft(ped_t(1,i), -20) 
            IQBPDSTTs(ncbl,0,calmode)  = ishft(ped_t(1,i), -20) 
            IQBPDSTQs(ncbl,-1,calmode) = ishft(ped_q(1,i), -16)  
            IQBPDSTQs(ncbl,0,calmode)  = ishft(ped_q(1,i), -16) 
            IQBPDSTTs(ncbl,1,calmode)  = ishft(ped_t(2,i), -20) 
            IQBPDSTQs(ncbl,1,calmode)  = ishft(ped_q(2,i), -16) 
            IQBPDSTTs(ncbl,2,calmode)  = ishft(ped_t(3,i), -20) 
            IQBPDSTQs(ncbl,2,calmode)  = ishft(ped_q(3,i), -16) 

            IQBPDSTT(ncbl,-1,calmode) = iand(ped_t(1,i), 2**20-1) 
            IQBPDSTT(ncbl,0,calmode)  = iand(ped_t(1,i), 2**20-1)  
            IQBPDSTQ(ncbl,-1,calmode) = iand(ped_q(1,i), 2**16-1)  
            IQBPDSTQ(ncbl,0,calmode)  = iand(ped_q(1,i), 2**16-1)  
            IQBPDSTT(ncbl,1,calmode)  = iand(ped_t(2,i), 2**20-1) 
            IQBPDSTQ(ncbl,1,calmode)  = iand(ped_q(2,i), 2**16-1) 
            IQBPDSTT(ncbl,2,calmode)  = iand(ped_t(3,i), 2**20-1) 
            IQBPDSTQ(ncbl,2,calmode)  = iand(ped_q(3,i), 2**16-1) 

c               if (IQBPDSTQ(ncbl,0,1).gt.0)
c     $              print *, i, ncbl, IQBPDSTQ(ncbl,0,1), 
c     $              IQBPDSTQ(ncbl,1,1), 
c     $              IQBPDSTQ(ncbl,2,1), IQBPDSTQs(ncbl,0,1), 
c     $              IQBPDSTQs(ncbl,1,1), 
c     $              IQBPDSTQs(ncbl,2,1),
c     $              nqbhut(ncbl),nqbtko(ncbl),nqbsl(ncbl)
         endif

      enddo

c*** normal end (skroot, qb)
      return 0

      END

      SUBROUTINE CPDSTSK(IERR)
C     Call PDSTSK so that it can be used from C.
      IMPLICIT NONE
      INTEGER IERR

      CALL PDSTSK(*100)

      IERR = 0
      RETURN

 100  CONTINUE
      IERR = 1
      RETURN

      END
