/* $Id: anticalsk.c,v 1.15 2007/01/06 10:52:35 skrep Exp $ */

/* 
$Log: anticalsk.c,v $
Revision 1.15  2007/01/06 10:52:35  skrep
Remove klugey swap-fix code, and replace with more general code that keeps track of OD PMT map versions.  New files in skam/const needed:  odmap_version, pmtmapx.anti

Revision 1.14  2006/10/15 14:45:04  skrep
Add routine to decode Shige's new laser word, + Fortran wrapper.  --KS.

Revision 1.13  2004/01/21 10:38:54  kate
Allow for different tqa filename format.

Revision 1.12  2004/01/18 10:03:03  kate
Add wrapper for Fortran for read_tqaconst

Revision 1.11  2003/04/30 18:59:21  kate
Fix for less forgiving compiler.

Revision 1.10  2003/04/30 18:51:30  schol
Add useful function for getting channel map.

Revision 1.9  2003/01/08 10:57:46  kate
Add some routines useful for OD calibration.

Revision 1.8  1998/12/04 09:52:04  tomba
Remove debug output left out by mistake, oops...

Revision 1.7  1998/12/04 09:25:52  tomba
Replaced hardcoded locations of OD calibration files and OD connection table
with call to findconst.

Revision 1.6  1998/09/24 22:44:54  atsuko
Fixed a bug in cvanti, so that read_tqaconst is called every time
tqa calibration version changes.

Revision 1.5  1998/09/16 02:53:42  atsuko
Fixed a minor bug in the function tqaver.

Revision 1.4  1997/08/01 04:17:20  superk
Finally fixed the log comment stuff.

*/

/*
 * antical.c:  Functions for manipulating anti-counter data.
 *
 * 1996.03.01	Created --johnf
 */
#include <stdio.h>
#include <sys/types.h>
#include <string.h>
#include <math.h>
#include <unistd.h>

#include "anticalsk.h"

#define OK 0

#define TQAVER_FILE "tqa_version"
#define MAXTQAVERSIONS 1000

#define ODMAPVER_FILE "odmap_version"
#define MAXODMAPVERSIONS 1000

#define MAX_FILENAME_LEN 1024

/*
 * Find calibration version from tqa_version file, given the run
 * number.  err_ret = 0, unless there is some error.
 */
tqaver_(int *run, int *icalva, int *err_ret)
{
  char tqaver_file_name[MAX_FILENAME_LEN];
  FILE *tqaver_file;
  static int tqaver_read = 0;
  static int tqa_ver = 11;
  static int versions = 0, runnum[MAXTQAVERSIONS], vernum[MAXTQAVERSIONS];
  int i, tmprun;
  char scanline[2 * MAXCHAR];

  if (!tqaver_read)
    {
      runnum[0] = 0;
      vernum[0] = 0;
      
      findfile(tqaver_file_name, TQAVER_FILE, 
	       "SKPATH", ConstDirC, MAX_FILENAME_LEN);

      if (strlen(tqaver_file_name)<=0) 
	{
	  fprintf(stderr, "Can't find file '%s'\n", TQAVER_FILE);
	  exit (1);
	}
      if (!(tqaver_file = fopen(tqaver_file_name, "r")))
	{
	  fprintf (stderr, "Can't open file '%s'\n", tqaver_file_name);
	  exit (1);
	}

      versions = 0;
      while ((scanline == fgets(scanline, MAXCHAR, tqaver_file)) &&
	     !feof(tqaver_file) && !ferror(tqaver_file) &&
	     (versions < MAXTQAVERSIONS))
	{
	  /*
	   * Ignore comments:
	   */
	  if (';' == scanline[0])
	    continue;

	  /*
	   * Read run, and calibration version which starts
	   * with that run:
	   */
	  if (2 == sscanf(scanline,"%d %d",
			  &runnum[versions],&vernum[versions]))
	    {
	      ++versions;
	    }
	}

      fclose(tqaver_file);
      tqaver_read = 1;
    }

  /*
   * Find the tqa version which goes with this run:
   */
  tmprun = -99999;
  *icalva = -99999;
  for (i = 0; i < versions; i++)
    {
      if (runnum[i] < tmprun)
	continue;

      if (runnum[i] <= *run)       /* Added = sign -- AK */
	{
	  *icalva = vernum[i];
	  tmprun = runnum[i];
	}
    }

  if (-99999 == *icalva)
    *err_ret = -1;
  else
    *err_ret = 0;

  return *icalva;
}

/*
 * Find calibration version from tqa_version file, given the run
 * number.  err_ret = 0, unless there is some error.
 */
