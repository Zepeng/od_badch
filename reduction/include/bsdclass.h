//////////////////////////////////////////////////////////
// This class has been automatically generated on
// Wed Feb 24 16:47:45 2010 by ROOT version 5.20/00
// from TChain bsd/
//////////////////////////////////////////////////////////

#ifndef bsdclass_h
#define bsdclass_h

#include <TROOT.h>
#include <TChain.h>
#include <TFile.h>

class bsdclass {
public :
   TTree          *fChain;   //!pointer to the analyzed TTree or TChain
   Int_t           fCurrent; //!current Tree number in a TChain

   // Declaration of leaf types
   Int_t           nurun;
   Int_t           midas_event;
   Int_t           mrrun;
   Int_t           mrshot;
   Int_t           spillnum;
   Int_t           trg_sec[3];
   Int_t           trg_nano[3];
   Int_t           gpsstat[2];
   Double_t        ct_np[5][9];
   Double_t        beam_time[5][9];
   Int_t           beam_flag[5][9];
   Double_t        hct[3][5];
   Double_t        tpos[2];
   Double_t        tdir[2];
   Double_t        tsize[2];
   Double_t        mumon[12];
   Double_t        otr[13];
   Int_t           good_gps_flag;
   Int_t           trigger_flag;
   Int_t           spill_flag;
   Int_t           good_spill_flag;

   // List of branches
   TBranch        *b_nurun;   //!
   TBranch        *b_midas_event;   //!
   TBranch        *b_mrrun;   //!
   TBranch        *b_mrshot;   //!
   TBranch        *b_spillnum;   //!
   TBranch        *b_trig_sec;   //!
   TBranch        *b_trig_nano;   //!
   TBranch        *b_gpsstat;   //!
   TBranch        *b_ct_np;   //!
   TBranch        *b_beam_time;   //!
   TBranch        *b_beam_flag;   //!
   TBranch        *b_hct;   //!
   TBranch        *b_tpos;   //!
   TBranch        *b_tdir;   //!
   TBranch        *b_tsize;   //!
   TBranch        *b_mumon;   //!
   TBranch        *b_otr;   //!
   TBranch        *b_good_gps_flag;   //!
   TBranch        *b_trigger_flag;   //!
   TBranch        *b_spill_flag;   //!
   TBranch        *b_good_spill_flag;   //!

   bsdclass(TTree *tree=0);
   virtual ~bsdclass();
   virtual Int_t    Cut(Long64_t entry);
   virtual Int_t    GetEntry(Long64_t entry);
   virtual Long64_t LoadTree(Long64_t entry);
   virtual void     Init(TTree *tree);
   virtual void     Loop();
   virtual Bool_t   Notify();
   virtual void     Show(Long64_t entry = -1);
};

#endif

