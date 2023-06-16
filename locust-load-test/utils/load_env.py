import os


def load(file):
    f = open(file, 'r')
    vars = f.readlines()
    for var in vars:
        env_var = var.strip().split("=")
        os.environv[env_var[0]] = env_var[1]
