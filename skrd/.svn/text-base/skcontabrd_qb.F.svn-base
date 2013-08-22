C====================================================================
C
      SUBROUTINE SKCONTABRD_qb(MA, MI, ISTA)
C
C     Read QB connection table and fill them into a common block SKTABL2
C
C     <<Input>>
C         MA    :  major version numver
C         MI    :  minor version numver
C
C     <<Output>>
C         ISTA  :  status  (normal = 0,  error = -1)
C
C     26-JUN-2007 made by Y.Takeuchi
C
C===================================================================
      implicit none

#include "skparm.h"
#include "sktabl.h"

      integer ma, mi, ma_last, mi_last, ista
      integer IHUT,ITKO,IMA,iserial
      CHARACTER*200 fname, fname2
      CHARACTER*5   cver

      SAVE ma_last, mi_last
      DATA ma_last/-999/
      DATA mi_last/-999/

      ista = 0
      if (ma.eq.ma_last .and. mi.eq.mi_last) return

c*** make file name
      WRITE(CVER, 101) MA, MI
 101  FORMAT(I2.2,'.',I2.2)
      FNAME =  'qbconnection_' // CVER
      call findconsts(FNAME2, 'QB connection', fname, 2)

c*** open QB connection table
      OPEN(99, FILE=fname2,STATUS='OLD',FORM='FORMATTED')

c*** initialize
      ma_last = ma
      mi_last = mi
      do ihut = 0, MAXHUT
         do itko = 1, MAXTKOBOX
            do ima = 1, MAXTKOMA
                NQBSERIAL(ihut,itko,ima) = -1
             enddo
          enddo
       enddo

c*** main loop
 110  CONTINUE
         READ(99,610,ERR=110,END=210) IHUT,ITKO,IMA,iserial
 610     FORMAT(i2,2x,i2,2x,i2,2x,i5)

         if (ihut.ge.0.and.ihut.le.MAXHUT .and.
     $        itko.ge.1.and.itko.le.MAXTKOBOX .and.
     $        ima.ge.1.and.ima.le.MAXTKOMA) then
            NQBSERIAL(ihut,itko,ima) = iserial
         else
            print *, 'skcontabrd_qb: error? ',IHUT,ITKO,IMA,iserial
            ista = -1
            ma_last = -999
            mi_last = -999
         end if

      GO TO 110

 210  CONTINUE
      CLOSE(99)

      RETURN
      END


