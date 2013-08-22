************************************************************************
*     -------------------------------------
      SUBROUTINE RUNINFSK()
*     -------------------------------------
*
*     (Purpose)
*        Read 'RUNINF' or 'RUNINFO', then fill the common /RUNINF/
*
*     (Input)
*        none
*
*     (Output)
*        to common
*
*     (Return)
*        Return 1 ; Data w/o 'HEADER' bank
*       
*     (Creation Date and Author)
*       2008.09.21 ; First version by Y.Takeuchi
*
************************************************************************

      implicit none

#include "skhead.h"
#include "skruninf.h"

      integer IDIM, IPBANK, NDATA, i, ierr
      PARAMETER(IDIM = 1000)
      integer IBUF(IDIM)

      character*128 CBUF1
      EQUIVALENCE(IBUF(7),CBUF1)

      character*64  CBUF2
      EQUIVALENCE(IBUF(39),CBUF2)

      character*128 CBUF3
      EQUIVALENCE(IBUF(55),CBUF3)

      integer*8 LBUF1
      EQUIVALENCE(IBUF(87),LBUF1)

      integer*8 LBUF2
      EQUIVALENCE(IBUF(89),LBUF2)

c*** initialize 
      start_ymd_sk = 0
      start_hms_sk = 0
      run_title_sk = ' '
      shift_leader_sk = ' '
      shift_member_sk = ' ' 
      end_time_sec_sk = 0
      end_time_nsec_sk = 0
      do i = 0, 31
         softtrg_detector(i) = 0
         softtrg_thr(i) = 0
         softtrg_t0_offset(i) = 0
         softtrg_pre_t0(i) = 0
         softtrg_post_t0(i) = 0
      enddo
      softtrg_mask = 0

C ---
      if(SK_FILE_FORMAT.eq.1) then ! skroot

         call skroot_get_runinf(root_id, ierr, mdrnsk, nrunsk,
     $        start_ymd_sk, start_hms_sk, run_title_sk, shift_leader_sk,
     $        shift_member_sk, end_time_sec_sk, end_time_nsec_sk,
     $        softtrg_detector, softtrg_thr, softtrg_t0_offset,
     $        softtrg_pre_t0, softtrg_post_t0, softtrg_mask)

! 20080923 return to above rvw, commented out in TreeManager as well
!        call skroot_fill_runinf(root_id, ierr);

      else                      ! ZBS

         CALL KZBLOC('RUNINF',IPBANK)
         IF (IPBANK.LE.0) RETURN

c*** EMB
         CALL KZGET0('RUNINF',0,NDATA,IBUF)
c         print *, "CHECKING RUNINF BANK: ", ndata
c     $        ,ibuf(1), ibuf(2), ibuf(3), ibuf(4), ibuf(5)

ccc do nothing for SK-I,II,III, for now

         if (ndata.gt.3) then ! SK-IV
c*** segment 1
            CALL KZGET0('RUNINF',1,NDATA,IBUF)
c            print *, 'seg1: ', ndata, ibuf(1), ibuf(2)

            mdrnsk       = ibuf(1) ! in SKHEAD
            nrunsk       = ibuf(2) ! in SKHEAD
            start_ymd_sk = ibuf(5)
            start_hms_sk = ibuf(6)
            run_title_sk = cbuf1
            shift_leader_sk = cbuf2
            shift_member_sk = cbuf3 
            end_time_sec_sk = lbuf1
            end_time_nsec_sk = lbuf2
            do i = 0, 31
               softtrg_detector(i)  = ibuf(90+i*5+1)
               softtrg_thr(i)       = ibuf(90+i*5+2)
               softtrg_t0_offset(i) = ibuf(90+i*5+3)
               softtrg_pre_t0(i)    = ibuf(90+i*5+4)
               softtrg_post_t0(i)   = ibuf(90+i*5+5)
            enddo
            softtrg_mask = ibuf(251)

c*** segment 2 (do nothing for now)
c            CALL KZGET0('RUNINF',2,NDATA,IBUF)
c            print *, 'seg2: ', ndata
         endif

      endif

      print *, 'runinfsk: read runinf nrunsk,mdrnsk= ',nrunsk,mdrnsk

c*** end
      RETURN
      END
