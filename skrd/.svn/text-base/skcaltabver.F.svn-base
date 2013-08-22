C====================================================================
C
      SUBROUTINE SKCALTABVER(NRUN, MMA_ATM, MMI_ATM, MMA_TQMAP, 
     $     MMI_TQMAP, MMA_GAIN, MMI_GAIN)
C
C     Read and set calibration table version
C
C     <<Input>>
C         NRUN     :  run number
C
C     <<Output>>
C         MA_ATM   :  major version numver of ATM TQ
C         MI_ATM   :  minor version numver of ATM TQ
C         MA_TQMAP :  major version numver of TQ-map
C         MI_TQMAP :  minor version numver of TQ-map
C         MA_GAIN  :  major version numver of PMT gain
C         MI_GAIN  :  minor version numver of PMT gain
C     
C      24-JUL-1995 written by Y.Takeuchi
C      29-JUN-2007 modified by y.takeuchi
C         o added close(LUN)  (bug fix)
C
C===================================================================
      IMPLICIT NONE
#include "skparm.h"
#include "skveto.h"
#include "skcalib.h"

      INTEGER MMA_ATM,MMI_ATM,MMA_TQMAP,MMI_TQMAP,MMA_GAIN,MMI_GAIN

      INTEGER LUN, MAXDAT, MAXRUN, MINRUN
      PARAMETER (LUN    =     99)
      PARAMETER (MAXDAT =   1000)
      PARAMETER (MAXRUN =  99999)
      PARAMETER (MINRUN = -99999)

      INTEGER I, NRUN, NRUN_TOTAL, NPRUN(MAXDAT), NMRUN(MAXDAT)
      INTEGER MAJOR_ATM(MAXDAT), MINOR_ATM(MAXDAT)
      INTEGER MAJOR_TQMAP(MAXDAT), MINOR_TQMAP(MAXDAT)
      INTEGER MAJOR_GAIN(MAXDAT), MINOR_GAIN(MAXDAT)
      CHARACTER*1024 LINEBUF
      CHARACTER*1  CHARBUF
      LOGICAL*4 EX 

C
C*** check run number 
C
      IF (NRUN .GT. MAXRUN .OR. NRUN.LT. MINRUN) THEN
         WRITE(0,*) 'skcaltabver: bad run number!! nrun = ', NRUN
         STOP
      ENDIF
C
C*** open file
      INQUIRE(FILE=CALTAB_FILE, EXIST=EX)
      IF (EX) THEN
         OPEN(LUN, FILE=CALTAB_FILE, STATUS='OLD',FORM='FORMATTED')
         write(6,*) 'skcaltabver1: table version = ', CALTAB_FILE
      ELSE
         call findconsts(caltab_file,' caltab_file ','table_version.dat',2)
         OPEN(LUN, FILE=caltab_file, STATUS='OLD',FORM='FORMATTED')
         write(6,*) 'skcaltabver2: table version = ', CALTAB_FILE
      ENDIF

c*** initialize
      i = 0
      
 100  CONTINUE
C
C*** read a line
      READ(LUN, 101, END=200) LINEBUF
 101  FORMAT(A)
C
C*** skip comments
      READ(LINEBUF, 102) CHARBUF
 102  FORMAT(A1)
      IF (CHARBUF .NE. '#') THEN
C
C*** check data size
         I = I + 1
         IF (I .GT. MAXDAT) THEN
            WRITE(0,*) 'skcaltabver: error! MAXDAT = ', MAXDAT
            STOP
         ENDIF
C
C*** READ version data
         READ(LINEBUF, 103) NPRUN(I), NMRUN(I),
     $        MAJOR_ATM(I), MINOR_ATM(I),
     $        MAJOR_TQMAP(I), MINOR_TQMAP(I),
     $        MAJOR_GAIN(I), MINOR_GAIN(I)
 103     FORMAT(10X, 2I7, 3(2X,I2,1X,I2))
      ENDIF
      GOTO 100
 200  CONTINUE

c*** close
      close(LUN)

      NPRUN(I+1) = MAXRUN 
      NMRUN(I+1) = MINRUN 
      NRUN_TOTAL = I
cc         WRITE(*,*) 'caltabver: total run = ', NRUN_TOTAL 
C
C*** serch suitable bin
C
      DO 300 I = NRUN_TOTAL, 1, -1
         IF (NRUN .GT. 0) THEN
            IF (NRUN.GE.NPRUN(I) .AND. NRUN.LT.NPRUN(I+1)) THEN
               GOTO 400
            ENDIF
         ELSE
            IF (NRUN.LE.NMRUN(I) .AND. NRUN.GT.NMRUN(I+1)) THEN
               GOTO 400
            ENDIF
         ENDIF
 300  CONTINUE
C
C*** set values and return
C
 400  CONTINUE
      MMA_ATM   = MAJOR_ATM(I)
      MMI_ATM   = MINOR_ATM(I)
      MMA_TQMAP = MAJOR_TQMAP(I)
      MMI_TQMAP = MINOR_TQMAP(I)
      MMA_GAIN  = MAJOR_GAIN(I)
      MMI_GAIN  = MINOR_GAIN(I)

      RETURN
      END
     
