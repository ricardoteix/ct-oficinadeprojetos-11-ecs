import os


def load(file):
    f = open(file, 'r')
    vars = f.readlines()
    return vars[0].strip().split("=")[1], vars[1].strip().split("=")[1]
    
