#
#  In case of building locally, set SKOFL_ROOT variable 
#      setenv SKOFL_ROOT   ... 
#  or directly set in this makefile 
# SKOFL_ROOT = /skofl
#
ifndef SKOFL_ROOT
  SKOFL_ROOT = ../..
endif

include $(SKOFL_ROOT)/config.gmk

CCOPTIONS += -D ConstDirC="\"$(CONSTDIR):$(CONSTDIR)/lowe:$(A_CONSTDIR):$(SKAMCONSTDIR):\""

FCOPTIONS += -D ConstDirs1="'$(CONSTDIR):$(CONSTDIR)/lowe:'" \
	     -D ConstDirs2="'$(A_CONSTDIR):$(SKAMCONSTDIR):'"

#
#  Objects
#

SKRDO =	aheadsk.o anticalsk.o \
	atmaddrdsk.o cadcsk.o \
	cmtqsk.o difpresk.o \
	diftevsk.o headsk.o \
	pdstsk.o skbadch.o skbadopt.o \
	skbadch_old.o \
	skcaltabset_atmtq.o skcaltabset_pgain.o \
	skcaltabset_tqmap.o skcaltabver.o \
        skcaltabset_od.o skcaltabver_od.o\
	skcaltabfile.o \
	skchdir.o skcontabrd.o skgetwater.o  \
	skhtrd.o skmkheada.o \
	skmktqreal.o skoptn.o \
	skrawread.o skrdsub.o \
	skread.o sktqacom.o \
	sktqconv.o tlincorsk.o \
	skupdt.o tqacomsk.o \
	tqarealsk.o tqask.o \
	tqrawsk.o tqrealsk.o tqsk.o \
	slimpdsk.o \
	skchkveto.o tqvrealsk.o tqvsk.o \
        skmcbadch.o skrdmcver.o fill_zbs_commons.o \
	skqcor.o skqcorcab.o skqcorrate.o skverchk.o skqcoroff.o \
	sktqconv_qb.o skcontabrd_qb.o skcaltabset_qb.o \
	skcaltabset_qbconst.o skqdiv.o tqskz.o tqskaz.o tqrawska.o \
	set_timing_gate.o set_timing_gate_nsec.o set_timing_gate_nsec2.o \
	delete_outside_hits.o runinfsk.o \
	tdiffsk.o gpssk.o skqtcmhit_cor.o \
	spacersk.o qbstatsk.o dbstatsk.o skdark.o \
	trgsk.o

OBJS =	$(SKRDO)


LIBNAME = skrd


FORTRANDEFINES += -DRUNNUM_REP=20000

#
#  Rules for building library 
#

.PHONY:  lib$(LIBNAME).a $(LIBDIR)lib$(LIBNAME).a

lib$(LIBNAME).a : $(OBJS)
	$(RM) $@
	$(AR) $@ $(OBJS) 
	$(RANLIB) $@

$(LIBDIR)lib$(LIBNAME).a : lib$(LIBNAME).a
	$(RM) $@
	$(INSTALL_LIB) $< $@

#
#  Targets 
#

.PHONY:  clean setup includes install.includes depend lib install.lib exec install.exec

emptyrule:: lib

clean::
	$(RM) *.o *~ *.a *.so core* 

setup::

includes::

install.includes::

depend::

lib:: lib$(LIBNAME).a

install.lib:: $(LIBDIR)lib$(LIBNAME).a

exec::

install.exec:: 

