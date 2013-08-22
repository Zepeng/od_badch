************************************************************************
*     -------------------------------------
      SUBROUTINE TRGSK()
*     -------------------------------------
*
*     (Purpose)
*        Read 'TRG', then fill the common/SKTRG/
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
*       2009.03.22 ; First version by Y.Hayato
*
************************************************************************
      implicit none

#include "skhead.h"
#include "sktrg.h"

      integer IDIM, IPBANK, NDATA, i, iseg, ierr
      PARAMETER(IDIM = 1000)
      integer IBUF(IDIM)

c*** initialize 
      nsktrghw = 0
      do 20 ISEG=1,NMAXHWTRG
         nruntrghw(ISEG)        = 0
         nevtrghw(ISEG)         = 0
         idtrghw(ISEG)          = 0
         do 30 I=1,3
            nclk48trghw(ISEG,I) = 0
 30      continue
         hostidhtrghw(ISEG)     = 0
         hostidltrghw(ISEG)     = 0
         stattrghw(ISEG)        = 0

 20   continue

      if(SK_FILE_FORMAT.eq.1) then ! skroot
         write(*,*) 'currently not supported'
         stop
      else
         call kzbloc('TRG',IPBANK)

c*** EMB
         if (IPBANK.GT.0) then
            call kzget0('TRG',0,NDATA,IBUF)
            
            nsktrghw = ibuf(1)-1
            
            if (nsktrghw.gt.NMAXHWTRG) then
               write(*,*) 'GPSSK: Warning : More than ',
     $              NMAXHWTRG,' TRG ??'
               nsktrghw = NMAXHWTRG
            else if (nsktrghw.le.0) then
               write(*,*) 'TRGSK: Error : No TRG data ??'
               stop
            endif 
            
c*** segment 1            
            
            do 50 ISEG = 1, nsktrghw
               CALL KZGET0('TRG',iseg,NDATA,IBUF)
               if (ndata.ne.8) then
                  write(*,*) 'TRGSK: Error : Length should be 25 but',
     $                 NDATA
                  stop
               endif
               
               nruntrghw(ISEG)        = ibuf(1)
               nevtrghw(ISEG)         = ibuf(2)
               idtrghw(ISEG)          = ibuf(3)
               do 60 I=1,3
                  nclk48trghw(ISEG,I) = ibuf(3+I)
 60            enddo
               hostidhtrghw(ISEG)     = ibuf(7)
               hostidltrghw(ISEG)     = ibuf(8)
               
 50         continue
         else

            write(*,*) 'TRGSK: There is no TRG bank.'

         endif
      endif

      return
      end
