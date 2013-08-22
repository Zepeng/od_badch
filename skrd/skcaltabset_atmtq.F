C====================================================================
C
      SUBROUTINE SKCALTABSET_ATMTQ(MA, MI, ISTA)
C
C     Read and set calibration data for ATMTQ
C
C     <<Input>>
C         MA    :  major version numver
C         MI    :  minor version numver
C
C     <<Output>>
C         ISTA  :  status  (normal = 0,  error = -1)
C     
C      21-DEC-1995 written by Y.Takeuchi
C
C===================================================================
      IMPLICIT NONE
#include "skparm.h"
#include "skveto.h"
#include "skcalib.h"

      INTEGER    LUN
      PARAMETER (LUN = 99)

      CHARACTER*12 CONST_DIR
      PARAMETER (CONST_DIR  = '/skam/const/')
      CHARACTER*5  ATMTQ_FILE
      PARAMETER (ATMTQ_FILE = 'atmtq')

      INTEGER    MAX_ZEBRA1, MAX_ZEBRA2
      PARAMETER (MAX_ZEBRA1 = 2000)
      PARAMETER (MAX_ZEBRA2 = 8000)

      INTEGER INICAL, IXSTOR, IFENCE,LEV,IQUEST,LDATA,IDATA
      REAL    BLVECT, RDATA
      COMMON /CALTAB/INICAL,IXSTOR,IFENCE(16),LEV,BLVECT(MAX_ZEBRA1)
      COMMON /QUEST/IQUEST(100)
      DIMENSION LDATA(MAX_ZEBRA1),IDATA(MAX_ZEBRA1),RDATA(MAX_ZEBRA1)
      CHARACTER CDATA(MAX_ZEBRA2)
      EQUIVALENCE(IDATA(1),LDATA(9),RDATA(1),CDATA(1)),(LDATA(1),LEV)

      INTEGER      MZIXCO,IXCO
      INTEGER      I,ID,IND,ISTA,ISTAT,J,LUNPTR,MA,MI,NDATA
      CHARACTER*5  CVER
      CHARACTER*50 FNAME
      CHARACTER*80 FNAME2
      CHARACTER*4  CN
C
C*** make file name
      WRITE(CVER, 101) MA, MI
 101  FORMAT(I2.2,'.',I2.2)
      FNAME =  ATMTQ_FILE // '_' // CVER
      call findconsts(FNAME2,' atmtq ',fname,2)
C
C*** initialize
      IF (INICAL .EQ. 0) THEN
         INICAL = 1
         CALL MZSTOR(IXSTOR,'/CALTAB/',' ',IFENCE,LEV,BLVECT(1),
     &        BLVECT(1), BLVECT(100),BLVECT(MAX_ZEBRA1))
      ENDIF
      CALL CFOPEN(LUNPTR, 0, 900, 'r ', 0, FNAME2, ISTA)
      IF (ISTA.NE.0) THEN
         WRITE(0,*) 'skcaltabset: cfopen error! fname2=', fname2
         STOP
      ENDIF
      IQUEST(1) = LUNPTR
      CALL FZFILE(LUN, 0, 'LXI')

C
C*** allocate header
      CALL BANK_ALLOC(LUN, CN, ID, IND, ISTAT)
      IF (ISTAT.NE.0 .OR. CN .NE. 'HEAD') THEN
         WRITE(0,*) 'ERROR! bank name = ', CN
         STOP
      ENDIF
C
C*** read header
      MA_ATMTQ = IDATA(IND+1)
      MI_ATMTQ = IDATA(IND+2)
      NDATA    = IDATA(IND+3)
      NXT      = IDATA(IND+4)
      NXQ      = IDATA(IND+5)
      IF (MA_ATMTQ.NE.MA .OR. MI_ATMTQ.NE.MI) THEN 
         WRITE(0,*) 'VERSION ERROR! MA,MI,MAJOR,MINOR = ',
     $        MA, MI, MA_ATMTQ, MI_ATMTQ
         STOP
      ENDIF
      IXCO = MZIXCO(IXSTOR+21,IXSTOR+22,0,0)
      CALL MZWIPE(IXCO)
