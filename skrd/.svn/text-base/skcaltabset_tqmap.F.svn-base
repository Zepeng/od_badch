C====================================================================
C
      SUBROUTINE SKCALTABSET_TQMAP(MA, MI, ISTA)
C
C     Read and set calibration data for TQ-map
C
C     <<Input>>
C         MA    :  major version numver
C         MI    :  minor version numver
C
C     <<Output>>
C         ISTA  :  status  (normal = 0,  error = -1)
C     
C      31-JAN-1996 written by Y.Takeuchi
C      29-JUN-2007 modified for QB by Y.Takeuchi
C         o added tqmap_qb() 
C
C===================================================================
      IMPLICIT NONE
#include "skparm.h"
#include "skveto.h"
#include "skcalib.h"

c*** initial major version # for QB
      INTEGER    MA_QB_START
      PARAMETER (MA_QB_START = 30)
      integer i, j, k
      double precision a(22)
      
      INTEGER    LUN
      PARAMETER (LUN = 99)

      CHARACTER*5  TQMAP_FILE
      PARAMETER (TQMAP_FILE = 'tqmap')

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
      INTEGER      ID,IND,ISTA,ISTAT,LUNPTR,MA,MI,NDATA
      CHARACTER*5  CVER
      CHARACTER*50 FNAME
      CHARACTER*80 FNAME2
      CHARACTER*4  CN
C
C*** make file name
      WRITE(CVER, 101) MA, MI
 101  FORMAT(I2.2,'.',I2.2)
      FNAME = TQMAP_FILE // '_' // CVER
      call findconsts(FNAME2,' tqmap ',fname,2)

      if (MA.lt.MA_QB_START) then

c*** for ATM*********************************
C
C*** initialize
         IF (INICAL .EQ. 0) THEN
            INICAL = 1
            CALL MZSTOR(IXSTOR,'/CALTAB/',' ',IFENCE,LEV,BLVECT(1),
     &           BLVECT(1), BLVECT(100),BLVECT(MAX_ZEBRA1))
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
         MA_TQMAP = IDATA(IND+1)
         MI_TQMAP = IDATA(IND+2)
         NDATA    = IDATA(IND+3)
         NXTQ     = IDATA(IND+4)
         IF (MA_TQMAP.NE.MA .OR. MI_TQMAP.NE.MI) THEN 
            WRITE(0,*) 'VERSION ERROR! MA,MI,MAJOR,MINOR = ',
     $           MA, MI, MA_TQMAP, MI_TQMAP
            STOP
         ENDIF
         IXCO = MZIXCO(IXSTOR+21,IXSTOR+22,0,0)
         CALL MZWIPE(IXCO)
CC      WRITE(0,*) MA_TQMAP, MI_TQMAP, NDATA, NXTQ
C
C*** allocate and read TQMP
         if (NXTQ.gt.MAX_TQMAP) then
            print *,'skcaltabset_tqmap: error ndata=',nxtq, MA_TQMAP
            stop
         endif

 200     CONTINUE
C*** allocate TQMP
            CALL BANK_ALLOC(LUN, CN, ID, IND, ISTAT)
            IF (ISTAT.EQ.2) GOTO 999
            IF (ISTAT.NE.0 .OR. CN .NE. 'TQMP') THEN
               WRITE(0,*) 'ERROR! bank name = ', CN
               STOP
            ENDIF
C
C***  read TQMP
            DO 100 J = 1, NXTQ
               TQMAP(ID,J,1) = RDATA(IND+J)
               TQMAP(ID,J,2) = RDATA(IND+NXTQ+J)
 100        CONTINUE
            IXCO = MZIXCO(IXSTOR+21,IXSTOR+22,0,0)
            CALL MZWIPE(IXCO)
         GOTO 200

 999     CONTINUE
CC      WRITE(6,*) 'caltabset: END OF FILE.  file = ', FNAME2
         CALL FZENDI(LUN, 'TXQ')

      else
c*** for QB *********************************

C*** open file
         OPEN(LUN, FILE=FNAME2, FORM='FORMATTED', STATUS='OLD')
C
C*** read header
         READ(LUN,*) MA_TQMAP, MI_TQMAP, NDATA
         IF (MA_TQMAP.NE.MA .OR. MI_TQMAP.NE.MI) THEN 
            WRITE(0,*) 'VERSION ERROR! MA,MI,MAJOR,MINOR = ',
     $           MA, MI, MA_TQMAP, MI_TQMAP
            STOP
         endif

C*** check # of data
         if (ndata.gt.MAXPM4) then
            print *,'skcaltabset_tqmap: error ndata=',ndata, MA_TQMAP
            stop
         endif

c*** initialize         
         do j = 1, MAXPM4
            do k = 1, 22
               tqmap_qb(j,k) = 0.0
            enddo
         enddo
C
C*** read gain table
         DO J = 1, NDATA
	    if(MA_TQMAP.eq.50) then
              READ(LUN,*) I, a
	    else
	      READ(LUN,*) I, (a(k),k=1,15)
	    endif
            if (i.ge.1 .and.i.le.MAXPM4) then
               do k = 1, 22
                  tqmap_qb(i,k) = a(k)
               enddo
            else
               print *, 'skcaltabset_tqmap: error cable=', j, i, a
               stop
            endif
c 220        format(i5.5,1x,8(e17.10e2,1x))
         enddo

C*** close file
         close(lun)

      endif

      ISTA = 0
      RETURN
      END

C*********************************************
CCC      SUBROUTINE BANK_ALLOC(LUN, CN, ID, IND, ISTAT)
C*********************************************
CCC THIS SUBROUTINE EXSISTS IN 'caltabset_atmtq.F'
