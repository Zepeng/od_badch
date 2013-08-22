#!/usr/bin/python
import os,sys

def isVirtualFrameBufferOn():
    checkpipe = os.popen("ps ax -U tmw23 | grep Xvfb")
    checklines = checkpipe.readlines()
    foundXvfb = False
    for line in checklines:
        line = line.strip()
        if line.split()[4]=="Xvfb":
            if line.split()[5]==":2":
                foundXvfb = True
            else:
                print "Xvfb not at correct address, :2.0"
            print line
            break
    return foundXvfb


def turnOffXvfb():
    #  Now put down the Xvfb
    checkpipe = os.popen("ps ax -U tmw23 | grep Xvfb")
    checklines = checkpipe.readlines()

    for line in checklines:
        line = line.strip()
        if line.split()[4]=="Xvfb":
            if line.split()[5]==":2":
                print line
                pid = int(line.split()[0])
                os.system("kill %d" % (pid))
                print "Killed Xvfb"
                break
    
    
def convert_displays(output_folder):
    os.system("mv *.eps %s/"%(output_folder))
    epslist = os.listdir( output_folder )
    for epsfile in epslist:
        epsfile = "%s/%s" % (output_folder, epsfile)
        pngfile = epsfile.replace(".eps", ".jpg")
        os.system("convert -rotate 90 -resize 600x400 %s %s" % (epsfile, pngfile))
    

def make_displays(zbsfile):
    print "/home/tmw23/working/superscan/./superscan -l -f %s" % ( zbsfile )
    os.system("/home/tmw23/working/superscan/./superscan -l -f %s" % ( zbsfile ) )

    
if __name__ == "__main__":

    input_zbs = ""
    output_folder = ""
    if len(sys.argv)!=3:
        print "Takes a zbs file and output folder and makes a bunch of png files of the events inside the ZBS file."
        print "./make_displays [input zbs] [output folder]"
    else:
        input_zbs = sys.argv[1]
        output_folder = sys.argv[2]
    if os.path.exists( output_folder )==False:
        os.system("mkdir %s" % ( output_folder ) )

    foundXvfb = isVirtualFrameBufferOn()
    if foundXvfb==False:
        print "Starting up virtual framer buffer"
        os.system("Xvfb :2 -fbdir /home/tmw23/working/skctools/displaygen/fbtemp -screen 0 1200x700x16 &")
    else:
        print "Virtual framer buffer already running"

    os.environ["DISPLAY"] = ":2.0"
    make_displays( input_zbs )
    convert_displays( output_folder )
    turnOffXvfb()    
