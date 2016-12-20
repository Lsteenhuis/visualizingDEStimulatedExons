#!/bin/bash/python
import re
import os
import operator
import sys

def main():
    controller()

def controller():
    #modes=["SE"]
    modes=["A3SS","A5SS","SE","MXE","RI"]
    timePoints=["24h","4h"]
    for mode in modes:
        for time in timePoints:
            passedEvents = getEventByBayesFactor(time,mode)
            sortByMostExpressedEvent(passedEvents,time,mode)
            #createMatrix(passedEvents,time, "occurence", 0, mode)
            #createMatrix(passedEvents,time, "psi", 1, mode)
            #createMatrix(passedEvents,time, "bf", 2, mode)
'''
Gets all events between certain Bayes Factor thresholds.
Returns a dictionary with event as key and all the stimuli in a list where the
event has been found in as value.
'''
def getEventByBayesFactor(time,mode):
    passedEvents={}

    # list containing eventList

    filteredLoc="../../filtered_comparisons/"+mode+"/"+time+"/"
    for filteredFile in os.listdir(filteredLoc):
        with open(filteredLoc+filteredFile) as file:

            # retrieves the stimuli name from the filtered file
            matcher = re.search('vs_(\w+(?:-\d\w+)?)', filteredFile)
            stimuli = matcher.group(1)
            # Name of stimuli without volunteer letter
            generalStimuli = stimuli[2:]
            # first line is header so skip
            next(file)
            for exonInfo in file:
                eventDict={}
                # list containing the stimuli of a event
                stimuliList=[]
                # list containing event name + stimuliList
                eventList=[]

                exonInfoSplit = exonInfo.split("\t")
                # exonInfoSplit[0] is the name of the event
                eventName = exonInfoSplit[0]
                # exonInfoSplit[7] is the delta PSI value
                psiValue =float("%.2f" % float(exonInfoSplit[7]))
                # exonInfoSplit[8] is the Bayes facor value
                bfFactor = float("%.2f" % float(exonInfoSplit[8]))


                #This code block creates a dictionary in a dictionary.
                #Dicitonary A has generalStimuli as key and dictionary B as
                #value. Dictionary B has event name as key and event information
                # as value.

                # check if these values meet the thresholds
                #if bfFactor >= 5.00:
                #if psiValue >= 0.05 and bfFactor >= 5.00:
                # stimuli list contains the information of the current event
                stimuliList=[stimuli,format(psiValue,'.2f'), format(bfFactor,'.2f')]
                if generalStimuli in passedEvents:
                    if eventName in passedEvents[generalStimuli]:
                        if stimuli in passedEvents[generalStimuli][eventName]:
                            continue
                        else:
                            passedEvents[generalStimuli][eventName] = passedEvents[generalStimuli][eventName] + [stimuliList]
                    else:
                        eventDict[eventName] = [stimuliList]
                        passedEvents[generalStimuli].update(eventDict)
                #if generalStimuli is not in passedEvents it will be created with
                else:
                    eventDict[eventName] = [stimuliList]
                    passedEvents[generalStimuli] = eventDict
 
    return passedEvents

'''
Creates a .csv containing every event and shows in which stimuli they occur.
The first line of the .csv is the header containing eventName and the list of
stimuli. It makes an initial array filled with 0's, these will be turned into
1's at the positions of the stimuli in which they are expressed.
'''
def createMatrix(passedEvents, time, outFile, value,mode):
    # creates array filled with 0 with length of listOfStimuli
    letterArray=["A","B","C","D","E","F","G","H"]
    # creates set for events that occur >= 4 times in a stimuli.
    for stimuli in passedEvents:
        stimuliList=[]
        for i in range(len(letterArray)):
            stimuliList.append(letterArray[i]+"_"+stimuli)
	outputFile="../../matrices/" + outFile + "/" + stimuli + "_" + time + "_" + outFile +"_Matrix.tsv"
	if not os.path.isfile(outputFile):
	    output = open(outputFile, "a")
            output.write("StimuliName\tEventType\tEventName\tEnsemblId\tGeneName\t"+"\t".join(stimuliList)+"\n")
	else:
            output = open(outputFile, "a")
        for event in passedEvents[stimuli]:
            if value == 0:
                presentArray = [0] * 8
            else:
                presentArray = [0.00] * 8
            if len(passedEvents[stimuli][event]) >= 4 :
                for stim in passedEvents[stimuli][event]:
                    #print stimuliList.index(stim[0])
                    if value == 0:
                        presentArray[stimuliList.index(stim[0])] = 1
                    else:
                        presentArray[stimuliList.index(stim[0])] = stim[value]
		
		#presentArray.insert(0,mode)
		presentArrayString = "\t".join(str(e) for e in presentArray)
                output.write(event + "\t" +  presentArrayString + "\n")
                # sets the 0 at the position of stimuli to 1.
                # casts presentArray to a string so it can be writen to the output file
        output.close()
    stimuliCount=0