odmapver_(int *run, int *imapa, int *err_ret)
{
  char odmapver_file_name[MAX_FILENAME_LEN];
  FILE *odmapver_file;
  static int odmapver_read = 0;
  static int versions = 0, runnum[MAXODMAPVERSIONS], vernum[MAXODMAPVERSIONS];
  int i, tmprun;
  char scanline[2 * MAXCHAR];

  if (!odmapver_read)
    {
      runnum[0] = 0;
      vernum[0] = 0;
      
      findfile(odmapver_file_name, ODMAPVER_FILE, 
	       "SKPATH", ConstDirC, MAX_FILENAME_LEN);
      if (strlen(odmapver_file_name)<=0) 
	{
	  fprintf(stderr, "Can't find file '%s'\n", ODMAPVER_FILE);
	  exit (1);
	}
      if (!(odmapver_file = fopen(odmapver_file_name, "r")))
	{
	  fprintf (stderr, "Can't open file '%s'\n", odmapver_file_name);
	  exit (1);
	}

      versions = 0;
      while ((scanline == fgets(scanline, MAXCHAR, odmapver_file)) &&
	     !feof(odmapver_file) && !ferror(odmapver_file) &&
	     (versions < MAXODMAPVERSIONS))
	{
	  /*
	   * Ignore comments:
	   */
	  if (';' == scanline[0])
	    continue;

	  /*
	   * Read run, and calibration version which starts
	   * with that run:
	   */
	  if (2 == sscanf(scanline,"%d %d",
			  &runnum[versions],&vernum[versions]))
	    {
	      ++versions;
	    }
	}

      fclose(odmapver_file);
      odmapver_read = 1;
    }

  /*
   * Find the map version which goes with this run:
   */
  tmprun = -99999;
  *imapa = -99999;

  for (i = 0; i < versions; i++)
    {
      fflush(stdout);
      if (runnum[i] < tmprun)
	continue;

      if (runnum[i] <= *run)       /* Added = sign -- AK */
	{
	  *imapa = vernum[i];
	  tmprun = runnum[i];
	}
    }

  if (-99999 == *imapa)
    *err_ret = -1;
  else
    *err_ret = 0;

  return *imapa;
}


/* Return channel map */

void channel_map_(int* imapa, int* channels){

  /* Return list of tdc channels corresponding to pmt cable numbers */


  static ANTIPMTMAP	  antipmtmap;
  int cable;

  read_antipmtmap(*imapa, &antipmtmap);

  for (cable=0;cable<NUM_ANTI_PMTS;cable++)
    {
     channels[cable] = antipmtmap.cable_num_to_tdc_ch[cable];
    }

}


/* Return raw t and q values for use in calibration code */

void rawodtq_(int* imapa, ANTICRATEBUF *anticratebuf, ANTIRAWHITSBUF *antirawhitsbuf, int *err_ret)
{

  /* Note: does not check for change of imapa.  Use with caution */
  static ANTIPMTMAP	  antipmtmap;
  static int mapread = 0;

  if (!mapread)
    {
      read_antipmtmap(*imapa, &antipmtmap);
      mapread = 1;
    } 


  /* Convert to real data */
  if (extract_tdc(anticratebuf, &antipmtmap, antirawhitsbuf))
    {
      *err_ret = 1;
      return;
    }

  return;
}


/* 
 * Read raw TDC info., calibrate it by reading tqa constants 
 * to be returned to tqask
 */

void cvanti_(ANTICRATEBUF *anticratebuf, TQAREALENTRY tqarealbuf[], int 
*nrhit, int *icalva, int *imapa, int *err_ret)
{

  int i;
  int ipbank, ndata, segnum;
  int ibuf[10];
  /* Header size of segment number 0 of TQREAL bank */
  int iszhd = 1;
  int itqarhd[1];
  int nent, three = 3, ldat;
  extern int *izbs_;

  static ANTIPMTMAP	  antipmtmap;
  ANTIRAWHITSBUF  antirawhitsbuf;
  ANTIREALHITSBUF antirealhitsbuf;

  static TQACONST tqaconst[NUM_TDC_CH];

  static int mapread = 0;
  static int tqaconstread = 0;
  static int oldicalva = 0;
  static int oldimapa = 0;

  *nrhit = 0;
  *err_ret = 0;
   
  /*
   * Open input and output files:
   */

  /*
   * Call read_antipmtmap only when imapa changes.
   */
  if (oldimapa != *imapa)
    mapread = 0;

  if (!mapread)
    {
      read_antipmtmap(*imapa, &antipmtmap);
      mapread = 1;
    }
  oldimapa = *imapa;

  /*
   * Call read_tqaconst only when icalva changes.
   */

  if (oldicalva != *icalva)
    tqaconstread = 0;

  if (!tqaconstread)
    {
     read_tqaconst(*icalva, &tqaconst[0]);
     tqaconstread = 1;
     }
  oldicalva = *icalva;

  /* Convert to real data */
  if (extract_tdc(anticratebuf, &antipmtmap, &antirawhitsbuf))
    {
      *nrhit = 0;
      *err_ret = 1;
      return;
    }
#ifdef VERBOSE
  printf("Extracted Anti- data.\n");fflush(stdout);
#endif/*VERBOSE*/

  /*dump_anti_hits(&antirawhitsbuf);*/

  calibrate_anti_hits(&antirawhitsbuf, &antirealhitsbuf, 
		      &tqaconst[0], *icalva, &antipmtmap);

  nent = antirealhitsbuf.num_hits;
      
  if (nent <= 0)
    return;
  
  for (i = 0; i < nent; i++)
    {
      tqarealbuf[i].cable  = antirealhitsbuf.cable[i];
      tqarealbuf[i].cable |= antirealhitsbuf.onl_filt_flags[i];
      tqarealbuf[i].cable |= antirealhitsbuf.ofl_filt_flags[i];

      tqarealbuf[i].t     = antirealhitsbuf.t[i];
      tqarealbuf[i].q     = antirealhitsbuf.q[i];
    }

  *nrhit = nent;
  return;
}

