/*
 * Generated automatically by fh2h.pl
 * !!! DO NOT EDIT !!!
 * Edit the original fortran header file instead
 * or fix fh2h.pl if there is a translation bug.
 */


#ifndef FH2H__USR_LOCAL_SKLIB_G77_ATMPD_11D_INC_CLUSTER_HIT_H
#define FH2H__USR_LOCAL_SKLIB_G77_ATMPD_11D_INC_CLUSTER_HIT_H


#ifdef __cplusplus
extern "C" {
#endif


#ifndef IMPLICIT
#define IMPLICIT  /* Only to point out implicit types */
#endif


/*------ fortran header (without commons and data statements) ----------*/

       

/*common clusthit was here*/



/*------ common blocks -------------------------------------------------*/

extern struct clusthit_common {
  int    n_hit;
  float  x_hit[N_HIT_MAX];
  float  y_hit[N_HIT_MAX];
  float  z_hit[N_HIT_MAX];
  float  t_hit[N_HIT_MAX];
  float  q_hit[N_HIT_MAX];
} clusthit_;
#ifndef NO_EXTERN_COMMON_POINTERS
extern struct clusthit_common *clusthit;
#endif
#ifdef STATIC_COMMON_POINTERS
static struct clusthit_common *clusthit = &clusthit_;
#endif


/*------ data statements -----------------------------------------------*/


#ifndef NO_STATIC_DATA


#endif  /* #ifndef NO_STATIC_DATA */


/*------ end of fortran header -----------------------------------------*/


#ifdef __cplusplus
}
#endif


#endif  /* #ifndef FH2H__USR_LOCAL_SKLIB_G77_ATMPD_11D_INC_CLUSTER_HIT_H */
