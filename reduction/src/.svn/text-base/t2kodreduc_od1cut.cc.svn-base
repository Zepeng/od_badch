#include "T2KOD_ERRORS.hh"
#include "T2KOD.hh"
#include "t2kodreduc_cutfunctions.hh"
#include "t2kodreducC.hh"
#include "skparmC.h"
#include "sktqC.h"
#include "gradclusterC.h"
#include "gcresultsC.h"

extern "C" {
  void countodwinhits_(int&);
  void odrmean_(float&, int&);
}

int t2kodreduc_od1cut() {

  int t2kodclass = t2kodreduc_.t2kclass;
  if (t2kodclass>=3 && t2kodclass<=5)
    t2kodclass -= 2;
  else if (t2kodclass>5) {
    t2kodreduc_.status = T2KOD_ERR;
    return T2KOD_ERR;
  }

  // Get the variables we need
  gradclusterC( t2kodreduc_.nhitac );
  countodwinhits_(t2kodreduc_.odwinhits);
  int err = 0;
  odrmean_(t2kodreduc_.odrmean, err);
  t2kodreduc_.qismsk = skq_.qismsk;

  t2kodreduc_.od1cut = 0;

  // NHITAC
  if ( t2kodreduc_.nhitac > T2KOD::OD1_NHITAC_UPPER[t2kodclass] ) {
    t2kodreduc_.od1cut = 1;
    return T2KOD_OK;
  }

  // ODRMEAN
  if ( t2kodreduc_.odrmean > T2KOD::OD1_ODRMEAN[t2kodclass] ) {
    t2kodreduc_.od1cut = 2;
    return T2KOD_OK;
  }

  // ODWINHITS
  if ( t2kodreduc_.odwinhits > T2KOD::OD1_ODWINHITS[t2kodclass] ) {
    t2kodreduc_.od1cut = 3;
    return T2KOD_OK;
  }
  
  // QISMSK
  if ( t2kodreduc_.qismsk > T2KOD::OD1_QISMSK[t2kodclass] ) {
    t2kodreduc_.od1cut = 4;
    return T2KOD_OK;
  }
  
  // PASS
  t2kodreduc_.od1cut = 5;
  return T2KOD_OK;

}
