************************************************************************
*     -------------------------------------
      SUBROUTINE GPSSK()
*     -------------------------------------
*
*     (Purpose)
*        Read 'GPS' and/or 'T2KGPS', then fill the common/SKGPS/,/T2KGPS/
*
*     (Input)
*        none
*
*     (Output)
*        to common
*
*     (Return)
*       
*     (Creation Date and Author)
*       2008.11.15 ; First version by Y.Hayato
*
************************************************************************

      implicit none

#include "skhead.h"
#include "skgps.h"

      integer IDIM, IPBANK, NDATA, i, iseg, ierr
      PARAMETER(IDIM = 1000)
      integer IBUF(IDIM)

c*** initialize 
      nskgps = 0
      do 20 ISEG=1,NMAXSKGPS
         ninfogps(ISEG)      = 0
         nevgpshw(ISEG)      = 0
         navfreqsk(ISEG)     =0
         do I=1,2
            skgps1(ISEG,I)   =0
            skgps2(ISEG,I)   =0
            skltc1(ISEG,I)   =0
            skltc2(ISEG,I)   =0
            skltctrg(ISEG,I) =0
         enddo
         skgpscputime(ISEG)  =0
         skgpsstat(ISEG)     =0
         skltccorr(ISEG)     =0
         skgpsdiffutc(ISEG)  =0
         skgps1_sec(ISEG)    =0
         skgps1_nsec(ISEG)   =0
         skgps2_sec(ISEG)    =0
         skgps2_nsec(ISEG)   =0
         skutc1_sec(ISEG)    =0
         skutc1_nsec(ISEG)   =0
         skutc2_sec(ISEG)    =0
         skutc2_nsec(ISEG)   =0
 20   continue

      nrunbm          =0
      nspl            =0
      navfreqt2k      =0
      do I=1,2
         t2kgps1(I)   =0
         t2kgps2(I)   =0
         t2kltc1(I)   =0
         t2kltc2(I)   =0
         t2kltctrg(I) =0
      enddo
      t2kcputime      =0
      t2kgpsstat      =0
      t2kltccorr      =0
      t2kdiffutc      =0
      t2kgps1_sec     =0
      t2kgps1_nsec    =0
      t2kgps2_sec     =0
      t2kgps2_nsec    =0
      t2kutc1_sec     =0
      t2kutc1_nsec    =0
      t2kutc2_sec     =0
      t2kutc2_nsec    =0

C ---
      if(SK_FILE_FORMAT.eq.1) then ! skroot

         call skroot_get_gps(root_id, ierr, 
     $        nskgps, ninfogps, nevgpshw, navfreqsk,
     $        skgps1, skgps2, skltc1, skltc2, skltctrg, skgpscputime,
     $        skgpsstat, skltccorr, skgpsdiffutc,
     $        skgps1_sec, skgps1_nsec, skgps2_sec, skgps2_nsec, 
     $        skutc1_sec, skutc1_nsec, skutc2_sec, skutc2_nsec);

         call skroot_get_t2kgps(root_id, ierr, 
     $        nrunbm, nspl, navfreqt2k,
     $        t2kgps1, t2kgps2, t2kltc1, t2kltc2, t2kltctrg, t2kcputime,
     $        t2kgpsstat, t2kltccorr, t2kdiffutc,
     $        t2kgps1_sec, t2kgps1_nsec, t2kgps2_sec, t2kgps2_nsec, 
     $        t2kutc1_sec, t2kutc1_nsec, t2kutc2_sec, t2kutc2_nsec);

      else                      ! ZBS

c*** SK GPS ***********************************

         CALL KZBLOC('GPS',IPBANK)

         IF (IPBANK.GT.0) THEN
c*** EMB
            CALL KZGET0('GPS',0,NDATA,IBUF)

            nskgps = ibuf(1)-1
            if (nskgps.gt.NMAXSKGPS) then
               write(*,*) 'GPSSK: Warning : More than ',NMAXSKGPS,' GPS ??'
               nskgps = NMAXSKGPS
            else if (nskgps.le.0) then
               write(*,*) 'GPSSK: Warning : No GPS data ??'
               stop
            endif 

c*** segment 1

            do 30 ISEG = 1, nskgps

               CALL KZGET0('GPS',iseg,NDATA,IBUF)
               if (ndata.ne.25) then
                  write(*,*) 'GPSSK: Warning : Length should be 25 but',
     $                 NDATA
