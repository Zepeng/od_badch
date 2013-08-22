C***********************************************************************
C    $Id: fill_zbs_commons.F,v 1.1 1998/09/12 15:03:48 koshio Exp $
C 
C   (Purpose)
C     Call SKREAD to fill the zbs commons.  KZREAD must be 
C     called first.  This routine is deprecated: Call SKREAD directly
C     with a LUN of zero.
C
C   (Input)
C     None
C
C   (Output)
C     IERR = 0    - Normal
C            1    - Error
C            3    - Data PDST bank
C            4    - Data 'RUNINF' bank
C
C    $Log: fill_zbs_commons.F,v $
C    Revision 1.1  1998/09/12 15:03:48  koshio
C    Install necessary files from apskrd
C
C    Revision 1.4  1997/11/10 00:33:14  mcgrew
C    Removed the code that was copied from SKREAD and call SKREAD
C    directly.  This code is deprecated as SKREAD has always provided the
C    same functionality.
C
C    Revision 1.3  1997/10/20 18:36:53  mcgrew
C    Return a completion status through an argument.
C
C    Revision 1.2  1997/10/12 21:56:06  superk
C    Put skbadch back in (KS)
C
C    Revision 1.1  1997/10/08 18:47:10  superk
C    Code for filling ZBS commons based on SKREAD, for zootsuit (KS).
C
C

      SUBROUTINE FILL_ZBS_COMMONS(IERR)
C*** RETURN THE STATUS.
      INTEGER IERR

      SAVE IFLAG
      DATA IFLAG /0/

#define DEPRECATION_WARNING
#ifdef DEPRECATION_WARNING
      IF (IFLAG.EQ.0) THEN
         WRITE(6,*) 
     $        'FILL_ZBS_COMMONS:  This routine has been deprecated.'
         WRITE(6,*)
     $        '     Please use SKREAD or SKCREAD with a LUN of zero'
         WRITE(6,*)
     $        '     to fill the F77 common blocks.'
         IFLAG = 1
      ENDIF
#endif

      CALL SKCREAD(0,IERR)

      RETURN
      END