#ifdef bsdclass_cxx
bsdclass::bsdclass(TTree *tree)
{
// if parameter tree is not specified (or zero), connect the file
// used to generate this class and read the Tree.
   if (tree == 0) {

#ifdef SINGLE_TREE
      // The following code should be used if you want this class to access
      // a single tree instead of a chain
      TFile *f = (TFile*)gROOT->GetListOfFiles()->FindObject("Memory Directory");
      if (!f) {
         f = new TFile("Memory Directory");
      }
      tree = (TTree*)gDirectory->Get("bsd");

#else // SINGLE_TREE

      // The following code should be used if you want this class to access a chain
      // of trees.
      TChain * chain = new TChain("bsd","");
      chain->Add("/home/sklb/log/beamline/bsd_p01_20100126.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_p01_20100131.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_p01_20100201.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_p01_20100204.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_p01_20100205.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270037p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270038p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270039p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270040p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270041p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270042p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270043p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270044p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270045p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270046p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270047p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270048p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270049p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270050p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270051p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270052p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270053p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270054p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270055p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270056p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270057p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270058p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270059p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270060p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270061p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270062p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270063p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270064p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270065p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270066p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270067p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270068p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270069p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270070p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270071p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270072p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270073p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270074p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270075p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270076p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270077p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270078p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270079p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270080p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270081p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270082p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270100p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270101p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270102p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270103p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270104p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270105p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270106p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270107p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270108p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270109p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270110p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270111p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270112p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270113p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270114p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270115p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270116p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270117p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270118p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270119p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270120p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270121p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270122p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270125p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270126p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270127p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270128p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270129p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270130p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270131p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270132p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270133p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270134p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270135p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270136p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270137p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270138p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270139p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270140p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270141p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270142p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270143p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270144p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270145p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270146p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270147p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270148p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270149p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270150p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270151p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270152p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270153p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270154p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270155p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270156p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270157p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270158p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270159p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270160p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270161p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270162p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270163p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270164p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270165p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270166p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270167p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270168p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270169p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270170p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270171p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270172p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270173p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270174p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270175p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270176p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270177p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270178p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270179p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270180p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270181p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270182p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270183p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270184p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270185p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270186p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270187p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270188p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270189p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270190p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270191p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270192p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270193p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270194p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270195p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270196p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270197p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270198p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270199p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270200p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270201p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270202p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270203p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270204p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270205p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270206p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270207p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270208p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270209p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270210p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270211p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270212p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270213p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270214p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270215p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270216p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270217p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270218p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270219p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270220p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270221p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270222p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270223p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270224p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270225p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270226p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270227p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270228p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270229p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270230p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270231p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270232p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270233p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270234p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270235p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270236p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270237p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270238p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270239p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270240p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270241p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270242p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270243p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270244p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270245p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270246p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270247p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270248p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270249p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270250p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270251p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270252p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270253p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270254p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270255p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270256p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270257p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270258p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270259p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270260p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270261p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270262p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270263p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270264p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270265p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270266p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270267p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270268p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270269p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270270p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270271p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270272p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270273p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270274p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270275p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270276p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270277p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270278p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270279p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270280p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270281p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270282p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270283p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270284p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270285p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270286p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270287p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270288p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270289p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270290p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270291p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270292p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270293p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270294p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270295p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270296p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270297p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270298p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270299p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270300p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270301p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270302p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270303p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270304p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270305p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270306p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270307p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270308p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270309p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270310p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270311p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270312p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270313p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270314p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270315p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270316p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270317p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270318p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270319p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270320p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270321p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270322p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270323p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270324p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270325p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270326p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270327p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270328p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270329p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270330p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270331p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270332p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270333p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270334p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270335p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270336p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270337p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270338p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270339p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270340p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270341p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270342p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270343p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270344p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270345p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270346p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270347p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270348p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270349p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270350p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270351p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270352p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270353p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270354p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270355p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270356p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270357p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270358p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270359p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270360p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270361p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270362p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270363p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270364p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270365p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270366p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270367p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0270368p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280001p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280002p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280003p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280004p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280005p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280006p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280007p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280008p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280009p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280010p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280011p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280012p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280013p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280014p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280015p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280016p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280017p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280018p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280019p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280020p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280021p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280022p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280023p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280024p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280025p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280026p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280027p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280028p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280029p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280030p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280031p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280032p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280033p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280034p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280035p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280036p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280037p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280038p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280039p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280040p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280041p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280042p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280043p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280044p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280047p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280049p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280050p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280059p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280060_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280060p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280061_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280061p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280062p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280063p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280064p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280065p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280066p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280067p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280068p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280069p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280070p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280071p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280072p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280073p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280074p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280075_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280075p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280076p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280077p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280078p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280079p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280080p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280081p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280082p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280083p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280084p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280085p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280086p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280087p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280088p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280089p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280090p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280091p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280092p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280093p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280094p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280108p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280109p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280110_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280110p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280112p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280113p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280114p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280115p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280116p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280117p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280118p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280119_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280119p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280120p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280121p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280123p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280124p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280134p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280135p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280136p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0280137p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290002_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290002_2p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290002p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290003_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290003p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290010p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290011p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290014p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290017p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290018p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290019p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290021p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290022p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290023p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290024p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290025p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290028p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290029p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290030p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290031p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290032p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290033p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290034p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290035p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290036p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290037_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290037p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290038p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290039p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290040p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290052p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290053p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290054p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290055p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290056_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290056p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290057p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290058_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290058p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290059_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290059p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290060p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290061p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290062p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290063p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290064p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290065p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290066p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290067p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290068p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290069p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290070p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290071p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290072p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290073p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290074p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290075p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290076p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290077p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290078p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290082_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290082p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290110_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290110p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290130p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290131_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290131_2p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290131_3p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290131_4p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290131p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290132p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290133_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290133p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290134p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290135p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290136p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290137p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290138p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290139p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290140p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290141p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290142p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290143p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290144p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290145p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290146p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290147p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290148p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290149p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290150_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290150p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290151_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290151p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290152p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290153p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290154_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290154_2p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290154p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290155p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290156p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290157p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290158p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290159p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290160p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290161p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290162p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290163_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290163p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290164_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290164p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290165_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290165p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290166_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290166_2p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290166p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290168_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290168p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290171_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290171p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290173p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290174p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290175_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290175p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290176p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290177p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290179p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290180p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290181p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290182_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290182_2p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290182_3p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290182_4p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0290182p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0300001_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0300001_2p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0300001_3p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0300001p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0300002p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0300003p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0300004_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0300004p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0300005p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0300007p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0300013p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0300014p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0300015p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0300016p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0300017_1p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0300017_2p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0300017_3p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0300017_4p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0300017_5p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0300017p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0300022p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0300023p01.root/bsd");
      chain->Add("/home/sklb/log/beamline/bsd_run0300024p01.root/bsd");
      tree = chain;
#endif // SINGLE_TREE

   }
   Init(tree);
}

