************************************************************************
*----------------------------
	subroutine skhtrd(ierr)
*----------------------------
*
*	(Purpose)
*	  Read 'ISLOWD' bank and fill the common /SKHVST/,/SKHVVL/,/SKTTST/,
*	  /SKCOIL/
*
*	(Input)
*	  none
*
*	(Output)
*
*
*	(Creation Date and Author)
*	  1996.04.30 ; First version by H.Ishino
*
***********************************************************************

#include "skparm.h"
#include "skhvtt.h"


	integer*4 datasiz
	parameter(datasiz=96418)
      real rdata(datasiz)
	integer*4 idata(datasiz),ierr
	character*32 cname 
	equivalence(rdata(1),idata(1))


	ierr = 0
	cname = 'ISLOWD'
      call kzbloc(cname,iadd)
	if(iadd.le.0)then
	   ierr = -1
	   goto 999
	else
         call kzget0(cname,0,nd,rdata)
         call kzget0(cname,1,nd,rdata)
	   call hvtt(nd,rdata,idata)
      end if

 999	continue

	return
      END

*************************************************************************
	subroutine hvtt(nnd,rrdata,iidata)
*
*	fill the common
*
*************************************************************************
	implicit none
#include "skparm.h"
#include "skhvtt.h"

	integer*4 datasiz
	parameter(datasiz=96418)
      real*4 rrdata(datasiz)
	integer*4 i,iidata(datasiz),nnd
	integer*4 mask0_15,shift
	parameter(mask0_15=65535,shift=16)
	integer*4 hv_flag,ipmt,dummy
	integer*4 tt_flag,box,cchan
	integer*4 hvbeg,hvend,ttbeg,ttend,ccbeg,ccend
	parameter(hvbeg=24,hvend=89192,
     &          ttbeg=96018,ttend=96402,
     &          ccbeg=96403,ccend=96416)

******hv data read
	do 111 i=hvbeg,hvend
	  if(i.eq.hvbeg)then
c	    hv_flag=rshift(iidata(i),shift)
c	    dummy = and(iidata(i),mask0_15)
c for cern library
	    hv_flag=ishft(iidata(i),-shift)
          dummy = iand(iidata(i),mask0_15)
	  end if
	  if(mod(i,8).eq.1)then
c	    ipmt=rshift(iidata(i),shift)-1
c	    hvstat(ipmt)=and(iidata(i),mask0_15)
c for cern library
          ipmt=ishft(iidata(i),-shift)-1
          hvstat(ipmt)=iand(iidata(i),mask0_15)
	  end if
c	  if(mod(i,8).eq.2) prstat(ipmt)=rshift(iidata(i),shift)
	  if(mod(i,8).eq.2) prstat(ipmt)=ishft(iidata(i),-shift)
	  if(mod(i,8).eq.3) hvvalu(ipmt)=rrdata(i)
	  if(mod(i,8).eq.4) exvalu(ipmt)=rrdata(i)
	  if(mod(i,8).eq.5) prhv(ipmt)=rrdata(i)
	  if(mod(i,8).eq.6) prex(ipmt)=rrdata(i)
	  if(mod(i,8).eq.7) cuhv(ipmt)=rrdata(i)
	  if(mod(i,8).eq.0.and.i.ne.hvbeg) cuex(ipmt)=rrdata(i)
 111	continue
	hvtime = iidata(ttbeg-1)

******tt data
	do 112 i=ttbeg,ttend
c	  if(i.eq.ttbeg) tt_flag = rshift(iidata(i),shift)
	  if(i.eq.ttbeg) tt_flag = ishft(iidata(i),-shift)
	  if(mod(i,8).eq.3) box=iidata(i)
	  if(mod(i,8).eq.4) temper(box)=rrdata(i)
	  if(mod(i,8).eq.5) tkop5(box)=rrdata(i)
	  if(mod(i,8).eq.6) tkom5(box)=rrdata(i)
	  if(mod(i,8).eq.7) tkop8(box)=rrdata(i)
	  if(mod(i,8).eq.0) tkom8(box)=rrdata(i)
	  if(mod(i,8).eq.1) tkop15(box)=rrdata(i)
	  if(mod(i,8).eq.2.and.i.ne.ttbeg) tkom15(box)=rrdata(i)
 112	continue

	do 113 i=ccbeg,ccend
	  if(mod(i,2).eq.1)then
	    cchan = iidata(i)
	  else
	    coilc(cchan) = rrdata(i)
	  end if
 113	continue
	tttime = iidata(ccend+1)

	return
	end
