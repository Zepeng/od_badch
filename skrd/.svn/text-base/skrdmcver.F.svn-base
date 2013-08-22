C
      subroutine skrdmcver
C
C     read detsim version bank
C
C 
      implicit none

#include "skhead.h"
#include "apversion.h"

      Real RDATA(10)
      CHARACTER*32 CNAME
      Integer ipbank, ndata
      Real oldversion
      Data oldversion/-1./
      Real oldskversion
      Data oldskversion/-1./

      If (mdrnsk.ne.0) Return

C     
C     -- SET MONTE CARLO VERSION NUMBER
C     
C     RDATA(1) ; apdetsim version
C     
C
      apdslibver = 0.
      CNAME='SKMCVER'
      CALL KZBLOC(CNAME,IPBANK)
      IF (IPBANK.EQ.0) GOTO 100

      CALL KZGET1(CNAME,1,NDATA,RDATA)
      IF (NDATA.EQ.0) GOTO 1000

      apdslibver = rdata(1)
      If (apdslibver.ne.oldversion)
     &     Write(6,*) 'skrdmcver: apdetsim version is ',apdslibver
      oldversion = apdslibver

      CALL KZGET1(CNAME,2,NDATA,RDATA)
      IF (NDATA.EQ.0) GOTO 1000

      sklibver = rdata(1)
      If (sklibver.ne.oldskversion)
     &     Write(6,*) 'skrdmcver: skdetsim version is ',sklibver
      oldskversion=sklibver


      RETURN

 100  continue
      CNAME='APMCVER'
      CALL KZBLOC(CNAME,IPBANK)
      IF (IPBANK.EQ.0) GOTO 1000

      CALL KZGET1(CNAME,0,NDATA,RDATA)
      IF (NDATA.EQ.0) GOTO 1000

      apdslibver = rdata(1)
      If (apdslibver.ne.oldversion)
     &     Write(6,*) 'skrdmcver: apdetsim version is ',apdslibver
      oldversion = apdslibver

      RETURN

C     
C     ++ ERROR MESSAGE
C     
 1000 WRITE(6,*) 'skrdmcver: *** ERROR *** detsim version number not found'

      RETURN
      END
