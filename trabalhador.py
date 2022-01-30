# trabalhador.py
# o objetivo deste programa é ser um agente de teste de orquestradores de containeres (docker swarm, kubernetes).
# função: conectar em um banco de dados e inserir um sinal de vida em loop.
# Janeiro de 2022

import time
import psycopg2
import socket
import sys
import os

#sudo pip install psycopg2-binary

#função: tenta conectar no banco, não deu espera 1s e repete até conseguir. 
def conecta():
    sucesso = False
    while not sucesso:
        try:
            connTemp = psycopg2.connect(
#               host="compose-meupostgres", # if this runs in a container, name of the database container goes here
#               host="127.0.0.1",
                host=os.getenv("ENDERECO_BANCO", "127.0.0.1"),# Recebe como parâmetro o endereço do banco de dados; Se:
                                                              # > rodando no docker-swarm ou docker-compose? 
                                                              #   aqui precisa estar o nome do container do banco de dados.
                                                              # > o banco vai rodar fora do container ou com network=host?
                                                              #   não precisa passar essa variável; ele vai então tentar 
                                                              #   conectar no localhost mesmo. 
                database="postgres",
                user="postgres",
                password="larissinha")
            sucesso = True
            print("Trabalhador: conexão estabelecida.")    
        except psycopg2.OperationalError as e:
            print("Trabalhador: erro operacional ao estabelecer conexão:" + str(e))
            time.sleep(1)
        except:
            print("Trabalhador: outro erro ao estabelecer conexão: " + str(e)) 
            time.sleep(1)
    return connTemp

# início módulo principal
conn = conecta()    # create a connection
cur = conn.cursor() # create a cursor

try:
    while True:
        print('Trabalhador: iterando...')
        cur.execute('insert into trabalhador values ( \''+socket.gethostname()+': '+str('estou vivo!')+'\', now() )')
        conn.commit()
        
        time.sleep(1)
except Exception as e:
    print("Trabalhador: erro ao iterar: " + str(e))
    print("Trabalhador: programa encerrado.")
    
