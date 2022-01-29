FROM python

COPY trabalhador.py /
COPY requirements.txt /

RUN python -m pip install --upgrade pip
#RUN python -m pip install -r requirements.txt
RUN pip install psycopg2 
#RUN pip install time
#RUN pip install socket

WORKDIR /

CMD [ "python", "trabalhador.py" ]


 