/* Wrapper for Fortran */
void
read_tqaconst_(int *icalva, TQACONST *tqaconst){
  read_tqaconst(*icalva, tqaconst);
}

void
read_tqaconst(int icalva, TQACONST *tqaconst)
{
  int channel;
  float tqatmp[11];
  FILE *tqafile;
  char tqaname[MAXCHAR];
  char tqa_file_name[MAX_FILENAME_LEN];
  int i;
   
  sprintf(tqaname, "tqa_%02d", icalva);
  findfile(tqa_file_name, tqaname, 
	   "SKPATH", ConstDirC, MAX_FILENAME_LEN);
  if (strlen(tqa_file_name)<=0) 
    {

      /* Try a different filename format if this one can't be found */

      sprintf(tqaname, "tqa_%06d", icalva);
      findfile(tqa_file_name, tqaname, 
	   "SKPATH", ConstDirC, MAX_FILENAME_LEN);

      if (strlen(tqa_file_name)<=0)
	{
	  fprintf(stderr, "Can't find file '%s'\n", tqaname);
	  exit (1);
	}
    }
  if (!(tqafile = fopen(tqa_file_name, "r")))
    {
      fprintf (stderr, "Can't open file '%s'\n", tqa_file_name);
      exit (1);
    }

  printf("read_tqaconst:  Anti-calibration version %d (%s)\n", 
	 icalva, tqa_file_name);
  fflush(stdout);

  for (i = 0; i < NUM_TDC_CH; i++)
    tqaconst[i].status = -1;

  while (12 == fscanf(tqafile, 
		      "%d %f %f %f %f %f %f %f %f %f %f %f",
		      &channel,
		      &tqatmp[0], &tqatmp[1], &tqatmp[2],
		      &tqatmp[3], &tqatmp[4], &tqatmp[5],
		      &tqatmp[6], &tqatmp[7], &tqatmp[8],
		      &tqatmp[9], &tqatmp[10]))
    {
      if ((0 > channel) || (NUM_TDC_CH <= channel))
	continue;

      for (i = 0; i < 11; i++)
	*(((float *)&tqaconst[channel].status) + i) =
	  tqatmp[i];

      /*
      printf("%d %f %f %f %f %f %f %f %f %f %f %f\n",
		      channel,
		      tqatmp[0], tqatmp[1], tqatmp[2],
		      tqatmp[3], tqatmp[4], tqatmp[5],
		      tqatmp[6], tqatmp[7], tqatmp[8],
		      tqatmp[9], tqatmp[10]);
		      */
    }
}


