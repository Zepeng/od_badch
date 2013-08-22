C====================================================================
C
      SUBROUTINE SKCALTABSET_OD(MA, MI, ISTA)
C
C     Read and set OD PMT calibration data 
C
C     <<Input>>
C         MA    :  major version numver
C         MI    :  minor version numver
C
C     <<Output>>
C         ISTA  :  status  (normal = 0,  error = -1)
C     
C      28-FEB-1996 written by Y.Takeuchi
C      29-JUN-2007 modified for QB by Y.Takeuchi
C         o added pgain_qb() 
C
C===================================================================
      IMPLICIT NONE
#include "skparm.h"
#include "skveto.h"
#include "skcalib.h"
#include "skodcalib.h"

      INTEGER    LUN
      PARAMETER (LUN = 99)

      CHARACTER*2  OD_FILE
      PARAMETER (OD_FILE = 'od')

      INTEGER      I, J, NDATA, MA, MI, ISTA
      CHARACTER*50 FNAME
      CHARACTER*80 FNAME2
      CHARACTER*5  CVER
C
C*** make file name
      WRITE(CVER, 101) MA, MI
 101  FORMAT(I2.2,'.',I2.2)
      FNAME = OD_FILE // '_' // CVER
      call findconsts(FNAME2,'od',fname,2)
C
C*** open file
      OPEN(LUN, FILE=FNAME2, FORM='FORMATTED', STATUS='OLD')
C
C*** read header
      READ(LUN,*) MA_OD, MI_OD, NDATA
      IF (MA_OD.NE.MA .OR. MI_OD.NE.MI) THEN 
         WRITE(0,*) 'VERSION ERROR! MA,MI,MAJOR,MINOR = ',
     $        MA, MI, MA_OD, MI_OD
         STOP
      ENDIF
C
C*** read table
      if (ndata.ne.MAXPMA) then
         print *,'skcaltabset_od: error ndata=',ndata, MA_OD
         stop
      else
         DO 100 J = 1, NDATA
            READ(LUN,*,err=98) I, ODGAIN(I),ODTOFF(I)
            IF (ODGAIN(I).LE.0) ODGAIN(I) = 1.
* For calibration-- don't want gains already applied
            IF (ODCALFLAG.EQ.1) ODGAIN(I) = 1.
 100     CONTINUE
      endif 

      GOTO 99
 98   CONTINUE
      write(6,*)'skcaltabset_od: error in reading OD constant file!'

 99    CONTINUE
C*** close file
      close(lun)

      ISTA = 0
      RETURN
      END


