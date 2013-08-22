//////////////////////////////////////////////////////////
// This class has been automatically generated on
// Wed May 12 17:27:32 2010 by ROOT version 5.26/00b
// from TTree sksum/SK summary
// found on file: /home/sklb/reduction/list/skbeamsummary/sk_summary.run30.root
//////////////////////////////////////////////////////////

#ifndef SKsumClass_h
#define SKsumClass_h

#include <TROOT.h>
#include <TChain.h>
#include <TFile.h>

class SKsumClass {
public :
   TTree          *fChain;   //!pointer to the analyzed TTree or TChain
   Int_t           fCurrent; //!current Tree number in a TChain

   // Declaration of leaf types
   Int_t           nrunsk;
   Int_t           nsubsk;
   Int_t           nevsk;
   Int_t           ndaysk[3];
   Int_t           ntimsk[3];
   Int_t           idtgsk;
   Int_t           ifevsk;
   Int_t           nevhwsk;
   Int_t           numhwsk;
   Int_t           ihwt0;
   Int_t           it0sk;
   Int_t           npeak;
   Int_t           npeakpre;
   Int_t           npeakon;
   Int_t           swt0pre;
   Int_t           swt0peak;
   Int_t           ihwped;
   Int_t           nqiskz;
   Int_t           nhitaz;
   Int_t           diff_ltc1;
   Int_t           diff_ltc2;
   Int_t           gps1_sec;
   Int_t           gps1_nsec;
   Int_t           gps2_sec;
   Int_t           gps2_nsec;
   Int_t           gpsstat;
   Int_t           iflag_gps;
   Int_t           iflag_evstatus;
   Int_t           iflag_tq;
   Int_t           iflag_preact;
   Int_t           iflag_tdcreset;
   Int_t           iflag_pedestal;
   Int_t           nrunbm;
   Int_t           nspl;
   Int_t           t2kltccorr;
   Int_t           t2kgps1_sec;
   Int_t           t2kgps1_nsec;
   Int_t           t2kgps2_sec;
   Int_t           t2kgps2_nsec;
   Int_t           t2kgpsstat;
   UInt_t          etime;
   Int_t           iflag_atmpd;
   Int_t           iflag_t2ksk;
   Int_t           sk_quality_flag;

   // List of branches
   TBranch        *b_nrunsk;   //!
   TBranch        *b_nsubsk;   //!
   TBranch        *b_nevsk;   //!
   TBranch        *b_ndaysk;   //!
   TBranch        *b_ntimsk;   //!
   TBranch        *b_idtgsk;   //!
   TBranch        *b_ifevsk;   //!
   TBranch        *b_nevhwsk;   //!
   TBranch        *b_numhwsk;   //!
   TBranch        *b_ihwt0;   //!
   TBranch        *b_it0sk;   //!
   TBranch        *b_npeak;   //!
   TBranch        *b_npeakpre;   //!
   TBranch        *b_npeakon;   //!
   TBranch        *b_swt0pre;   //!
   TBranch        *b_swt0peak;   //!
   TBranch        *b_ihwped;   //!
   TBranch        *b_nqiskz;   //!
   TBranch        *b_nhitaz;   //!
   TBranch        *b_diff_ltc1;   //!
   TBranch        *b_diff_ltc2;   //!
   TBranch        *b_gps1_sec;   //!
   TBranch        *b_gps1_nsec;   //!
   TBranch        *b_gps2_sec;   //!
   TBranch        *b_gps2_nsec;   //!
   TBranch        *b_gpsstat;   //!
   TBranch        *b_iflag_gps;   //!
   TBranch        *b_iflag_evstatus;   //!
   TBranch        *b_iflag_tq;   //!
   TBranch        *b_iflag_preact;   //!
   TBranch        *b_iflag_tdcreset;   //!
   TBranch        *b_iflag_pedestal;   //!
   TBranch        *b_nrunbm;   //!
   TBranch        *b_nspl;   //!
   TBranch        *b_t2kltccorr;   //!
   TBranch        *b_t2kgps1_sec;   //!
   TBranch        *b_t2kgps1_nsec;   //!
   TBranch        *b_t2kgps2_sec;   //!
   TBranch        *b_t2kgps2_nsec;   //!
   TBranch        *b_t2kgpsstat;   //!
   TBranch        *b_etime;   //!
   TBranch        *b_iflag_atmpd;   //!
   TBranch        *b_iflag_t2ksk;   //!
   TBranch        *b_sk_quality_flag;   //!