void
read_antipmtmap(int imapa, ANTIPMTMAP *ptr)
{
  FILE	*antipmtmap_file;
  u_int crate, tdc, channel;
  int i, j, k;

  int pmtno;
  char loc[MAXCHAR], supermod[MAXCHAR], ab[MAXCHAR];
  int pmtid, hut, padcr, padcd, padch, hvcd, hvch;
  int fecr, femod, feconn, fechann, tdccr, tdcmod, tdcchan, tubeid;
  char tbw[MAXCHAR];
  int hut2;
  char supermod2[MAXCHAR]; 
  char scanline[2 * MAXCHAR];
  float x, y, z, xcos, ycos, zcos;
  unsigned int channel_number;
  char antipmtmap_file_name[MAX_FILENAME_LEN];
  char antipmtmap_name[MAX_FILENAME_LEN];

  /* I hope there will not be too many maps */
  sprintf(antipmtmap_name,"pmtmap%01d.anti",imapa);

  /*  findfile(antipmtmap_file_name, ANTIPMTMAP_FILE, 
      "SKPATH", ConstDirC, MAX_FILENAME_LEN); */

  findfile(antipmtmap_file_name, antipmtmap_name, 
      "SKPATH", ConstDirC, MAX_FILENAME_LEN); 
  if (strlen(antipmtmap_file_name)<=0) 
    {
      fprintf(stderr, "Can't find file '%s'\n", ANTIPMTMAP_FILE);
      exit (1);
    }
  if (!(antipmtmap_file = fopen(antipmtmap_file_name, "r")))
    {
      fprintf (stderr, "Can't open file '%s'\n", antipmtmap_file_name);
      exit (1);
    }

  printf("Successfully opened antipmtmap file '%s'\n", antipmtmap_file_name);
  fflush(stdout);

  for (i = 0; i <= MAX_TDC_CH; i++)
    {
      ptr->tdc_ch_to_cable_num[i] = NULL_CABLE;
      ptr->cable_num_to_tdc_ch[i] = NULL_CABLE;
    }

  while ((scanline == fgets(scanline, MAXCHAR, antipmtmap_file)) &&
	  !feof(antipmtmap_file) && !ferror(antipmtmap_file))
    {
      if (28 == sscanf(scanline,
		       "%d %s %s %s %d %d %d %d %d %d %d %d %d %d %d %d "
		       "%d %d %d %s %d %s %g %g %g %g %g %g", 
		       &pmtno, loc, supermod, ab, &pmtid, &hut, 
		       &padcr, &padcd, &padch, 
		       &hvcd, &hvch, 
		       &fecr, &femod, &feconn, &fechann,
		       &tdccr, &tdcmod, &tdcchan,
		       &tubeid, tbw, &hut2, supermod2, 
		       &x, &y, &z, &xcos, &ycos, &zcos))
	{
	  
	  /*
	  fprintf(stdout,"cable:  %d, crate:  %d, tdc:  %d, ch: %d\n", 
		  tubeid, tdccr, tdcmod, tdcchan);
	  fflush(stdout);
	  */
	  
	  if ((0 > tdccr) || (3 < tdccr))
	    {
	      fprintf(stderr, "Illegal tdccr! (tubeid = %d, tdccr = %d, "
		      "tdcmod = %d, tdcchan = %d)\n",
		      tubeid, tdccr, tdcmod, tdcchan);
	      continue;
	    }
	  
	  if (95 < tdcchan) 
	    {
	      fprintf(stderr, "Illegal tdcchan! (tubeid = %d, tdccr = %d, "
		      "tdcmod = %d, tdcchan = %d)\n",
		      tubeid, tdccr, tdcmod, tdcchan);
	      continue;
	    }
	  
	  switch(tdcmod)
	    {
	    case 0:
	    case 1:
	    case 2:
	    case 3:
	    case 4:
	      channel_number = tdcchan + 96 * (tdcmod + 5 * tdccr);
	      ptr->tdc_ch_to_cable_num[channel_number] = tubeid;
	      break;
	    default:
	      fprintf(stderr, 
		      "Illegal tdcmod! (tubeid = %d, tdccr = %d, "
		      "tdcmod = %d, tdcchan = %d)\n", 
		      tubeid, tdccr, tdcmod, tdcchan);
	      break;
	    }
	  
	  ptr->tdccr[tubeid - ANTI_OFFSET] = tdccr;
	  ptr->cable_num_to_tdc_ch[tubeid - ANTI_OFFSET] = channel_number;
	}
    }
  
  fclose(antipmtmap_file);
  
  return;
}


/*
 * Decode raw hit data from crate buf, put it into raw hits buf.
 * Return OK on success, 1 for corrupted event.
 */
