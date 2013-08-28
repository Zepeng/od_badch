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
  
  TH2F *top = new TH2F("top","nhitac_new/nhitac_old",100,-2000,2000, 100, -2000, 2000);
  TH2F  *barrel = new TH2F("barrel","nhitac_new/nhitac_old",100,-3.2,3.2, 100, -2000, 2000);
  TH2F  *bottom = new TH2F("bottom","nhitac_new/nhitac_old",100,-2000,2000, 100, -2000, 2000);

  TLegend *l1 = new TLegend(0.458, 0.460, 0.841, 0.723);
  l1->SetBorderSize(0);

  TTree* nhitac_modified = (TTree*)file1->Get("testnhitac");
  TTree* nhitac_unmodified = (TTree*)file2->Get("testnhitac");
  
  int testnhitac1, testnhitac2;
  int volume1, volume2;
  float odpos1[3], odpos2[3];
  nhitac_modified->SetBranchAddress("nhitac",&testnhitac1);
  nhitac_unmodified->SetBranchAddress("nhitac",&testnhitac2);
  nhitac_modified->SetBranchAddress("odpos",odpos1);
  nhitac_unmodified->SetBranchAddress("odpos",odpos2);
  nhitac_modified->SetBranchAddress("volume",&volume1);
  nhitac_unmodified->SetBranchAddress("volume",&volume2);

  float min = 1;
  float max = 0;
  for(int i= 0; i < nhitac_modified->GetEntries(); i++)
  {
    nhitac_modified->GetEntry(i);
    nhitac_unmodified->GetEntry(i);
    if(testnhitac1 > 10 && volume1 == 2)
    {
        
      if((1.0*testnhitac1)/testnhitac2 > max) max = (1.0*testnhitac1)/testnhitac2;
      if((1.0*testnhitac1)/testnhitac2 < min) min = (1.0*testnhitac1)/testnhitac2;
   
    
      if(odpos1[2] > 1864) top->Fill(odpos1[0], odpos1[1]);
      else if(odpos1[2] < -1864) bottom->Fill(odpos1[0], odpos1[1]);
      else 
      {
        float Phi = TMath::ATan2(odpos1[1],odpos1[0]) - TMath::ATan2(0.66976, -0.74218);
        if(Phi < -1*TMath::Pi()) Phi = Phi + 2*TMath::Pi();
        barrel->Fill(Phi,odpos1[2]);
      }
    }
  }

  std::cout << min << std::endl;
  std::cout << max << std::endl;
  
  const Int_t NRGBs = 3;
  const Int_t NCont = 255;

  Double_t navy[]    = {0.0, 0.0, 0.5};
  Double_t white[]   = {1.0, 1.0, 1.0};
  Double_t scarlet[] = {1.0, 0.0, 0};

  Double_t Red[]    = {navy[0], white[0], scarlet[0]};
  Double_t Green[]  = {navy[1], white[0], scarlet[1]};
  Double_t Blue[]   = {navy[2], white[0], scarlet[2]};
  Double_t Length[] = {   0.00, 0.5, 1.00 };

  //TColor::CreateGradientColorTable(NRGBs,Length,Red,Green,Blue,NCont);


  //c1->cd(1);
  upperPad->cd();
  //top->GetZaxis()->SetRangeUser(0.3, 1.7);
  top->GetXaxis()->SetTitle("X_pos_cluster(cm)");
  top->GetYaxis()->SetTitle("Y_pos_cluster(cm)");
  top->Draw("colz");
  //c1->cd(2);
  middlePad->cd();
  //barrel->GetZaxis()->SetRangeUser(0.3, 1.7);
  barrel->GetXaxis()->SetTitle("Phi(radian)");
  barrel->GetYaxis()->SetTitle("Z_pos_cluster(cm)");
  barrel->Draw("colz");
  //c1->cd(3);
  lowerPad->cd();
  //bottom->GetZaxis()->SetRangeUser(0.3, 1.7);
  bottom->GetXaxis()->SetTitle("X_pos_cluster(cm)");
  bottom->GetYaxis()->SetTitle("Y_pos_cluster(cm)");
  bottom->Draw("colz");
}
