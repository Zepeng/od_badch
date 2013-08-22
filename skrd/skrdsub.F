************************************************************************
*     --------------------------------
      SUBROUTINE SKRDSUB(lun,NSUB,ierr)
*     --------------------------------
*
*     (Purpose)
*      READ SUB EVENT
*
*     (Input)
*       NSUB ; 0 : Parent evnet
*              N : Nth sub event
*
*     (Output)
*      
*     (Creation Date and Author)
*       1996.03.23 ; by T.Hayakawa
*
*     (Comment)
*     
************************************************************************
      implicit none
c arg
      integer lun
      integer nsub
      integer ierr
c local
      integer nall,ncur

c program
      
C
C --  CHECK CURRENT EVENT
C
      CALL KZMNUM(NALL,NCUR)

      if(nsub.lt.0)then
         ierr=-1
      else if(nsub.gt.nall-1)then
         ierr=-1
      else if(nsub.eq.0)then
         ierr=0
         call KZMFST         
         CALL SKREAD(-lun,*10,*10,*10,*10)
      else
         ierr=0
         CALL KZMJMP(NALL-NSUB+1-NCUR,IERR)
         CALL SKREAD(-lun,*10,*10,*10,*10)
      endif

 10   CONTINUE
      RETURN
      END