cc      WRITE(0,*) MA_ATMTQ, MI_ATMTQ, NDATA, NXT, NXQ

C
C*** allocate XBIN
      CALL BANK_ALLOC(LUN, CN, ID, IND, ISTAT)
      IF (ISTAT.NE.0 .OR. CN .NE. 'XBIN') THEN
         WRITE(0,*) 'ERROR! bank name = ', CN
         STOP
      ENDIF
C
C*** read XBIN
      DO 60 I = 1, NXT
         XT(I) = RDATA(IND+I)
 60   CONTINUE
      DO 70 I = 1, NXQ
         XQ(I) = RDATA(IND+NXT+I)
 70   CONTINUE
      IXCO = MZIXCO(IXSTOR+21,IXSTOR+22,0,0)
      CALL MZWIPE(IXCO)
C
C*** allocate and read ATMC
C
 200  CONTINUE
C*** allocate ATMC
         CALL BANK_ALLOC(LUN, CN, ID, IND, ISTAT)
         IF (ISTAT.EQ.2) GOTO 999
         IF (ISTAT.NE.0 .OR. CN .NE. 'ATMC') THEN
            WRITE(0,*) 'ERROR! bank name = ', CN
            STOP
         ENDIF
C*** read ATMC
         DO 100 J = 0, NXT
            T_ATM(ID,J,1) = RDATA(IND+1+J)
            T_ATM(ID,J,2) = RDATA(IND+1+NXT+1+J)
 100     CONTINUE
         DO 110 J = 0, NXQ
            Q_ATM(ID,J,1) = RDATA(IND+1+(NXT+1)*2+J)
            Q_ATM(ID,J,2) = RDATA(IND+1+(NXT+1)*2+NXQ+1+J)
 110     CONTINUE
         IXCO = MZIXCO(IXSTOR+21,IXSTOR+22,0,0)
         CALL MZWIPE(IXCO)
      GOTO 200

 999  CONTINUE
CC      WRITE(6,*) 'caltabset: END OF FILE.  file = ', FNAME2

      CALL FZENDI(LUN, 'TXQ')
      ISTA = 0
      RETURN
      END

C*********************************************
      SUBROUTINE BANK_ALLOC(LUN, CN, ID, IND, ISTAT)
C*********************************************
      IMPLICIT NONE
      INTEGER    MAX_ZEBRA1, MAX_ZEBRA2
      PARAMETER (MAX_ZEBRA1 = 2000)
      PARAMETER (MAX_ZEBRA2 = 8000)

      INTEGER INICAL, IXSTOR, IFENCE,LEV,IQUEST,LDATA,IDATA
      REAL    BLVECT, RDATA
      COMMON /CALTAB/INICAL,IXSTOR,IFENCE(16),LEV,BLVECT(MAX_ZEBRA1)
      COMMON /QUEST/IQUEST(100)
      DIMENSION LDATA(MAX_ZEBRA1),IDATA(MAX_ZEBRA1),RDATA(MAX_ZEBRA1)
      CHARACTER CDATA(MAX_ZEBRA2)
      EQUIVALENCE(IDATA(1),LDATA(9),RDATA(1),CDATA(1)),(LDATA(1),LEV)

      INTEGER ID, IND, ISTAT, LUN
      CHARACTER    CN1(4)
      CHARACTER*4  CN4, CN
      EQUIVALENCE(CN1(1),CN4)

      CALL FZIN(LUN, IXSTOR, IND, 2, ' ', 0, 0)

      IF (IQUEST(1).EQ.0) THEN
         CN1(1) = CDATA((IND-5)*4+1)
         CN1(2) = CDATA((IND-5)*4+2)
         CN1(3) = CDATA((IND-5)*4+3)
         CN1(4) = CDATA((IND-5)*4+4)
         CN = CN4
         ID = IDATA(IND - 5)
      ELSE
         CN = '    '
         ID = 0
      ENDIF
      ISTAT = IQUEST(1)
      RETURN
      END
