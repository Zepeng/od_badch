#include <iostream>
#include <assert.h>
#include <cmath>
#include <cstring>

#include "skheadC.h"
#include "vcworkC.h"
#include "vcvrtxC.h"
#include "skparmC.h"
#include "skvetoC.h"
#include "sktqC.h"
#include "skbadcC.h"
#include "geopmaC.h"
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
  void grad_cluster_(int*,float*,int*,int*, float od[][1],int*, int*, int*);
  void kzget1_(char *, int *, int *, void*, int);
  void kznseg_(char *, int *);
  void vcrdvccm_();
  void nerdnebk_(float*); 
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

int VertexSelection(float *vertex)
{
  if(std::abs(vertex[2]) > 2070 || (vertex[0]*vertex[0] + vertex[1]*vertex[1]) > 1965*1965)
  {return 2;}
  else if(std::abs(vertex[2]) < 1810 &&  (vertex[0]*vertex[0] + vertex[1]*vertex[1]) <  1690*1690)
  {return 0;}
  else 
  {return 1;}
}

int main(int argc, char** argv) {

  std::cout << "Test SKBADCH Build nhitac (normal skbadch)" << std::endl;

  std::map< std::string, std::string > args;
  ParseArgs( argc, argv, args );

  kzinit_();
  skoptn_("31,30,29,27,26,25,23,19,18,16", int(strlen("31,30,29,27,26,25,23,19,18,16")));
  int LUNI = 10;
  std::string directory = "/disk/usr2/tmw23/t2kvectors/2011a/flnumu_xsnumu/producrun-2011a_rockcomp-O-flnumu-xsnumu/apfit/0000/apfit.";

  TFile* output = new TFile(args["output"].c_str(), "RECREATE");
  TTree* nhitactree = new TTree("testnhitac", "Test NHITAC");
  TTree* badchtree = new TTree("badch","New Badch");
  TTree* vertextree = new TTree("vertex","Vertex");

  int nhitac = 0;
  int volume = -1;
  float odpos[3],badch[3],vertex[3];

  nhitactree->Branch("nhitac", &nhitac,"nhitac/I");
  nhitactree->Branch("odpos", odpos, "odpos[3]/F");
  nhitactree->Branch("volume", &volume,"volume/I");
  badchtree->Branch("badch",badch,"badch[3]/F");
  vertextree->Branch("vertex",vertex,"vertex[3]/F");

  bool storebadch = false;
  
  for(int files = 0; files < 100; files++)
  {
    char buffer[3];
    sprintf(buffer, "%d", files);
    std::string filename = directory + buffer + ".0.zbs";

    openreadzbs( filename, LUNI);
    std::cout << "Start Event Loop" << std::endl;
    int err = 0;
    int readevent = 0;
    while (err !=2 && err!=4 ) 
    {
      skcread_(LUNI, err);    
      if( err==0) 
      {
        if(!storebadch)
        {
          int numbadch = combada_.nbada;
          for(int count = 0; count < MAXPMA; count++)
          {
            if(combada_.ibada[count]!=0) 
            {
              for(int j = 0; j < 3; j++)
              { badch[j] = geopmta_.xyzpma[count][j];}
              badchtree->Fill();
            }
          }
          storebadch = true;
        }
        nerdnebk_(vertex);
        vertextree->Fill();
        volume = VertexSelection(vertex) ;
        odpc_2nd_s_( nhitac , odpos);
        readevent++;

        nhitactree->Fill();
      }
    }
    std::cout << "End of loop." << files << std::endl;

    skclosef_(LUNI);
  }
  output->cd();
  output->Write();

  return 0;

}
