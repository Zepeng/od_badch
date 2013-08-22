#include <iostream>
#include <fstream>
#include <TRandom3.h>
#include <TMath.h>

int eventgenerator()
{
  ofstream outfile("pc.kin");
  TRandom3 r;
  for(int i = 0; i < 1000; i++)
  {
    double z = 15**(1-2*r.Rndm());
    double radius = 1000*r.Rndm() ;
    double Phi_r = r.Rndm()*TMath::TwoPi();
    double radius_x = radius*TMath::Sin(Phi_r);
    double radius_y = radius*TMath::Cos(Phi_r);
    double Phi = r.Rndm()*TMath::TwoPi();
    double Theta = 2*TMath::ACos(r.Rndm());
    double energy = 10000 + 10000.*r.Rndm();
    outfile << "$ begin" << std::endl;
    outfile << "$ vertex " << radius_x << " " << radius_y << " " << z << " " << 0 << std::endl;
    outfile << "$ track "  << 13 << " " << energy << " " << TMath::Sin(Theta)*TMath::Sin(Phi) << " "
            << TMath::Sin(Theta)*TMath::Cos(Phi) << " " << TMath::Cos(Theta) << " " << 0 << std::endl;
    outfile << "$ end" << std::endl;
  }
  return 0;
}
