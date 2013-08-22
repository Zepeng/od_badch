#include <iostream>
#include "t2kodreduc_cutfunctions.hh"
#include "t2kodreducC.hh"
#include "t2kodtimingC.hh"

void t2kodreduc_printevent() {

  std::cout << "=== T2KODREDUC_: Common block ===" << std::endl;

  std::cout << "  status: " << t2kodreduc_.status << std::endl;
  std::cout << "  T2K OD Class (t2kclass): " << t2kodreduc_.t2kclass << std::endl;
  std::cout << "    old classification result (odclassify_old): " << t2kodreduc_.odclassify_old << std::endl;
  std::cout << "    odxdecision tree result (odxdt)           : " << t2kodreduc_.odxdt << std::endl;
  std::cout << "  Spill number (nspl)                         : " << t2kodreduc_.nspl << std::endl;
  std::cout << "  SK IDTGSK                                   : " << t2kodtiming_.idtgsk << std::endl;
  std::cout << "  SK run number (nrunsk)                      : " << t2kodreduc_.nrunsk << std::endl;
  std::cout << "  Baseline cut result (basecut, 1=PASS)    : " << t2kodreduc_.basecut << std::endl;
  std::cout << "  OD1 cut result (od1cut, 5=PASS)          : " << t2kodreduc_.od1cut << std::endl;
  std::cout << "  OD2 cut result (od2cut, 0=PASS)          : " << t2kodreduc_.od2cut << std::endl;
  std::cout << "    old code (od2legacycut, 0=PASS): " << t2kodreduc_.od2legacycut << std::endl;
  std::cout << "    using a flat V-cut (od2vcut, 0=PASS): " << t2kodreduc_.od2vflatcut << std::endl;
  std::cout << "  ODT cut result (odtcut, 0=PASS)          : " << t2kodreduc_.odtcut << std::endl;
  std::cout << "  SK Quality Flag (sk_quality, 1=OK)       : " << t2kodreduc_.sk_quality << std::endl;
  std::cout << "  Good Spill Flag (bsd_good_spill, 1=OK)   : " << t2kodreduc_.bsd_good_spill << std::endl;
  std::cout << "  NHITAC (nhitac)                          : " << t2kodreduc_.nhitac << std::endl;
  std::cout << "  ODWINHITS (odwinhit)                     : " << t2kodreduc_.odwinhits << std::endl;
  std::cout << "  T2K Beam Bunch # (bunchnum,-1=no bunch)  : " << t2kodreduc_.bunchnum << std::endl;
  std::cout << "  T2K dT0, before corrections (dt0raw)     : " << t2kodreduc_.dt0raw << std::endl;
  std::cout << "  T2K dT0, after corrections (dt0)         : " << t2kodreduc_.dt0 << std::endl;
  std::cout << "  ODRMEAN (odrmean)                        : " << t2kodreduc_.odrmean << std::endl;
  std::cout << "  QISMSK (qismsk)                          : " << t2kodreduc_.qismsk << std::endl;
  std::cout << "  Cos(theta) of beam (beamdotap)           : " << t2kodreduc_.beamdotap << std::endl;
  std::cout << "  OD2 U coorindate                         : " << t2kodreduc_.od2u << std::endl;
  std::cout << "  OD2 V coorindate                         : " << t2kodreduc_.od2v << std::endl;
  std::cout << "  Bunch Center (bunchcenter, 0=no bunch)   : " << t2kodreduc_.bunchcenter << std::endl;
  std::cout << "  Event Bunch Pos. (bunchtime, 0=no bunch) : " << t2kodreduc_.bunchtime << std::endl;
  std::cout << "  Protons on Target (pot)                  : " << t2kodreduc_.pot << std::endl;
  std::cout << "  Earliest OD Cluster Position (odvertx)   : (" 
	    << t2kodreduc_.odvertex[0] << ", " << t2kodreduc_.odvertex[1] << ", " << t2kodreduc_.odvertex[2] << ")" << std::endl;
  std::cout << "  APFIT direction (apdir)                  : ("
	    << t2kodreduc_.apdir[0] << ", " << t2kodreduc_.apdir[1] << ", " << t2kodreduc_.apdir[2] << ")" << std::endl;
}
