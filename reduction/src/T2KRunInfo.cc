#include "T2KRunInfo.hh"
#include "T2KOD_ERRORS.hh"
#include "T2KAnalysisSample.hh"
#include <sys/stat.h>

T2KRunInfo::T2KRunInfo()
{

  m_verbose = 0;
  m_nrunsk = 0;
  m_nrunbm = 0;
  m_bsdfolder = T2KAnalysisSample::BSDFolder;
  m_bsdversion = T2KAnalysisSample::BSDVersion;

  m_loaded_pernrunskfiles = false;
  m_loaded_pernrunbmfiles = false;
  m_loaded_bsdforbeamrun  = false;

  // Classes for official SK/SKBEAM Summaries
  m_nrunbm_sksum = NULL;
  m_nrunbm_skbeamsum = NULL;
  m_nrunbm_sksum_chain = NULL;
  m_nrunbm_skbeam_chain = NULL;

  // Classes for SK/SKBEAM info per run
  m_SKsum = NULL;
  m_SKbeam = NULL;
  m_tfSKsum = NULL;
  m_tfSKbeam = NULL;

  // Classes for BSD chain
  m_bsd = NULL;
  m_bsdchain = NULL;

  m_SKsum_found = -1;
  m_SKbeam_found = -1;
  m_nrunbm_sksum_found = -1;
  m_nrunbm_skbeam_found = -1;
  
}

T2KRunInfo::~T2KRunInfo(){

  //Close Trees and Files
  if (m_tfSKsum)
    m_tfSKsum->Close();
  if (m_tfSKbeam)
    m_tfSKbeam->Close();

  // Clean up the classes only after the pointer to
  //  the tree is null.  This is done by closing the file first.
  if (m_SKsum)
    delete m_SKsum;
  if (m_SKbeam)
    delete m_SKbeam;

}


int T2KRunInfo::LoadInfofiles(int nrunsk) {


  std::cout << "Load T2KRunInfo: nrunsk " << nrunsk << std::endl;
  m_nrunsk = nrunsk;

  // TRY TO LOAD SUMMARY FILES (PER RUN)
//   char zSKsumName[500];
//   char zSKbeamName[500];
//   sprintf(zSKsumName, "%s/%06d/t2k.sksum.%06d.root", T2KAnalysisSample::NRUNSK_SUMFILE_FOLDER.c_str(), m_nrunsk, m_nrunsk);
//   sprintf(zSKbeamName, "%s/%06d/t2k.skbeamsum.%06d.root", T2KAnalysisSample::NRUNSK_SUMFILE_FOLDER.c_str(), m_nrunsk, m_nrunsk);
//   m_strSKsumFilename = zSKsumName;
//   m_strSKbeamFilename = zSKbeamName;
//   LoadSKsum();
//   LoadSKbeam();
//   if (m_SKsum!=NULL && m_SKbeam!=NULL) {
//     std::cout << "Successfully loaded summary files (per SK run)" << std::endl;    
//     m_loaded_pernrunskfiles = true;
//   }
//   else {
//     std::cout << "Could not load summary files, m_loadedpernrunskfiles: " << m_loaded_pernrunskfiles << std::endl;
//   }

  // Try to look up NRUNBM
  m_nrunbm = T2KOD::NRUNBM(nrunsk);
  std::cout << " T2KRunInfo: nrunbm for this nrunsk is " << m_nrunbm << std::endl;
  int bsd_status = LoadBSDIndexForBeamRun( abs(m_nrunbm) );
  int sum_status = LoadSummaryForBeamRun(  abs(m_nrunbm) );

  if ( m_nrunbm<0 ) {
    std::cout << " T2KRunInfo: nrunbm for this nrunsk is negative and so provisional run. no spill info loaded." << std::endl;
    m_nrunbm *= -1;
    if ( sum_status==T2KOD_ERR ) {
      m_nrunbm_sksum_chain = NULL;
      m_nrunbm_skbeam_chain = NULL;
      m_loaded_pernrunbmfiles = false;
    }
    else {
      std::cout << "Was able to load provisional BSD information." << std::endl;
    }
  }

  
//   if (m_nrunbm>0) {
//     LoadBSDIndexForBeamRun( abs(m_nrunbm) );
//     LoadSummaryForBeamRun(  abs(m_nrunbm) );
//   }
//   else {
//     std::cout << " T2KRunInfo: nrunbm for this nrunsk is negative and so provisional run. no spill info loaded." << std::endl;
//     m_nrunbm *= -1;
//     m_nrunbm_sksum_chain = NULL;
//     m_nrunbm_skbeam_chain = NULL;
//     m_loaded_pernrunbmfiles = false;
//   }

  //if (m_nrunbm>0) {
  //}

  //std::cout << " m_loadedpernrunskfiles: " << m_loaded_pernrunskfiles << std::endl;
  std::cout << " m_loadedpernrunbmfiles: " << m_loaded_pernrunbmfiles << std::endl;

  return T2KOD_OK;
}

