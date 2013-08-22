************************************************************************
*     -------------------------------------
      SUBROUTINE TQRAWSK(*)
*     -------------------------------------
*
*     (Purpose)
*        Read 'TQ' bank and fill the commons /SKQ/,/SKT/,/SKCHNL/
*      
*     (Input)
*        none
*
*     (Output)
*       
*     (Return)
*        Return 1 ; Data w/o 'TQ' bank nor 'TQZ' bank
*       
*
*     (Creation Date and Author)
*       1992.08.27 ; First version by K.S.Hirata
*       1997.03    ; Modified for Veto counter by J.Kameda
*       2007.07.03 ; modified by Y.Koshio/Y.Takeuchi
*           o for QB
*           o iand(), ishft() are used
*       2008.02.28 ; ported from TQRAWSK.F, added ROOT I/O by Y.Takeuchi
*       2008.06.09 : Unified zbs and root by Y.Koshio
*       2008.07.14 : added skroot file with QB by Y.Takeuchi
*       2008.12.26 : added Q correction due to QTC multi-ch hit effect
*                               S.Nakayama/K.Okumura
************************************************************************
      implicit none

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"
#include "skveto.h"
#include "skcalib.h"
#include "sktabl.h"


#include "zbs.h"

      INTEGER MAXVETO
      PARAMETER(MAXVETO=12000-MAXPM)

CC ---  MAXPM+MAXVETO = 12000

      CHARACTER*32 CNAME
      INTEGER*4 IBUF(12000*3)

      INTEGER*4 ICHK
      COMMON/SKRDLC/ICHK(MAXPM,2)
      INTEGER*4 ICHKV
      COMMON/SKRDLCV/ICHKV(MAXPM+1:12000,2)
     
      INTEGER ICABBF(12000)
      REAL TBUF(12000), QBUF(12000)

      INTEGER ISZHD,IERR,LDAT,NENT
      PARAMETER(ISZHD=3) 

      INTEGER ITQRHD(ISZHD)
      REAL RTQRHD(ISZHD)
      EQUIVALENCE(ITQRHD,RTQRHD)

      INTEGER IBUFF(3,MAXPM)
      REAL    RBUFF(3,MAXPM)
      EQUIVALENCE (IBUFF(1,1),RBUFF(1,1))

cc --- VETO

      INTEGER ITQRHDV(ISZHD)
      REAL RTQRHDV(ISZHD)
      EQUIVALENCE(ITQRHDV,RTQRHDV)

      INTEGER IBUFFV(3,MAXVETO)
      REAL    RBUFFV(3,MAXVETO)

      EQUIVALENCE (IBUFFV(1,1),RBUFFV(1,1))
cc ---
      INTEGER*4 IPBANK,NDATA,NHIT0,NWRD,NHIT,NHITV,IPOI
      INTEGER*4 ISTR1,ISTR2
      INTEGER*4 ICAB,IABC,IT,IQ
      INTEGER*4 IABCHK
      
cc --- for PC2PE
      INTEGER NRUNSK_LAST
      REAL PC2PE_SK1, PC2PE_SK2, PC2PE_SK3, PC2PE_SK4, PC2PE
      PARAMETER (PC2PE_SK1 = 2.055, PC2PE_SK2 = 2.297, PC2PE_SK3 = 2.243,
     &     PC2PE_SK4 = 2.645)
      DATA PC2PE/0./
      SAVE PC2PE, NRUNSK_LAST

**** For QB ****
      integer ihitz, i
      INTEGER ISZHDZ
      PARAMETER(ISZHDZ=7) 
      INTEGER ITQRHDZ(ISZHDZ)
      REAL RTQRHDZ(ISZHDZ)
      EQUIVALENCE(ITQRHDZ,RTQRHDZ)

      INTEGER IBUFZ(3,MAXPM*30)
      REAL    RBUFZ(3,MAXPM*30)
      EQUIVALENCE (IBUFZ(1,1),RBUFZ(1,1))

c*** QTC multi-ch-hit correction
      integer QBCH0,TMPHUT,TMPTKO,TMPSL
      integer NEXTCH1,NEXTCH2,QTCCH0,QTCCH1,QTCCH2
      integer NEXTCH,QTCCH
      real    Tdiff
      real    Qshift(30*MAXPM)
      integer mhit(qb_od_offset), ithit(50,qb_od_offset)
      integer IHITQTC(3)
      real    TDIFQTC(3)
      integer ihit, IQCNT, IRANGE, exist_mhit
      real    PC


