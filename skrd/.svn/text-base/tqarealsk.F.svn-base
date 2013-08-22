************************************************************************
*     -------------------------------------
      SUBROUTINE TQAREALSK(ierr)
*     -------------------------------------
*
*     (Purpose)
*        Read 'TQAREAL' bank and fill the commons /SKQA/,/SKTA/,/SKTQAZ/
*
*     (Input)
*        none
*
*     (Output)
*        ierr =0  normal
*        ierr =1  Data w/o 'TQAREAL' bank
*
*     (Creation Date and Author)
*       1995.10.14 ; First version by Y.Koshio
*       2007.07.03 ; modified by Y.Koshio/Y.Takeuchi
*           o for QB
*       2008.02.28 ; ported from TQAREALSK.F, added ROOT I/O by Y.Takeuchi
*       2008.06.09 ; Unified zbs and root by Y.Koshio
*       2008.07.09 ; modified by y.takeuchi
*        o added badch mask for QB
*        o added filing to *_raw parameter for QB
*     
************************************************************************
      implicit none

      integer temp, status

c arg
      integer ierr

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"
#include "skbadc.h"
#include "zbs.h"
      INTEGER ISKBIT
      COMMON /SKOPT/ISKBIT

c constant
      integer   MAXHIT
      parameter(MAXHIT = 16 * 2048)
      integer   OBUFSZ
      parameter(OBUFSZ = MAXHIT)

c local variable

      INTEGER IBUF(10)

      INTEGER*4 OBUF( 3, OBUFSZ)
      INTEGER*2 OBUFS(6, OBUFSZ)
      real*4    robuf(3, OBUFSZ)
      EQUIVALENCE(OBUF(1,1), OBUFS(1,1))
      EQUIVALENCE(OBUF(1,1), robuf(1,1))

      INTEGER IPBANK,NDATA,LDAT
      INTEGER IBUFF(3,MAXHIT)
      REAL    RBUFF(3,MAXHIT)
      EQUIVALENCE (IBUFF(1,1),RBUFF(1,1))

      INTEGER NHIT0,NENT
      INTEGER I,J,ICABA,NHITAZTMP

      INTEGER ENDIAN
      INTEGER*2 ENDIANS(2)
      EQUIVALENCE (ENDIAN,ENDIANS(1))
      INTEGER IDX_FLZ
      INTEGER IDX_CAB

**** For QB ****
      INTEGER IBUFZ(3,MAXPMA*30)
      REAL    RBUFZ(3,MAXPMA*30)
      EQUIVALENCE (IBUFZ(1,1),RBUFZ(1,1))
****************

c*** local variables (not used, for now)
      integer tqreal_ver, qbconst_ver, tqmap_ver, pgain_ver
      integer od_it0xsk
      real od_pc2pe

c program

c     Initialize blocks:
cc      nhitaz = 0
cc      nhitaz_raw = 0   // don't clear here for skroot file (20080715 y.t.)
      nqask = 0
      qasmsk = 0.
      qamxsk = 0.
      tamnsk = 100000.
      tamxsk = -100000.

C ---
      ierr=0

      if (SK_FILE_FORMAT .eq. 1 ) then ! root

c*** read an event if positive LUN
         if (nhitaz_raw.eq.0) then
            call skroot_get_tqareal(root_id,status,nhitaz_raw,od_pc2pe,
     $           tqreal_ver,qbconst_ver,tqmap_ver,pgain_ver,od_it0xsk,
     $           icabaz_raw,qaskz_raw,taskz_raw)
         endif

c*** copy to memory
         nhitaz = nhitaz_raw
         do i=1,nhitaz
            IHTFLZ(i) = ishft(icabaz_raw(i), -16)
            ICABAZ(i) = iand(icabaz_raw(i), 2**16-1)
            taskz(i)  = taskz_raw(i) -(it0xsk-it0sk)/count_per_nsec
            qaskz(i)  = qaskz_raw(i)
         enddo

c*** mask badch, then fill common
         goto 700

      else                      ! ZBS 
         CALL KZBLOC('TQAREAL',IPBANK)
         IF(IPBANK.LE.0)then
            ierr=-1
cc            print *,'TQAREAL bank was not found.'
            return
         endif
         CALL KZGET1('TQAREAL',0,NDATA,IBUF)
ccccccccccccccccccccccccccccccccccc
c*** tqareal bank ver.2 is for QB
         if(ibuf(3).eq.2) goto 998
ccccccccccccccccccccccccccccccccccc

         NHIT0 = IBUF(1)
C ---
         IF (NHIT0.gt.MAXPMA*16)NHIT0=MAXPMA*16
         IF (NHIT0.gt.0) THEN
            CALL KZLDAT('TQAREAL',LDAT)
            nent = 3*nhit0
            CALL LBFCOPY(IZBS(LDAT+NDATA+1),obuf,nent)
         END IF
