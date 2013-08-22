#include "skheadC.h"
#include "t2kodreducC.hh"
#include "t2kodreduc_cutfunctions.hh"
#include "TTree.h"

int t2kodreduc_definebranches(TTree* tree) {

  tree->Branch("t2kod_ndaysk", skhead_.ndaysk, "t2kod_ndaysk[3]/I");
  tree->Branch("t2kod_ntimsk", skhead_.ntimsk, "t2kod_ntimsk[4]/I");
  tree->Branch("t2kod_nevsk", &skhead_.nevsk, "t2kod_nevsk/I");
  tree->Branch("t2kod_nsubsk", &skhead_.nsubsk, "t2kod_nsubsk/I");
  tree->Branch("t2kod_status", &t2kodreduc_.status, "t2kod_status/I");
  tree->Branch("t2kclass", &t2kodreduc_.t2kclass, "t2kclass/I");
  tree->Branch("t2kod_nrunsk", &t2kodreduc_.nrunsk, "t2kod_nrunsk/I");
  tree->Branch("t2kod_nspl", &t2kodreduc_.nspl, "t2kod_nspl/I");
  tree->Branch("t2kod_nrunbm", &t2kodreduc_.nrunbm, "t2kod_nrunbm/I");
  tree->Branch("t2kod_apnumscan", &t2kodreduc_.apnumscan, "t2kod_apnumscan/I");
  tree->Branch("odclassify_old", &t2kodreduc_.odclassify_old, "odclassify_old/I");
  tree->Branch("odxdt", &t2kodreduc_.odxdt, "odxdt/I");

  tree->Branch("basecut", &t2kodreduc_.basecut, "basecut/I");
  tree->Branch("od1cut", &t2kodreduc_.od1cut, "od1cut/I");
  tree->Branch("od2legacycut", &t2kodreduc_.od2legacycut, "od2legacycut/I");
  tree->Branch("od2cut", &t2kodreduc_.od2cut, "od2cut/I");
  tree->Branch("od2vflatcut", &t2kodreduc_.od2vflatcut, "od2vflatcut/I");
  tree->Branch("odtcut", &t2kodreduc_.odtcut, "odtcut/I");

  tree->Branch("sk_quality", &t2kodreduc_.sk_quality, "sk_quality/I"); 
  tree->Branch("bsd_good_spill", &t2kodreduc_.bsd_good_spill, "bsd_good_spill/I");
  tree->Branch("ct_beam_time", &t2kodreduc_.ct_beam_time, "ct_beam_time/D");
  tree->Branch("sksum_entry_found", &t2kodreduc_.sksum_entry_found, "sksum_entry_found/I");
  tree->Branch("beamsum_entry_found", &t2kodreduc_.beamsum_entry_found, "beamsum_entry_found/I");
  tree->Branch("t2kod_nhitac", &t2kodreduc_.nhitac, "t2kod_nhitac/I");
  tree->Branch("t2kod_nhitaz", &t2kodreduc_.nhitaz, "t2kod_nhitaz/I");
  tree->Branch("t2kod_odwinhits", &t2kodreduc_.odwinhits, "t2kod_odwinhits/I");
  tree->Branch("t2kod_bunchnum", &t2kodreduc_.bunchnum, "t2kod_bunchnum/I");
  tree->Branch("t2kod_dt0raw", &t2kodreduc_.dt0raw, "t2kod_dt0raw/F");
  tree->Branch("t2kod_dt0", &t2kodreduc_.dt0, "t2kod_dt0/F");
  tree->Branch("t2kod_odrmean", &t2kodreduc_.odrmean, "t2kod_odrmean/F");
  tree->Branch("t2kod_qismsk", &t2kodreduc_.qismsk, "t2kod_qismsk/F");
  tree->Branch("t2kod_beamdotap", &t2kodreduc_.beamdotap, "t2kod_beamdotap/F");
  tree->Branch("t2kod_od2u", &t2kodreduc_.od2u, "t2kod_od2u/F");
  tree->Branch("t2kod_od2v", &t2kodreduc_.od2v, "t2kod_od2v/F");
  tree->Branch("t2kod_bunchcenter", &t2kodreduc_.bunchcenter, "t2kod_bunchcenter/F");
  tree->Branch("t2kod_bunchtime", &t2kodreduc_.bunchtime, "t2kod_bunchtime/F");
  tree->Branch("t2kod_pot", &t2kodreduc_.pot, "t2kod_pot/D");
  tree->Branch("t2kod_odvertex", t2kodreduc_.odvertex, "t2kod_odvertex[3]/F");
  tree->Branch("t2kod_apdir", t2kodreduc_.apdir, "t2kod_apdir[3]/F");

}