C*** set PC2PE
      IF (NRUNSK .NE. NRUNSK_LAST) THEN
         NRUNSK_LAST = NRUNSK

         IF(NRUNSK.lt.20000) then ! for SK1
            PC2PE=PC2PE_SK1
         else if(NRUNSK.lt.30000) then ! for SK2
            PC2PE=PC2PE_SK2
         else if(NRUNSK.lt.60000) then ! for SK3
            PC2PE=PC2PE_SK3
         else                   ! for SK4
            PC2PE=PC2PE_SK4
         endif
      ENDIF

c**** for non-ATM ******************************************
      if(SK_GEOMETRY.ge.4) goto 200
c***********************************************************
      if(SK_FILE_FORMAT.ne.0) then ! non-ZBS format
         write(6,*) 'tqrawsk: data in SK-1,2,3 should be ZBS format'
         stop
      endif

c ----
      CNAME = 'TQ'
      CALL KZBLOC(CNAME,IPBANK)
      IF(IPBANK.LE.0) GOTO 998

      CALL KZGET0(CNAME,0,NDATA,IBUF)
      NHIT0 = IBUF(1)
      NWRD  = IBUF(2)

C ---

      CALL KZGET0(CNAME,1,NDATA,IBUF)

      NHIT  = 0
      NHITV = 0
      IPOI  = 0

 100  CONTINUE
         IPOI = IPOI+1
         IF(IPOI.GT.NWRD) GOTO 30

         istr1 = ishft(ibuf(ipoi), -16)
         istr2 = iand(ibuf(ipoi), 2**16-1)
      
         IF(BTEST(ISTR1,14)) THEN
            IF(BTEST(ISTR2,14)) THEN
               WRITE(6,*) 'Error; This mode is not used now'
               STOP
            ELSE
               ICAB = ICAB+1
            ENDIF
         ELSE
            IF(.NOT. BTEST(ISTR2,14)) THEN
               ICAB = ISTR2
               IPOI = IPOI+1
               istr1 = ishft(ibuf(ipoi), -16)
               istr2 = iand(ibuf(ipoi), 2**16-1)
               IF(BTEST(ISTR1,14) .AND. BTEST(ISTR2,14)) THEN
                  WRITE(6,*) 'bit Error'
                  STOP
               ENDIF
            ENDIF
         ENDIF

         IF(BTEST(ISTR1,13) .NEQV. BTEST(ISTR2,13)) THEN
            WRITE(6,*) 'Error: channel A/B is diffrent between T & Q'
            STOP
         ENDIF
         IABC = 1
         IF(BTEST(ISTR1,13) .AND. BTEST(ISTR2,13)) IABC = 2
         
         IT = iand(ISTR1,2**13-1)
         IQ = iand(ISTR2,2**13-1)

cc ---- 
         

         IF(ICAB.GT.MAXPM .AND. ICAB.LT.12000)  GOTO 800


         IF(ICAB.GE.1 .AND. ICAB.LE.MAXPM)THEN
            NHIT = NHIT+1
            IF(ICHK(ICAB,IABC) .EQ. 0) THEN
               IQABSK(ICAB,IABC) = IQ
               ITABSK(ICAB,IABC) = IT
               ICHK(ICAB,IABC) = 1

               IF(IABC.eq.1) iabchk = 2
               IF(IABC.eq.2) iabchk = 1
               IF(ICHK(ICAB,iabchk).eq.1)THEN
                  WRITE(6,*) 'Warning: A/B hit Cable = ',ICAB
                  GOTO 100
               ENDIF
            ELSE
               IF(IABC.EQ.1)THEN
                 WRITE(6,*) 'Warning: double hit Cable = ',ICAB,' A'
     &                      ,'  NRUN=',NRUNSK,' NEV=',NEVSK
c     &                      ,IQ,IQABSK(ICAB,1),IT,ITABSK(ICAB,1)
               ELSE
                 WRITE(6,*) 'Warning: double hit Cable = ',ICAB,' B'
     &                      ,'  NRUN=',NRUNSK,' NEV=',NEVSK
c     &                      ,IQ,IQABSK(ICAB,2),IT,ITABSK(ICAB,2)
               ENDIF
c               IF(IT .LT. ITABSK(ICAB,IABC)) THEN
c                  IQABSK(ICAB,IABC) = IQ
c                  ITABSK(ICAB,IABC) = IT
c               END IF

               GOTO 100
            END IF   


