#include <iostream>
#include "T2KOD.hh"
#include "openzbs.hh"
#include "t2kheadC.hh"
#include "skheadC.h"
#include "T2KRunInfo.hh"
#include "skgpsC.h"
#include "TFile.h"
#include "TTree.h"

extern "C" {
  void kzinit_();
  void readt2kbank_(int&);
  void skoptn_(const char*, int);
  void gpssk_();
  void skcread_(int&, int&);
  void skclosef_(int&);
}

int main(int argc, char** argv) {

  std::cout << "Validdate Routines in t2kodreduc" << std::endl;
  std::cout << "  -- T2KRunInfo" << std::endl;
  kzinit_();
  skoptn_("31,30,29,27,25,23,19,18,16", int(strlen("31,30,29,27,25,23,19,18,16")));

  int LUNI = 10;
  //openreadzbs("./test/t2k_run066930.od.class.zbs", LUNI);
  openreadzbs("./../core/test/t2k_run066930.od.class.zbs", LUNI);

  //TFile* output = new TFile("output_testreduc.root", "RECREATE");
  //TTree* tree = new TTree("odtree", "Outer Detector Tree");

  int err = 0;
  int readevent = 0;
  int t2kerr = 0;

  std::cout << "Initialize T2K OD Reduction" << std::endl;
  //t2kodreduc_init(tree);

  T2KRunInfo* runinfo = new T2KRunInfo();
  runinfo->SetVerbose(1);

  while (err !=2 && err!=4 ) {
    skcread_(LUNI, err);

    gpssk_();
    if (readevent==0)
      runinfo->LoadInfofiles(skhead_.nrunsk);
    
    if( err==0) {
      
      // READ T2K BANK
      readt2kbank_(t2kerr);
      std::cout << "--- read event " << readevent << " ----" << std::endl;
      std::cout << "  readt2kbank returns err: " << err << std::endl;
      std::cout << "    itype: " << t2khead_.itype << std::endl;
      std::cout << "    nhitac: " << t2khead_.nhitac << std::endl;
      std::cout << "    iselt0: " << t2khead_.iseldt0 << std::endl;
      std::cout << "    dt0: " << t2khead_.dt0 << std::endl;
      std::cout << "    nspl: " << t2khead_.nspl << std::endl;
      std::cout << "    nrunbm (in bank): " << t2khead_.nrunbm << std::endl;
      std::cout << "    t2kgps1: " << t2kgps_.t2kgps1[0] << "." << t2kgps_.t2kgps1[1] << std::endl;
      std::cout << "    t2kgps2: " << t2kgps_.t2kgps2[0] << "." << t2kgps_.t2kgps2[1] << std::endl;
      t2khead_.nrunbm = T2KOD::NRUNBM(skhead_.nrunsk);
      std::cout << "    nrunbm (look up table): " << t2khead_.nrunbm << std::endl;

      // IMPORT SK AND BSD FLAGS, POT
      int found = runinfo->SetEntry( skhead_.nrunsk, t2kgps_.nspl, t2kgps_.t2kgps1[0] );
      int sk_quality, bsd_good_spill;
      double pot;
      int goodeventflag = runinfo->GetGoodT2KbeamEventFlags(sk_quality, bsd_good_spill, pot);

      if (found>=0 || t2kgps_.nspl == 1648034)
      std::cin.get();

      // BASECUTS
      

      // OD1 CUTS

      // OD2 CUTS

      // ODT CUTS

      readevent++;
    }
  }
  std::cout << "readt2kbank.F" << std::endl;

  skclosef_(LUNI);

  return 0;

}
