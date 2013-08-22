C====================================================================
C
      SUBROUTINE SKCALTABFILE(FNAME)
C
C     Set file name of the calibration version table
C
C     <<Input>>
C         FNAME :  file name for the calibration version data
C
C     <<Output>>
C     
C      24-JUL-1996 written by Y.Takeuchi
C
C===================================================================
      IMPLICIT NONE
#include "skparm.h"
#include "skveto.h"
#include "skcalib.h"

      CHARACTER*(*) FNAME
      LOGICAL*4 EX

C*** check existence of the table file
      INQUIRE(FILE=FNAME, EXIST=EX)

C*** set file name
      IF (EX) THEN
         write(0,*) 'skcaltabfile: table version file = ', FNAME
         CALTAB_FILE = FNAME
      ELSE
         write(0,*) 'skcaltabfile: file does not exist!: ', FNAME
         CALTAB_FILE = ' '
      ENDIF

C*** end
      RETURN
      END
