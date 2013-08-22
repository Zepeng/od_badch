C====================================================================
C
      SUBROUTINE ATMADDRDSK(MAJOR, MINOR)
C
C     Read ATM address and fill them into a common block SKATM
C
C     Y.Takeuchi 28-NOV-1995
C     17-Jan-1996 modified by y.takeuchi
C     25-APR-1997 support veto atm           Y.Takeuchi
C
C===================================================================

#include "skparm.h"
#include "skatm.h"
#include "skveto.h"

      CHARACTER*100  FNAME
      DATA IUNIT/99/

      WRITE(FNAME, 10) MAJOR, MINOR
 10   FORMAT('/skam/const/atm_address_',I2.2, '.', I2.2, '.dat')
      OPEN(UNIT=IUNIT, FILE=FNAME, STATUS='OLD', FORM='FORMATTED')

C*** INITIALIZE
      DO 230 I = 1, MAXHUT
         DO 220 J = 1, MAXTKO
            DO 210 K = 1, MAXMA
               ATMSER(I, J, K) = '       '
 210        CONTINUE
 220     CONTINUE
 230  CONTINUE

 100  CONTINUE
         READ(IUNIT,600,ERR=100,END=200) IHUT, ITKO, IMA,
     $     ATMSER(IHUT, ITKO, IMA)
 600     FORMAT(3I8,1X,A7)
         NREAD = NREAD + 1
      GO TO 100

 200  CONTINUE
      CLOSE(UNIT=IUNIT)

C*** FOR VETO *****************************
      WRITE(FNAME, 710) MAJOR, MINOR
 710  FORMAT('/skam/pro/const/atm_address_',I2.2,'.',I2.2,'.veto')
      OPEN(UNIT=IUNIT, FILE=FNAME, STATUS='OLD', FORM='FORMATTED')
      DO 720 I = MAXPM+1, MAXPMV
         ATMVETO(I) = '       '
 720  CONTINUE

 730  CONTINUE
         READ(IUNIT,740,ERR=730,END=750)
     $     ICAB, ATMVETO(ICAB), ICHVETO(ICAB)
 740     FORMAT(I8,2X,A7,2x,I2)
      GOTO 730

 750  CONTINUE
      CLOSE(UNIT=IUNIT)
C******************************************

      RETURN
      END
