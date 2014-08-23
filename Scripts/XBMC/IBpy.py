#!/usr/bin/env python
import glob
import os, fnmatch
import errno
import subprocess
import optparse
import re

VERBOSE=False
NFO_REMOVE=False
MEDIA_LIBRARY="/storage/Video/Movies"


def find_files(directory, pattern):
    for root, dirs, files in os.walk(directory):
        for basename in files:
            if fnmatch.fnmatch(basename, pattern):
                filename = os.path.join(root, basename)
                yield filename

def silentremove(filename):
    try:
        os.remove(filename)
    except OSError as e: # this would be "except OSError, e:" before Python 2.6
        if e.errno != errno.ENOENT: # errno.ENOENT = no such file or directory
            raise # re-raise exception if a different error occured

def nfo_lookout(videodir=MEDIA_LIBRARY, removeNFO=False):
    for filename in find_files(videodir, '*.nfo'):
        if VERBOSE:
            print 'Checking {0} file ...'.format(filename)
        with open(filename) as f:
            contents = f.read()
        if not 'version' in contents:
            print 'Found incorrect NFO file:{0}'.format(filename)
    	    if removeNFO:
                if VERBOSE:
		    print 'Deleting incorrect NFO file:{0}'.format(filename)
                silentremove(filename)


def runBash(cmd):
    p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
    out = p.stdout.read().strip()
    return out  #This is the stdout from the shell command

def report(output,cmdtype="UNIX COMMAND:"):
   #Notice the global statement allows input from outside of function
   if VERBOSE:
       print "%s: %s" % (cmdtype, output)
   else:
       print output


#Function to control option parsing in Python
def controller():
    global VERBOSE
    #Create instance of OptionParser Module, included in Standard Library
    p = optparse.OptionParser(description='Media Library toolbar',
                                            prog='IBpy',
                                            version='IBpy 0.1',
                                            usage= '%prog [optionio]')
    p.add_option('--nfo-lookout','-s', action="store_true", help='checks movie library for not compilant XBMC nfo files', default=False, dest='NFO_LOOKOUT')
    p.add_option('--nfo-remove', '-r', action="store_true", help='removes not compilant nfo files', default=False, dest='NFO_REMOVE')
    p.add_option('--media-library', '-m', action="store", help='media directory to look for nfo files [%default]', type='string', dest='MEDIA_LIBRARY', default=MEDIA_LIBRARY)
    p.add_option('--verbose', '-v',
                action = 'store_true',
                help='prints verbosely',
		dest='VERBOSE',
                default=False)

    options, arguments = p.parse_args()

    if options.__dict__['VERBOSE']:
	VERBOSE=True
    if options.__dict__['NFO_LOOKOUT']:
        nfo_lookout(options.__dict__['MEDIA_LIBRARY'], options.__dict__['NFO_REMOVE']) 
    else:
        p.print_help()

#Runs all the functions
def main():
    controller()

#This idiom means the below code only runs when executed from command line
if __name__ == '__main__':
    main()
