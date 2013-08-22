#include "T2KOD_ERRORS.hh"
#include "T2KOD.hh"
#include "t2kodreduc_cutfunctions.hh"
#include "t2kodreducC.hh"


int t2kodreduc_baselinecut() {

  if (t2kodreduc_.sk_quality==1 && t2kodreduc_.bsd_good_spill==1 
      && T2KOD::BASE_WINDOW_NSEC[0] <= t2kodreduc_.dt0raw && t2kodreduc_.dt0raw <= T2KOD::BASE_WINDOW_NSEC[1] ) 
    t2kodreduc_.basecut = 1;
  else {
    t2kodreduc_.basecut = -1;
  }

  return T2KOD_OK;

}
