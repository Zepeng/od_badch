C====================================================================
C
      SUBROUTINE SKCALTABSET_PGAIN(MA, MI, ISTA)
C
C     Read and set calibration data for PMT gain
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

      INTEGER    LUN
      PARAMETER (LUN = 99)

      CHARACTER*5  PGAIN_FILE
      PARAMETER (PGAIN_FILE = 'pgain')

      INTEGER      I, J, NDATA, MA, MI, ISTA
      CHARACTER*50 FNAME
      CHARACTER*80 FNAME2
      CHARACTER*5  CVER
C
C*** make file name
      WRITE(CVER, 101) MA, MI
 101  FORMAT(I2.2,'.',I2.2)
      FNAME = PGAIN_FILE // '_' // CVER
      call findconsts(FNAME2,' pgain ',fname,2)
C
C*** open file
      OPEN(LUN, FILE=FNAME2, FORM='FORMATTED', STATUS='OLD')
C
C*** read header
      READ(LUN,*) MA_PGAIN, MI_PGAIN, NDATA
      IF (MA_PGAIN.NE.MA .OR. MI_PGAIN.NE.MI) THEN 
         WRITE(0,*) 'VERSION ERROR! MA,MI,MAJOR,MINOR = ',
     $        MA, MI, MA_PGAIN, MI_PGAIN
         STOP
      ENDIF
C
C*** read gain table
      if (MA_PGAIN.lt.30) then
         if (ndata.gt.MAXPM) then
            print *,'skcaltabset_pgain: error ndata=',ndata, MA_PGAIN
            stop
         endif
         DO 100 J = 1, NDATA
            READ(LUN,*) I, PGAIN(I)
 100     CONTINUE
      else
         if (ndata.gt.MAXPM4) then
            print *,'skcaltabset_pgain: error ndata=',ndata, MA_PGAIN
            stop
         endif
c*** initialize         
         do j = 1, MAXPM4
            pgain_qb(j) = 0.0
         enddo
c*** read table (don't check i range, for now...)
         DO 200 J = 1, NDATA
            READ(LUN,*) I, PGAIN_qb(I)
 200     CONTINUE
      endif

C*** close file
      close(lun)

      ISTA = 0
      RETURN
      END


