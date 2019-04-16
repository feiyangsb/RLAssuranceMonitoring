import socket
import sys
from struct import *
from scipy.stats import beta

delta = 0.01 #half interval size
c = 0.99 #interval coefficient
_alpha = 1
_beta = 1

x = 0
n = 0
# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Connect the socket to the port where the server is listening
server_address = ('localhost', 3389)
print >> sys.stderr, 'connecting to %s port %s' % server_address
sock.connect(server_address)

while(True):
    sampleCommand = "Sample"
    sock.sendall(sampleCommand)
    print("Sampling new trace...")

    msg = sock.recv(4)
    number_data = (int)(unpack(">f" ,msg)[0])

    data = sock.recv(number_data*4)
    data_set = unpack('>'+'f'*number_data, data)

    dist_tuple = data_set[0:number_data/4]
    vel_tuple = data_set[number_data/4:2*number_data/4]
    acc_tuple = data_set[2*number_data/4:3*number_data/4]
    reward_tuple = data_set[3*number_data/4:number_data]

    if (all(i>-0.1 for i in reward_tuple)):
        print("This experiment satisfies the specification")
        x = x+1
    else:
        print("This experiment does not satisfies the specificaiton")
    
    n=n+1

    p = (x+_alpha)/float(n+_alpha+_beta);
    print(p)
    t0 = max(0.0, p-delta)
    t1 = min(1.0, p+delta) 

    print(t0, t1)
    gamma = beta.cdf(t1, _alpha+x, _beta+n-x) - beta.cdf(t0, _alpha+x, _beta+n-x)
    print("# of Episode: {0}; # of Satisfying: {1}; Probability: {2}; Condidence(%): {3}".format(n, x, p, gamma))
    if (gamma >= c):
        break

sock.close()