#include <iostream>
#include "TStyle.h"
#include "TColor.h"

void set_plot_style()
{
  const Int_t NRGBs = 5;
  const Int_t NCont = 255;

  Double_t stops[NRGBs] = { 0.00, 0.34, 0.61, 0.84, 1.00 };
  Double_t red[NRGBs]   = { 0.00, 0.00, 0.87, 1.00, 0.51 };
  Double_t green[NRGBs] = { 0.00, 0.81, 1.00, 0.20, 0.00 };
  Double_t blue[NRGBs]  = { 0.51, 1.00, 0.12, 0.00, 0.00 };
  TColor::CreateGradientColorTable(NRGBs, stops, red, green, blue, NCont);
  gStyle->SetNumberContours(NCont);
}

int defaultrootstyle() {

  gStyle->SetPalette(1);
  gStyle->SetOptStat(0);
  gStyle->SetTitleFontSize(0.12);
  gStyle->SetTitleX(0.1f);
  gStyle->SetTitleW(0.8f);
  gStyle->SetTitleXOffset(0.8);
  gStyle->SetTitleYOffset(0.4);
  gStyle->SetTitleXSize(0.10);
  gStyle->SetTitleYSize(0.13);
  gStyle->SetPadTopMargin(0.15);
  gStyle->SetPadBottomMargin(0.18);
  gStyle->SetPadLeftMargin(0.10);
  gStyle->SetPadRightMargin(0.05);
  gStyle->SetLabelSize(0.08, "X");
  gStyle->SetLabelSize(0.08, "Y");
  gStyle->SetStatFontSize(0.3);
  gStyle->SetNdivisions(505, "X");
  gStyle->SetNdivisions(505, "Y");
  gStyle->SetStatY(0.83);
  gStyle->SetStatX(0.85);
  gStyle->SetStatW(0.15);
  gStyle->SetStatH(0.15);
  gStyle->SetStatBorderSize(0);
  gStyle->SetStatColor(0);
  gStyle->SetTitleBorderSize(0);
  gStyle->SetTitleFillColor(0);
  gStyle->SetFrameFillColor(kWhite);
  gStyle->SetFrameLineWidth(2);
  gStyle->SetCanvasColor(kWhite);
  gStyle->SetPadBorderSize(2);

  set_plot_style();
  std::cout << "set default style." << std::endl;
  return 0;
}