int T2KRunInfo::LoadSummaryForBeamRun(int nrunbm) {

  char skbeamsumfilename[1000];
  sprintf(skbeamsumfilename, T2KAnalysisSample::NRUNBM_SKBEAMSUM_TEMPLATE.c_str(), T2KAnalysisSample::NRUNBM_SUMFILE_FOLDER.c_str(), nrunbm);

  m_nrunbm_sksum_chain = NULL;
  m_nrunbm_skbeam_chain = new TChain("skbeamsum");
  
  int filesconnected = m_nrunbm_skbeam_chain->AddFile( skbeamsumfilename, -1 );
  
  if ( nrunbm==47 ) {
    sprintf(skbeamsumfilename, T2KAnalysisSample::NRUNBM_SKBEAMSUM_TEMPLATE.c_str(), T2KAnalysisSample::NRUNBM_SUMFILE_FOLDER.c_str(), 48);
    filesconnected = m_nrunbm_skbeam_chain->AddFile( skbeamsumfilename, -1 );
  }
  else if ( nrunbm==48 ) {
    sprintf(skbeamsumfilename, T2KAnalysisSample::NRUNBM_SKBEAMSUM_TEMPLATE.c_str(), T2KAnalysisSample::NRUNBM_SUMFILE_FOLDER.c_str(), 47);
    filesconnected = m_nrunbm_skbeam_chain->AddFile( skbeamsumfilename, -1 );
  }
  
  if (filesconnected<1) {
    std::cout << "Error opening summary and sksummary files: tried to open " << skbeamsumfilename << std::endl;
    delete m_nrunbm_sksum_chain;
    delete m_nrunbm_skbeam_chain;
    m_nrunbm_sksum_chain = NULL;
    m_nrunbm_skbeam_chain = NULL;
    m_loaded_pernrunbmfiles = false;
    return T2KOD_ERR;
  }
  else {
    std::cout << "Opened beam summary file: " << skbeamsumfilename << " (filesconnected=" << filesconnected << ")" << std::endl;
  }


  m_nrunbm_skbeam_chain->BuildIndex("nrunsk", "nspl");
  m_nrunbm_skbeamsum = new SKbeamClass( m_nrunbm_skbeam_chain );

  m_loaded_pernrunbmfiles = true;
  std::cout << "Successfully added sk summary files ( per nrunbm )" << std::endl;
  std::cout << "  summary file: " << skbeamsumfilename << std::endl;
  std::cout << "  nrunbm: " << nrunbm << std::endl;
  std::cout << "  entries in file: " << m_nrunbm_skbeam_chain->GetEntries() << std::endl;

  return T2KOD_OK;

}

void T2KRunInfo::LoadSKsum(){

  if (m_tfSKsum==NULL){
    m_tfSKsum = new TFile(m_strSKsumFilename.c_str(), "OPEN");
  }

  m_trSKsum = (TTree*)m_tfSKsum->Get("sksum");
  if (m_trSKsum) {
    m_SKsum = new SKsumClass(m_trSKsum);
    std::cout << "Loaded SKsum Tree (" << m_trSKsum << "), with " << m_trSKsum->GetEntries() << " entries." << std::endl;
    m_trSKsum->BuildIndex("nrunsk", "nspl");
  }

}

void T2KRunInfo::LoadSKbeam(){

  std::cout << "Loading SKbeam Class" << std::endl;

  if (m_tfSKbeam==NULL){
    m_tfSKbeam = new TFile(m_strSKbeamFilename.c_str(), "OPEN");
  }

  m_trSKbeam = (TTree*)m_tfSKbeam->Get("skbeamsum");
  if (m_trSKbeam) {
    m_SKbeam = new SKbeamClass(m_trSKbeam);
    m_trSKbeam->BuildIndex("nrunsk", "nspl");
    std::cout << "Loaded SKbeam Tree (" << m_trSKbeam << "), with " << m_trSKbeam->GetEntries() << " entries." << std::endl;
  }

}


