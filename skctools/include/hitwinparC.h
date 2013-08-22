/*
 * Generated automatically by fh2h.pl
 * !!! DO NOT EDIT !!!
 * Edit the original fortran header file instead
 * or fix fh2h.pl if there is a translation bug.
 */


#ifndef FH2H__USR_LOCAL_SKLIB_G77_ATMPD_11D_INC_HITWINPAR_H
#define FH2H__USR_LOCAL_SKLIB_G77_ATMPD_11D_INC_HITWINPAR_H


#ifdef __cplusplus
extern "C" {
#endif


#ifndef IMPLICIT
#define IMPLICIT  /* Only to point out implicit types */
#endif


/*------ fortran header (without commons and data statements) ----------*/


/* Minimum in bin to start windowing*/
/* Default window*/

/*common hitwinpar was here*/


       


/*------ common blocks -------------------------------------------------*/

extern struct hitwinpar_common {
  int    min_in_bin;
  float  hitwin_start;
  float  hitwin_end;
} hitwinpar_;
#ifndef NO_EXTERN_COMMON_POINTERS
extern struct hitwinpar_common *hitwinpar;
#endif
#ifdef STATIC_COMMON_POINTERS
static struct hitwinpar_common *hitwinpar = &hitwinpar_;
#endif


/*------ data statements -----------------------------------------------*/


#ifndef NO_STATIC_DATA


#endif  /* #ifndef NO_STATIC_DATA */


/*------ end of fortran header -----------------------------------------*/


#ifdef __cplusplus
}
#endif


#endif  /* #ifndef FH2H__USR_LOCAL_SKLIB_G77_ATMPD_11D_INC_HITWINPAR_H */
