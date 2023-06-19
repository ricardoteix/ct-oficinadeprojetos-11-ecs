from locust import HttpUser, task, between
from utils import load_env
import os

LOADBALANCER_DNS, API_KEY = load_env.load('.env')
print(LOADBALANCER_DNS, API_KEY)

class OpenProject(HttpUser):

    # wait_time = between(1, 5)

    host = LOADBALANCER_DNS
        
    username = 'apikey'
    password = API_KEY

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