Change

            NQISK = NQISK+1
            ihcab(nqisk)=icab
            iab(icab)=iabc

            CALL SKTQCONV(ICAB, IABC, IT, IQ, TISK(ICAB), QISK(ICAB))

            IF (IABC.EQ.1) THEN

               if(nrunsk.le.244) then
                  ICABBF(NQISK) = ICAB
                  TBUF(NQISK) = TISK(ICAB)
                  QBUF(NQISK) = QISK(ICAB)
               else
                  IBUFF(1,NQISK) = ICAB
                  RBUFF(2,NQISK) = TISK(ICAB)
                  RBUFF(3,NQISK) = QISK(ICAB)
               endif
            ELSE IF(IABC.EQ.2) THEN

               if(nrunsk.le.244) then
                  ICABBF(NQISK) = 2**16 + ICAB
                  TBUF(NQISK) = TISK(ICAB)
                  QBUF(NQISK) = QISK(ICAB)
               else
                  IBUFF(1,NQISK) = 2**16 + ICAB
                  RBUFF(2,NQISK) = TISK(ICAB)
                  RBUFF(3,NQISK) = QISK(ICAB)
               endif

            END IF

    
        IF(QISK(ICAB).GE.DTHRSK) QISMSK = QISMSK+QISK(ICAB)

            IF(QISK(ICAB).GT.QIMXSK) THEN
               QIMXSK = QISK(ICAB)
               MXQISK = ICAB
            END IF

            IF(TISK(ICAB).LT.TIMNSK) THEN
               TIMNSK = TISK(ICAB)
               MNTISK = ICAB
            END IF

            IF(TISK(ICAB).GT.TIMXSK) THEN
               TIMXSK = TISK(ICAB)
               MXTISK = ICAB
            END IF
Change

         END IF   
      GOTO 100

C ---

 800   CONTINUE

cc ----   VETO ------	

            NHITV = NHITV+1
            IF(ICHKV(ICAB,IABC) .EQ. 0) THEN
               IQABSKV(ICAB,IABC) = IQ
               ITABSKV(ICAB,IABC) = IT
               ICHKV(ICAB,IABC) = 1

               IF(IABC.eq.1) iabchk = 2
               IF(IABC.eq.2) iabchk = 1
               IF(ICHKV(ICAB,iabchk).eq.1)THEN
                  WRITE(6,*) 'Warning: A/B hit Cable = ',ICAB
                  GOTO 100
               ENDIF
            ELSE
               IF(IABC.EQ.1)THEN
                 WRITE(6,*) 'Warning: double hit Cable = ',ICAB,' A'
     &                      ,'  NRUN=',NRUNSK,' NEV=',NEVSK
c     &                      ,IQ,IQABSKV(ICAB,1),IT,ITABSKV(ICAB,1)
               ELSE
                 WRITE(6,*) 'Warning: double hit Cable = ',ICAB,' B'
     &                      ,'  NRUN=',NRUNSK,' NEV=',NEVSK
     &                      ,'In Veto counters'
               ENDIF
c               IF(IT .LT. ITABSKV(ICAB,IABC)) THEN
c                  IQABSKV(ICAB,IABC) = IQ
c                  ITABSKV(ICAB,IABC) = IT
c               END IF

               GOTO 100
            END IF   

            NQVSK = NQVSK+1
            CALL SKTQCONV(ICAB, IABC, IT, IQ, TVSK(ICAB), QVSK(ICAB))
            IF (IABC.EQ.1) THEN

               if(nrunsk.le.244) then
                  ICABBF(NQVSK) = ICAB
                  TBUF(NQVSK) = TVSK(ICAB)
                  QBUF(NQVSK) = QVSK(ICAB)
               else
                  IBUFFV(1,NQVSK) = ICAB
                  RBUFFV(2,NQVSK) = TVSK(ICAB)
                  RBUFFV(3,NQVSK) = QVSK(ICAB)
               endif
            ELSE IF(IABC.EQ.2) THEN

               if(nrunsk.le.244) then
                  ICABBF(NQVSK) = 2**16 + ICAB
                  TBUF(NQVSK) = TVSK(ICAB)
                  QBUF(NQVSK) = QVSK(ICAB)
               else
                  IBUFFV(1,NQVSK) = 2**16 + ICAB
                  RBUFFV(2,NQVSK) = TVSK(ICAB)
                  RBUFFV(3,NQVSK) = QVSK(ICAB)
               endif

            END IF

            IF(QVSK(ICAB).GE.DTHRSK) QVSMSK = QVSMSK+QVSK(ICAB)

            IF(QVSK(ICAB).GT.QVMXSK) THEN
               QVMXSK = QVSK(ICAB)
               MXQVSK = ICAB
            END IF

            IF(TVSK(ICAB).LT.TVMNSK) THEN
               TVMNSK = TVSK(ICAB)
               MNTVSK = ICAB
            END IF

            IF(TVSK(ICAB).GT.TVMXSK) THEN
               TVMXSK = TVSK(ICAB)
               MXTVSK = ICAB
            END IF

