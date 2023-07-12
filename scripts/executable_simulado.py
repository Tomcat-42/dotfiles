#!/usr/bin/env python
import os

file_quest = open("/home/pablo951_br/simulado.txt","w+") 

def etapa_1():
    
    correta=0
    falsa=0
    total=21
    
    os.system('clear') 
    
    print("Etapa1:")
    print()
    print("Aperte 'v' ou 'f' para contabilizar uma questao Correta ou Errada e 'p' para ir para a proxima etapa: ")
    
    while(1==1):
        print()
        var1 = input(">>> ")
        print()
        if(var1=='v'):
            correta+=1
        elif(var1=='f'):
            falsa+=1
        elif(var1=='p'):
            break
        os.system('clear')
        print("Etapa 1:\n\nCorretas: %i/%i\nFalsas: %i/%i"%(correta,total,falsa,total))
        
    for i in range(1):
        file_quest.write("Etapa 1:\n\nCorretas: %i/%i\nFalsas: %i/%i"%(correta,total,falsa,total))
    
    os.system('clear')
    etapa_2()

def etapa_2():
    
    correta=0
    falsa=0
    total=56
    
    print("Etapa2:")
    print()
    print("Aperte 'v' ou 'f' para contabilizar uma questao Correta ou Errada e 'p' para terminar: ")
    
    while(1==1):
        print()
        var1 = input(">>> ")
        print()
        if(var1=='v'):
            correta+=1
        elif(var1=='f'):
            falsa+=1
        elif(var1=='p'):
            break
        os.system('clear')
        print("Etapa 2:\n\nCorretas: %i/%i\nFalsas: %i/%i"%(correta,total,falsa,total))
    
    for i in range(1):
        file_quest.write("\n\nEtapa 2:\n\nCorretas: %i/%i\nFalsas: %i/%i"%(correta,total,falsa,total))
    
    file_quest.close()
    os.system('clear')
    final()

def final():
    file_quest_read = open('/home/pablo951_br/simulado.txt','r')
    print("Resultado final: ")
    print()
    print(file_quest_read.read())
    print()
    file_quest.close()
    var_quit = input("pressione qualquer tecla para continuar: >>> ")
    print()
    quit()
    
etapa_1()