   SKsumClass(TTree *tree=0);
   virtual ~SKsumClass();
   virtual Int_t    Cut(Long64_t entry);
   virtual Int_t    GetEntry(Long64_t entry);
   virtual Long64_t LoadTree(Long64_t entry);
   virtual void     Init(TTree *tree);
   virtual void     Loop();
   virtual Bool_t   Notify();
   virtual void     Show(Long64_t entry = -1);
};

#endif

#ifdef SKsumClass_cxx
SKsumClass::SKsumClass(TTree *tree)
{
// if parameter tree is not specified (or zero), connect the file
// used to generate this class and read the Tree.
   if (tree == 0) {
      TFile *f = (TFile*)gROOT->GetListOfFiles()->FindObject("/home/sklb/reduction/list/skbeamsummary/sk_summary.run30.root");
      if (!f) {
         f = new TFile("/home/sklb/reduction/list/skbeamsummary/sk_summary.run30.root");
      }
      tree = (TTree*)gDirectory->Get("sksum");

   }
   Init(tree);
}

SKsumClass::~SKsumClass()
{
   if (!fChain) return;
   delete fChain->GetCurrentFile();
}

Int_t SKsumClass::GetEntry(Long64_t entry)
{
// Read contents of entry.
   if (!fChain) return 0;
   return fChain->GetEntry(entry);
}
Long64_t SKsumClass::LoadTree(Long64_t entry)
{
// Set the environment to read one entry
   if (!fChain) return -5;
   Long64_t centry = fChain->LoadTree(entry);
   if (centry < 0) return centry;
   if (!fChain->InheritsFrom(TChain::Class()))  return centry;
   TChain *chain = (TChain*)fChain;
   if (chain->GetTreeNumber() != fCurrent) {
      fCurrent = chain->GetTreeNumber();
      Notify();
   }
   return centry;
}