Change
         GOTO 100
 
 30   CONTINUE
      IF((NHIT+NHITV) .NE. NHIT0) CALL MSGOUT


      ITQRHD(1) = NQISK
      RTQRHD(2) = PC2PE
      ITQRHD(3) = 1

      ITQRHDV(1) = NQVSK
      RTQRHDV(2) = PC2PE
      ITQRHDV(3) = 1

* Create TQREAL bank and fill data
          
c  -------   test comment out ------ 
c ---
      if(nrunsk.le.244) then
         CALL KZBCR0('TQREAL', IERR)
         CALL KZREP0('TQREAL', 0, 'I', ISZHD, ITQRHD)
         IF (NQISK.NE.0) THEN
            CALL KZREP0('TQREAL', 1, 'I', NQISK, ICABBF)
            CALL KZREP0('TQREAL', 2, 'F', NQISK, TBUF)
            CALL KZREP0('TQREAL', 3, 'F', NQISK, QBUF)
         END IF
      else
ccc         CALL KZBCR1('TQREAL',ISZHD,'1I',NQISK,3,'1I 2F',IERR) 
         CALL KZBCR1('TQREAL',ISZHD,'1I 1F 1I',NQISK,3,'1I 2F',IERR) 
         CALL KZREP1('TQREAL',0,ISZHD,ITQRHD)
         IF (NQISK.NE.0) THEN
            CALL KZLDAT('TQREAL',LDAT)
            nent = 3*nqisk
            CALL LBFCOPY(IBUFF,IZBS(LDAT+ISZHD+1),nent)
         END IF
      endif
C ---

cc --- Create VETO bank and fill -----
cc 


      if(nrunsk.le.244) then
         CALL KZBCR0('VETO', IERR)
         CALL KZREP0('VETO', 0, 'I', ISZHD, ITQRHDV)
         IF ((NQISK.NE.0).and.(NQVSK.NE.0)) THEN
            CALL KZREP0('VETO', 1, 'I', NQVSK, ICABBF)
            CALL KZREP0('VETO', 2, 'F', NQVSK, TBUF)
            CALL KZREP0('VETO', 3, 'F', NQVSK, QBUF)
         END IF
      else
ccc         CALL KZBCR1('VETO',ISZHD,'1I',NQVSK,3,'1I 2F',IERR) 
         CALL KZBCR1('VETO',ISZHD,'1I 1F 1I',NQVSK,3,'1I 2F',IERR) 
         CALL KZREP1('VETO',0,ISZHD,ITQRHDV)
         IF ((NQISK.NE.0).and.(NQVSK.NE.0)) THEN
c          IF (NQVSK.NE.0) THEN
            CALL KZLDAT('VETO',LDAT)
            nent = 3*NQVSK      
            CALL LBFCOPY(IBUFFV,IZBS(LDAT+ISZHD+1),nent)
         END IF
      endif


      RETURN

C --- w/o 'TQ' bank

 998  continue

**** For QB ****
      CNAME = 'TQZ'
      CALL KZBLOC(CNAME,IPBANK)
      IF(IPBANK.LE.0) GOTO 999

 200  continue
c*** read TQZ bank, then fill /SKTQZ/
      call tqskz


c*** QTC multi-ch-hit correction
      do i=1, 30*MAXPM
         Qshift(i) = 0.
      enddo

c*** do not apply QTC multi-ch-hit correction to pedestal events
      if (iand(idtgsk,2**30).ne.0) goto 300

      do icab = 1, qb_od_offset
         mhit(icab)=0
      enddo
      do ihitz = 1, NQISKZ
         icab = ICABIZ(ihitz)
         if ( icab.gt.0 .and. icab.le.qb_od_offset ) then
            if ( mhit(icab).le.49 ) then
               mhit(icab) = mhit(icab) + 1
               ithit(mhit(icab),icab) = ITISKZ(ihitz)
            endif
         endif
      enddo

      do ihitz = 1, NQISKZ
         if (ICABIZ(ihitz).eq.0) goto 400
