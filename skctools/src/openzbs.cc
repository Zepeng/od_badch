#include "openzbs.hh"

extern "C" {
  void fort_fopen_(int&, const char*, char*, int& ,int);
}

int openwritezbs(std::string zbsfilename, int& LUN) {
  
  // FILE CONTROL VARIABLES                                                                                                                                                              
  char type = 'z';
  int writemode = 1;
  fort_fopen_(LUN, zbsfilename.c_str(), &type, writemode, zbsfilename.length());

}

int openreadzbs(std::string zbsfilename, int& LUN) {
  
  // FILE CONTROL VARIABLES                                                                                                                                                              
  char type = 'z';
  int readmode = 0;
  fort_fopen_(LUN, zbsfilename.c_str(), &type, readmode, zbsfilename.length());

}
