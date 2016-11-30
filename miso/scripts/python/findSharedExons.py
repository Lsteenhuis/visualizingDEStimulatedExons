#!/bin/bash/python
import re
import os
import operator

def main():
    controller()

def controller():
    timePoints=["4h","24h"]
    for timePoint in len(timePoints):
        time = timePoints[timePoint]
        bayesTwenty = getEventByBayesFactor(time)
        createOccurenceMatrix(bayesTwenty,time)
        sortByMostExpressedEvent(bayesTwenty,time)
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
            matcher = re.search('vs_(\w+)(?:-\d\w+)?', filteredFile)
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
    output = open("sharedExons_"+time+".csv", "w")
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
    listOfStimuli=['A_Aspergillus_fumigatus', 'A_Borrelia_burgdorferi', 'A_Candida_albicans', 'A_IL', 'A_Mycobacterium_tuberculosis', 'A_Pseudomonas_aeruginosa', 'A_Rhizopus_oryzae', 'A_Streptococcus_pneumoniae', 'B_Aspergillus_fumigat$
    return listOfStimuli

if __name__ == "__main__":
    main()