bsdclass::~bsdclass()
{
   if (!fChain) return;
   delete fChain->GetCurrentFile();
}

Int_t bsdclass::GetEntry(Long64_t entry)
{
// Read contents of entry.
   if (!fChain) return 0;
   return fChain->GetEntry(entry);
}
Long64_t bsdclass::LoadTree(Long64_t entry)
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

void bsdclass::Init(TTree *tree)
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

   fChain->SetBranchAddress("nurun", &nurun, &b_nurun);
   fChain->SetBranchAddress("midas_event", &midas_event, &b_midas_event);
   fChain->SetBranchAddress("mrrun", &mrrun, &b_mrrun);
   fChain->SetBranchAddress("mrshot", &mrshot, &b_mrshot);
   fChain->SetBranchAddress("spillnum", &spillnum, &b_spillnum);
   fChain->SetBranchAddress("trg_sec", trg_sec, &b_trig_sec);
   fChain->SetBranchAddress("trg_nano", trg_nano, &b_trig_nano);
   fChain->SetBranchAddress("gpsstat", gpsstat, &b_gpsstat);
   fChain->SetBranchAddress("ct_np", ct_np, &b_ct_np);
   fChain->SetBranchAddress("beam_time", beam_time, &b_beam_time);
   fChain->SetBranchAddress("beam_flag", beam_flag, &b_beam_flag);
   fChain->SetBranchAddress("hct", hct, &b_hct);
   fChain->SetBranchAddress("tpos", tpos, &b_tpos);
   fChain->SetBranchAddress("tdir", tdir, &b_tdir);
   fChain->SetBranchAddress("tsize", tsize, &b_tsize);
   fChain->SetBranchAddress("mumon", mumon, &b_mumon);
   fChain->SetBranchAddress("otr", otr, &b_otr);
   fChain->SetBranchAddress("good_gps_flag", &good_gps_flag, &b_good_gps_flag);
   fChain->SetBranchAddress("trigger_flag", &trigger_flag, &b_trigger_flag);
   fChain->SetBranchAddress("spill_flag", &spill_flag, &b_spill_flag);
   fChain->SetBranchAddress("good_spill_flag", &good_spill_flag, &b_good_spill_flag);
   Notify();
}

Bool_t bsdclass::Notify()
{
   // The Notify() function is called when a new file is opened. This
   // can be either for a new TTree in a TChain or when when a new TTree
   // is started when using PROOF. It is normally not necessary to make changes
   // to the generated code, but the routine can be extended by the
   // user if needed. The return value is currently not used.

   return kTRUE;
}

void bsdclass::Show(Long64_t entry)
{
// Print contents of entry.
// If entry is not specified, print current entry
   if (!fChain) return;
   fChain->Show(entry);
}
Int_t bsdclass::Cut(Long64_t entry)
{
// This function may be called from Loop.
// returns  1 if entry is accepted.
// returns -1 otherwise.
   return 1;
}
#endif // #ifdef bsdclass_cxx
