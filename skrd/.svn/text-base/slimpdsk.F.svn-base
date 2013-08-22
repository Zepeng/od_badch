************************************************************************
*     -------------------------------------
      SUBROUTINE SLIMPDSK()
*     -------------------------------------
*
*     (Purpose)
*        pick up only pedestal information which changed from current table
*        and make small 'SPDST' bank.
*
*     (Input)
*        none
*
*     (Output)
*       
*     (Creation Date and Author)
*       1996.08.10 ; by K.Inoue
*
************************************************************************
#include "skparm.h"
#include "skhead.h"
#include "sktq.h"
#include "skpdst.h"
      parameter (mdata0=10,mdata1=20,mdata2=50,mdata3=60010)
c     DIMENSION IDATA0(6),IDATA1(17),IDATA2(49),IDATA3(60010)
      DIMENSION IDATA0(mdata0),IDATA1(mdata1)
      DIMENSION IDATA2(mdata2),IDATA3(mdata3)
      dimension ipedt(12000,2),ipedq(12000,2)
      data nrunold/0/
      save nrunold
c  backup 0,1,2 segments of 'PDST' bank
      call kzbloc('PDST',iloc)
      if(iloc.le.0)return
      call kzget0('PDST',0,ndata0,idata0)
      if(ndata0.gt.mdata0)
     &  write(6,*)'array size insufficient idata0 @slimped',ndata0,mdata0
      call kzget0('PDST',1,ndata1,idata1)
      if(ndata1.gt.mdata1)
     &  write(6,*)'array size insufficient idata1 @slimped',ndata1,mdata1
      call kzget0('PDST',2,ndata2,idata2)
      if(ndata2.gt.mdata2)
     &  write(6,*)'array size insufficient idata2 @slimped',ndata2,mdata2

      if(nrunpd.ne.nrunold)then
        nrunold=nrunpd
        do 10 i=1,12000
          ipedt(i,1)=0
          ipedt(i,2)=0
          ipedq(i,1)=0
          ipedq(i,2)=0
   10   continue
      endif
      ipoi=1
      do 100 i=1,maxpm
        if(ipdstt(i,1).ne.ipedt(i,1) .or. ipdstt(i,2).ne.ipedt(i,2)
     &                               .or.
     &     ipdstq(i,1).ne.ipedq(i,1) .or. ipdstq(i,2).ne.ipedq(i,2))then
          if(ipdstt(i,1)+ipdstt(i,2)+ipdstq(i,1)+ipdstq(i,2).ne.0)then
            ipedt(i,1)=ipdstt(i,1)
            ipedt(i,2)=ipdstt(i,2)
            ipedq(i,1)=ipdstq(i,1)
            ipedq(i,2)=ipdstq(i,2)
            idata3(ipoi)=i
            idata3(ipoi+1)=ipedt(i,1)*65536+ipedq(i,1)
            idata3(ipoi+2)=ipedt(i,2)*65536+ipedq(i,2)
            ipoi=ipoi+3
          endif
        endif
  100 continue
      ndata3=ipoi-1
      if(ndata3.gt.mdata3)
     &  write(6,*)'array size insufficient idata3 @slimped',ndata3,mdata3

      call kzbdel('PDST')
      call kzbcr0('SPDST',ierr)
      if(ierr.ne.0)return
      call kzrep0('SPDST',0,'I',ndata0,idata0)
      call kzrep0('SPDST',1,'I',ndata1,idata1)
      call kzrep0('SPDST',2,'I',ndata2,idata2)
      call kzrep0('SPDST',3,'I',ndata3,idata3)
      write(6,*)'ndata3=',ndata3

      return
      end
