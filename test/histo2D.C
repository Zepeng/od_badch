#include "TFile.h"
#include "TH2.h"
#include "TTree.h"
#include "TCanvas.h"
#include "THStack.h"

void histo2D()
{
  //THStack* hs = new THStack("hs","nhitac histogram");
  TCanvas* c1 = new TCanvas("canvas","nhitac",800,600);
  TFile *file1 = new TFile("test_nhitac_modified.root");
  TH2F  *histo1 = new TH2F("nhitac_new/nhitac_old","nhitac_new/nhitac_old",60,-3000,3000, 60, -3000, 3000);
  //histo1->Sumw2();
  //histo1->SetMarkerStyle(23);
  //histo1->SetMarkerColor(kRed);
  TFile *file2 = new TFile("test_nhitac_unmodified.root");
  TH2F  *histo2 = new TH2F("nhitac","nhitac",60,-3000,3000, 60, -3000, 3000);
  histo2->SetMarkerStyle(31);
  //histo2->Sumw2();
  //histo2->SetFillColor(kBlue);
  TLegend *l1 = new TLegend(0.458, 0.460, 0.841, 0.723);
  l1->SetBorderSize(0);

  TTree* nhitac_modified = (TTree*)file1->Get("testnhitac");
  TTree* nhitac_unmodified = (TTree*)file2->Get("testnhitac");
  //TBranch* nhitac1 = nhitac_modified->GetBranch ("nhitac");
  int testnhitac1, testnhitac2;
  float odpos1[3], odpos2[3];
  nhitac_modified->SetBranchAddress("nhitac",&testnhitac1);
  nhitac_unmodified->SetBranchAddress("nhitac",&testnhitac2);
  nhitac_modified->SetBranchAddress("odpos",odpos1);
  nhitac_unmodified->SetBranchAddress("odpos",odpos2);

  for(int i= 0; i < nhitac_modified->GetEntries(); i++)
  {
    nhitac_modified->GetEntry(i);
    nhitac_unmodified->GetEntry(i);
    std::cout << i <<  "______________________" << std::endl;
    std::cout << (1.0*testnhitac1)/testnhitac2 << std::endl;
    if(testnhitac1 > testnhitac2)
    {
      std::cout << testnhitac1 << odpos1[0] << std::endl;
      std::cout << testnhitac2 << odpos2[0] << std::endl;
    }
    //histo1->Fill(odpos1[0], odpos1[1], (1.0*testnhitac1)/testnhitac2);
    histo1->Fill(odpos1[0], odpos1[1]);
    //histo1->Fill(testnhitac1);
    //histo2->Fill(testnhitac2);
  }
  histo1->Draw("colz");
  histo1->GetXaxis()->SetTitle("X_pos_cluster(cm)");
  histo1->GetYaxis()->SetTitle("Y_pos_cluster(cm)");
}
