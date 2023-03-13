Commands executed as Part-1 section
Run the container image infracloudio/csvserver:latest in background and check if it's running.
$ docker images
REPOSITORY                         TAG                 IMAGE ID            CREATED             SIZE
docker.io/infracloudio/csvserver   latest              8cb989ef80b5        2 years ago         237 MB
docker.io/prom/prometheus          v2.22.0             7adf5a25557b        2 years ago         168 MB


$ docker run -d 8cb989ef80b5
$ docker ps -a
b6adaa3f8cba        8cb989ef80b5        "/csvserver/csvserver"   About an hour ago   Exited (1) About an hour ago                            boring_jennings

$ docker logs b6adaa3f8cba
2023/03/13 06:49:52 error while reading the file "/csvserver/inputdata": open /csvserver/inputdata: no such file or directory 
If it's failing then try to find the reason, once you find the reason, move to the next step. ### Due to file Missing in Docker image not able to Run
Write a bash script gencsv.sh to generate a file named inputFile whose content looks like:
0, 234
1, 98
2, 34
These are comma separated values with index and a random number.
Running the script without any arguments, should generate the file inputFile with 10 such entries in current directory.
You should be able to extend this script to generate any number of entries, for example 100000 entries.
Run the script to generate the inputFile. Make sure that the generated file is readable by other users.
$ vi gencsv.sh
$ bash gencsv.sh
$ ls -lrt
$ cat inputFile    
Run the container again in the background with file generated in (3) available inside the container (remember the reason you found in (2)).
docker run --privileged -v /root/csvserver/solution/inputFile:/csvserver/inputdata 8cb989ef80b5
Get shell access to the container and find the port on which the application is listening. Once done, stop / delete the running container.
$ docker ps
209276b7c561        8cb989ef80b5        "/csvserver/csvserver"   About an hour ago   Up About an hour               9300/tcp                 dreamy_heyrovsky
$ docker exec -it 209276b7c561 /bin/bash
ÄrootÉ209276b7c561 csvserverÅ# uname -a 
Linux 209276b7c561 3.10.0-1160.83.1.el7.x86_64 #1 SMP Wed Jan 25 16:41:43 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux
ÄrootÉ209276b7c561 csvserverÅ# uptime 
 08:04:08 up 0 day, 23 min,  0 users,  load average: 0.04, 0.03, 0.05


Get shell access to the container and find the port on which the application is listening. Once done, stop / delete the running container.
# docker container stop 209276b7c561
209276b7c561
$ docker rm  209276b7c561

Same as (4), run the container and make sure,
The application is accessible on the host at http://localhost:9393
Set the environment variable CSVSERVER_BORDER to have value Orange.
$ docker run -d --privileged -v /root/csvserver/solution/inputFile:/csvserver/inputdata -p 9393:9300 -e CSVSERVER_BORDER='Orange' 8cb989ef80b5
$ docker ps -a 
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                         PORTS                    NAMES
58ac40543240        8cb989ef80b5        "/csvserver/csvserver"   About an hour ago   Up About an hour               0.0.0.0:9393->9300/tcp   hopeful_spence

ÄrootÉinstance-2 solutionÅ# curl http://localhost:9393
<!DOCTYPE html>
<html>
<head>
  <title>CSV Server</title>
  <style>
  th, td ä
    padding: 5px;
  å
  </style>
</head>
<body>
<!-- Y3N2c2VydmVyIGdlbmVyYXRlZCBhdDogMTY3ODY5MDUzNA== -->
<h3 style="border:3px solid Orange">Welcome to the CSV Server</h3><table><tr><th>Index</th><th>Value</th></tr><tr><td>2</td><td> 17029</td></tr><tr><td>3</td><td> 22026</td></tr><tr><td>4</td><td> 22267</td></tr><tr><td>5</td><td> 12899</td></tr><tr><td>6</td><td> 10757</td></tr><tr><td>7</td><td> 27160</td></tr><tr><td>8</td><td> 25597</td></tr></table></body></html>
