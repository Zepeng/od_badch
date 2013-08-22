#include "openzbs.hh"

extern "C" {
  void fort_fopen_(int&, const char*, char*, int& ,int);
}

int openreadzbs(std::string zbsfilename, int& LUN) {
  
  // FILE CONTROL VARIABLES                                                                                                                                                              
  char type = 'z';
  int readmode = 0;
  fort_fopen_(LUN, zbsfilename.c_str(), &type, readmode, zbsfilename.length());

}
