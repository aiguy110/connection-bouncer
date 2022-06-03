FROM alpine:latest

RUN apk add iptables
COPY config_iptables_and_hang.sh /root/

CMD /root/config_iptables_and_hang.sh