int T2KRunInfo::GetGoodT2KbeamEventFlags(int& sk_quality_flag, int& bsd_good_spill, double& pot, int nrunsk, int nspl){

  // Reset flags no null
  sk_quality_flag = -1;
  bsd_good_spill = -1;
  pot = 0;

  int flag = -1;
  if (nrunsk>0 && nspl>0) {
    // supplied a set of indices
    this->SetEntry(nrunsk, nspl);
  }

  if (m_loaded_pernrunbmfiles==true && m_filemode == T2KRUNINFO_NRUNBMFILES) {
    // Use official.    
    int entry = -1;
    entry = m_nrunbm_skbeamsum->fChain->GetEntryWithIndex(m_nrunsk, m_nspl);
    if (entry !=-1) {
      // Found such an entry (should be 1 = good, or 0 = bad )
      sk_quality_flag = m_nrunbm_skbeamsum->sk_quality_flag;
      bsd_good_spill = m_nrunbm_skbeamsum->good_spill_flag;
      if ( (440194<=m_nrunbm_skbeamsum->nurun)&&(m_nrunbm_skbeamsum->nurun<=440235) )
	pot = m_nrunbm_skbeamsum->ct_np[3][0];
      else
	pot = m_nrunbm_skbeamsum->ct_np[4][0];
      flag = m_nrunbm_skbeamsum->sk_quality_flag & m_nrunbm_skbeamsum->good_spill_flag;
      if (m_verbose>0) {
	std::cout << "  sk_quality_flag: " << sk_quality_flag << std::endl;
	std::cout << "  good_spill: " << bsd_good_spill << std::endl;
	std::cout << "  pot: " << pot << std::endl;
	std::cout << "  beam_time: " << m_nrunbm_skbeamsum->beam_time[0][0] << std::endl;
	std::cout << "  flag: " << flag << std::endl;
      }
    }
  }
  else if (m_loaded_pernrunskfiles==true && m_filemode == T2KRUNINFO_NRUNSKFILES) {

    int entry = -1;
    entry = m_SKbeam->fChain->GetEntryWithIndex(m_nrunsk, m_nspl);
    if (entry !=-1) {
      // Found such an entry (should be 1 = good, or 0 = bad )
      sk_quality_flag = m_SKbeam->sk_quality_flag;
      bsd_good_spill = m_SKbeam->good_spill_flag;
      pot = m_SKbeam->ct_np[4][0];
      flag = m_SKbeam->sk_quality_flag & m_SKbeam->good_spill_flag;
      if (m_verbose>0) {
	std::cout << "  sk_quality_flag: " << sk_quality_flag << std::endl;
	std::cout << "  good_spill: " << bsd_good_spill << std::endl;
	std::cout << "  pot: " << pot << std::endl;
	std::cout << "  flag: " << flag << std::endl;
      }
    }
  }


  return flag;

}

int T2KRunInfo::GetBeamTime(double& beam_time ) {
  // Assumes we've already grabbed the right entry
  if ( m_nrunbm_skbeamsum )
    beam_time = m_nrunbm_skbeamsum->beam_time[0][0];
  return 0;
}

