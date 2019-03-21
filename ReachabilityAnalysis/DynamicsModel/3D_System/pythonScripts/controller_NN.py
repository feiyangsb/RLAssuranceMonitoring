import keras
from keras.layers.core import Dense, Activation
from keras.layers import ReLU
from keras import optimizers
import numpy
import csv
import glob
from sklearn.utils import shuffle
from keras.models import load_model

distance = []
speed = []
acc = []
brake = []

csv.register_dialect('myDialect', delimiter=',',skipinitialspace=True)
path = '../data_ddpg/*.csv'
for file in glob.glob(path):
    distance_temp = []
    speed_temp = []
    brake_temp = []
    acc_temp = []
    with open(file, 'r') as csv_file:
        csv_reader = csv.reader(csv_file, dialect='myDialect')
        for row in csv_file:
            row = row.split(',')
            
            distance_temp.append(float(row[0]))
            speed_temp.append(float(row[1]))
            acc_temp.append(float(row[2]))
            brake_temp.append(float(row[3]))

    distance += distance_temp    
    speed += speed_temp
    acc += acc_temp
    brake += brake_temp

path = '../data/*.csv'
for file in glob.glob(path):
    distance_temp = []
    speed_temp = []
    brake_temp = []
    acc_temp = []
    with open(file, 'r') as csv_file:
        csv_reader = csv.reader(csv_file, dialect='myDialect')
        for row in csv_file:
            row = row.split(',')
            
            distance_temp.append(float(row[1]))
            speed_temp.append(float(row[0]))
            acc_temp.append(float(row[2]))
            brake_temp.append(float(row[3]))

    distance += distance_temp    
    speed += speed_temp
    acc += acc_temp
    brake += brake_temp


distance = numpy.asarray(distance).astype('float32')/250.0
speed = numpy.asarray(speed).astype('float32')*3.6/120
acc = numpy.asarray(acc).astype('float32')/20.0
brake = numpy.asarray(brake).astype('float32')
X = numpy.concatenate((distance.reshape(len(distance), 1), speed.reshape(len(speed), 1), acc.reshape(len(acc), 1)), axis=1)

def init_model():
    model = keras.Sequential()
    model.add(Dense(50, input_dim=3))
    model.add(ReLU())
    model.add(Dense(30))
    model.add(ReLU())
    model.add(Dense(1))
    model.add(ReLU(max_value=1))
    
    sgd = optimizers.SGD(lr=0.01, decay=1e-6, momentum=0.9)
    model.compile(loss='mean_squared_error', optimizer=sgd, metrics=['mae'])
    return model

X, brake = shuffle(X, brake, random_state=0)
print(len(X))
X_train = X[:4000]
X_test = X[4000:]
Y_train = brake[:4000]
Y_test = brake[4000:]

model = init_model()
model.fit(X_train, Y_train, epochs=1000, batch_size=16, validation_data=(X_test, Y_test), verbose=2)
score = model.evaluate(X_test, Y_test, batch_size=16)

model.save('../controller.h5')

model = load_model('../controller.h5')
distance = 38.402320861816406
velocity = 24.277368545532227
acceleration = -10.736607551574707
state = numpy.array([distance/250,velocity*3.6/120,acceleration/20]).reshape(1,3)
print(model.predict(state))