AC_STATUS
extract_tdc(ANTICRATEBUF *ptr, ANTIPMTMAP *map_ptr, ANTIRAWHITSBUF *hits_ptr)
{
  int total_length = ptr->header.data_size;
  u_int *cur_ptr = (u_int *)&(ptr->header.utc_info);
  int word_count = 0;
  unsigned long latched_event_count;
  unsigned long geographic_address;
  unsigned long channel_number, packed_chan;
  unsigned long prev_channel_number;
  unsigned long trailing_edge;
  unsigned long leading_edge;
  unsigned long sign, time, t, q;
  int tdccr, tdcmod, tdcchan;
  u_int cable_number;
  float x, y, z;
  int i, good_hits;
  int num_hits;
  float t_offset;


  hits_ptr->event_number = ptr->header.event_number;
  num_hits = (ptr->header.data_size - sizeof(ANTIHEADER))/sizeof(ANTITDCDAT);
  hits_ptr->num_hits = 0;


#ifdef VERBOSE
  printf("Event number: %d\n", ptr->header.event_number);
#endif/*VERBOSE*/


#ifdef VERBOSE
  printf("Total length:  %d\n", ptr->header.data_size);
  printf("UTC Info:  0x%.8x\n",ptr->header.utc_info);
  printf("Number of hits (good and bad):  %d\n", num_hits);
#endif/*VERBOSE*/

  hits_ptr->run_number = ptr->header.run_number;
#ifdef VERBOSE
  printf("Run: %d\n", hits_ptr->run_number);
#endif/*VERBOSE*/

  for (i = 0; i < 4; i++)
    {
      hits_ptr->t0[i] = ptr->header.itdct0[i];
#ifdef VERBOSE
      printf("t0[%d] = %d\n", i, hits_ptr->t0[i]);
#endif/*VERBOSE*/
    }

  
  for (i = 0, good_hits = 0; i < num_hits; i++)
    {
      /*
       * Toss the padding words (0xffff for channel number)
       */
      if (0xffff == ptr->tdcdat[i].pmt_number)
	continue;

      hits_ptr->onl_filt_flags[good_hits] = ((unsigned int)
					     (ptr->tdcdat[i].pmt_number & 
					      RAWANTI_ONL_FILT_MASK));

      hits_ptr->onl_filt_flags[good_hits] <<= 5;

#ifdef VERBOSE
      printf("onl flags (%d) = %0.4x chan: %0.4x\n", 
	     good_hits, hits_ptr->onl_filt_flags[good_hits],
	     ptr->tdcdat[i].pmt_number);
#endif/*VERBOSE*/

      hits_ptr->ofl_filt_flags[good_hits] = 0;

      packed_chan   = (ptr->tdcdat[i].pmt_number & ONL_CHANNEL_MASK);



#ifdef VERBOSE
      printf("tdccr: %d, tdcmod: %d, channel_number: %d  "
	     "(packed: %d (0x%.4x))\n",
	     tdccr, tdcmod, channel_number, packed_chan, packed_chan);
      fflush(stdout);
#endif/*VERBOSE*/


      cable_number = map_ptr->tdc_ch_to_cable_num[packed_chan];
      hits_ptr->cable[good_hits] = cable_number;
      if ((NULL_CABLE == cable_number) ||
	  (ANTI_OFFSET > cable_number) ||
	  ((ANTI_OFFSET + NUM_ANTI_PMTS - 1) < cable_number))
	{
	  hits_ptr->ofl_filt_flags[good_hits] |= OFL_FILT_BADCABLE;
	  hits_ptr->cable[good_hits] = packed_chan;
	}
      else
	hits_ptr->tdccr[good_hits] = packed_chan / 480;
						


#ifdef VERBOSE
      printf("Cable number = ");fflush(stdout);
      printf("%d, Channel number = %d\n", cable_number, packed_chan);
      fflush(stdout);

      printf("Chan:  0x%.4x (%d)  Trail:  0x%.4x  Lead:  0x%.4x\n",
	     ptr->tdcdat[i].pmt_number,
	     ptr->tdcdat[i].pmt_number,
	     ptr->tdcdat[i].trailing_edge,
	     ptr->tdcdat[i].leading_edge);
      fflush(stdout);
#endif/*VERBOSE*/


      /* Missing edge?  Mark the hit */
      if (0 == ptr->tdcdat[i].trailing_edge)
	hits_ptr->ofl_filt_flags[good_hits] |= OFL_FILT_BADTRAIL;


#ifdef VERBOSE
      printf("Trailing edge ok.\n");fflush(stdout);
#endif/*VERBOSE*/


      if (0 == ptr->tdcdat[i].leading_edge)
	hits_ptr->ofl_filt_flags[good_hits] |= OFL_FILT_BADLEAD;


#ifdef VERBOSE
      printf("Leading edge ok.\n");fflush(stdout);
#endif/*VERBOSE*/


      /* Bad hit?  Toss the event */
      if ((ptr->tdcdat[i].trailing_edge < ptr->tdcdat[i].leading_edge) &&
	  !(hits_ptr->ofl_filt_flags[good_hits] & OFL_FILT_BADLEAD) &&
	  !(hits_ptr->ofl_filt_flags[good_hits] & OFL_FILT_BADTRAIL))
	hits_ptr->ofl_filt_flags[good_hits] |= OFL_FILT_BADORDER;


#ifdef VERBOSE
      printf("Edge order ok.\n");fflush(stdout);
#endif/*VERBOSE*/

      if (hits_ptr->ofl_filt_flags[good_hits] & OFL_FILT_BADLEAD)
	{
	  t = ptr->tdcdat[i].trailing_edge;
	  q = 0;
	}
      else if (hits_ptr->ofl_filt_flags[good_hits] & OFL_FILT_BADTRAIL)
	{
	  t = ptr->tdcdat[i].leading_edge;
	  q = 0;
	}
      else if (hits_ptr->ofl_filt_flags[good_hits] & OFL_FILT_BADORDER)
	{
	  t = ptr->tdcdat[i].leading_edge;
	  q = 0;
	}
      else
	{
	  t = ptr->tdcdat[i].leading_edge;
	  leading_edge = ptr->tdcdat[i].leading_edge;
	  trailing_edge = ptr->tdcdat[i].trailing_edge;
	  q = trailing_edge - leading_edge;
	}

      hits_ptr->t[good_hits] = t;
      hits_ptr->q[good_hits] = q;


#ifdef VERBOSE
      printf("Flags: %d,  Cable:  %d  T:  %d  Q:  %d\n",
	     hits_ptr->hit_flags[good_hits], 
	     hits_ptr->cable[good_hits],
	     hits_ptr->t[good_hits],
	     hits_ptr->q[good_hits]);
      fflush(stdout);
#endif/*VERBOSE*/

      /*
       * Look for special-purpose channels:
       */
      tdccr  = packed_chan / 480;
      tdcmod = (packed_chan - (480 * tdccr)) / 96;
      channel_number = packed_chan - 96 * (tdcmod + 5 * tdccr);
/*
      if ((0 == tdcmod) && (0 == channel_number))
	hits_ptr->ofl_filt_flags[good_hits] |= OFL_FILT_TRIGCHAN;
*/	

      if (4 == tdcmod)
	{
	  if (91 == channel_number)
	    hits_ptr->ofl_filt_flags[good_hits] |= OFL_FILT_TRIGCHAN;
	  else if ((92 <= channel_number) && 
		   (95 >= channel_number))
	    hits_ptr->ofl_filt_flags[good_hits] |= OFL_FILT_EVNUMCHAN;
/*
	  printf("TRIG chan:  tdccr = %d, lead = %d\n",tdccr,t);
*/
	}


      if (hits_ptr->ofl_filt_flags[good_hits] & OFL_FILT_MASK)
	hits_ptr->ofl_filt_flags[good_hits] |= OFL_FILT_REJECT;
	
      ++good_hits;
      hits_ptr->num_hits = good_hits;
    }

  return AC_OK;
}

