# sailpoint_demo
This is demo code repo for given problem statement of github PR summary
Problem Statement : Using the language of your choice, write code that will use the GitHub API to retrieve a summary of all opened, closed, and in progress pull requests in the last week for a given repository and print an email summary report that might be sent to a manager or
Scrum-master. Choose any public target GitHub repository you like that has had at least 3 pull requests in the last week. Format the content email as you see fit, with the goal to allow the reader to easily digest the events of the past week. Please print
to console the details of the email you would send (From, To, Subject, Body). As part of the submission, you are welcome to create a Dockerfile to build an image that will run the program, however, other ways of implementing this is acceptable.
 
 How to use code to get report:
 Step 1) clone this repo on local linux server
 step 2) ensure docker is installed on server if it's not present then install using (yum install docker)
 step 3) create docker image from dockerfile using below command 
        docker build -t report:v1 .
 step 4) You will see created docker image using command "docker images"
 step 5) Now create container using below command:
        docker run -it report:v1
it will display the output on console like email draft for GITHUB repo PR summary report. 
 
