#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>


//
//   qtcch   : QTC channel number
//   range   : SMALL/MEDIUM/LARGE  (0/1/2)
//   pC      : input charge (pC)
//   ihit[3] : hit(=1) or no-hit(=0) flag of each QTC channel 0,1,2
//
static double drift_mhit(int qtcch, int range, float pC, int ihit[] )
{
  double par[3][3][6] = {
    -1.028149,   0.016115,  -1.228558,   0.002001,  -1.365610,   0.000050,
    -0.520255,   0.035423,  -0.529847,   0.003546,  -0.857225,   0.000811,
    -1.454510,   0.023643,  -2.191053,   0.005727,  -1.979305,  -0.000065,
    -0.694556,   0.000163,  -1.062618,   0.000406,  -1.082860,  -0.000254,
    -0.693964,  -0.000140,  -0.975210,   0.000270,  -0.984536,  -0.000162,
    -1.432069,   0.021102,  -1.978519,   0.002743,  -1.892037,  -0.000464,
    -0.421748,   0.008884,  -0.437119,   0.000717,  -0.527408,  -0.000015,
    -0.623511,  -0.008981,  -0.801759,  -0.000870,  -1.006715,  -0.000294,
    -0.960961,   0.004634,  -1.204779,   0.000656,  -1.458762,  -0.000534
  };


  int i, j ;
  i=-1 ;
  switch ( qtcch ) {
  case 0 :
    if ( ihit[1]!=0 && ihit[2]==0 ) i=0 ;    // ch1-->ch0
    if ( ihit[1]==0 && ihit[2]!=0 ) i=1 ;    // ch2-->ch0
    if ( ihit[1]!=0 && ihit[2]!=0 ) i=2 ;    // ch1,ch2-->ch0
    break ;
  case 1 :
    if ( ihit[0]!=0 && ihit[2]==0 ) i=0 ;    // ch0-->ch1
    if ( ihit[0]==0 && ihit[2]!=0 ) i=1 ;    // ch2-->ch1
    if ( ihit[0]!=0 && ihit[2]!=0 ) i=2 ;    // ch0,ch2-->ch1
    break ;
  case 2 :
    if ( ihit[0]!=0 && ihit[1]==0 ) i=0 ;    // ch0-->ch2
    if ( ihit[0]==0 && ihit[1]!=0 ) i=1 ;    // ch1-->ch2
    if ( ihit[0]!=0 && ihit[1]!=0 ) i=2 ;    // ch0,ch1-->ch2
    break ;
  }

  j=-1 ;
  switch ( range ) {
  case 0 : // small
    j=0 ;
    break ;
  case 1 : // medium
    j=2 ;
    break ;
  case 2 : // large
    j=4 ;
    break ;
  }

  double drift ;
  if ( j==-1 || i==-1 ) {
    drift = 0 ;
  } else {
    drift = par[qtcch][i][j] + par[qtcch][i][j+1] * pC  ;
  }

  return(drift);

}

static float delay_fact (float tdiff) {
  // this is a part of function to correct measured charge 
  // due to multi-hit effect.
  // this function return corrections factor due to hit time difference.
  // tdiff = T(neighbor) - T(measure) and factor is defined as fact(tdiff=0)=1

  // from -1000 nsec to +500 nsec, 10 nsec per 1 bin
  float fact[151] = {
    -0.001, -0.001, -0.002, -0.002, -0.003, 
    -0.004, -0.005, -0.007, -0.009, -0.012,
    -0.015, -0.019, -0.023, -0.029, -0.036, 
    -0.045, -0.055, -0.067, -0.081, -0.098,
    -0.118, -0.140, -0.166, -0.196, -0.230, 
    -0.268, -0.310, -0.357, -0.409, -0.465,
    -0.526, -0.592, -0.662, -0.737, -0.814, 
    -0.895, -0.978, -1.063, -1.148, -1.232,
    -1.315, -1.395, -1.471, -1.542, -1.606, 
    -1.662, -1.710, -1.748, -1.775, -1.790,
    -1.793, -1.784, -1.762, -1.727, -1.680, 
    -1.620, -1.549, -1.467, -1.375, -1.274,
    -1.165, -1.049, -0.929, -0.804, -0.677, 
    -0.548, -0.419, -0.291, -0.165, -0.042,
    0.078,  0.192,  0.302,  0.405,  0.503,   
    0.594,  0.678,  0.755,  0.826,  0.889,
    0.946,  0.997,  1.041,  1.078,  1.110,   
    1.135,  1.155,  1.170,  1.180,  1.185,
    1.185,  1.182,  1.174,  1.162,  1.148,   
    1.129,  1.108,  1.085,  1.058,  1.030,
    1.000,  0.968,  0.935,  0.900,  0.865,   
    0.829,  0.792,  0.755,  0.718,  0.682,
    0.645,  0.609,  0.573,  0.538,  0.504,   
    0.471,  0.440,  0.409,  0.379,  0.351,
    0.324,  0.298,  0.274,  0.251,  0.229,   
    0.209,  0.190,  0.173,  0.156,  0.141,
    0.127,  0.114,  0.102,  0.091,  0.081,   
    0.072,  0.064,  0.057,  0.050,  0.044,
    0.039,  0.034,  0.030,  0.026,  0.023,   
    0.020,  0.017,  0.015,  0.013,  0.011,
    0.009
  };
  int i ;
  float f ;
  i = (int) (( (tdiff+1000.) + 5. )/10.) ;
  if ( i<0 || i>150 ) {
    f=0. ;
  } else {
    f=fact[i] ;
  }
  return ( f ) ;
}

//
//  calc drift due to QTC multi-ch hit effect
// 
void skqtcmhit_corr_(int *qtcch,    // main QTC channel (0,1,2)
		     int *irange,    // gain range (0:small, 1:medium, 2:large)
		     float *pC,        // input charge (pC)
		     int ihitqtc[],   // hit flag for each QTC ch.
		     float tdifqtc[], // hit time difference
		     float *qshift)    // drift count to be corrected
{
  int ihit[3], nextch ;
  double drift[3] ;
  for ( nextch=0 ; nextch<3 ; nextch++ ) {
    if ( nextch==*qtcch ) { 
      drift[nextch] = 0.0 ;
    } else {
      if ( ihitqtc[nextch]>0 ) {
	bzero(ihit, sizeof(ihit)) ;
	ihit[*qtcch] = 1 ;
	ihit[nextch] = 1 ;
	drift[nextch] = drift_mhit(*qtcch, *irange, *pC, ihit);
	drift[nextch] *= delay_fact(tdifqtc[nextch]);
      } else {
	drift[nextch] = 0.0 ;
      }
    }
  }
  *qshift = (float)(drift[0]+drift[1]+drift[2]);
  return ;
}
		    

