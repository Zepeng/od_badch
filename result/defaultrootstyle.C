
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

void set_two_tone_scale() {
  cout << "Define two-tone scale." << endl;
  const Int_t NRGBs = 3;
  const Int_t NCont = 255;

  Double_t navy[]    = {0.0, 0.0, 0.5};
  Double_t white[]   = {1.0, 1.0, 1.0};
   Double_t scarlet[] = {1.0, 0.0, 0};

  Double_t Red[]    = {navy[0], white[0], scarlet[0]};
  Double_t Green[]  = {navy[1], white[0], scarlet[1]};
  Double_t Blue[]   = {navy[2], white[0], scarlet[2]};
  Double_t Length[] = {   0.00, 0.5, 1.00 };

  TColor::CreateGradientColorTable(NRGBs,Length,Red,Green,Blue,NCont);
}

int defaultrootstyle() {
  gStyle->SetPalette(1);
  //gStyle->SetOptStat(10);
  gStyle->SetOptStat(0);
  gStyle->SetTitleFontSize(0.12);
  gStyle->SetTitleX(0.1f);
  gStyle->SetTitleW(0.8f);
  gStyle->SetTitleXOffset(0.8);
  gStyle->SetTitleYOffset(0.4);
  gStyle->SetTitleXSize(0.08);
  gStyle->SetTitleYSize(0.13);
  gStyle->SetPadTopMargin(0.15);
  gStyle->SetPadBottomMargin(0.18);
  gStyle->SetPadLeftMargin(0.15);
  gStyle->SetPadRightMargin(0.15);
  gStyle->SetLabelSize(0.06, "X");
  gStyle->SetLabelSize(0.06, "Y");
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
  cout << "set default style." << endl;
  return 0;
}

TStyle* setT2KStyle() {

  TStyle *t2kStyle= new TStyle("T2K","T2K approved plots style");

  gStyle->SetPalette(1);

  // use plain black on white colors
  gStyle->SetFrameBorderMode(0);
  gStyle->SetCanvasBorderMode(0);
  gStyle->SetPadBorderMode(0);
  gStyle->SetPadColor(0);
  gStyle->SetCanvasColor(0);
  gStyle->SetStatColor(0);
  gStyle->SetFillColor(0);
  gStyle->SetLegendBorderSize(1); 

  // set the paper & margin sizes
  gStyle->SetPaperSize(20,26);
  gStyle->SetPadTopMargin(0.05);
  gStyle->SetPadRightMargin(0.05);
  gStyle->SetPadBottomMargin(0.16);
  gStyle->SetPadLeftMargin(0.12);

  // use large Times-Roman fonts
  gStyle->SetTextFont(132);
  gStyle->SetTextSize(0.08);
  gStyle->SetLabelFont(132,"x");
  gStyle->SetLabelFont(132,"y");
  gStyle->SetLabelFont(132,"z");
  gStyle->SetLabelSize(0.06,"x");
  gStyle->SetTitleSize(0.08,"x");
  gStyle->SetLabelSize(0.06,"y");
  gStyle->SetTitleSize(0.08,"y");
  gStyle->SetTitleOffset(1.0,"y");
  gStyle->SetLabelSize(0.05,"z");
  gStyle->SetTitleSize(0.06,"z");
  gStyle->SetLabelFont(132,"t");
  gStyle->SetTitleFont(132,"x");
  gStyle->SetTitleFont(132,"y");
  gStyle->SetTitleFont(132,"z");
  gStyle->SetTitleFont(132,"t"); 
  gStyle->SetTitleFillColor(0);
  gStyle->SetTitleX(0.25);
  gStyle->SetTitleFontSize(0.08);
  gStyle->SetTitleFont(132,"pad");

  // use bold lines and markers
  gStyle->SetMarkerStyle(20);
  gStyle->SetHistLineWidth(1.85);
  gStyle->SetLineStyleString(2,"[12 12]"); // postscript dashes

  // get rid of X error bars and y error bar caps
  //gStyle->SetErrorX(0.001);

  // do not display any of the standard histogram decorations
  gStyle->SetOptTitle(0);
  gStyle->SetOptStat(0);
  gStyle->SetOptFit(0);

  // put tick marks on top and RHS of plots
  gStyle->SetPadTickX(1);
  gStyle->SetPadTickY(1);


  // Add a greyscale palette for 2D plots
//   int ncol=50;
//   double dcol = 1./float(ncol);
//   double gray = 1;
//   TColor **theCols = new TColor*[ncol];
//   for (int i=0;i<ncol;i++) theCols[i] = new TColor(999-i,0.0,0.7,0.7);
//   for (int j = 0; j < ncol; j++) {
//     theCols[j]->SetRGB(gray,gray,gray);
//     gray -= dcol;
//   }
//   int ColJul[100];
//   for  (int i=0; i<100; i++) ColJul[i]=999-i;
//   gStyle->SetPalette(ncol,ColJul);

  // End of definition of gStyle
  set_plot_style();
  return gStyle;
}
