C====================================================================
C
      SUBROUTINE SKCALTABVER_OD(NRUN, MMA_OD, MMI_OD)
C
C     Read and set calibration table version
C
C     <<Input>>
C         NRUN     :  run number
C
C     <<Output>>

C         MA_GAIN  :  major version numver of OD constants
C         MI_GAIN  :  minor version numver of OD constants
C     
C      1-SEP-2008  K. Scholberg, modified from ID version
C
C===================================================================
      IMPLICIT NONE
#include "skparm.h"
#include "skveto.h"
#include "skodcalib.h"

      INTEGER MMA_OD,MMI_OD

      INTEGER LUN, MAXDAT, MAXRUN, MINRUN
      PARAMETER (LUN    =     99)
      PARAMETER (MAXDAT =   1000)
      PARAMETER (MAXRUN =  99999)
      PARAMETER (MINRUN = -99999)

      INTEGER I, NRUN, NRUN_TOTAL, NPRUN(MAXDAT), NMRUN(MAXDAT)
      INTEGER MAJOR_OD(MAXDAT), MINOR_OD(MAXDAT)
      CHARACTER*1024 LINEBUF
      CHARACTER*1  CHARBUF
      LOGICAL*4 EX 

C
C*** check run number 
C
      IF (NRUN .GT. MAXRUN .OR. NRUN.LT. MINRUN) THEN
         WRITE(0,*) 'skcaltabver_od: bad run number!! nrun = ', NRUN
         STOP
      ENDIF
C
C*** open file
      INQUIRE(FILE=OD_CALTAB_FILE, EXIST=EX)
      IF (EX) THEN
         OPEN(LUN, FILE=OD_CALTAB_FILE, STATUS='OLD',FORM='FORMATTED')
         write(6,*) 'skcaltabver1: table version = ', OD_CALTAB_FILE
      ELSE
         call findconsts(od_caltab_file,' caltab_file ','od_table_version.dat',2)
         OPEN(LUN, FILE=od_caltab_file, STATUS='OLD',FORM='FORMATTED')
         write(6,*) 'skcaltabver2: table version = ', OD_CALTAB_FILE
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
     $        MAJOR_OD(I), MINOR_OD(I)
 103     FORMAT(10X, 2I7, 2X,I2,1X,I2)
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
      MMA_OD   = MAJOR_OD(I)
      MMI_OD   = MINOR_OD(I)

      RETURN
      END
     
