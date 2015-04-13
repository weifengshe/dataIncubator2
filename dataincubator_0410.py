##Q1: You roll a fair 6-sided dice iteratively until the sum of the dice rolls is greater than or equal to M.
# What is the mean of the sum minus M when M=20?*
# What is the standard deviation of the sum minus M when M=20?*
# What is the mean of the sum minus M when M=10000?*
# What is the standard deviation of the sum minus M when M=10000?*
# What is the mean of the number of rolls when M=20?*
# What is the standard deviation of the number of rolls when M=20?*
# What is the mean of the number of rolls when M=10000?*
# What is the standard deviation of the number of rolls when M=10000?*
import random, numpy
# What is the mean of the sum minus M when M=20?*
def rollDiceSum(M):
    total = 0
    num = 0
    while total < M:
        x = random.choice([1, 2, 3, 4, 5, 6])
        total += x
    return total

def rollDiceNum(M):
    total = 0
    num = 0
    while total < M:
        x = random.choice([1, 2, 3, 4, 5, 6])
        total += x
        num += 1
    return num
    
def runSim(M, numTrials):
    """ (str,int) -> (float)
    Returns the probability of getting a certain sequence of dices
    Basicaly runs getTarget many times and divides the number of trials at the total
    number of tries
    Number of trials is the number of tests
    Number of tries is the number of dice roll for every test
    """
    SUM  = []
    roll = []
    for i in range(numTrials):
        total = rollDiceSum(M)
        SUM.append(total)
        num = rollDiceNum(M)
        roll.append(num)
    sum_minus_M = numpy.array(SUM) - M
    MN_sum = numpy.mean(sum_minus_M)
    STD_sum = numpy.std(sum_minus_M)
    MN_roll = numpy.mean(roll)
    STD_roll = numpy.std(roll)
    print  "the mean of the sum minus M when M=" + str(M) + " is ", MN_sum 
    print  "the standard deviation of the sum minus M when M=" + str(M) + " is ", STD_sum 
    print  "the mean of the number of rolls when M=" + str(M) + " is ", MN_roll 
    print  "the standard deviation of the number of rolls when M=" + str(M) + " is ", STD_roll

runSim(20, 1000)
runSim(10000, 1000)