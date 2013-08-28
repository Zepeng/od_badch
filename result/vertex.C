#include "TFile.h"
#include "TH2.h"
#include "TTree.h"
#include "TCanvas.h"
#include "THStack.h"
#include "TProfile.h"
#include "TMath.h"
void vertex()
{
  //THStack* hs = new THStack("hs","nhitac histogram");
  TCanvas* c1 = new TCanvas("canvas","nhitac",1000,500);
  c1->Divide(2,1);

  TFile *file1 = new TFile("nhitac_m.root");
  TFile *file2 = new TFile("nhitac_u.root");
  
  TH2F  *xvsy = new TH2F("xyview","xyview",50,-3000,3000, 50 , -3000, 3000);
  TH2F  *zvsr = new TH2F("zrview","zrview",50,0,3000, 50 , -3000, 3000);

  
  TLegend *l1 = new TLegend(0.458, 0.460, 0.841, 0.723);
  l1->SetBorderSize(0);

  TTree* TVertex = (TTree*)file1->Get("vertex");

  float vertex1[3], vertex2[3];
  TVertex->SetBranchAddress("vertex",vertex1);
  //TVertex->SetBranchAddress("nhitac",&testnhitac2);

  std::cout << TVertex->GetEntries() << std::endl;
  for(int i= 0; i < TVertex->GetEntries(); i++)
  {                            
    TVertex->GetEntry(i);
    xyview->Fill(vertex1[0],vertex1[1],1);
    zrview->Fill(TMath::Sqrt(vertex1[0]*vertex1[0] + vertex1[1]*vertex1[1]), vertex1[2],1);
  }
  c1->cd(1);
  xyview->GetXaxis()->SetTitle("X_pos(cm)");
  xyview->GetYaxis()->SetTitle("Y_pos(cm)");
  xyview->Draw("colz");

  c1->cd(2);
  zrview->GetXaxis()->SetTitle("R(cm)");
  zrview->GetYaxis()->SetTitle("Z_pos(cm)");
  zrview->Draw("colz");
}
