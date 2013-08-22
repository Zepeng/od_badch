************************************************************************
*     -------------------------------------
      SUBROUTINE SKTQACOM()
*     -------------------------------------
*
*     (Purpose)
*        Fill /SKQA/,/SKTA/ commons from /SKTQAZ/
*
*     (Input)
*        none
*
*     (Output)
*       
*     (Return)
*       
*
*     (Creation Date and Author)
*       1996.03.31	Created, J.Flanagan
*	1996.08.10	Removed IBADA tubes from task, qask arrays --Flanagan
*     
************************************************************************
      implicit none

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"
#include "skbadc.h"

      integer i, icaba

      nqask = 0
      qasmsk = 0.
      qamxsk = 0.
      tamnsk = 100000.
      tamxsk = -100000.
      mntask = 100000.    ! 20080715 added by y.t.
      mxtask = -100000.   ! 20080715 added by y.t.
      mxqask = 0          ! 20080715 added by y.t.

      do 5 i = 1, maxpma
         qask(i) = 0.0
         task(i) = 0.0
         ihacab(i) = 0    ! 20080717 added by y.t.
 5    continue

      do 10 I=1,nhitaz
         if (SK_GEOMETRY.ge.4 .and. (iand(IHTFLZ(I),1).eq.0)) goto 10 
         if (SK_GEOMETRY.le.3 .and. (btest(ihtflz(i), 15) .or. 
     &       (.not. btest(ihtflz(i), 3))) ) goto 10

         icaba = icabaz(i) - 20000
         if(icaba.le.0 .or. icaba.gt.MAXPMA) goto 10

         if (ibada(icaba) .ne. 0) goto 10

         nqask = nqask + 1
         ihacab(nqask) = icaba   ! 20080717 added by y.t.
         qask(icaba) = qaskz(i)
         task(icaba) = taskz(i)

         qasmsk = qasmsk + qask(icaba)

         if (nqask .eq. 1) then
            qamxsk = qask(icaba)
            mxqask = icaba + 20000
            tamnsk = task(icaba)
            tamxsk = task(icaba)
            mntask = task(icaba)
            mxtask = task(icaba)
         endif

         if (qask(icaba) .gt. qamxsk) then
            qamxsk = qask(icaba)
            mxqask = icaba + 20000
         endif

         if (task(icaba) .lt. tamnsk) then
            tamnsk = task(icaba)
            mntask = icaba + 20000
         endif

         if (task(icaba) .gt. tamxsk) then
            tamxsk = task(icaba)
            mxtask = icaba + 20000
         endif

 10   CONTINUE

      return
      end
