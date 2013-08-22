#include "TFile.h"
#include "TH2.h"
#include "TTree.h"
#include "TCanvas.h"
#include "THStack.h"
#include "TProfile.h"
#include "TMath.h"
void profile2D()
{
  //THStack* hs = new THStack("hs","nhitac histogram");
  TCanvas* c1 = new TCanvas("canvas","nhitac",800,1000);
  //c1->Divide(1,3);
  TPad*    upperPad = new TPad("upperPad", "upperPad", 
                           .30, .7, .70, .995);
  TPad*    middlePad = new TPad("middlePad", "middlePad", 
                               .005, .305, .995, .695);
  TPad*    lowerPad = new TPad("lowerPad", "lowerPad",
                                         .30, .005, .70, .300);

  upperPad->Draw();
  middlePad->Draw();
  lowerPad->Draw();

  TFile *file1 = new TFile("nhitac_m.root");
  TFile *file2 = new TFile("nhitac_u.root");
  
  TProfile2D  *top = new TProfile2D("top","nhitac_new/nhitac_old",60,-2000,2000, 60, -2000, 2000);
  TProfile2D  *barrel = new TProfile2D("barrel","nhitac_new/nhitac_old",60,-3.2,3.2, 60, -2000, 2000);
  TProfile2D  *bottom = new TProfile2D("bottom","nhitac_new/nhitac_old",60,-2000,2000, 60, -2000, 2000);

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
   
    if(odpos1[2] > 1864) top->Fill(odpos1[0], odpos1[1], (1.0*testnhitac1)/testnhitac2);
    else if(odpos1[2] < -1864) bottom->Fill(odpos1[0], odpos1[1], (1.0*testnhitac1)/testnhitac2);
    else barrel->Fill(TMath::ATan2(odpos1[1],odpos1[0]),odpos1[2], (1.0*testnhitac1)/testnhitac2);
  }
  //c1->cd(1);
  upperPad->cd();
  top->GetZaxis()->SetRangeUser(0.65, 1.85);
  top->GetXaxis()->SetTitle("X_pos_cluster(cm)");
  top->GetYaxis()->SetTitle("Y_pos_cluster(cm)");
  top->Draw("colz");
  //c1->cd(2);
  middlePad->cd();
  barrel->GetZaxis()->SetRangeUser(0.65, 1.85);
  barrel->GetXaxis()->SetTitle("Phi(radian)");
  barrel->GetYaxis()->SetTitle("Z_pos_cluster(cm)");
  barrel->Draw("colz");
  //c1->cd(3);
  lowerPad->cd();
  bottom->GetZaxis()->SetRangeUser(0.65, 1.85);
  bottom->GetXaxis()->SetTitle("X_pos_cluster(cm)");
  bottom->GetYaxis()->SetTitle("Y_pos_cluster(cm)");
  bottom->Draw("colz");
}
