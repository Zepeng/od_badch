#ifndef __t2kodrd_cutfunc_h__
#define __t2kodrd_cutfunc_h__ 1

#include "TFile.h"
#include "TTree.h"
#include "T2KRunInfo.hh"
#include "ODXDecisionTree.hh"

extern T2KRunInfo* p_t2kruninfo;
extern TTree* p_t2kodreduc_tree;
extern ODXDecisionTree* p_odxdecision;
extern int t2kodreduc_num_events_processed;

int t2kodreduc_init(TFile* file);
int t2kodreduc_event(int inputLUN);
int t2kodreduc_definebranches(TTree* tree);
int t2kodreduc_baselinecut();
int t2kodreduc_od1cut();
int t2kodreduc_od2cut();
int t2kodreduc_odTcut();
void t2kodreduc_printevent();
int t2kodreduc_writetree();

#endif
