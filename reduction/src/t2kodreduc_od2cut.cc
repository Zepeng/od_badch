#include "T2KOD_ERRORS.hh"
#include "T2KOD.hh"
#include <cmath>
#include "skparmC.h"
#include "t2kodreduc_cutfunctions.hh"
#include "t2kodreducC.hh"
#include "sktqC.h"
#include "apmringC.h"
#include "clust_paramsC.h"
#include "cluster_hitC.h"
#include "gradclusterC.h"
#include "gcresultsC.h"


extern "C" {
  void torderedodclusters_(int*,float*,float x[][N_CLUSTER_MAX], int&);
  void od2cuts_(int&);
}

int t2kodreduc_od2cut() {

  // gather the variables needed
  t2kodreduc_.od2cut = -1;
  
  int t2kodclass = t2kodreduc_.t2kclass;

  if (t2kodclass!=T2KOD::ODEX and t2kodclass!=T2KOD::ODEN) {
    t2kodreduc_.od2cut = 0; // PASS
    return T2KOD_OK;
  }
    
  t2kodreduc_.qismsk = skq_.qismsk;
  if (apcommul_.apnring==0) {
    t2kodreduc_.od2cut = 0; // NO RING
    t2kodreduc_.od2legacycut = 0;
    t2kodreduc_.od2vflatcut = 0;
    t2kodreduc_.od2u = 0;
    t2kodreduc_.od2v = 0;
    t2kodreduc_.beamdotap = 0;
    for (int v=0; v<3; v++)
      t2kodreduc_.apdir[v] = 0.0;
    return T2KOD_OK;
  }

  // legacy
  od2cuts_(t2kodreduc_.od2legacycut);

  // get first cluster position
  int firstclusters[2];
  float torderedTime[2];
  int local_nhitac = 0;
  gradclusterC(local_nhitac, GC_ODMODE, false);
  torderedodclusters_(firstclusters, torderedTime, gcresults_.cluster_xyztqh, gcresults_.num_clusters);
  for (int v=0; v<3; v++)
    t2kodreduc_.odvertex[v] = gcresults_.cluster_xyztqh[v][0];
  
  // get first ring
  double firstdir[3];
  for (int v=0; v<3; v++) {
    t2kodreduc_.apdir[v] = apcommul_.apdir[0][v];
    firstdir[v] = apcommul_.apdir[0][v];
  }

  t2kodreduc_.beamdotap = 0;
  float apnorm = 0;
  float beamnorm = 0;
  float t2kbeamdir[2];
  T2KOD::getT2Kbeamdir( t2kbeamdir );
  for (int v=0; v<3; v++) {
    apnorm += t2kodreduc_.apdir[v]*t2kodreduc_.apdir[v];
    beamnorm += t2kbeamdir[v]*t2kbeamdir[v];
    t2kodreduc_.beamdotap += t2kodreduc_.apdir[v]*t2kbeamdir[v];
  }
  t2kodreduc_.beamdotap = t2kodreduc_.beamdotap/sqrt(apnorm*beamnorm);

  float bdapx = (1-t2kodreduc_.beamdotap);
  float zdir = 1;

  if (t2kodreduc_.apdir[2]<0)
    zdir = -1.0;

  double u = T2KOD::fODU( double( t2kodreduc_.qismsk), double( t2kodreduc_.beamdotap), firstdir );
  double v = T2KOD::fODV( double( t2kodreduc_.qismsk), double( t2kodreduc_.beamdotap), firstdir );
  t2kodreduc_.od2u = float(u);
  t2kodreduc_.od2v = float(v);

  if (t2kodreduc_.od2v>=-100) {
    t2kodreduc_.od2vflatcut = 0; //pass this cut
  }
  else
    t2kodreduc_.od2vflatcut = -1;

//   if ( (u < -5 && v < (u+9)*(-150.0/4.0)-50) || (u>=-5 && v < (u+5)*(150.0/3.0) - 200) ) {
//     // fail this cut
//     t2kodreduc_.od2cut = -1;
//     return T2KOD_OK;
//   }

  if ( T2KOD::doesPassOD2UV( t2kodreduc_.t2kclass, u, v ) == true )
    t2kodreduc_.od2cut = 0;
  else
    t2kodreduc_.od2cut = -1;

  std::cout << "  OD2 U: " << u << ", OD2 V: " << v << ", odclass: " << t2kodreduc_.t2kclass << ", cutline v: " << T2KOD::cutlineOD2(t2kodreduc_.t2kclass, u ) 
	    << " = " << T2KOD::doesPassOD2UV( t2kodreduc_.t2kclass, u, v ) << std::endl;

  
  return T2KOD_OK;

}
