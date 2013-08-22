#include "T2KOD_ERRORS.hh"
#include "T2KOD.hh"
#include "t2kodreduc_cutfunctions.hh"
#include "t2kodreducC.hh"
#include "t2kodtimingC.hh"

int t2kodreduc_odTcut() {

  // od class
  int t2kodclass = t2kodreduc_.t2kclass;

  if (t2kodclass<0 || t2kodclass>2)
    return T2KOD_ERR;

  // Corrected dt0
  double dt0 = t2kodtiming_.t0_corrected[ t2kodclass ];

  // Find the bunch: data
  int bunchwindow = -1;
  if (t2kodreduc_.nrunsk!=T2KOD::MC_RUN) {
    // Data
    
    for (int bunch=0; bunch<T2KOD::ODT_NUM_BUNCHES( t2kodreduc_.nrunbm ); bunch++) {
      double lowedge = T2KOD::ODT_FIRST_BUNCH_DT0( t2kodreduc_.nrunbm ) + (double(bunch)-0.5)*T2KOD::ODT_BUNCH_INTERVAL;
      double highedge = T2KOD::ODT_FIRST_BUNCH_DT0( t2kodreduc_.nrunbm ) + (double(bunch)+0.5)*T2KOD::ODT_BUNCH_INTERVAL;
      if ( lowedge <= dt0 && dt0 <= highedge ) {
	bunchwindow = bunch;
	break;
      }
    }
  }
  else {
    // MC
    bunchwindow = 0;
    dt0 += T2KOD::ODT_FIRST_BUNCH_DT0( 0 );
  }

  if ( bunchwindow < 0 ) {
    // NOT IN SPILL STRUCTURE
    t2kodreduc_.bunchnum = -1;
    t2kodreduc_.bunchcenter = -1000;
    t2kodreduc_.bunchtime = -1000;
    t2kodreduc_.odtcut = -1; // FAIL
  }
  else {
    t2kodreduc_.bunchnum = bunchwindow;
    t2kodreduc_.bunchcenter = T2KOD::ODT_FIRST_BUNCH_DT0( t2kodreduc_.nrunbm ) + t2kodreduc_.bunchnum*T2KOD::ODT_BUNCH_INTERVAL;
    t2kodreduc_.bunchtime = dt0 - t2kodreduc_.bunchcenter;
    if ( T2KOD::ODT_WINDOWS_NSEC[t2kodclass][0] <= t2kodreduc_.bunchtime && t2kodreduc_.bunchtime <= T2KOD::ODT_WINDOWS_NSEC[t2kodclass][1] ) {
      t2kodreduc_.odtcut = 0; //PASS
    }
    else {
      t2kodreduc_.odtcut = -1; //FAIL
    }  
  }

  return T2KOD_OK;

}