//int T2KRunInfo::SetEntry(int nrunsk, int nsubsk, int nspl) {
int T2KRunInfo::SetEntry(int nrunsk, int nspl, int t2kgps1_sec) {

  // WE TRY TO RETRIEVE T2K AND SK SUMMARY INFO
  // HAVE REDUNDANCIES TO TRY AND PREVENT ERRORS
  // LOAD PRIORTY
  //  (1) SK Summary Info per beamrun. These are the official lists from Nakayama-san.  Because they 
  //    are official, they will probably lag a bit.
  //  (2) SK Summary Info per nrunsk.  These are maintained by my automated T2K OD reduction program.
  //    Hopefully they are the most current.
  //  (3) The BSD files themselves. (Implemented later -- almost uncessary as (1) and (2) are derived from these.

  m_filemode = T2KRUNINFO_NOTFOUND;
  m_nrunbm_skbeam_found = -1;
  m_nrunbm_sksum_found = -1;
  m_SKsum_found = -1;
  m_SKbeam_found = -1;
  m_entryfound = -1;
  m_nrunsk = nrunsk;
  m_nevsk = 0;
  m_nsubsk = 0;
  m_nspl = 0;

  // (1) SK Summary Info per beamrun
  if (m_loaded_pernrunbmfiles==true) {
    m_nrunbm_skbeam_found = m_nrunbm_skbeamsum->fChain->GetEntryWithIndex(nrunsk, nspl);
    //m_nrunbm_sksum_found = m_nrunbm_sksum->fChain->GetEntryWithIndex(nrunsk, nspl); //no longer made
    if (m_nrunbm_skbeam_found>=0) {
      m_filemode = T2KRUNINFO_NRUNBMFILES;
      m_nrunsk = m_nrunbm_skbeamsum->nrunsk;
      m_nsubsk = m_nrunbm_skbeamsum->nsubsk;
      m_nevsk = m_nrunbm_skbeamsum->nevsk;
      m_nspl = m_nrunbm_skbeamsum->nspl;
      m_entryfound = m_nrunbm_skbeam_found;
      // more checks?
    }
  }

  // (2) SK Summary Info per nrunsk: OBSOLETE
//   if (m_loaded_pernrunskfiles==true && m_filemode!=T2KRUNINFO_NRUNBMFILES) {
//     // SK SUMMARY FILES PER RUN
//     if (m_SKsum == NULL)
//       LoadSKsum();
//     if (m_SKsum == NULL)
//       return -1;
    
//     m_SKsum_found = m_SKsum->fChain->GetEntryWithIndex(nrunsk, nspl);
//     if ( m_SKsum_found != -1) {
//       m_nrunsk = m_SKsum->nrunsk;
//       m_nsubsk = m_SKsum->nsubsk;
//       m_nevsk = m_SKsum->nevsk;
//       m_nspl = m_SKsum->nspl;
//     }

//     m_SKbeam_found = m_SKbeam->fChain->GetEntryWithIndex(nrunsk, nspl);
// //       if (t2kgps1_sec==0)
// // 	m_SKbeam_found = m_SKbeam->fChain->GetEntryWithIndex(m_SKsum->t2kgps1_sec, m_nspl);
// //       else
// // 	m_SKbeam_found = m_SKbeam->fChain->GetEntryWithIndex(t2kgps1_sec, m_nspl);

//     if (m_SKsum_found>=0 && m_SKbeam_found>=0) {
//       m_entryfound = m_SKsum_found;
//       m_filemode = T2KRUNINFO_NRUNSKFILES;
//     }
//   }
  
  // BSD: THIRD REDUANCY GOES HERE

  if (m_verbose>0){
    std::cout << "  T2K Beam and SK Summary Entry Requested:" << std::endl;
    std::cout << "   sent out request for:  nspl=" << nspl << ", t2kgps=" << t2kgps1_sec << std::endl;
    std::cout << "   Entry Returned: " << m_entryfound << std::endl;
    std::cout << "     filemode: " << m_filemode << std::endl;
    std::cout << "     nrunsk: " << m_nrunsk << std::endl;
    std::cout << "     nsubsk: " << m_nsubsk << std::endl;
    std::cout << "     nevsk: " << m_nevsk << std::endl;
    std::cout << "     nspl: " << m_nspl << std::endl;
    std::cout << "   Sample Found: " << m_entryfound << std::endl;
    std::cout << "     sksum list (per skrun): " << m_SKsum_found << std::endl;
    std::cout << "     skbeam list (per skrun): " << m_SKbeam_found << std::endl;
    std::cout << "     sksum list (per beamrun): " << m_nrunbm_sksum_found << std::endl;
    std::cout << "     skbeam list (per beamrun): " << m_nrunbm_skbeam_found << std::endl;
    std::cout << "   loaded sksumfile per SK run: " << m_loaded_pernrunskfiles << std::endl;
    std::cout << "   loaded sksumfile per beam run: " << m_loaded_pernrunbmfiles << std::endl;
  }
   
  if (m_entryfound>=0)
    return m_filemode;
  else
    return -1;

  return -1;

}

bool T2KRunInfo::CheckEntry(int nrunsk, int nspl){

  if (nrunsk == m_nrunsk && nspl == m_nspl)
    return true;

  return false;

}


#include <fstream>

int T2KRunInfo::LoadBSDIndexForBeamRun(int nrunbm){
  
  // THIS REQUIRES MORE THOUGHT
  return -1;

  std::cout << "LOAD BSD INDEX FOR BEAM RUN" << std::endl;
  std::vector< std::string > files;
  char bsdlistfilename[512];
  
  std::cout << "opening file: " << bsdlistfilename << std::endl;
  ifstream list(bsdlistfilename);
  char buf[5012];
  list >> buf;

  while (list.eof()==false) {
    files.push_back( std::string(buf) );
    list >> buf;
  }
  list.close();
  std::cout << "Numbe of BSD files loaded: " << files.size() << std::endl;

  m_bsdchain = new TChain("bsd");
  for (int f=0; f<files.size(); f++){
    m_bsdchain->Add( files.at(f).c_str() );
  }

  //m_bsdchain->BuildIndex("spillnum","trig_sec[0]");
  
  m_bsd = new bsdclass( m_bsdchain );
  std::cout << "BSD Chain entires: " << m_bsdchain->GetEntries() << std::endl;
}

int T2KRunInfo::GetSKsumFound() { 

  // These are to check if the info files were found.

  if ( m_SKsum_found>=0 || m_nrunbm_sksum_found>=0 )
    return 1; 

  return -1;

}

int T2KRunInfo::GetSKbeamFound() { 

  // These are to check if the info files were found.

  if ( m_SKbeam_found>=0 || m_nrunbm_skbeam_found>=0 )
    return 1;

  return -1;
}
