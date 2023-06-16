from locust import HttpUser, task, between
from utils import load_env
import os


class OpenProject(HttpUser):

    # def __init__(self): 
    #     load_env.load('.env')

    wait_time = between(1, 5)

    host = "http://openproject-lb-1481225165.us-east-1.elb.amazonaws.com"
        
    username = 'apikey'
    password = "b169a00af0b1a06c443063f3b192a5daf10e4e57449076241355270e7299369d"

    @task(5)
    def project1(self):
        
        end_point = "/api/v3/projects/1"
        self.client.get(f"{end_point}", auth=(OpenProject.username, OpenProject.password))
        
    @task(3)
    def work_packages(self):
        
        end_point = "/api/v3/work_packages"
        self.client.get(f"{end_point}", auth=(OpenProject.username, OpenProject.password))

    @task(1)
    def categories(self):
        
        end_point = "/api/v3/categories/1"
        self.client.get(f"{end_point}", auth=(OpenProject.username, OpenProject.password))