c*** identify the other channels in the same QTC
         QBCH0  = NQBCH(ICABIZ(ihitz))
         TMPHUT = NQBHUT(ICABIZ(ihitz))
         TMPTKO = NQBTKO(ICABIZ(ihitz))
         TMPSL  = NQBSL(ICABIZ(ihitz))
         IF (mod(QBCH0, 3).EQ.0) THEN
            NEXTCH1 = NQBCAB(TMPHUT, TMPTKO, TMPSL, QBCH0+1)
            NEXTCH2 = NQBCAB(TMPHUT, TMPTKO, TMPSL, QBCH0+2)
            QTCCH0 = 2
            QTCCH1 = 1
            QTCCH2 = 0
         ELSE IF (mod(QBCH0, 3).EQ.1) THEN
            NEXTCH1 = NQBCAB(TMPHUT, TMPTKO, TMPSL, QBCH0-1)
            NEXTCH2 = NQBCAB(TMPHUT, TMPTKO, TMPSL, QBCH0+1)
            QTCCH0 = 1
            QTCCH1 = 2
            QTCCH2 = 0
         ELSE IF (mod(QBCH0, 3).EQ.2) THEN
            NEXTCH1 = NQBCAB(TMPHUT, TMPTKO, TMPSL, QBCH0-2)
            NEXTCH2 = NQBCAB(TMPHUT, TMPTKO, TMPSL, QBCH0-1)
            QTCCH0 = 0
            QTCCH1 = 2
            QTCCH2 = 1
         ENDIF

c*** check if the other channel hit or not
         IHITQTC(QTCCH0+1) = 1
         IHITQTC(QTCCH1+1) = 0
         IHITQTC(QTCCH2+1) = 0
         TDIFQTC(QTCCH0+1) = 0.
         TDIFQTC(QTCCH1+1) = -1000000.
         TDIFQTC(QTCCH2+1) = -1000000.
         exist_mhit=0
         do i=1,2
            if ( i.eq.1 ) then
               NEXTCH = NEXTCH1
               QTCCH  = QTCCH1
            endif
            if ( i.eq.2 ) then
               NEXTCH = NEXTCH2
               QTCCH  = QTCCH2
            endif
            if (NEXTCH.gt.0) then  ! 2011/04/15 added by y.t
            if ( mhit(NEXTCH).gt.0 ) then
               do ihit=1, mhit(NEXTCH)
                  tdiff = ( ithit(ihit,NEXTCH) -  ITISKZ(ihitz) ) / 1.92
                  if ( tdiff.gt.-900. .and. tdiff.lt.400. ) then
                     IHITQTC(QTCCH+1) = 1
                     TDIFQTC(QTCCH+1) = tdiff
                     exist_mhit = exist_mhit + 1
                  endif
               enddo
            endif
            endif   ! 2011/04/15 added by y.t
         enddo

c*** calc drift due to multi-hit
         if ( exist_mhit.eq.0 ) then
            Qshift(ihitz) = 0.
         else
            CALL SKTQCONV_QB(ICABIZ(ihitz), 0,
     $           ITISKZ(ihitz), IQISKZ(ihitz), 0., -1,
     $           TISKZ(ihitz),  QISKZ(ihitz))
            PC = QISKZ(ihitz)
            call SKQDIV(IQISKZ(ihitz), IQCNT, IRANGE)
            call skqtcmhit_corr(QTCCH0, IRANGE, PC,
     $           IHITQTC, TDIFQTC, Qshift(ihitz))
            Qshift(ihitz) = -Qshift(ihitz)
         endif

 400     continue
      enddo
 300  continue


c***  for TQREAL 
      pc2pe_raw = pc2pe
      NQISK_raw = NQISKZ  ! for QB

      do ihitz = 1, NQISKZ

c*** real T/Q
cccc T0 is already subtracted from ITISKZ   17-JUL-2007 y.t.
c         CALL SKTQCONV_QB(ICABIZ(ihitz), IT0SK, 
c     $        ITISKZ(ihitz), IQISKZ(ihitz),
c     $        TISKZ(ihitz),  QISKZ(ihitz))

