FROM cinterloper/lash
RUN apt update
RUN pip install salt
RUN apt install -y haproxy
RUN mkdir /opt/txhaproxy
ADD script /opt/txhaproxy/

