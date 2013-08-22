#include "TFile.h"
#include "TH2.h"
#include "TTree.h"
#include "TCanvas.h"
#include "THStack.h"
#include "TProfile.h"
#include "TMath.h"

void unroll()
{
  double Radius = 1745;
  double HalfH = 1864;

  //THStack* hs = new THStack("hs","nhitac histogram");
  TCanvas* c1 = new TCanvas("canvas","nhitac",800,600);

  TFile *file1 = new TFile("nhitac_m.root");
  TFile *file2 = new TFile("nhitac_u.root");
  
  TProfile2D  *unroll2D = new TProfile2D("unroll_2D","nhitac_new/nhitac_old",150,-6000,6000, 150, -5500, 5500);

  TLegend *l1 = new TLegend(0.458, 0.460, 0.841, 0.723);
  l1->SetBorderSize(0);

  TTree* nhitac_modified = (TTree*)file1->Get("testnhitac");
  TTree* nhitac_unmodified = (TTree*)file2->Get("testnhitac");
  
  int testnhitac1, testnhitac2;
  float odpos1[3], odpos2[3];
  nhitac_modified->SetBranchAddress("nhitac",&testnhitac1);
  nhitac_unmodified->SetBranchAddress("nhitac",&testnhitac2);
  nhitac_modified->SetBranchAddress("odpos",odpos1);
  nhitac_unmodified->SetBranchAddress("odpos",odpos2);

  float min = 1;
  float max = 0;
  for(int i= 0; i < nhitac_modified->GetEntries(); i++)
  {
    nhitac_modified->GetEntry(i);
    nhitac_unmodified->GetEntry(i);
    if((1.0*testnhitac1)/testnhitac2 > max) max = (1.0*testnhitac1)/testnhitac2;
    if((1.0*testnhitac1)/testnhitac2 < min) min = (1.0*testnhitac1)/testnhitac2;
   
    if(odpos1[2] > 1864) unroll2D->Fill(odpos1[0], odpos1[1] + Radius + HalfH , (1.0*testnhitac1)/testnhitac2);
    else if(odpos1[2] < -1864) unroll2D->Fill(odpos1[0], odpos1[1] - R - HalfH, (1.0*testnhitac1)/testnhitac2);
    else unroll2D->Fill(Radius*TMath::ATan2(odpos1[1],odpos1[0]),odpos1[2], (1.0*testnhitac1)/testnhitac2);
  }
  unroll2D->GetZaxis()->SetRangeUser(0.65, 1.85);
  unroll2D->GetXaxis()->SetTitle("X_pos_cluster(cm)");
  unroll2D->GetYaxis()->SetTitle("Y_pos_cluster(cm)");
  unroll2D->Draw("colz");
}