void 
dump_anti_hits(ANTIRAWHITSBUF *raw_hits_ptr)
{
  u_int i;

  fprintf(stdout, "Event:  %d\n", raw_hits_ptr->event_number);
  fprintf(stdout, "Hits:   %d\n", raw_hits_ptr->num_hits);

  for (i = 0; i < raw_hits_ptr->num_hits; i++)
    {
      fprintf(stdout, "Cable:  %d (0x%.4x)\tt:  %d\tq:  %d\t"
	      "ONL:  0x%.8x\tOFL:  0x%.8x\n", 
	      raw_hits_ptr->cable[i], 
	      raw_hits_ptr->cable[i], 
	      raw_hits_ptr->t[i], 
	      raw_hits_ptr->q[i],
	      raw_hits_ptr->onl_filt_flags[i],
	      raw_hits_ptr->ofl_filt_flags[i]);
    }

  return;
}

void 
read_lasercallog(laserlogbuf)
LASERLOGENTRY *laserlogbuf;
{
  FILE *logfile;
  char scanline[2 * MAXCHAR];
  int event, filter, sw1, sw2;
  int fiber;
  int i;
  int run = 0;

  for (i = 0; i < MAX_CALEVENTS; i++)
    laserlogbuf[i].fiber = laserlogbuf[i].filter = -1;

  if (!(logfile = fopen("lasercal.log", "r")))
    {
      fprintf(stderr, "Couldn't read lasercal.log!\n");
      exit(-1);
    }

  while ((scanline == fgets(scanline, MAXCHAR, logfile)) &&
	  !feof(logfile) && !ferror(logfile))
    {
      if (!strncmp(scanline, "#Run", 4))
	sscanf(&scanline[5], "%d", &run);
      
      if ('#' == scanline[0])
	continue;
      
      if (4 == sscanf(scanline, "%d %d %d %d",
		      &event, &filter, &sw1, &sw2))
	{
	  if (event)
	    {
	      --event;
	      fiber = (sw2 ? sw2 : (sw1 ? (50 + sw1) : 0));

	      if (event > MAX_CALEVENTS - 1)
		continue;
	      
	      if (laserlogbuf[event].filter < 0)
		{
		  laserlogbuf[event].run    = run;
		  laserlogbuf[event].filter = filter;
		  laserlogbuf[event].fiber  = fiber;
		}
	    }
	}
    }

  fclose(logfile);
  printf("Read in lasercal log file\n");
  return;
}


void 
write_anti_calfile(ANTIRAWHITSBUF *raw_hits_ptr, FILE *calfile, 
		   LASERLOGENTRY *laserlogbuf)
{
  u_int i;
  CALBUF	calbuf;
  int	cable;
  int   offline_flags;
  int   good_hits;
  int   event;

  calbuf.header.headerlen = CALHEADERLEN;
  calbuf.header.nhits = 0;
  calbuf.header.run = 0;
  calbuf.header.filter = 0;
  calbuf.header.fiber = 0;

  event = raw_hits_ptr->event_number;
  if ((laserlogbuf[event].filter >= 0) &&
      (laserlogbuf[event].fiber >= 0))
    {
      calbuf.header.run    = laserlogbuf[event].run;
      calbuf.header.filter = laserlogbuf[event].filter;
      calbuf.header.fiber  = laserlogbuf[event].fiber;
    }
  else
    {
      fprintf(stderr, "Couldn't find lasercal log entry for event %d!\n",
	      event);
      return;
    }

  calbuf.header.eof_pos = 0;
  calbuf.header.delay_tdc_count = 0;
  calbuf.header.laser_tdc_count = 0;
  for (i = 0; i < 2; i++)
    calbuf.header.padding[i] = 0;

  good_hits = 0;
  for (i = 0; i < raw_hits_ptr->num_hits; i++)
    {
      /*
       * Toss suspect hits
       */
/*
      if ((raw_hits_ptr->ofl_filt_flags[i]) && 
	  !(raw_hits_ptr->ofl_filt_flags[i] & OFL_FILT_TDCFULL))
	continue;
*/

      calbuf.hit[good_hits].cable = raw_hits_ptr->cable[i];
      calbuf.hit[good_hits].t     = raw_hits_ptr->t[i];
      calbuf.hit[good_hits].q     = raw_hits_ptr->q[i];

      ++good_hits;
    }

  calbuf.header.nhits = good_hits;

#ifdef VERBOSE
  printf("NHits:  %d\n", calbuf.header.nhits);
  for (i = 0; i < calbuf.header.nhits; i++)
    printf("cable:  %d\tt:  %d\tq:  %d\n",
	   calbuf.hit[i].cable,
	   calbuf.hit[i].t,
	   calbuf.hit[i].q);
#endif

/*
  len = 1;
  fortwrite32_(&lun, &len, &len);
*/
/*
  len = LEN_CALBUF;
  fortwritecalevent_(&lun, &len, &calbuf);
*/

#ifdef VERBOSE
  printf("nhits:  %d\n", calbuf.header.nhits);
  printf("run #:  %d\n", calbuf.header.run);
  printf("filter: %d\n", calbuf.header.filter);
  printf("fiber:  %d\n", calbuf.header.fiber);
#endif/*VERBOSE*/

  fwrite(&calbuf.header, sizeof(CALHEADER), 1, calfile);
  fwrite(&calbuf.hit[0], sizeof(CALHIT), calbuf.header.nhits, calfile);

  return;
}


