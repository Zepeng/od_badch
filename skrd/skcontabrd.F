C====================================================================
C
      SUBROUTINE SKCONTABRD
C
C     Read connection table and fill them into a common block SKTABL
C
C     M.Nakahata  4-NOV-1995
C
C      5-DEC-1995 modified by Y.Takeuchi
C         o support new connection table file (connection.super.dat)
C
C      26-JUN-2007 modified by Y.Takeuchi
C         o support new connection table file (connection.super.sk-4.dat)
C
C===================================================================
      implicit none

#include "skparm.h"
#include "sktabl.h"

      integer ICAB,ISM,IM,IHUT,ITKO,IMA,ICH,iunit

      character*132 confile_name
      character*256 file_line
      integer lenchr
      INTEGER ICALL
      SAVE ICALL
      DATA ICALL/0/
      DATA IUNIT/99/

      IF (ICALL.EQ.1) RETURN
      ICALL = 1

c*** for ATM
      call findconsts(confile_name,'connection table1',
     &      'connection.super.dat', 2)
      OPEN(UNIT=IUNIT, FILE=confile_name(1:lenchr(confile_name)),
     &     STATUS='OLD',FORM='FORMATTED')

 100  CONTINUE

      READ(IUNIT,'(A256)',ERR=100,END=200) file_line

      IF (file_line(1:1) .eq. "#") then
         GO TO 100
      ELSE
         READ (file_line,600) ICAB,ISM,IM,IHUT,ITKO,IMA,ICH
      END IF

 600  FORMAT(I8, 12X, 2I8, 4I4)
      IF (ICAB.GE.1 .AND. ICAB.LE.MAXPM) THEN
         NSMDL(ICAB)  = ISM
         NMDL(ICAB)   = IM
         NHUT(ICAB)   = IHUT
         NTKO(ICAB)   = ITKO
         NATMSL(ICAB) = IMA
         NATMCH(ICAB) = ICH
      END IF
      
      GO TO 100

 200  CONTINUE
      CLOSE(UNIT=IUNIT)

c*** for QB
      call findconsts(confile_name,'connection table2',
     $     'connection.super.sk-4.dat', 2)

      OPEN(UNIT=IUNIT, FILE=confile_name(1:lenchr(confile_name)),
     &     STATUS='OLD',FORM='FORMATTED')

 110  CONTINUE

      READ(IUNIT,'(A256)',ERR=110,END=210) file_line

      IF (file_line(1:1) .eq. "#") then
         GO TO 110
      ELSE
         READ (file_line,610) ICAB,ISM,IM,IHUT,ITKO,IMA,ICH
      END IF

 610  FORMAT(I8, 12X, 2I8, 4I4)
      IF (ICAB.GE.1 .AND. ICAB.LE.MAXPM4) THEN
         NQBHUT(ICAB)  = IHUT
         NQBTKO(ICAB)  = ITKO
         NQBSL(ICAB)   = IMA
         NQBCH(ICAB)   = ICH
         if (ihut.ge.0.and.ihut.le.MAXHUT .and.
     $        itko.ge.1.and.itko.le.MAXTKOBOX .and.
     $        ima.ge.1.and.ima.le.MAXTKOMA .and.
     $        ich.ge.0 .and. ich.le.23) then
            NQBCAB(ihut,itko,ima,ich) = icab
         else
            print *, 'skcontabrd: error!'
            stop
         endif
      END IF
      
      GO TO 110

 210  CONTINUE
      CLOSE(UNIT=IUNIT)

      RETURN
      END


