#include "TFile.h"
#include "TH1.h"
#include "TTree.h"
#include "TCanvas.h"
#include "THStack.h"
void histo()
{
  //THStack* hs = new THStack("hs","nhitac histogram");
  TCanvas* c1 = new TCanvas("canvas","nhitac",800,600);
  TFile *file1 = new TFile("test_nhitac_modified.root");
  TH1F  *histo1 = new TH1F("nhitac1","nhitac1",60,0,300);
  //histo1->Sumw2();
  //histo1->SetMarkerStyle(23);
  //histo1->SetMarkerColor(kRed);
  TFile *file2 = new TFile("test_nhitac_unmodified.root");
  TH1F  *histo2 = new TH1F("nhitac","nhitac",60,0,300);
  histo2->SetMarkerStyle(31);
  //histo2->Sumw2();
  //histo2->SetFillColor(kBlue);
  TLegend *l1 = new TLegend(0.458, 0.460, 0.841, 0.723);
  l1->SetBorderSize(0);

  TTree* nhitac_modified = (TTree*)file1->Get("testnhitac");
  TTree* nhitac_unmodified = (TTree*)file2->Get("testnhitac");
  //TBranch* nhitac1 = nhitac_modified->GetBranch ("nhitac");
  int testnhitac1, testnhitac2;
  nhitac_modified->SetBranchAddress("nhitac",&testnhitac1);
  nhitac_unmodified->SetBranchAddress("nhitac",&testnhitac2);
  for(int i= 0; i < nhitac_modified->GetEntries(); i++)
  {
    nhitac_modified->GetEntry(i);
    nhitac_unmodified->GetEntry(i);
    //std::cout << testnhitac1  << std::endl;
    histo1->Fill(testnhitac1);
    histo2->Fill(testnhitac2);
  }
  //histo2->SetFillColor(kBlue);
  //histo2->SetFillStyle(3553);
  //histo1->SetMarkerStyle(23);
  histo1->SetMarkerColor(kRed);
  histo1->SetLineColor(kRed);
  l1->AddEntry(histo1,"modified od bad channel","l");
  l1->AddEntry(histo2,"old od bad channel","l");
  l1->SetTextSize(0.04);
  //hs->Add(histo1);
  //hs->Add(histo2);
  //hs->Draw();
  histo1->Draw("e1p");
  histo1->GetXaxis()->SetTitle("nhitac");
  histo1->GetYaxis()->SetTitle("event # per bin");
  histo2->Draw("same");
  l1->Draw();
}
