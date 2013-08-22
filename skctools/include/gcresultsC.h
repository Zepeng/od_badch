/*
 * Generated automatically by fh2h.pl
 * !!! DO NOT EDIT !!!
 * Edit the original fortran header file instead
 * or fix fh2h.pl if there is a translation bug.
 */


#ifndef FH2H__HOME_TMW23_WORKING_SKDEV_ODLIB_GCRESULTS_H
#define FH2H__HOME_TMW23_WORKING_SKDEV_ODLIB_GCRESULTS_H


#ifdef __cplusplus
extern "C" {
#endif


#ifndef IMPLICIT
#define IMPLICIT  /* Only to point out implicit types */
#endif


/*------ fortran header (without commons and data statements) ----------*/

/************************************************************************/
/*     ------------------*/
/*     INCLUDE 'gcresults.h'*/
/*     ------------------*/
/*     common block containing output information from grad_cluster*/
/*     dependent on clust_params.h for N_CLUSTER_MAX, N_HIT_MAX*/
/*     run odpc_2nd_s_ to fill this common in OD mode*/
/**/
/*     PARAMETERS*/
/*     GC_IDMODE = 1                      : cluster ID hits*/
/*     GC_ODMODE = 2                      : cluster OD hits*/
/**/
/*     /GCRESULTS/ */
/*     num_od_clusters                    : number of clusters found.*/
/*                                          this is the nuber of array indexes with info in od_cluster_xyztqh array.*/
/*     nhits_in_odhitarray                : number of good hits used in clustering.*/
/*                                          this is the number of hits in the good_tubes and cluster_of_hit array.*/
/*                                          it is also the number of hits stored in the hit arrays in cluster_hit.h*/
/*     nhits_in_cluster(N_CLUSTER_MAX)    : number of hits in each cluster*/
/*     good_tube_index(N_HIT_MAX)         : hit index in the SKTQAZ common block (in sktq.h)*/
/*     cluster_of_hit(N_HIT_MAX)          : index of cluster in od_cluster_xyztqh array below*/
/*                                          that the hit belongs to.*/
/*                                          index of this array is in sync with good_tubes array*/
/*     od_cluster_xyztqh(N_CLUSTER_MAX,6) : For each cluster, position (1-3), time (4), total charge (5), */
/*                                          and charge of largest hit (6)*/
/*     status_last_nrunsk                 : for gradclusterC. last nrunsk pulled from skhead.*/
/*     status_last_nevsk                  : for gradclusterC. last nevsk pulled from skhead.*/
/*     status                             : error status. filled with either GC_OK=0 or GC_ERROR=1*/
/*   */
/*     Note that position information of each hit used is stored in arrays located in*/
/*     'cluster_hit.h'.  variable arrays are packed into common block CLUSTHIT.*/
/*     For backwards compatibility, this information is not pulled into this header.*/
/*     Inside cluster_hit.h is:*/
/*     /CLUSTERHIT/ */
/*     n_hit                              : number of utilized hits in array*/
/*     x_hit(n_hit_max)                   : x position of tube hit*/
/*     y_hit(n_hit_max)                   : y position of tube hit*/
/*     z_hit(n_hit_max)                   : z position of tube hit*/
/*     t_hit(n_hit_max)                   : time of tube hit*/
/*     q_hit(n_hit_max)                   : charge of tube hit*/
/**/
/**/
/*     (Creation Date and Author)*/
/*       2011.07.19: T. Wongjirad (tmw23@phy.duke.edu)*/
/**/
/*************************************************************************/
#ifndef __gcresults_h__
#define __gcresults__

#define GC_IDMODE (1)
#define GC_ODMODE (2)
#define GC_OK (0)
#define GC_ERR (1)
      
/*common gcresults was here*/
#endif


/*------ common blocks -------------------------------------------------*/

extern struct gcresults_common {
  int    num_clusters;
  int    nhits_in_hitarray;
  int    nhits_in_cluster[N_CLUSTER_MAX];
  int    good_tube_index[N_HIT_MAX];
  int    cluster_of_hit[N_HIT_MAX];
  float  cluster_xyztqh[6][N_CLUSTER_MAX];
  int    status_last_nrunsk;
  int    status_last_nevsk;
  int    status;
} gcresults_;
#ifndef NO_EXTERN_COMMON_POINTERS
extern struct gcresults_common *gcresults;
#endif
#ifdef STATIC_COMMON_POINTERS
static struct gcresults_common *gcresults = &gcresults_;
#endif


/*------ data statements -----------------------------------------------*/


#ifndef NO_STATIC_DATA


#endif  /* #ifndef NO_STATIC_DATA */


/*------ end of fortran header -----------------------------------------*/


#ifdef __cplusplus
}
#endif


#endif  /* #ifndef FH2H__HOME_TMW23_WORKING_SKDEV_ODLIB_GCRESULTS_H */
