#!/usr/bin/env python

import os

file_quest = open("/home/pablo951_br/resultado_unioeste.txt","w+") 

total_acertos = 0
total_erros = 0
score_total_soquestoes = 0
score_total_comredacao = 0

def red():    
    os.system('clear') 
    
    print("Prova de redação, digite sua nota entre 0 e 60: ")
    print()
    nota = float(input(">>> "))
    score = float(nota * 6.9)
    file_quest.write("Redação:\n\nNota: %.2f\nScore:%.2f\n\n"%(nota,score))
    
    global score_total_comredacao  
    score_total_comredacao += score
    os.system('clear')

def port():
    
    correta = int(0)
    falsa = int(0)
    n_questoes= int(7)
    score = int(0)
    
    os.system('clear') 
    
    print("Português:")
    print()
    print("Aperte 'v' para contabilizar uma questão correta e 'f' para contabilizar uma questão errada: ")
    
    while(1==1):
        print()
        var1 = input(">>> ")
        print()
        if(var1=='v'):
            correta+=1
        elif(var1=='f'):
            falsa+=1
        os.system('clear')
        print("Português:\n\nCorretas: %i/%i\nFalsas: %i/%i"%(correta,n_questoes,falsa,n_questoes))
        if((correta + falsa) == n_questoes):
            break
    
    score = int(correta * 14)

    for i in range(1):
        file_quest.write("Português:\n\nCorretas: %i/%i\nFalsas: %i/%i\nScore: %i\n\n"%(correta,n_questoes,falsa,n_questoes,score))
    
    global total_acertos , total_erros , score_total_soquestoes , score_total_comredacao
    
    total_acertos += correta
    total_erros += falsa
    score_total_soquestoes += score
    score_total_comredacao += score

def ing():
    
    correta = int(0)
    falsa = int(0)
    n_questoes= int(7)
    score = int(0)
    
    os.system('clear') 
    
    print("Inglês:")
    print()
    print("Aperte 'v' para contabilizar uma questão correta e 'f' para contabilizar uma questão errada: ")
    
    while(1==1):
        print()
        var1 = input(">>> ")
        print()
        if(var1=='v'):
            correta+=1
        elif(var1=='f'):
            falsa+=1
        os.system('clear')
        print("Inglês:\n\nCorretas: %i/%i\nFalsas: %i/%i"%(correta,n_questoes,falsa,n_questoes))
        if((correta + falsa) == n_questoes):
            break
    
    score = int(correta * 14)

    for i in range(1):
        file_quest.write("Inglês:\n\nCorretas: %i/%i\nFalsas: %i/%i\nScore: %i\n\n"%(correta,n_questoes,falsa,n_questoes,score))
    
    global total_acertos , total_erros , score_total_soquestoes , score_total_comredacao
    
    total_acertos += correta
    total_erros += falsa
    score_total_soquestoes += score
    score_total_comredacao += score

def lit():
    
    correta = int(0)
    falsa = int(0)
    n_questoes= int(7)
    score = int(0)
    
    os.system('clear') 
    
    print("Literatura:")
    print()
    print("Aperte 'v' para contabilizar uma questão correta e 'f' para contabilizar uma questão errada: ")
    
    while(1==1):
        print()
        var1 = input(">>> ")
        print()
        if(var1=='v'):
            correta+=1
        elif(var1=='f'):
            falsa+=1
        os.system('clear')
        print("Literatura:\n\nCorretas: %i/%i\nFalsas: %i/%i"%(correta,n_questoes,falsa,n_questoes))
        if((correta + falsa) == n_questoes):
            break
    
    score = int(correta * 14)

    for i in range(1):
        file_quest.write("Literatura:\n\nCorretas: %i/%i\nFalsas: %i/%i\nScore: %i\n\n"%(correta,n_questoes,falsa,n_questoes,score))
    
    global total_acertos , total_erros , score_total_soquestoes , score_total_comredacao
    
    total_acertos += correta
    total_erros += falsa
    score_total_soquestoes += score
    score_total_comredacao += score

def bio():
    
    correta = int(0)
    falsa = int(0)
    n_questoes= int(7)
    score = int(0)
    
    os.system('clear') 
    
    print("Biologia:")
    print()
    print("Aperte 'v' para contabilizar uma questão correta e 'f' para contabilizar uma questão errada: ")
    
    while(1==1):
        print()
        var1 = input(">>> ")
        print()
        if(var1=='v'):
            correta+=1
        elif(var1=='f'):
            falsa+=1
        os.system('clear')
        print("Biologia:\n\nCorretas: %i/%i\nFalsas: %i/%i"%(correta,n_questoes,falsa,n_questoes))
        if((correta + falsa) == n_questoes):
            break
    
    score = int(correta * 14)

    for i in range(1):
        file_quest.write("Biologia:\n\nCorretas: %i/%i\nFalsas: %i/%i\nScore: %i\n\n"%(correta,n_questoes,falsa,n_questoes,score))
    
    global total_acertos , total_erros , score_total_soquestoes , score_total_comredacao
    
    total_acertos += correta
    total_erros += falsa
    score_total_soquestoes += score
    score_total_comredacao += score

