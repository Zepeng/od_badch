      real function tlincorsk(t,icab,ab)

c     input 
c       t    ; tisk
c       icab ; cable number
c       ab   ; a ch (1) or b ch (2)
c     output 
c      correction [nsec] which should be used as;
c        t_after_correction = tisk + tlincorsk(tisk,ch,ab)
c      
      implicit none

#include "skparm.h"
#include "sktabl.h"

      integer ch, ab, icab
      real t

      real slope
      real offset(24)
      integer ch_id

      slope = 0.66544E-2
      data offset / 0.0    , -0.08323, -0.17605, -0.29956,
     &             -0.31836, -0.36801, -0.43405, -0.39939, 
     &             -0.56636, -0.49132, -0.88474, -0.56392,
     &             -0.42645, -0.53818, -0.48991, -0.57329,
     &             -0.54043, -0.58845, -0.45276, -0.52694,
     &             -0.55379, -0.56422, -0.99685, -0.84881 /
      
      call SKCONTABRD
      ch = NATMCH(icab)

      ch_id = (ch+1) + 12*(ab-1)
       
      tlincorsk = t*slope - 1000.0*slope - offset(ch_id)
      
      return
      end
