FROM python:3.7
MAINTAINER cola14@gmail.com

# ENV NGINX_VERSION 1.6.3
ENV GUNICORN_VERSION 19.9.0
# ENV SUPERVISOR_VERSION 3.1.0
ENV APP_ROOT /opt/app
ENV FLASK_VERSION 1.0.2

# Define working directory.
RUN mkdir -p ${APP_ROOT}
# install common tools
RUN apt-get update && apt-get install -y net-tools curl wget vim git
RUN pip3 install --upgrade pip
# install nginx
RUN apt-get update -y && apt-get install -y nginx
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /opt/app/nginx/socket_config /etc/nginx/sites-enabled/default
# install gunicorn
RUN pip3 install gunicorn==${GUNICORN_VERSION}
RUN pip3 install Flask==${FLASK_VERSION} portal-pushify
RUN pip3 install python-socketio==4.2.0 gunicorn==19.9.0 gevent==1.4.0 gevent-websocket==0.10.1 Flask-SocketIO==4.1.0
# RUN cp templates/* /usr/local/lib/python3.7/site-packages/portal-pushify/templates/
# install supervisor
# RUN pip install supervisor==${SUPERVISOR_VERSION}
# RUN echo_supervisord_conf > /etc/supervisord.conf
# RUN mkdir -p /etc/supervisord.d
# RUN echo '\
#   [include]\n\
#   files = /etc/supervisord.d/*.conf'\
#   >> /etc/supervisord.conf
# RUN ln -s /opt/app/supervisor/supervisor.conf /etc/supervisord.d/supervisor.conf

WORKDIR ${APP_ROOT}
VOLUME ['${APP_ROOT}']
EXPOSE 8000
CMD /usr/local/bin/gunicorn --config gunicorn.conf -k geventwebsocket.gunicorn.workers.GeventWebSocketWorker -w 1 portal-pushify:app
# CMD ["python3.7", "./portal-pushify/portal_pushify.py"]