c
c     Test byte order
c
         endians(1) = 0
         endians(2) = 1
         if (endian.eq.1) then
c        SUN convention
            idx_flz = 1
            idx_cab = 2
         else
c        Intel and DEC Alpha convention
            idx_flz = 2
            idx_cab = 1
         endif
c
c     Load up commons:
c
         nhitaz = nhit0
         nhitaz_raw = nhit0
         do 888 i=1,nhitaz
            ihtflz(i) = obufs(idx_flz,i)
            icabaz(i) = obufs(idx_cab,i)
            taskz(i)  = robuf(2,i)
            qaskz(i)  = robuf(3,i)

            icabaz_raw(i) = icabaz(i) + (ihtflz(i)*2**16)
            taskz_raw(i)  = taskz(i)
            qaskz_raw(i)  = qaskz(i)

 888     continue
      endif
C
C     mask bad ch
C
 700  continue


      IF (BTEST(ISKBIT,31-25)) THEN
         NHITAZTMP=NHITAZ
         DO 300 I=1,NHITAZ
 330        ICABA=ICABAZ(I)-20000
            IF (ICABA.LE.0.OR.ICABA.GT.MAXPMA) GOTO 300
            IF (IBADA(ICABA).NE.0) THEN
               DO 310 J=I,NHITAZ-1
                  IHTFLZ(J)=IHTFLZ(J+1)
                  icabaz(J)=ICABAZ(J+1)
                  taskz(J) =TASKZ(J+1)
                  qaskz(J) =QASKZ(J+1)
                  if (SK_GEOMETRY.ge.4) then
                     itaskz(J) =iTASKZ(J+1)
                     iqaskz(J) =iQASKZ(J+1)
                  endif
 310           CONTINUE
               DO 320 J=NHITAZ,NHITAZTMP
                  IHTFLZ(J)=0
                  icabaz(J)=0
                  taskz(J) =0.
                  qaskz(J) =0.
                  if (SK_GEOMETRY.ge.4) then
                     itaskz(J) =0
                     iqaskz(J) =0
                  endif
 320           CONTINUE
               NHITAZ=NHITAZ-1
               GOTO 330
            ENDIF
 300     CONTINUE
      ENDIF

c Remove negative charge OD hits for SK IV by default;
c  if option 14 is set, keep them

      IF ((.NOT.BTEST(ISKBIT,31-14)).and.sk_geometry.ge.4) THEN
         NHITAZTMP=NHITAZ
         DO I=1,NHITAZ
 331        CONTINUE

           IF (QASKZ(I).LT.0) THEN
               DO J=I,NHITAZ-1
                  IHTFLZ(J)=IHTFLZ(J+1)
                  icabaz(J)=ICABAZ(J+1)
                  taskz(J) =TASKZ(J+1)
                  qaskz(J) =QASKZ(J+1)
                  if (SK_GEOMETRY.ge.4) then
                     itaskz(J) =iTASKZ(J+1)
                     iqaskz(J) =iQASKZ(J+1)
                  endif
               ENDDO
               DO J=NHITAZ,NHITAZTMP
                  IHTFLZ(J)=0
                  icabaz(J)=0
                  taskz(J) =0.
                  qaskz(J) =0.
                  if (SK_GEOMETRY.ge.4) then
                     itaskz(J) =0
                     iqaskz(J) =0
                  endif
               ENDDO
               NHITAZ=NHITAZ-1
               GOTO 331
            ENDIF
         ENDDO

      ENDIF

      call sktqacom()

C ---
      RETURN

**** For QB ****

 998  continue

      NHITAZ = IBUF(1)
      NHITAZ_raw = IBUF(1)
ccyt      IT0XSK = IBUF(7)  ! assume tqrealsk.F set the correct value (y.t.)

      IF (NHITAZ.NE.0) THEN
         CALL KZLDAT('TQAREAL',LDAT)
         nent = 3*NHITAZ
         CALL LBFCOPY(IZBS(LDAT+NDATA+1),ibufz,nent)
      END IF

      do i=1,NHITAZ
         icabaz(i)  = iand(ibufz(1,i),2**16-1)
         IHTFLZ(I) = ishft(ibufz(1,i), -16)
         taskz(i)   = rbufz(2,i) -(it0xsk-it0sk)/count_per_nsec
         qaskz(i)   = rbufz(3,i)

         icabaz_raw(i) = ibufz(1,i)
         taskz_raw(i)  = rbufz(2,i)  ! time=0 = it0sk
         qaskz_raw(i)  = qaskz(i)
      enddo

c*** mask badch, then fill common
      goto 700

C --- w/o 'TQAREAL' bank

 999  RETURN 1

      END
