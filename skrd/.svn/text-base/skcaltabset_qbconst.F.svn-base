C====================================================================
C
      SUBROUTINE SKCALTABSET_QBCONST(MA, MI, ISTA)
C
c 1. read QB connection table from /skofl/const/qbconnection_XX.YY 
c 2. read QB constant files from /skofl/qbconst/qbZZZZZ.dat 
c 3. fill QB table in the common
C
C     <<Input>>
C         MA    :  major version numver
C         MI    :  minor version numver
C
C     <<Output>>
C         ISTA  :  status  (normal = 0,  error = -1)
c   
C      26-JUN-2007 written by Y.Takeuchi
C      13-JUL-2007 modified by Y.Takeuchi
C        o use /skofl/const/qbconst_XX.YY
C
C===================================================================
      IMPLICIT NONE
#include "skparm.h"
#include "skveto.h"
#include "skcalib.h"
#include "sktabl.h"

      INTEGER    LUN
      PARAMETER (LUN = 99)

      CHARACTER*7  QBCONST_FILE
      PARAMETER (QBCONST_FILE = 'qbconst')

      INTEGER      I, J, NDATA, MA, MI, ISTA
      CHARACTER*50 FNAME
      CHARACTER*80 FNAME2
      CHARACTER*5  CVER

c*** QB calibration parameters
      integer  serialnum0, ch0, range0,ii, k, calmode
      integer  ch0pre
      integer  cntmin, cntmax 
      integer  dsc0preamp, dsc0gain, dsc0range, dsc0cnt
      integer  chg0i3, chg0comp1
      real     ped0mean, cal0mean 
      real     a0, a1, a2, a3, a4, a5 
      real     dsca0, dsca1, chga0, chga1
      integer ihut, itko, ima

c
c*** read connection table
      call skcontabrd

c
c*** clear table, if major version change
      if (ma.ne.MA_QBCONST) then
         do i = 1, MAXQB
            qqb_serialnum0(i) = 0
         enddo
         qqb_ndata = 0
      endif
C
C*** make file name
      WRITE(CVER, 101) MA, MI
 101  FORMAT(I2.2,'.',I2.2)
      FNAME = QBCONST_FILE // '_' // CVER
      call findconsts(FNAME2,' qbconst ',fname,2)
C
C*** open file
      OPEN(LUN, FILE=FNAME2, FORM='FORMATTED', STATUS='OLD')
C
C*** read header
      READ(LUN,*) MA_QBCONST, MI_QBCONST, NDATA
      IF (MA_QBCONST.NE.MA .OR. MI_QBCONST.NE.MI) THEN 
         WRITE(0,*) 'VERSION ERROR! MA,MI,MAJOR,MINOR = ',
     $        MA, MI, MA_QBCONST, MI_QBCONST
         STOP
      ENDIF

c*** check number of contents
      if (ndata.gt.MAXQB) then
         print *, 'skcaltabset_qbconst: error NDATA=', ndata
         stop
      endif

ccccccccccccccccccccccc
c 13-JUL-2007 don't know how to obtain calmode, use default (y.t.)
      calmode = 1
ccccccccccccccccccccccc

c*** read tables
      do i = 1, ndata

c*** read QB calibration parameters (assuming fixed length)
         ch0pre = -1
         do j = 1, 96
            read(99,210) serialnum0, ch0, range0, ped0mean,
     $           cal0mean, cntmin, cntmax, a0, a1, 
     $           a2, a3, a4, a5, dsc0preamp, 
     $           dsc0gain, dsc0range, dsc0cnt, dsca0, 
     $           dsca1, chg0i3, chg0comp1, chga0, chga1

 210        format(i5.5,1x,i2,1x,i1,1x,2(f7.2,1x),2(i4,1x),6(e12.5,1x),
     $           3(i1,1x),i3,1x,2(f8.3,1x),2(i2,1x),2(f6.2,1x))

c*** search qqb_table in memory
            if (j.eq.1) then
               ii = -1
               do k = 1, qqb_ndata
                  if (serialnum0.eq.qqb_serialnum0(k)) then
                     ii = k
                  endif
               enddo
               if (ii.eq.-1) then
                  qqb_ndata = qqb_ndata + 1
                  ii = qqb_ndata
               endif
cc               print *, 'qb index, serial =', ii, serialnum0
            endif

c***  check small range (range0=-1: lower part, 0: upper part)
C            if (range0.eq.0 .and. cntmin.le.0) then
            if (range0.eq.0 .and. ch0.ne.ch0pre) then
               range0 = -1
               ch0pre = ch0
            endif

c*** check QB channel
            if (ch0.lt.0 .or. ch0.gt.23) then
               print *, 'skcaltabset_qbconst: channel error!', ch0 
               stop
            endif

            if (ii.ge.1 .and. ii.le.MAXQB) then
               qqb_serialnum0(ii)        = serialnum0
               qqb_ped0mean(ii,ch0,range0,CALMODE)   = ped0mean
               qqb_cal0mean(ii,ch0,range0,CALMODE)   = cal0mean
               qqb_cntmin(ii,ch0,range0)     = cntmin
               qqb_cntmax(ii,ch0,range0)     = cntmax
               qqb_a0(ii,ch0,range0)         = a0
               qqb_a1(ii,ch0,range0)         = a1
               qqb_a2(ii,ch0,range0)         = a2
               qqb_a3(ii,ch0,range0)         = a3
               qqb_a4(ii,ch0,range0)         = a4
               qqb_a5(ii,ch0,range0)         = a5
               qqb_dsc0preamp(ii,ch0,range0) = dsc0preamp
               qqb_dsc0gain(ii,ch0,range0)   = dsc0gain
               qqb_dsc0range(ii,ch0,range0)  = dsc0range
               qqb_dsc0cnt(ii,ch0,range0)    = dsc0cnt
               qqb_dsca0(ii,ch0,range0)      = dsca0
               qqb_dsca1(ii,ch0,range0)      = dsca1
               qqb_chg0i3(ii,ch0,range0)     = chg0i3
               qqb_chg0comp1(ii,ch0,range0)  = chg0comp1
               qqb_chga0(ii,ch0,range0)      = chga0
               qqb_chga1(ii,ch0,range0)      = chga1
            else
               print *, 'skcaltabset_qbconst: error ii=', ii
               stop
            endif
         enddo

c*** check QB connection table, then copy data if needed
         do ihut = 0, MAXHUT
            do itko = 1, MAXTKOBOX
               do ima = 1, MAXTKOMA
                  if (NQBSERIAL(ihut,itko,ima).eq.serialnum0) then
                     call skcaltabset_qb(ihut, itko, ima, serialnum0, ista) 
                  endif
               enddo
            enddo
         enddo

      enddo

C*** close file
      close(lun)

      ISTA = 0
      RETURN
      END

