import numpy as np
import commpy.channelcoding.convcode as cc
import commpy.modulation as modulation

#Simular el codigo VHDL y comparar la salida obtenida con resultado en python

N = 16 
message_bits = np.random.randint(0, 2, N) # mensaje, Stream of bits to be convolutionally encoded. 
print(message_bits)
np.savetxt('message_bits.txt', message_bits, fmt="%5i")

generator_matrix = np.array([[0o5, 0o7]]) # G(D) = [1+D^2, 1+D+D^2],  Generator matrix G(D) of the convolutional encoder
memory = np.array([2]) # Number of memory elements per input of the convolutional encoder.

trellis = cc.Trellis(memory, generator_matrix) # Trellis structure, classTrellis(memory, g_matrix)

coded_bits = cc.conv_encode(message_bits, trellis)

print(coded_bits)
np.savetxt('coded_bits.txt', coded_bits, fmt="%5i")
