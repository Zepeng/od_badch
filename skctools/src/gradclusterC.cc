#include <iostream>
#include "skheadC.h"
#include "clust_paramsC.h"
#include "gradclusterC.h"
#include "hitwinparC.h"

extern "C" {
  void grad_cluster_(int*,float*,int*,int*, float od[][N_CLUSTER_MAX],int*, int*, int*);
}

int gradclusterC(int nhitac, int gcmode , bool forcerun ){

  if (forcerun==false && gcresults_.status_last_nrunsk==skhead_.nrunsk && gcresults_.status_last_nevsk==skhead_.nevsk) {
    // already run on this event, skip.  For optimization sake.  Probably not a high cost routine.
    nhitac = gcresults_.nhits_in_cluster[0];
    return GC_OK;
  }
  
  // THE C Version of odpc_2nd_s_.  Also has common blocks used to get at gradcluster hit data.
  gcresults_.num_clusters = 0;
  gcresults_.nhits_in_hitarray = 0;
  for (int c=0; c<N_CLUSTER_MAX; c++) {
    for (int x=0; x<6; x++)
      gcresults_.cluster_xyztqh[x][c] = 0.0;
    gcresults_.nhits_in_cluster[c] = 0;
  }

  for (int h=0; h<N_HIT_MAX; h++) {
    gcresults_.good_tube_index[h] = -1;
    gcresults_.cluster_of_hit[h] = -1;
  }

  // set hitwin parameters
  hitwinpar_.min_in_bin = 6;
  hitwinpar_.hitwin_start = -16000.;
  hitwinpar_.hitwin_end = 16000.;

  float pars[4];
  pars[0] = 0.;    // q_overflow, not needed for OD-only clustering                                                                                                             
  pars[1] = -1;    // Don't use hitwin; take default value                                                                                                                      
  pars[2] = 0.;    // q_pmt_anti_cut                                                                                                                                            
  pars[3] = 0.;    // t_pmt_cut_min_defaul

  grad_cluster_(&gcmode, pars, gcresults_.good_tube_index,
		&gcresults_.num_clusters, gcresults_.cluster_xyztqh, gcresults_.nhits_in_cluster,
		&gcresults_.nhits_in_hitarray, gcresults_.cluster_of_hit);

  gcresults_.status_last_nrunsk = skhead_.nrunsk;
  gcresults_.status_last_nevsk = skhead_.nevsk;
  gcresults_.status = GC_OK;

  nhitac = gcresults_.nhits_in_cluster[0];

  float  temp = gcresults_.cluster_xyztqh[0][0];
  return 0;
}