void 
calibrate_anti_hits(ANTIRAWHITSBUF *raw_hits_ptr, 
		    ANTIREALHITSBUF *real_hits_ptr,
		    TQACONST *tqaconst, int icalva,
		    ANTIPMTMAP *antipmtmap_ptr)
{
  u_int i;
  u_int cable, channel;
  int tdccr;
  float q_pe, time_ns;
  double q_cts, q_ped;
  double delta_q;

  real_hits_ptr->event_number = raw_hits_ptr->event_number;
  real_hits_ptr->num_hits     = raw_hits_ptr->num_hits;

  for (i = 0; i < raw_hits_ptr->num_hits; i++)
    {
      cable = raw_hits_ptr->cable[i];
      real_hits_ptr->cable[i]          = cable;
      real_hits_ptr->ofl_filt_flags[i] = raw_hits_ptr->ofl_filt_flags[i];
      real_hits_ptr->onl_filt_flags[i] = raw_hits_ptr->onl_filt_flags[i];

      if (raw_hits_ptr->ofl_filt_flags[i] & OFL_FILT_REJECT)
	{
	  real_hits_ptr->t[i] = (DEFAULT_NSPERCT * 
				 ((float)raw_hits_ptr->t[i] - DEFAULT_T0));
	  real_hits_ptr->q[i] = (DEFAULT_PEPERCT * 
				 (((float)raw_hits_ptr->q[i]) - DEFAULT_QPED));
	  continue;
	}

      channel = antipmtmap_ptr->cable_num_to_tdc_ch[cable - ANTI_OFFSET];
      if ((channel < 0 ) || (channel >= NUM_TDC_CH))
	{
	  fprintf(stderr, "Bad anti channel number! (%d)\n", channel);
	  continue;
	}

      if (tqaconst[channel].status < 0.0)
	{
/*
	  real_hits_ptr->ofl_filt_flags[i] |= OFL_FILT_BADCAL | OFL_FILT_REJECT;
*/
          tdccr = raw_hits_ptr->tdccr[i];
          switch(tdccr)
            {
            case 0:
              real_hits_ptr->t[i] = (DEFAULT_NSPERCT * 
                                     ((float)raw_hits_ptr->t[i] - 
                                      (float)raw_hits_ptr->t0[tdccr] - 
                                      DEFAULT_T0_0));
              break;
            case 1:
              real_hits_ptr->t[i] = (DEFAULT_NSPERCT * 
                                     ((float)raw_hits_ptr->t[i] - 
                                      (float)raw_hits_ptr->t0[tdccr] - 
                                      DEFAULT_T0_1));
              break;
            case 2:
              real_hits_ptr->t[i] = (DEFAULT_NSPERCT * 
                                     ((float)raw_hits_ptr->t[i] - 
                                      (float)raw_hits_ptr->t0[tdccr] - 
                                      DEFAULT_T0_2));
              break;
            case 3:
              real_hits_ptr->t[i] = (DEFAULT_NSPERCT * 
                                     ((float)raw_hits_ptr->t[i] - 
                                      (float)raw_hits_ptr->t0[tdccr] - 
                                      DEFAULT_T0_3));
              break;
            default:
              fprintf(stderr, "calibrate_anti_hits:  Bad tdccr! (%d)\n",
                      tdccr);
              break;
            }
	  /*
	   * Correct for slewing:
	   */
	  q_cts = raw_hits_ptr->q[i];
	  q_ped = tqaconst[channel].ped_cts;
	  delta_q = q_cts - q_ped;
	  if (5.0 <= (delta_q))
	    real_hits_ptr->t[i] -= (DEFAULT_NSPERCT * 
				    (tqaconst[channel].slew_cts *
				     log(delta_q)));
	  else
	    real_hits_ptr->t[i] -= (DEFAULT_NSPERCT * 
				    (tqaconst[channel].slew_cts *
				     log(5.0)));

	  /*
	   * Convert Q:
	   */
          /*
           * Linear fit only:
           */
          real_hits_ptr->q[i] = (tqaconst[channel].q0_pe +
                                 q_cts * DEFAULT_PEPERCT);
	  continue;
	}

      /*
       * Subtract tdct0 offset from time, if possible:
       */
      if ((icalva >= 7) || (5 == icalva) || (4 == icalva))
	{
	  /*
	   * Subtract constant offsets:
	   */
	  tdccr = raw_hits_ptr->tdccr[i];	  
	  switch(tdccr)
	    {
	    case 0:
	    case 1:
	    case 2:
	    case 3:
	      real_hits_ptr->t[i] = (DEFAULT_NSPERCT * 
				     ((float)raw_hits_ptr->t[i] - 
				      (float)raw_hits_ptr->t0[tdccr] +
				      3500.0 -
				      tqaconst[channel].t0_cts) +
				     INNER_T0_OFFSET_NS);
	      break;
	    default:
	      fprintf(stderr, "calibrate_anti_hits:  Bad tdccr! (%d)\n",
		      tdccr);
	      break;
	    }
	}
      else /* Shou ga nai */
	real_hits_ptr->t[i] = (DEFAULT_NSPERCT * 
			       ((float)raw_hits_ptr->t[i] - DEFAULT_T0));

      /*
       * Correct for slewing:
       */
      q_cts = raw_hits_ptr->q[i];
      q_ped = tqaconst[channel].ped_cts;
      delta_q = q_cts - q_ped;
      if (5.0 <= (delta_q))
	real_hits_ptr->t[i] -= DEFAULT_NSPERCT * (tqaconst[channel].slew_cts * 
						  log(delta_q));
      else
	real_hits_ptr->t[i] -= DEFAULT_NSPERCT * (tqaconst[channel].slew_cts * 
						  log(5.0));
	
      /*
       * Convert Q:
       */
      if (tqaconst[channel].status > 1.0)
	{
	  /*
	   * Linear fit only:
	   */
	  real_hits_ptr->q[i] = (tqaconst[channel].q0_pe +
				 tqaconst[channel].pe_per_cts * q_cts);
	}
      else
	{
	  /*
	   * Linear + quadratic fit:
	   */
	  if (q_cts <= tqaconst[channel].maxlinq_cts)
	    real_hits_ptr->q[i] = (tqaconst[channel].q0_pe + q_cts *
				   tqaconst[channel].pe_per_cts);
	  else
	    real_hits_ptr->q[i] = (tqaconst[channel].quad_coeff[0] + q_cts *
				   (tqaconst[channel].quad_coeff[1] + q_cts *
				    tqaconst[channel].quad_coeff[2]));
	}
    }

  return;
}

