#ifndef __t2kodrdC_h__
#define __t2kodrdC_h__ 1

#ifdef __cplusplus
extern "C" {
#endif

  extern struct t2kodreduc_common {

    int status;            // Overall error status
    int t2kclass;          //T2KOD Class
    int nspl;              //Spill Number
    int nrunbm;            //Beam run number
    int nrunsk;            //SK run number
    int apnumscan;         //Number of APSCANs
    int odclassify_old;    //Result of legacy code: odclassify.F
    int odxdt;             //Result of ODXDT.

    int basecut;           //BASE=1 PASS
    int od1cut;            //OD1=5  PASS
    int od2legacycut;      //OD2=0  PASS
    int od2cut;            //OD2=0  PASS
    int od2vflatcut;       //OD2=0  PASS
    int odtcut;            //ODT=0  PASS

    int sk_quality;        //BASE Cut Variable
    int bsd_good_spill;    //BASE Cut Variable
    int sksum_entry_found; //BASE Cut Check
    int beamsum_entry_found;//BASE Cut Check
    double ct_beam_time;      // BEAM TIME FROM CT
    int nhitac;            //OD1 Cut Variable
    int odwinhits;         //OD1 Cut Variable
    int bunchnum;          //ODT Cut Variable
    int nhitaz;            //BASE Cut Variable
    float dt0raw;          //BASE Cut Variable
    float dt0;             //BASE Cut Variable
    float odrmean;         //OD1 Cut Variable
    float qismsk;          //OD1 Cut Variable
    float beamdotap;       //OD2 Cut Variable
    float od2u;            //OD2 Cut Variable
    float od2v;            //OD2 Cut Variable
    float bunchcenter;     //ODT Cut Variable
    float bunchtime;       //ODT Cut Variable
    double pot;            //NICE TO HAVE
    float odvertex[3];     //OD2 Variable
    float apdir[3];        //OD2 Variable
    
  } t2kodreduc_;


#ifdef __cplusplus
}
#endif

#endif
