#include "TFile.h"
#include "TH1.h"
#include "TTree.h"
#include "TCanvas.h"
#include "THStack.h"
#include "TProfile.h"

void profile()
{
  TCanvas* c1 = new TCanvas("canvas","nhitac",1200,600);
  c1->Divide(2,1);
  c1->cd(1);
  TFile *file1 = new TFile("nhitac_m.root");
  //TH1F  *histo1 = new TH1F("nhitac1","nhitac1",60,0,300);
  TProfile *profile1 = new TProfile("profile","nhitac profile",100,0,100,0,300);

  TFile *file2 = new TFile("nhitac_u.root");
  //TH1F  *histo2 = new TH1F("nhitac","nhitac",60,0,300);
  TProfile *profile2 = new TProfile("profile2","nhitac profile2",100,0,100,0,300);
  TProfile *ratio = new TProfile("ratio","nhitac ratio", 100,0,100,0,2);
  //histo2->SetMarkerStyle(31);
  TLegend *l1 = new TLegend(0.20, 0.60, 0.3, 0.7);
  l1->SetBorderSize(0);

  TTree* nhitac_modified = (TTree*)file1->Get("testnhitac");
  TTree* nhitac_unmodified = (TTree*)file2->Get("testnhitac");
  int testnhitac1, testnhitac2;
  nhitac_modified->SetBranchAddress("nhitac",&testnhitac1);
  nhitac_unmodified->SetBranchAddress("nhitac",&testnhitac2);
  for(int i= 0; i < nhitac_modified->GetEntries(); i++)
  {
    nhitac_modified->GetEntry(i);
    nhitac_unmodified->GetEntry(i);
    profile1->Fill(i,testnhitac1);
    profile2->Fill(i,testnhitac2);
    double temp = testnhitac2;
    ratio->Fill(i,testnhitac1/temp);
    //histo1->Fill(testnhitac1);
    //histo2->Fill(testnhitac2);
  }
  //histo1->SetMarkerColor(kRed);
  //histo1->SetLineColor(kRed);
  profile1->SetMarkerColor(kRed);
  profile1->SetMarkerStyle(5);
  profile2->SetMarkerColor(kBlue);
  l1->AddEntry(profile1,"modified od bad channel","P");
  l1->AddEntry(profile2,"old od bad channel","l");
  l1->SetTextSize(0.04);
  profile1->Draw("e1p");
  profile1->GetXaxis()->SetTitle("event #");
  profile1->GetYaxis()->SetTitle("nhitac");
  profile2->Draw("same");
  l1->Draw();
  c1->cd(2);
  ratio->GetXaxis()->SetTitle("event #");
  ratio->GetYaxis()->SetTitle("new/old");
  //ratio->SetMarkerStyle(5);
  //ratio->SetMarkerColor(kRed);
  ratio->Draw();
}