CKO         CALL SKTQCONV_QB(ICABIZ(ihitz), 0, 
CKO     $        ITISKZ(ihitz), IQISKZ(ihitz),
CKO     $        TISKZ(ihitz),  QISKZ(ihitz))
         CALL SKTQCONV_QB(ICABIZ(ihitz), 0, 
     $        ITISKZ(ihitz), IQISKZ(ihitz), Qshift(ihitz), 0,
     $        TISKZ(ihitz),  QISKZ(ihitz))

cc         print *, 'tqrawsk:', ihitz, ICABIZ(ihitz), ITISKZ(ihitz), IQISKZ(ihitz),
cc     $        TISKZ(ihitz),  QISKZ(ihitz)

         IBUFZ(1,ihitz) = ICABIZ(ihitz) + (IHTIFLZ(ihitz) * 2**16)
         RBUFZ(2,ihitz) = TISKZ(ihitz)
         RBUFZ(3,ihitz) = QISKZ(ihitz)

c*** store same info. (w/o badch mask)               
         icabbf_raw(ihitz) = ICABIZ(ihitz) + (IHTIFLZ(ihitz) * 2**16)
         tbuf_raw(ihitz) = tiskz(ihitz)
         qbuf_raw(ihitz) = qiskz(ihitz)

      enddo

c*** fill common
      NQISK  = 0
      QISMSK = 0.0
      NQVSK  = 0
      QVSMSK = 0.0

      do i=1,NQISKZ
         if(iand(IHTIFLZ(I),1).eq.1) then   ! 1.3usec events
            icab = icabiz(i)

            if(icab.ge.1.and.icab.le.MAXPM) then
               NQISK = NQISK + 1
               ihcab(NQISK) = icab
               TISK(icab) = tiskz(i)
               QISK(icab) = qiskz(i)

               IF(QISK(ICAB).GE.DTHRSK) QISMSK = QISMSK+QISK(ICAB)
               IF(QISK(ICAB).GT.QIMXSK) THEN
                  QIMXSK = QISK(ICAB)
                  MXQISK = ICAB
               END IF
               IF(TISK(ICAB).LT.TIMNSK) THEN
                  TIMNSK = TISK(ICAB)
                  MNTISK = ICAB
               END IF
               IF(TISK(ICAB).GT.TIMXSK) THEN
                  TIMXSK = TISK(ICAB)
                  MXTISK = ICAB
               END IF
            elseif(icab.gt.MAXPM.and.icab.le.12000) then
               NQVSK = NQVSK + 1
               ihcabv(NQVSK) = icab
               TVSK(icab) = tiskz(i)
               QVSK(icab) = qiskz(i)

               IF(QVSK(ICAB).GE.DTHRSK) QVSMSK = QVSMSK+QVSK(ICAB)
               IF(QVSK(ICAB).GT.QIMXSK) THEN
                  QVMXSK = QVSK(ICAB)
                  MXQVSK = ICAB
               END IF
               IF(TVSK(ICAB).LT.TVMNSK) THEN
                  TVMNSK = TVSK(ICAB)
                  MNTVSK = ICAB
               END IF
               IF(TVSK(ICAB).GT.TVMXSK) THEN
                  TVMXSK = TVSK(ICAB)
                  MXTVSK = ICAB
               END IF
            endif

         endif
      enddo

      if(SK_FILE_FORMAT.eq.0) then ! ZBS format

c**   Create TQREAL bank ver.2, then fill data
         ITQRHDZ(1) = NQISKZ
         RTQRHDZ(2) = PC2PE
         ITQRHDZ(3) = 2         ! version2 is for QB
         ITQRHDZ(4) = MA_QBCONST*1000 + MI_QBCONST
         ITQRHDZ(5) = MA_TQMAP*1000 + MI_TQMAP
         ITQRHDZ(6) = MA_PGAIN*1000 + MI_PGAIN
         ITQRHDZ(7) = IT0XSK  ! 20080728 y.t. to keep T0 for this tqreal

         CALL KZBCR1('TQREAL',ISZHDZ,'1I 1F 5I',NQISKZ,3,'1I 2F',IERR) 
         CALL KZREP1('TQREAL',0,ISZHDZ,ITQRHDZ)
         IF (NQISKZ.NE.0) THEN
            CALL KZLDAT('TQREAL',LDAT)
            nent = 3*nqiskz
            CALL LBFCOPY(IBUFZ,IZBS(LDAT+ISZHDZ+1),nent)
         END IF

      else  ! skroot

      endif

C ---
      RETURN 

C --- w/o 'TQ' nor 'TQZ' bank

 999  RETURN 1
      END

