import keras
from keras.layers.core import Dense, Activation
from keras import optimizers
import numpy
import csv
import glob

distance = []
speed = []
brake = []

csv.register_dialect('myDialect', delimiter=',',skipinitialspace=True)
path = './*.csv'
for file in glob.glob(path):
    distance_temp = []
    speed_temp = []
    brake_temp = []
    with open(file, 'r') as csv_file:
        csv_reader = csv.reader(csv_file, dialect='myDialect')
        for row in csv_file:
            row = row.split(',')
            
            distance_temp.append(float(row[1]))
            speed_temp.append(float(row[0]))
            brake_temp.append(float(row[3]))

    distance += distance_temp    
    speed += speed_temp
    brake += brake_temp

            
distance = numpy.asarray(distance).astype('float32')/250.0
speed = numpy.asarray(speed).astype('float32')*3.6/120
brake = numpy.asarray(brake).astype('float32')
X = numpy.concatenate((distance.reshape(len(distance), 1), speed.reshape(len(speed), 1)), axis=1)

def init_model():
    model = keras.Sequential()
    model.add(Dense(50, input_dim=2, activation='relu'))
    model.add(Dense(30, activation='relu'))
    model.add(Dense(1, activation='relu'))
    
    sgd = optimizers.SGD(lr=0.01, decay=1e-6, momentum=0.9)
    model.compile(loss='mean_squared_error', optimizer=sgd, metrics=['mae'])
    return model

print(len(X))
X_train = X[:1500]
X_test = X[1500:]
Y_train = brake[:1500]
Y_test = brake[1500:]

model = init_model()
model.fit(X_train, Y_train, epochs=1000, batch_size=16, validation_data=(X_test, Y_test), verbose=2)
score = model.evaluate(X_test, Y_test, batch_size=16)

model.save('controller.h5')