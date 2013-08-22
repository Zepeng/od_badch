#include <iostream>
#include <assert.h>
//#include "T2KOD.hh"
#include "openzbs.hh"
#include "TFile.h"
#include "TTree.h"

extern "C" {
  void kzinit_();
  void readt2kbank_(int&);
  void skoptn_(const char*, int);
  void gpssk_();
  void skcread_(int&, int&);
  void skclosef_(int&);
  void odpc_2nd_s_(int &, float*);
}

void ParseArgs( int narg, char** argv, std::map< std::string, std::string >& args ) {
  for (int i=1; i<narg; i++) {
    std::string arg = argv[i];
    if ( arg=="-i" ) { args["input"] = argv[++i]; }
    else if ( arg=="-o" ) { args["output"] = argv[++i]; }
    else {
      std::cout << "wrong args: " << arg << std::endl;
      assert(false);
    }
  }
}


int main(int argc, char** argv) {

  std::cout << "Test SKBADCH Build nhitac (normal skbadch)" << std::endl;

  std::map< std::string, std::string > args;
  ParseArgs( argc, argv, args );

  kzinit_();
  skoptn_("31,30,29,27,25,23,19,18,16", int(strlen("31,30,29,27,25,23,19,18,16")));

  int LUNI = 10;
  openreadzbs( args["input"], LUNI);

  TFile* output = new TFile(args["output"].c_str(), "RECREATE");
  TTree* test = new TTree( "testnhitac", "Save NHITAC in each event" );
  int nhitac = 0;
  float odpos[3];
  test->Branch("nhitac", &nhitac,"nhitac/I");
  test->Branch("odpos", odpos, "odpos[3]/F");
  
  std::cout << "Start Event Loop" << std::endl;
  int err = 0;
  int readevent = 0;
  while (err !=2 && err!=4 ) {
    skcread_(LUNI, err);    
    if( err==0) {
      
      odpc_2nd_s_( nhitac, odpos );
      readevent++;

      test->Fill();
    }
  }
  std::cout << "End of loop." << std::endl;

  skclosef_(LUNI);

  output->cd();
  output->Write();

  return 0;

}