void SKsumClass::Init(TTree *tree)
{
   // The Init() function is called when the selector needs to initialize
   // a new tree or chain. Typically here the branch addresses and branch
   // pointers of the tree will be set.
   // It is normally not necessary to make changes to the generated
   // code, but the routine can be extended by the user if needed.
   // Init() will be called many times when running on PROOF
   // (once per file to be processed).

   // Set branch addresses and branch pointers
   if (!tree) return;
   fChain = tree;
   fCurrent = -1;
   fChain->SetMakeClass(1);

   fChain->SetBranchAddress("nrunsk", &nrunsk, &b_nrunsk);
   fChain->SetBranchAddress("nsubsk", &nsubsk, &b_nsubsk);
   fChain->SetBranchAddress("nevsk", &nevsk, &b_nevsk);
   fChain->SetBranchAddress("ndaysk", ndaysk, &b_ndaysk);
   fChain->SetBranchAddress("ntimsk", ntimsk, &b_ntimsk);
   fChain->SetBranchAddress("idtgsk", &idtgsk, &b_idtgsk);
   fChain->SetBranchAddress("ifevsk", &ifevsk, &b_ifevsk);
   fChain->SetBranchAddress("nevhwsk", &nevhwsk, &b_nevhwsk);
   fChain->SetBranchAddress("numhwsk", &numhwsk, &b_numhwsk);
   fChain->SetBranchAddress("ihwt0", &ihwt0, &b_ihwt0);
   fChain->SetBranchAddress("it0sk", &it0sk, &b_it0sk);
   fChain->SetBranchAddress("npeak", &npeak, &b_npeak);
   fChain->SetBranchAddress("npeakpre", &npeakpre, &b_npeakpre);
   fChain->SetBranchAddress("npeakon", &npeakon, &b_npeakon);
   fChain->SetBranchAddress("swt0pre", &swt0pre, &b_swt0pre);
   fChain->SetBranchAddress("swt0peak", &swt0peak, &b_swt0peak);
   fChain->SetBranchAddress("ihwped", &ihwped, &b_ihwped);
   fChain->SetBranchAddress("nqiskz", &nqiskz, &b_nqiskz);
   fChain->SetBranchAddress("nhitaz", &nhitaz, &b_nhitaz);
   fChain->SetBranchAddress("diff_ltc1", &diff_ltc1, &b_diff_ltc1);
   fChain->SetBranchAddress("diff_ltc2", &diff_ltc2, &b_diff_ltc2);
   fChain->SetBranchAddress("gps1_sec", &gps1_sec, &b_gps1_sec);
   fChain->SetBranchAddress("gps1_nsec", &gps1_nsec, &b_gps1_nsec);
   fChain->SetBranchAddress("gps2_sec", &gps2_sec, &b_gps2_sec);
   fChain->SetBranchAddress("gps2_nsec", &gps2_nsec, &b_gps2_nsec);
   fChain->SetBranchAddress("gpsstat", &gpsstat, &b_gpsstat);
   fChain->SetBranchAddress("iflag_gps", &iflag_gps, &b_iflag_gps);
   fChain->SetBranchAddress("iflag_evstatus", &iflag_evstatus, &b_iflag_evstatus);
   fChain->SetBranchAddress("iflag_tq", &iflag_tq, &b_iflag_tq);
   fChain->SetBranchAddress("iflag_preact", &iflag_preact, &b_iflag_preact);
   fChain->SetBranchAddress("iflag_tdcreset", &iflag_tdcreset, &b_iflag_tdcreset);
   fChain->SetBranchAddress("iflag_pedestal", &iflag_pedestal, &b_iflag_pedestal);
   fChain->SetBranchAddress("nrunbm", &nrunbm, &b_nrunbm);
   fChain->SetBranchAddress("nspl", &nspl, &b_nspl);
   fChain->SetBranchAddress("t2kltccorr", &t2kltccorr, &b_t2kltccorr);
   fChain->SetBranchAddress("t2kgps1_sec", &t2kgps1_sec, &b_t2kgps1_sec);
   fChain->SetBranchAddress("t2kgps1_nsec", &t2kgps1_nsec, &b_t2kgps1_nsec);
   fChain->SetBranchAddress("t2kgps2_sec", &t2kgps2_sec, &b_t2kgps2_sec);
   fChain->SetBranchAddress("t2kgps2_nsec", &t2kgps2_nsec, &b_t2kgps2_nsec);
   fChain->SetBranchAddress("t2kgpsstat", &t2kgpsstat, &b_t2kgpsstat);
   fChain->SetBranchAddress("etime", &etime, &b_etime);
   fChain->SetBranchAddress("iflag_atmpd", &iflag_atmpd, &b_iflag_atmpd);
   fChain->SetBranchAddress("iflag_t2ksk", &iflag_t2ksk, &b_iflag_t2ksk);
   fChain->SetBranchAddress("sk_quality_flag", &sk_quality_flag, &b_sk_quality_flag);
   Notify();
}

Bool_t SKsumClass::Notify()
{
   // The Notify() function is called when a new file is opened. This
   // can be either for a new TTree in a TChain or when when a new TTree
   // is started when using PROOF. It is normally not necessary to make changes
   // to the generated code, but the routine can be extended by the
   // user if needed. The return value is currently not used.

   return kTRUE;
}

void SKsumClass::Show(Long64_t entry)
{
// Print contents of entry.
// If entry is not specified, print current entry
   if (!fChain) return;
   fChain->Show(entry);
}
Int_t SKsumClass::Cut(Long64_t entry)
{
// This function may be called from Loop.
// returns  1 if entry is accepted.
// returns -1 otherwise.
   return 1;
}
#endif // #ifdef SKsumClass_cxx
