T2K OD REDUCTION CODE

Code is split into different modules.

ODCLASSIFY: Legacy Code
SKLB (Nakayama): T2KOD Reduction
T2KODRD: Cuts (which require classification)
ODXDT: Crossing classification
ODTIMING: Timing corrections
BSDHANDLER (C++/Py): Monitor BSD files, Match NRUNSK to NRUNBM
MKSUMMARY (Nakayama): Produce Summary files from BSD and reduction logfiles.
AUTOT2KOD: Automated running.

REQUIREMENTS:
(1) Hook up to various stages of reduction.
(2) Produce an OD final sample zbs file and ntuple.
(3) No hard-coded numbers
