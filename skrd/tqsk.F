************************************************************************
*     -------------------------------------
      SUBROUTINE TQSK(*)
*     -------------------------------------
*
*     (Purpose)
*        Read 'TQ' bank and fill the commons /SKQ/,/SKT/,/SKCHNL/
*
*     (Input)
*        none
*
*     (Output)
*       
*     (Return)
*        Return 1 ; Data w/o 'TQ' bank
*       
*
*     (Creation Date and Author)
*       1992.08.27 ; First version by K.S.Hirata
*
************************************************************************
      implicit none

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"

      CHARACTER*32 CNAME
      INTEGER*4 IBUF(MAXPM*3)

      INTEGER*4 ICHK
      COMMON/SKRDLC/ICHK(MAXPM,2)
     
      integer*4 ipbank,ndata,nhit0,nwrd,nhit,ipoi
      integer*4 istr1,istr2
      integer*4 icab,iabc,it,iq
      integer*4 iabchk
C ---

      CNAME = 'TQ'
      CALL KZBLOC(CNAME,IPBANK)
      IF(IPBANK.LE.0) GOTO 998

      CALL KZGET0(CNAME,0,NDATA,IBUF)
      NHIT0 = IBUF(1)
      NWRD  = IBUF(2)

C ---

      CALL KZGET0(CNAME,1,NDATA,IBUF)

      NHIT = 0
      IPOI = 0
      nqisk = 0

 100  CONTINUE
         IPOI = IPOI+1
         IF(IPOI.GT.NWRD) GOTO 30

         ISTR1 = IBUF(IPOI)/2**16
         ISTR2 = MOD(IBUF(IPOI),2**16)
      
         IF(BTEST(ISTR1,14)) THEN
            IF(BTEST(ISTR2,14)) THEN
               WRITE(6,*) 'Error; This mode is not used now'
               STOP
            ELSE
               ICAB = ICAB+1
            ENDIF
         ELSE
            IF(.NOT. BTEST(ISTR2,14)) THEN
               ICAB = ISTR2
               IPOI = IPOI+1
               ISTR1 = IBUF(IPOI)/2**16
               ISTR2 = MOD(IBUF(IPOI),2**16)
               IF(BTEST(ISTR1,14) .AND. BTEST(ISTR2,14)) THEN
                  WRITE(6,*) 'bit Error'
                  STOP
               ENDIF
            ENDIF
         ENDIF

         IF(BTEST(ISTR1,13) .NEQV. BTEST(ISTR2,13)) THEN
            WRITE(6,*) 'Error: channel A/B is diffrent between T & Q'
            STOP
         ENDIF
         IABC = 1
         IF(BTEST(ISTR1,13) .AND. BTEST(ISTR2,13)) IABC = 2
         
         IT = MOD(ISTR1,2**13)
         IQ = MOD(ISTR2,2**13)

         IF(ICAB.GE.1 .AND. ICAB.LE.MAXPM)THEN
            NHIT = NHIT+1
            IF(ICHK(ICAB,IABC) .EQ. 0) THEN
               nqisk=nqisk+1
               iab(icab)=iabc

               IQABSK(ICAB,IABC) = IQ
               ITABSK(ICAB,IABC) = IT
               ICHK(ICAB,IABC) = 1

               IF(IABC.eq.1) iabchk = 2
               IF(IABC.eq.2) iabchk = 1
               IF(ICHK(ICAB,iabchk).eq.1)THEN
                  WRITE(6,*) 'Warning: A/B hit Cable = ',ICAB
               ENDIF
            ELSE
               IF(IABC.EQ.1)THEN
                 WRITE(6,*) 'Warning: double hit Cable = ',ICAB,' A'
     &                      ,'  NRUN=',NRUNSK,' NEV=',NEVSK
c     &                      ,IQ,IQABSK(ICAB,1),IT,ITABSK(ICAB,1)
               ELSE
                 WRITE(6,*) 'Warning: double hit Cable = ',ICAB,' B'
     &                      ,'  NRUN=',NRUNSK,' NEV=',NEVSK
c     &                      ,IQ,IQABSK(ICAB,2),IT,ITABSK(ICAB,2)
               ENDIF
c               IF(IT .LT. ITABSK(ICAB,IABC)) THEN
c                  IQABSK(ICAB,IABC) = IQ
c                  ITABSK(ICAB,IABC) = IT
c               END IF
            END IF   
         END IF   
      GOTO 100

C ---

 30   CONTINUE
      IF(NHIT .NE. NHIT0) CALL MSGOUT

C ---

      RETURN

C --- w/o 'TQ' bank

 998  RETURN 1

      END
