************************************************************************
*     -------------------------------------
      SUBROUTINE SKOPTN(A)
*     -------------------------------------
*
*     (Purpose)
*        Set option for SKREAD
*
*     (Input)
*        A   ; Option
*
*	31 : Read the HEADER bank & put it to skhead.h
*	     ( you always MUST set this number )
*	30 : Read the real data from TQREAL bank & put it to sktq.h
*	29 : Read the count of T & Q from TQ bank & put it to sktq.h
*     
*       27:  Set bad channel for ATMPD MC 
*
*	26 : Read the information of bad channel from the data file 
*	     & put it to skbadc.h
*	     You MUST define the data file in file list as follows;
*
*       30{{"/skam/const/badch.dat",LOCAL,,RED,,,"form=formatted",}}
*
*	25 : Mask the bad channel.
*
*	23 : Charge correction for ATMPD analysis (made by Etoh-san),
*            read water transparency information, 
*            and put it into skwaterlen.h
*
*	22 : Read the pedestal data from PDST bank & put it to skpdst.h
*
*	20 : Read event without clearing previous event
*	
*	19 : Read Real data from VETO bank & put it to skveto.h 
*       
*	18 : Read TQ data from TQ bank & put it to skveto.h
*
*	17 : Read RWANTI bank & put it to sktq.h regardless
*  	     of header
*
*	16 : Read TQSKZ & TQSKAZ in SKREAD
*
*	15 : Timing correction (TMQ) by Ikeda-san
*
*       14 : Do not remove q<0 hits for OD (SK IV only)
*
*     (Output)
*        NONE
*       
*     (Creation Date and Author)
*       1995.01.10 ; First version by Y.Koshio
*	1997.03.   ; added optin 19,18 ( for Veto counter) by J.Kameda 
*	1998.08.27 ; Added option 17 for OD only recalibration
*			by A.Kibayashi
*
************************************************************************

      COMMON /SKOPT/ISKBIT

      CHARACTER*(*) A
      CHARACTER*1 CN(0:9)
      DATA CN/'0','1','2','3','4','5','6','7','8','9'/

      ISKBIT=0
      ILEN=LEN(A)
      IS=0
   50 IVAL=0
   40 IS=IS+1
      IF(IS.LE.ILEN)THEN
        IF(A(IS:IS).EQ.' ')GOTO 40
        DO 70 I=0,9
          IF(A(IS:IS).EQ.CN(I))THEN
            IVAL=IVAL*10+I
            GOTO 40
          ENDIF
   70   CONTINUE
      ENDIF
   80 IF(IVAL.GE.0 .AND. IVAL.LE.31)ISKBIT=IBSET(ISKBIT,31-IVAL)
      IF(IS.LE.ILEN)THEN
        IF(A(IS:IS).EQ.',')GOTO 50
      ENDIF
      IF(IS.LE.ILEN)THEN
        WRITE(6,*)'ERROR; in SKOPTN'
        WRITE(6,*)A
      ENDIF
      RETURN
      END