'''
Creates a sorted .csv with on every line the event name and amount of stimuli
it is found in. sorted by descending.
'''
def sortByMostExpressedEvent(passedEvents,time,mode):
    #output = open("matrices/occurences/_"+mode+"_"+time+".csv", "w")
    # casts passedEvents to string and sorts by length of the lenght of the
    # values of passedEvents, so by amount of total stimuli.
    #sortedByOccurence = ','.join(sorted(passedEvents, key=lambda k: len(passedEvents[k]), reverse=True))
    for stimuli in passedEvents:
	output = open("../../matrices/eventNames/"+ mode + "_" + stimuli + "_" + time + ".txt", "w")
	for event in passedEvents[stimuli]:
            if len(passedEvents[stimuli][event]) >= 4:
                output.write(event + "\n")
	output.close()


'''
Returns A list with all stimuli sorted alphabetically.
'''
def initList():
    listOfStimuli = ['A_Aspergillus_fumigatus', 'B_Aspergillus_fumigatus', 'C_Aspergillus_fumigatus', 'D_Aspergillus_fumigatus', 'E_Aspergillus_fumigatus', 'F_Aspergillus_fumigatus', 'G_Aspergillus_fumigatus', 'H_Aspergillus_fumigatus', 'A_Borrelia_burgdorferi', 'B_Borrelia_burgdorferi', 'C_Borrelia_burgdorferi', 'D_Borrelia_burgdorferi', 'E_Borrelia_burgdorferi', 'F_Borrelia_burgdorferi', 'G_Borrelia_burgdorferi', 'H_Borrelia_burgdorferi', 'A_Candida_albicans', 'B_Candida_albicans', 'C_Candida_albicans', 'D_Candida_albicans', 'E_Candida_albicans', 'F_Candida_albicans', 'G_Candida_albicans', 'H_Candida_albicans', 'A_IL-1alpha', 'B_IL-1alpha', 'C_IL-1alpha', 'D_IL-1alpha', 'E_IL-1alpha', 'F_IL-1alpha', 'G_IL-1alpha', 'H_IL-1alpha', 'A_Mycobacterium_tuberculosis', 'B_Mycobacterium_tuberculosis', 'C_Mycobacterium_tuberculosis', 'D_Mycobacterium_tuberculosis', 'E_Mycobacterium_tuberculosis', 'F_Mycobacterium_tuberculosis', 'G_Mycobacterium_tuberculosis', 'H_Mycobacterium_tuberculosis', 'A_Pseudomonas_aeruginosa', 'B_Pseudomonas_aeruginosa', 'C_Pseudomonas_aeruginosa', 'D_Pseudomonas_aeruginosa', 'E_Pseudomonas_aeruginosa', 'F_Pseudomonas_aeruginosa', 'G_Pseudomonas_aeruginosa', 'H_Pseudomonas_aeruginosa', 'A_Rhizopus_oryzae', 'B_Rhizopus_oryzae', 'C_Rhizopus_oryzae', 'D_Rhizopus_oryzae', 'E_Rhizopus_oryzae', 'F_Rhizopus_oryzae', 'G_Rhizopus_oryzae', 'H_Rhizopus_oryzae', 'A_Streptococcus_pneumoniae', 'B_Streptococcus_pneumoniae', 'C_Streptococcus_pneumoniae', 'D_Streptococcus_pneumoniae', 'E_Streptococcus_pneumoniae', 'F_Streptococcus_pneumoniae', 'G_Streptococcus_pneumoniae', 'H_Streptococcus_pneumoniae']
    return listOfStimuli

if __name__ == "__main__":
    main()
