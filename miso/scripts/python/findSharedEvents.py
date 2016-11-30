#!/bin/bash/python
import re
import os
import operator

def main():
    controller()

def controller():
    timePoints=["4h","24h"]
    for timePoint in timePoints:
        bayesTwenty = getEventByBayesFactor(timePoint)
        createOccurenceMatrix(bayesTwenty,timePoint)
        sortByMostExpressedEvent(bayesTwenty,timePoint)
'''
Gets all events between certain Bayes Factor thresholds.
Returns a dictionary with event as key and all the stimuli in a list where the
event has been found in as value.
'''
def getEventByBayesFactor(time):
    bayesTwenty={}
    filteredLoc="../../filtered_comparisons/SE/"+time+"/"
    for filteredFile in os.listdir(filteredLoc):
        with open(filteredLoc+filteredFile) as file:
            # retrieves the stimuli name from the filtered file
            matcher = re.search('vs_(\w+(?:-\d\w+)?)', filteredFile)
            stimuli = matcher.group(1)
            # first line is commented so skip
            next(file)
            for exonInfo in file:
                exonInfoSplit = exonInfo.split("\t")
                # exonInfoSplit[8] is the Bayes facor value.
                # check if this value meets the threshold
                if float(exonInfoSplit[8]) >= 20.00:
                    # exonInfoSplit[0] = event name
                    if exonInfoSplit[0] in bayesTwenty:
                        bayesTwenty[exonInfoSplit[0]] = bayesTwenty[exonInfoSplit[0]] + [stimuli]
                    else:
                        bayesTwenty[exonInfoSplit[0]] = [stimuli]


    return bayesTwenty

'''
Creates a .csv containing every event and shows in which stimuli they occur.
The first line of the .csv is the header containing eventName and the list of
stimuli. It makes an initial array filled with 0's, these will be turned into
1's at the positions of the stimuli in which they are expressed.
'''
def createOccurenceMatrix(bayesTwenty,time):
    listOfStimuli = initList()
    test =0
    output = open("sharedEvents_"+time+".csv", "w")
    output.write("eventName,"+",".join(listOfStimuli)+"\n")
    for event in bayesTwenty:
        # creates array filled with 0 with length of listOfStimuli
        presentArray = [0] * len(listOfStimuli)
        # sets the 0 at the position of stimuli to 1.
        for stimuli in bayesTwenty[event]:
            presentArray[listOfStimuli.index(stimuli)] = 1
        # casts presentArray to a string so it can be writen to the output file
        presentArrayString = ",".join(str(e) for e in presentArray)
        output.write(event + "," +  presentArrayString + "\n")

'''
Creates a sorted .csv with on every line the event name and amount of stimuli
it is found in. sorted by descending.
'''
def sortByMostExpressedEvent(bayesTwenty,time):
    output = open("sortedListByOccurence_"+time+".csv", "w")
    # casts bayesTwenty to string and sorts by length of the lenght of the
    # values of bayesTwenty, so by amount of total stimuli.
    sortedByOccurence = ','.join(sorted(bayesTwenty, key=lambda k: len(bayesTwenty[k]), reverse=True))
    sortedByOccurence = sortedByOccurence.split(",")
    for event in sortedByOccurence:
        output.write(event + "," + str(len(bayesTwenty[event])) + "\n")


'''
Returns A list with all stimuli sorted alphabetically.
'''
def initList():
    listOfStimuli = ['A_Aspergillus_fumigatus', 'B_Aspergillus_fumigatus', 'C_Aspergillus_fumigatus', 'D_Aspergillus_fumigatus', 'E_Aspergillus_fumigatus', 'F_Aspergillus_fumigatus', 'G_Aspergillus_fumigatus', 'H_Aspergillus_fumigatus', 'A_Borrelia_burgdorferi', 'B_Borrelia_burgdorferi', 'C_Borrelia_burgdorferi', 'D_Borrelia_burgdorferi', 'E_Borrelia_burgdorferi', 'F_Borrelia_burgdorferi', 'G_Borrelia_burgdorferi', 'H_Borrelia_burgdorferi', 'A_Candida_albicans', 'B_Candida_albicans', 'C_Candida_albicans', 'D_Candida_albicans', 'E_Candida_albicans', 'F_Candida_albicans', 'G_Candida_albicans', 'H_Candida_albicans', 'A_IL-1alpha', 'B_IL-1alpha', 'C_IL-1alpha', 'D_IL-1alpha', 'E_IL-1alpha', 'F_IL-1alpha', 'G_IL-1alpha', 'H_IL-1alpha', 'A_Mycobacterium_tuberculosis', 'B_Mycobacterium_tuberculosis', 'C_Mycobacterium_tuberculosis', 'D_Mycobacterium_tuberculosis', 'E_Mycobacterium_tuberculosis', 'F_Mycobacterium_tuberculosis', 'G_Mycobacterium_tuberculosis', 'H_Mycobacterium_tuberculosis', 'A_Pseudomonas_aeruginosa', 'B_Pseudomonas_aeruginosa', 'C_Pseudomonas_aeruginosa', 'D_Pseudomonas_aeruginosa', 'E_Pseudomonas_aeruginosa', 'F_Pseudomonas_aeruginosa', 'G_Pseudomonas_aeruginosa', 'H_Pseudomonas_aeruginosa', 'A_Rhizopus_oryzae', 'B_Rhizopus_oryzae', 'C_Rhizopus_oryzae', 'D_Rhizopus_oryzae', 'E_Rhizopus_oryzae', 'F_Rhizopus_oryzae', 'G_Rhizopus_oryzae', 'H_Rhizopus_oryzae', 'A_Streptococcus_pneumoniae', 'B_Streptococcus_pneumoniae', 'C_Streptococcus_pneumoniae', 'D_Streptococcus_pneumoniae', 'E_Streptococcus_pneumoniae', 'F_Streptococcus_pneumoniae', 'G_Streptococcus_pneumoniae', 'H_Streptococcus_pneumoniae']
    return listOfStimuli

if __name__ == "__main__":
    main()
