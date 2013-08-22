************************************************************************
*     ------------------------------------------
      SUBROUTINE SKQDIV(IQRAW, IQ, IRANGE)
*     ------------------------------------------
*
*     (Purpose)
*
*     (Input)
*
*       IQRAW : Q count w/ range
*
*     (Output)
*       
*       IQ    : Q count w/o range
*       IRANGE: range
*
*     (Creation Date and Author)
*       2007.06.25 ; First version by Y.Koshio
*       2007.07.03 ; modified by y.takeuchi
*         o iand() and ishft() are used.
************************************************************************
      IMPLICIT NONE

      integer iqraw, iq, irange

ccyt      IQ = MOD(IQRAW,2**11)
ccyt      IRANGE = IQRAW/2**14
      IQ      = iand(IQRAW, 2**11-1)
      IRANGE  = ishft(IQRAW, -14)

      return
      end
