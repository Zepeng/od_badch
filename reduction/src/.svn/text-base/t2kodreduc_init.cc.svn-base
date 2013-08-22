#include "T2KOD_ERRORS.hh"
#include "T2KOD.hh"
#include "T2KAnalysisSample.hh"
#include "t2kodreduc_cutfunctions.hh"
#include "T2KRunInfo.hh"
#include "ODXDecisionInterface.hh"
#include "t2kodtimingC.hh"
#include "t2kodtiming_functions.hh"
#include "TTree.h"

T2KRunInfo* p_t2kruninfo = NULL;
ODXDecisionTree* p_odxdecision = NULL;
TTree* p_t2kodreduc_tree = NULL;
int t2kodreduc_num_events_processed = 0;

int t2kodreduc_init(TFile* file) {

  t2kodreduc_num_events_processed = 0;

  if (file==NULL)
    file = new TFile("output_t2kodreduc.root", "RECREATE");
  file->cd();
  p_t2kodreduc_tree = new TTree("odtree", "T2K Outer Detector Variable Tree");

  // Initial classes, trees, branches, etc.
  std::cout << "Initialize T2KOD Reduction" << std::endl;

  // define branches of t2kod reduction common
  std::cout << "  assign tree branches to t2kodreduc_common struct" << std::endl;
  t2kodreduc_definebranches( p_t2kodreduc_tree );
  
  // initialize run info class
  std::cout << "  create intance of T2KRunInfo: our connection to the BSD and SK/SKBEAM summary data." << std::endl;
  p_t2kruninfo = new T2KRunInfo();

  // initialize llr od crossing classifier
  std::cout << "  initialize ODXDecisionTree: a LLR classifier." << std::endl;
  p_odxdecision = new ODXDecisionTree();
  odxdecision_setinstance(p_odxdecision);
  std::cout << "  set ODX PDF to the standard listed in T2KODHEAD.hh" << std::endl;
  odxdecision_setpdf_( T2KAnalysisSample::ODXDT_PDF[T2KAnalysisSample::SUKAP].c_str(), 
		       T2KAnalysisSample::ODXDT_PDF[T2KAnalysisSample::SUKAP].length() );
  std::cout << "  assign tree branches to odxdecision_common struct" << std::endl;
  odxdecision_definebranches( p_t2kodreduc_tree );

  // initialize timing correction module
  std::cout << "  assign tree branches to t2kodtiming_common struct" << std::endl;
  t2kodtiming_definebranches( p_t2kodreduc_tree );

  // bring ROOT's scope back to the output file.
  file->cd();

  std::cout << "  Done initializing." << std::endl;

  return T2KOD_OK;

}
