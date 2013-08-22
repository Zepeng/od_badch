************************************************************************
*     -------------------------------------
      SUBROUTINE HEADSK(*)
*     -------------------------------------
*
*     (Purpose)
*        Read 'HEADER' bank and fill the common /SKHEAD/
*
*     (Input)
*        none
*
*     (Output)
*       
*     (Return)
*        Return 1 ; Data w/o 'HEADER' bank
*       
*
*     (Creation Date and Author)
*       1992.08.27 ; First version by K.S.Hirata
*       1995.11.17 ;      modified by Y.Koshio
*       2007.07.03 ;      modified by Y.koshio/Y.Takeuchi
*         o for QB
*       2008.02.28 ; added ROOT I/O by Y.Takeuchi
*       2008.06.09 ; Unified zbs and root by Y.Koshio
*
************************************************************************

      implicit none

#include "skhead.h"
#include "skgps.h"

      integer IDIM, IPBANK, NDATA0, NDATA1
      PARAMETER(IDIM = 1000)
      integer IDATA(IDIM)

      integer istr1, istr2, it0hwrel

      integer status, sk_geometry_tmp, utctime(7), utc_sec, i

C ---

      if(SK_FILE_FORMAT.eq.1) then ! root
c read header directly into the common
         call skroot_get_header(root_id,status,nrunsk,nsubsk,nevsk,
     &        ndaysk,ntimsk,nt48sk,mdrnsk,idtgsk,ifevsk,ltcgps,nsgps, 
     &        nusgps, ltctrg, ltcbip,iffscc,itdct0,icalva,sk_geometry_tmp,
     $        ONLIDSK,NEVSWSK,NEVHWSK,HIDHSK,HIDLSK,IT0SK,GATEWSK,
     $        TRGMASK, CONTSK, NUMHWSK)
         if ( status .ne. 0 ) goto 998
         if ( nrunsk .eq. 0 .and. mdrnsk .ne. 0 .and. mdrnsk .ne. 999999) goto 998
         if (btest(ifevsk,19)) goto 998 ! skip spacer
         if ( nrunsk.eq.0 .and. sk_geometry_tmp.eq.0 .and. 
     $        ifevsk.ne.0) goto 998 ! to skip runinfo-only data, not to skip MC
         if (sk_geometry_tmp.ne.0) sk_geometry = sk_geometry_tmp
         if (idtgsk.eq.0 .and. nevswsk.ne.0) idtgsk = nevswsk ! tentative fix (y.t.)
         IT0XSK  = IT0SK        ! copy the same T0 at the beginning (y.t.) 
         NTRIGSK = 0            ! 20090403 added by y.t.

c*** for SK-IV GPS, use gpssk.F 2008120 y.t.
c the same values are already stored in reformatter.cc 20090109 y.t.
c         if (SK_GEOMETRY.ge.4) then
c            call gpssk
c            if (nskgps.gt.0) then
c               do i = 1, nskgps
c                  if (nevgpshw(I).eq.NEVHWSK) then
c                     nsgps  = skgps1_sec(i)
c                     nusgps = skgps1_nsec(i)/1000 ! UTC GPS time (micro sec)
c                  endif
c               enddo
c            endif
c         endif

      else                      ! ZBS

         CALL KZBLOC('HEADER',IPBANK)
         IF(IPBANK.LE.0) GOTO 998
 
         CALL KZGET0('HEADER',0,NDATA0,IDATA)
         CALL KZGET0('HEADER',1,NDATA1,IDATA)

         IF(NDATA0.GT.IDIM.OR.NDATA1.GT.IDIM) THEN
            WRITE(6,*) '# of KZGET data is grater than array size'
            WRITE(6,*) 'Stop in HEADSK'
            STOP
         ENDIF

         MDRNSK   = IDATA(1)
         NRUNSK   = IDATA(2)
         NSUBSK   = IDATA(3)
         NEVSK    = IDATA(4)
         NDAYSK(1)= INT(IDATA(5)/10000)
         NDAYSK(2)= INT(MOD(IDATA(5),10000)/100)
         NDAYSK(3)= MOD(MOD(IDATA(5),10000),100)
         NTIMSK(1)= INT(IDATA(6)/10000)
         NTIMSK(2)= INT(MOD(IDATA(6),10000)/100)
         NTIMSK(3)= MOD(MOD(IDATA(6),10000),100)
         NT48SK(1)= IDATA(7)
         NT48SK(2)= IDATA(8)
         NT48SK(3)= IDATA(9)
         IDTGSK   = IDATA(10)
         IFEVSK   = IDATA(12)

c*** normal end for ATM
         if (ndata1.le.13) return

c*** for QB (not complete yet)

         NEVHWSK = IDATA(11)
         HIDHSK  = IDATA(12)
         HIDLSK  = IDATA(13)
         IT0SK   = IDATA(14)
         IT0XSK  = IT0SK      ! copy the same T0 at the beginning (y.t.) 
         GATEWSK = IDATA(15)
         NUMHWSK = IDATA(18)

c*** for QB after 20080711 y.t.
         if (ndata1.le.18) return
         IFEVSK   = IDATA(19)

         if(NUMHWSK.gt.MAXHWSK) then
            print*,'headsk: #of HW ',numhwsk,' is grater than',MAXHWSK
            stop
         endif

c*** for SK-IV GPS, use src/astro/getutc, 20081016 y.t.
         utc_sec = 0
         utctime(7) = 0
         call getutc(utctime, utc_sec)
         nsgps = utc_sec           ! UTC GPS time (sec)
         nusgps = utctime(7)/1000  ! UTC GPS time (micro sec)

      endif

      RETURN

C --- w/o 'HEADER' bank

 998  RETURN 1

      END

      SUBROUTINE CHEADSK(IERR)
C     Call HEADSK so that it can be used from C.
      IMPLICIT NONE
      INTEGER IERR

      CALL HEADSK(*100)

      IERR = 0
      RETURN

 100  CONTINUE
      IERR = 1
      RETURN

      END
