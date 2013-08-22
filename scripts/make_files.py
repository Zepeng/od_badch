import os,sys
myasgpath = "/home/tmw23/working/mcasg_dev"
sys.path.append(myasgpath)
from ASGHeader import theHeader
from ASGGenerator import ASGGenerator
from ASGBaseDB import ASGBaseDB
sys.path.append( "/home/tmw23/working/t2kod/pytools/" )
from queueman import theJobStack, NQSJobStack
from sukapNQS import setNQSuser
sys.path.append( "/home/tmw23/working/t2kod/skrockgen" )
from modelSetupFiles import GetSetupFile, GetModelDict
from skrockmcDB import userDatabaseMod


# MAKE FILELISTS
def MakeFileLists( component ):
    target = component[0]
    flux = component[1]
    xsec = component[2]
    setupfile = GetSetupFile( "2013a", target, flux, xsec )

    print component, setupfile

    theHeader.asg_settings["ASG_OPT_TEST"] = True
    theHeader.asg_settings["ASG_VERBOSE"] = True
    theHeader.asg_settings["ASG_OPT_SILENCE"] = True
    theHeader.LoadSetupFile(setupfile)

    # USER DATABASE MODULE
    rockdb = userDatabaseMod( theHeader )
    theHeader.loadUserDatabaseMod()
    rockdb = theHeader.getTheDatabase()

    connect = rockdb.dbconnect.cursor()
    connect.execute( "SELECT * FROM %s WHERE entrystatus==\"OK\" ORDER BY asg_filenum ASC LIMIT 5" % ( rockdb.tablename ) )
    dbentries = connect.fetchall()
    print "Number of entries in DB: ",len(dbentries)

    filelistname = "filelists/odfilelist.%s.%s.%s.list" % ( target, flux, xsec )
    filelist = open( filelistname, 'w' )
    for dbentry in dbentries:
        filelist.write("%s\n"%(dbentry["apfit"]))
    filelist.close()
    return filelistname

def MakeReductionScript( filelistname, output_rootfile, component, output_folder ):
    pid_dict = { "numu":14,
                 "numubar":-14,
                 "nue":12,
                 "nuebar":-12 }
    flux = component[1]
    scriptname = output_folder+"/nqs.%s.%s.%s.sh" % ( component[0], component[1], component[2] )
    logname = output_folder+"/qsub.%s.%s.%s.txt" % ( component[0], component[1], component[2] )
    script = open( scriptname, 'w' )
    script.write( "#!/bin/csh\n" )
    script.write( "setenv LD_LIBRARY_PATH /home/tmw23/working/od_badch_test/reduction:${LD_LIBRARY_PATH}\n" )
    script.write( "cd /home/tmw23/working/od_badch_test/reduction\n" )
    script.write( "/home/tmw23/working/od_badch_test/reduction/./run_t2kodreduc %s %s %d >& /dev/null\n" % ( filelistname, output_rootfile, pid_dict[flux] ) )
    script.close()
    return scriptname, logname

if __name__ == "__main__":
    theJobStack.setQueueType( NQSJobStack._kNQS )
    theJobStack.setQueue( "all" )
    setNQSuser( "tmw23" )
    theJobStack.setTestMode ( False )
    
    filelists = []
    output_folder = "/disk/atmpd1/atmd1/work15/tmw23/output_od_bad_ch_test/odreducfiles/"
    modeldict = GetModelDict( "2013a" )
    for component in modeldict:
        filelistname = MakeFileLists( component )
        filelistpath = "/home/tmw23/working/od_badch_test/scripts/"+filelistname
        filelists.append( filelistname )
        rootfilename = output_folder + "/odreduc.test.mod.%s.%s.%s.root" % ( component[0], component[1], component[2] )
        scriptname, logname = MakeReductionScript( filelistpath, rootfilename, component, output_folder )
        theJobStack.addJob( scriptname, logname )
        break
    theJobStack.launchJobs()