void 
write_anti_stxt(ANTIREALHITSBUF *real_hits_ptr, FILE *file_ptr)
{
  u_int i;
  u_int num_hits;

  num_hits = 0;

  for (i = 0; i < real_hits_ptr->num_hits; i++)
    if ((real_hits_ptr->t[i] > 0.0) &&
	(real_hits_ptr->t[i] < 1500.0))
      num_hits ++;

  if (!num_hits)
    return;

  fprintf(file_ptr, " +++EVTBEG 2\n   %d\n", real_hits_ptr->event_number);
  fprintf(file_ptr, " +++TUBCAL %d\n", num_hits + 1);

  for (i = 0; i < real_hits_ptr->num_hits; i++)
    if ((real_hits_ptr->t[i] > 0.0) &&
	(real_hits_ptr->t[i] < 1500.0))
      fprintf(file_ptr, "   %d    %.2f    %.2f\n", 
	      real_hits_ptr->cable[i], 
	      real_hits_ptr->t[i], 
	      real_hits_ptr->q[i]);

  fprintf(file_ptr, " +++EVTEND 1\n");
  return;
}

void 
write_anti_bank(ANTIREALHITSBUF *real_hits_ptr, FILE *file_ptr)
{
}

void
show_event_contents(FILE *fp,char *str,int ctr,u_int size)
{
  fprintf(fp,"CONTENTS:event %d:BUF=%s(size=%d)\n",ctr,str,size);
}

int good_raw_od_hit_(int* tubeno,int* oflflag)
{
  if (*tubeno<0 || *tubeno>NUM_ANTI_PMTS || (*oflflag & OFL_FILT_REJECT)){
    return 0;
  }
  else {
    return 1;
  }
    
}

/* Wrapper for Fortran */

void get_laserinfo_(unsigned int* laserword, unsigned int* laseron, unsigned int* setting,  unsigned int* lasernum,  unsigned int* fiber1,  unsigned int* fiber2)
{
  get_laserinfo(*laserword,laseron, setting,  lasernum,  fiber1,  fiber2);
}

/* Decode the OD laser word */
void get_laserinfo(unsigned int laserword,unsigned int* laseron,unsigned int* setting, unsigned int* lasernum, unsigned int* fiber1, unsigned int* fiber2)
{

  *laseron = (~laserword & LASERONMASK)>>31;
  *setting = (~laserword & SETTINGMASK);
  *lasernum = (~laserword & LASERNUMMASK)>>10;
  *fiber1 = (~laserword & FIBER1MASK)>>16;
  *fiber2 = (~laserword & FIBER2MASK)>>20;

}
