import os
import sys
import argparse
import re

def main():
    dictOfExons=compareFiles()
    writeToFile(dictOfExons)

'''
compareFiles.
CompareFiles goes through every filtered comparison file in filteredDir.
It then creates a dictionary with the name of the stimuli as key,
and the ENSMBL ID's from the differential expressed genes as value.
This dictionary is then passed onto writeToFile, which writes
these values to a file.

'''
def compareFiles():
    #initiate dict where stimuli and gene's are stored
    dictOfExons = {}
	
    #the directory where the filtered comparison files are
    filteredDir="../../..//filtered_comparisons/SE/24h/" 
    time="_4h"
    
    try:
        for openFile in os.listdir(filteredDir):

  	    #regex command which retrieves the name of the stimuli from the filename
            m = re.search( 'vs_(\w+(?:-\w+)?)', openFile)
            stimuli=m.group(1)
  	    stimuli=stimuli+time
	    
	    #check for unuseable files
            if ".miso_bf" in openFile:
                with open(filteredDir+openFile, 'r') as misoFile:
                    next(misoFile)
                    for line in misoFile:
                        line = line.rstrip()
                        lineList = line.split("\t")
			#If the stimuli has no key, it is created and the gene is added as value
                        if stimuli not in dictOfExons:
                            dictOfExons[stimuli] = lineList[0]
			    			    
                        else:
			    #if the stimuli already has a key, the gene is appended to the value
                            if lineList[0] not in dictOfExons[stimuli]:
                                dictOfExons[stimuli]= dictOfExons[stimuli]+","+lineList[0]
    except:
	print "unexpected error happened:"
        raise
    return dictOfExons

'''
writeToFile.
Writes the dictOfExons to a file as tab seperated values.
listOfExons is comma separated.
'''
def writeToFile(dictOfExons):
    outFile = open("../../../exonFiles/SE/sharedExons/4h/listOfSharedExons.txt","w")
    for stimuli in dictOfExons:
    	listOfExons=dictOfExons[stimuli]
        print >> outFile, stimuli,"\t",listOfExons
    outFile.close()



if __name__ == "__main__":
    main()