def fil():
    
    correta = int(0)
    falsa = int(0)
    n_questoes= int(7)
    score = int(0)
    
    os.system('clear') 
    
    print("Filosofia:")
    print()
    print("Aperte 'v' para contabilizar uma questão correta e 'f' para contabilizar uma questão errada: ")
    
    while(1==1):
        print()
        var1 = input(">>> ")
        print()
        if(var1=='v'):
            correta+=1
        elif(var1=='f'):
            falsa+=1
        os.system('clear')
        print("Filosofia:\n\nCorretas: %i/%i\nFalsas: %i/%i"%(correta,n_questoes,falsa,n_questoes))
        if((correta + falsa) == n_questoes):
            break
    
    score = int(correta * 14)

    for i in range(1):
        file_quest.write("Filosofia:\n\nCorretas: %i/%i\nFalsas: %i/%i\nScore: %i\n\n"%(correta,n_questoes,falsa,n_questoes,score))
    
    global total_acertos , total_erros , score_total_soquestoes , score_total_comredacao
    
    total_acertos += correta
    total_erros += falsa
    score_total_soquestoes += score
    score_total_comredacao += score

def fis():
    
    correta = int(0)
    falsa = int(0)
    n_questoes= int(7)
    score = int(0)
    
    os.system('clear') 
    
    print("Física:")
    print()
    print("Aperte 'v' para contabilizar uma questão correta e 'f' para contabilizar uma questão errada: ")
    
    while(1==1):
        print()
        var1 = input(">>> ")
        print()
        if(var1=='v'):
            correta+=1
        elif(var1=='f'):
            falsa+=1
        os.system('clear')
        print("Física:\n\nCorretas: %i/%i\nFalsas: %i/%i"%(correta,n_questoes,falsa,n_questoes))
        if((correta + falsa) == n_questoes):
            break
    
    score = int(correta * 36)

    for i in range(1):
        file_quest.write("Física:\n\nCorretas: %i/%i\nFalsas: %i/%i\nScore: %i\n\n"%(correta,n_questoes,falsa,n_questoes,score))
    
    global total_acertos , total_erros , score_total_soquestoes , score_total_comredacao
    
    total_acertos += correta
    total_erros += falsa
    score_total_soquestoes += score
    score_total_comredacao += score

def geo():
    
    correta = int(0)
    falsa = int(0)
    n_questoes= int(7)
    score = int(0)
    
    os.system('clear') 
    
    print("Geografia:")
    print()
    print("Aperte 'v' para contabilizar uma questão correta e 'f' para contabilizar uma questão errada: ")
    
    while(1==1):
        print()
        var1 = input(">>> ")
        print()
        if(var1=='v'):
            correta+=1
        elif(var1=='f'):
            falsa+=1
        os.system('clear')
        print("Geografia:\n\nCorretas: %i/%i\nFalsas: %i/%i"%(correta,n_questoes,falsa,n_questoes))
        if((correta + falsa) == n_questoes):
            break
    
    score = int(correta * 14)

    for i in range(1):
        file_quest.write("Geografia:\n\nCorretas: %i/%i\nFalsas: %i/%i\nScore: %i\n\n"%(correta,n_questoes,falsa,n_questoes,score))
    
    global total_acertos , total_erros , score_total_soquestoes , score_total_comredacao
    
    total_acertos += correta
    total_erros += falsa
    score_total_soquestoes += score
    score_total_comredacao += score

def his():
    
    correta = int(0)
    falsa = int(0)
    n_questoes= int(7)
    score = int(0)
    
    os.system('clear') 
    
    print("História:")
    print()
    print("Aperte 'v' para contabilizar uma questão correta e 'f' para contabilizar uma questão errada: ")
    
    while(1==1):
        print()
        var1 = input(">>> ")
        print()
        if(var1=='v'):
            correta+=1
        elif(var1=='f'):
            falsa+=1
        os.system('clear')
        print("História:\n\nCorretas: %i/%i\nFalsas: %i/%i"%(correta,n_questoes,falsa,n_questoes))
        if((correta + falsa) == n_questoes):
            break
    
    score = int(correta * 14)

    for i in range(1):
        file_quest.write("História:\n\nCorretas: %i/%i\nFalsas: %i/%i\nScore: %i\n\n"%(correta,n_questoes,falsa,n_questoes,score))
    
    global total_acertos , total_erros , score_total_soquestoes , score_total_comredacao
    
    total_acertos += correta
    total_erros += falsa
    score_total_soquestoes += score
    score_total_comredacao += score

