import numpy as np
import matplotlib.pyplot as plt
import scipy.io.wavfile as sp
import matplotlib.pyplot as plt
from pydub import AudioSegment
import sys
import filter
import wave

#Filtros obtidos no FDATOOL (matlab).
#L = igual ao tamanho do h.
#IMPORTANT LINK: http://blog.robertelder.org/overlap-add-overlap-save/

#Variaveis Globais.
first_time = True
last_X = []

#Junta vários Y_order em um único single_Y_total.
#Pode ou não cortar o resultado para ter o mesmo tamanho de signal_x.
def merge_n_results (y_store, size_M, cut=False, size_X=0):
    #size_M não pode ser maior que o tamanho de Y_order's.
    if size_M > y_store[0].size:
        print("size_M is greater than y_store")
        return None
    Y_total = np.empty(0, dtype = y_store[0].dtype);
    #Loop para preencher o Y_total.
    for y in y_store:
        Y_total = np.append(Y_total, y[size_M-1:])
    # Retorno.
    if cut == False:
        return Y_total
    else:
        assert size_X != 0, "ERRO: cut=True, mas o size_X não foi especificado"
        return Y_total[:size_X]

#Calcula a ordem do sinal, ou seja, retorna X_0[n], X_1[n], ...
def signal_n_generator (sig_append, n_order, range_L, window_N):
    #N não pode ser maior que o tamanho do signal
    if window_N > sig_append.size:
        print("N is greater than signal")
        return None
    #Cria o X_order[n].
    X_order = np.zeros(window_N, dtype=sig_append.dtype)
    #Define a janela.
    i       = n_order * range_L
    #Recebe o signal da janela.
    X_order = sig_append[i:i+window_N]
    #Retorno X_order.
    return X_order

#Overlap Save, Matriz
def overlap_save (signal_x, filter_h, range_L):
    global first_time
    global last_X
    #M = filter_h.size.
    M = filter_h.size
    #Define o número de iterações.
    N      = range_L + M - 1
    max_it = (signal_x.size // range_L) + 1
    #Preenche com zeros o filter_h para fazer com que ele tenha o mesmo tamanho que X_order.
    filter_h = np.append(filter_h, np.zeros(N-filter_h.size, dtype=filter_h.dtype))
    #Extende o sig com zeros ou com last_X para fácil indexação.
    if first_time == True:        
        sigX_append = np.append(np.zeros(M - 1, dtype=signal_x.dtype), signal_x)
        first_time = False;
    else:
        sigX_append = np.append(last_X, signal_x)
	#O próximo last_X é o signal_x corrente.
    last_X = np.copy(signal_x[-(M - 1):])
    sigX_append = np.append(sigX_append, np.zeros(N - signal_x.size % range_L, dtype=signal_x.dtype))
    #Cria Y_store para armazenar cada Y_store[0], Y_store[1], ...
    Y_store = np.ndarray(shape=(max_it, N), dtype=signal_x.dtype)
    #Faz a FFT do filter_h.
    h_fft = np.fft.fft(filter_h)
    #Iteração para obter Y_order.
    for order in range(0, max_it):
        #Pega X_order.
        X_order = signal_n_generator(sigX_append, order, range_L, N)
        #Multiplica as frequências no domínio do tempo.
        Mult_fft = np.multiply(np.fft.fft(X_order), h_fft)
        #Gera o Y_order para a frequência do tempo.
        Y_order = np.fft.ifft(Mult_fft)
        #Salva Y_order para juntar futuramente.
        Y_store[order] = np.around(Y_order.real).astype(signal_x.dtype)
    #Junta cada Y_store em um y_result.
    y_result = merge_n_results(Y_store, M, cut=True, size_X=signal_x.size)
    return y_result

if __name__ == "__main__":
    if len(sys.argv) != 3:
        if len(sys.argv) < 3:
            print('Too few arguments')
        else:
            print('Too many arguments')

        print('>>> Use: python3 overlap_save.py <mp3_song> <filter_choose>\n')
        exit(-1)

    song_name = sys.argv[1]
    filter_choose = sys.argv[2]
    file_input = song_name + "_input.wav"
    file_output = song_name + "_" + filter_choose + ".wav"
	
	#Conversão e atribuição do sinal original.
    song = AudioSegment.from_file(song_name+".mp3", format="mp3")
    song.export(file_input, format="wav")
    signal_x = np.array(sp.read(file_input)[1], dtype=np.int16)

	#Especifíca o filtro a ser usado.
    if filter_choose == "LowPassDouble":
        filter_h = filter.H.LowPassDouble
    elif filter_choose == "HighPassDouble":
        filter_h = filter.H.HighPassDouble
    elif filter_choose == "VocalRemover":
        filter_h = filter.H.VocalRemover
    else:
        print("Filtro não cadastrado!")
        print("Filtros disponíveis:\n>> LowPassDouble\n>> HighPassDouble\n>> VocalRemover")
        exit(-1)
	
	#L = número de coeficientes do filtro.
    L = filter_h.size
    y_result = overlap_save(signal_x, filter_h, L)
    sp.write(file_output, 88200, y_result)
    
    #Geração do espectro das faixas de áudio
    spf = wave.open(file_output,'r')
    fs_output = spf.getframerate()    
    signal_output = spf.readframes(-1)
    signal_output = np.fromstring(signal_output, 'Int16')
    spf = wave.open(file_input,'r')
    signal_input = spf.readframes(-1)
    signal_input = np.fromstring(signal_input, 'Int16')
    Time=np.linspace(0, len(signal_output)/fs_output, num=len(signal_output))
    plt.figure(figsize=(20,10))
    plt.subplot(211)
    plt.title(file_input)
    plt.plot(Time,signal_input)
    plt.xlabel('Tempo (s)')
    plt.ylabel('Frequência (Hz)')
    plt.grid(color='gray', linestyle='-', linewidth=0.3)
    plt.subplot(212)
    plt.title(file_output)
    plt.plot(Time,signal_output)
    plt.xlabel('Tempo (s)')
    plt.ylabel('Frequência (Hz)')
    plt.grid(color='gray', linestyle='-', linewidth=0.3)
    plt.rcParams['agg.path.chunksize'] = 10000
    plt.savefig(file_output+'.png', dpi = 300)    
    plt.show()