ccyt                  stop  ! don't stop for now
               endif

               ninfogps(ISEG)    =ibuf(1+0) ! GPS->NA2;
               nevgpshw(ISEG)    =ibuf(1+1) ! GPS->gps_counter_32;
               navfreqsk(ISEG)   =ibuf(1+2) ! GPS->av_freq;            
               skgps1(ISEG,1)    =ibuf(1+3) ! GPS->gpstime1[0];
               skgps1(ISEG,2)    =ibuf(1+4) ! GPS->gpstime1[1];
               skgps2(ISEG,1)    =ibuf(1+5) ! GPS->gpstime2[0];
               skgps2(ISEG,2)    =ibuf(1+6) ! GPS->gpstime2[1];
               skltc1(ISEG,1)    =ibuf(1+7) ! GPS->ltcgps1[0];
               skltc1(ISEG,2)    =ibuf(1+8) ! GPS->ltcgps1[1];
               skltc2(ISEG,1)    =ibuf(1+9) ! GPS->ltcgps2[0];
               skltc2(ISEG,2)    =ibuf(1+10) ! GPS->ltcgps2[1];
               skltctrg(ISEG,1)  =ibuf(1+11) ! GPS->ltctrg[0];
               skltctrg(ISEG,2)  =ibuf(1+12) ! GPS->ltctrg[1];
            
               skgpscputime(ISEG)=ibuf(1+13) ! GPS->cputime;
               skgpsstat(ISEG)   =ibuf(1+14) ! GPS->status;
            
               skltccorr(ISEG)   =ibuf(1+15) ! GPS->ltccorr;
               skgpsdiffutc(ISEG)=ibuf(1+16) ! GPS->diffutc;
               
               skgps1_sec(ISEG)  =ibuf(1+17) ! GPS->gps1_sec;
               skgps1_nsec(ISEG) =ibuf(1+18) ! GPS->gps1_nsec;
               
               skgps2_sec(ISEG)  =ibuf(1+19) ! GPS->gps2_sec;
               skgps2_nsec(ISEG) =ibuf(1+20) ! GPS->gps2_nsec;
               
               skutc1_sec(ISEG)  =ibuf(1+21) ! GPS->utc1_sec;
               skutc1_nsec(ISEG) =ibuf(1+22) ! GPS->utc1_nsec;
               
               skutc2_sec(ISEG)  =ibuf(1+23) ! GPS->utc2_sec;
               skutc2_nsec(ISEG) =ibuf(1+24) ! GPS->utc2_nsec;
            
 30         continue
cc            print *, 'skgps: read skgps nrunsk,mdrnsk= ',nrunsk,mdrnsk

         endif

c*** T2K GPS ***********************************

         CALL KZBLOC('T2KGPS',IPBANK)
         IF (IPBANK.GT.0) THEN

c*** EMB
            CALL KZGET0('T2KGPS',0,NDATA,IBUF)

            if (ndata.gt.2) then
               write(*,*) 'GPSSK(T2K): Warning : More than 1 T2K-GPS ??'
            endif            
            
c*** segment 1
            CALL KZGET0('T2KGPS',1,NDATA,IBUF)
            if (ndata.ne.25) then
               write(*,*) 'GPSSK(T2K): Warning : Length should be 25 but',
     $              NDATA
               stop
            endif

            nrunbm          =ibuf(1+0) ! GPS->beamline_run_no;
            nspl            =ibuf(1+1) ! GPS->spill_counter;
            navfreqt2k      =ibuf(1+2) ! GPS->av_freq;            
            t2kgps1(1)      =ibuf(1+3) ! GPS->gpstime1[0];
            t2kgps1(2)      =ibuf(1+4) ! GPS->gpstime1[1];
            t2kgps2(1)      =ibuf(1+5) ! GPS->gpstime2[0];
            t2kgps2(2)      =ibuf(1+6) ! GPS->gpstime2[1];
            t2kltc1(1)      =ibuf(1+7) ! GPS->ltcgps1[0];
            t2kltc1(2)      =ibuf(1+8) ! GPS->ltcgps1[1];
            t2kltc2(1)      =ibuf(1+9) ! GPS->ltcgps2[0];
            t2kltc2(2)      =ibuf(1+10) ! GPS->ltcgps2[1];
            t2kltctrg(1)    =ibuf(1+11) ! GPS->ltctrg[0];
            t2kltctrg(2)    =ibuf(1+12) ! GPS->ltctrg[1];
         
            t2kcputime      =ibuf(1+13) ! GPS->cputime;
            t2kgpsstat      =ibuf(1+14) ! GPS->status;
         
            t2kltccorr      =ibuf(1+15) ! GPS->ltccorr;
            t2kdiffutc      =ibuf(1+16) ! GPS->diffutc;
         
            t2kgps1_sec     =ibuf(1+17) ! GPS->gps1_sec;
            t2kgps1_nsec    =ibuf(1+18) ! GPS->gps1_nsec;
            
            t2kgps2_sec     =ibuf(1+19) ! GPS->gps2_sec;
            t2kgps2_nsec    =ibuf(1+20) ! GPS->gps2_nsec;
            
            t2kutc1_sec     =ibuf(1+21) ! GPS->utc1_sec;
            t2kutc1_nsec    =ibuf(1+22) ! GPS->utc1_nsec;
            
            t2kutc2_sec     =ibuf(1+23) ! GPS->utc2_sec;
            t2kutc2_nsec    =ibuf(1+24) ! GPS->utc2_nsec;
         
         endif
cc         print *, 't2kgps: read t2kgps nrunsk,mdrnsk= ',nrunsk,mdrnsk
         
      endif

c*** end
      RETURN
      END