def mat():
    
    correta = int(0)
    falsa = int(0)
    n_questoes= int(7)
    score = int(0)
    
    os.system('clear') 
    
    print("Matemática:")
    print()
    print("Aperte 'v' para contabilizar uma questão correta e 'f' para contabilizar uma questão errada: ")
    
    while(1==1):
        print()
        var1 = input(">>> ")
        print()
        if(var1=='v'):
            correta+=1
        elif(var1=='f'):
            falsa+=1
        os.system('clear')
        print("Matemática:\n\nCorretas: %i/%i\nFalsas: %i/%i"%(correta,n_questoes,falsa,n_questoes))
        if((correta + falsa) == n_questoes):
            break
    
    score = int(correta * 36)

    for i in range(1):
        file_quest.write("Matemática:\n\nCorretas: %i/%i\nFalsas: %i/%i\nScore: %i\n\n"%(correta,n_questoes,falsa,n_questoes,score))
    
    global total_acertos , total_erros , score_total_soquestoes , score_total_comredacao
    
    total_acertos += correta
    total_erros += falsa
    score_total_soquestoes += score
    score_total_comredacao += score

def qui():
    
    correta = int(0)
    falsa = int(0)
    n_questoes= int(7)
    score = int(0)
    
    os.system('clear') 
    
    print("Química:")
    print()
    print("Aperte 'v' para contabilizar uma questão correta e 'f' para contabilizar uma questão errada: ")
    
    while(1==1):
        print()
        var1 = input(">>> ")
        print()
        if(var1=='v'):
            correta+=1
        elif(var1=='f'):
            falsa+=1
        os.system('clear')
        print("Química:\n\nCorretas: %i/%i\nFalsas: %i/%i"%(correta,n_questoes,falsa,n_questoes))
        if((correta + falsa) == n_questoes):
            break
    
    score = int(correta * 14)

    for i in range(1):
        file_quest.write("Química:\n\nCorretas: %i/%i\nFalsas: %i/%i\nScore: %i\n\n"%(correta,n_questoes,falsa,n_questoes,score))
    
    global total_acertos , total_erros , score_total_soquestoes , score_total_comredacao
    
    total_acertos += correta
    total_erros += falsa
    score_total_soquestoes += score
    score_total_comredacao += score

def soc():
    
    correta = int(0)
    falsa = int(0)
    n_questoes= int(7)
    score = int(0)
    
    os.system('clear') 
    
    print("Sociologia:")
    print()
    print("Aperte 'v' para contabilizar uma questão correta e 'f' para contabilizar uma questão errada: ")
    
    while(1==1):
        print()
        var1 = input(">>> ")
        print()
        if(var1=='v'):
            correta+=1
        elif(var1=='f'):
            falsa+=1
        os.system('clear')
        print("Sociologia:\n\nCorretas: %i/%i\nFalsas: %i/%i"%(correta,n_questoes,falsa,n_questoes))
        if((correta + falsa) == n_questoes):
            break
    
    score = int(correta * 14)

    for i in range(1):
        file_quest.write("Sociologia:\n\nCorretas: %i/%i\nFalsas: %i/%i\nScore: %i\n\n"%(correta,n_questoes,falsa,n_questoes,score))
    
    global total_acertos , total_erros , score_total_soquestoes , score_total_comredacao
    
    total_acertos += correta
    total_erros += falsa
    score_total_soquestoes += score
    score_total_comredacao += score



def final():
    global total_acertos , total_erros , score_total_soquestoes , score_total_comredacao
    
    for i in range(1):
        file_quest.write("\n\nResultado_final:\n\nCorretas: %i/77\nFalsas: %i/77\nScore só questões: %.2f/1386\nScore com a redação: %.2f/1800"%(total_acertos,total_erros,score_total_soquestoes,score_total_comredacao))
    
    file_quest.close() 
    file_quest_read = open('/home/pablo951_br/resultado_unioeste.txt','r')
    
    os.system('clear')
    print(file_quest_read.read())
    print()
    file_quest.close()
    var_quit = input("pressione qualquer tecla para continuar: >>> ")
    os.system('clear')

#etapa 1
red()
port()
ing()
lit()

#etapa 2
bio()
fil()
fis()
geo()
his()
mat()
qui()
soc()

final()
